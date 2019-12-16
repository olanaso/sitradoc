/*!
 * Author: Erick Escalante Olano
 * Description:
 *      Archivo JS para adminitracion 
 !**/

/*
 * Global variables. If you change any of these vars, don't forget 
 * to change the values in the less files!
 */
 /*
    /* INITIALIZE 
     * ------------------------
     */
$(function() {
    initForm();
    crearGrilla();
    cargarGrilla();
        $('#containerGrilla').bind('resize', function () {
            $("#grid").setGridWidth($('#containerGrilla').width());
        }).trigger('resize');
});

     /*EVENTS
     * ------------------------
     */
$(function() {

    $("#btnNuevo").click(function(e) {

        if ($("#btnNuevo").text() === 'Nuevo') {
            $.HabilitarForm('#form');
            $("#btnNuevo").text('Guardar');
            return;
        }
        if ($("#btnNuevo").text() === 'Guardar') {
            save();
            return;
        }

        if ($("#btnNuevo").text() === 'Actualizar') {
            actualizar();
        }
        e.stopPropagation();
    });

    $("#btnCancelar").click(function(e) {
        $.DesabilitarForm('#form');
        $.LimpiarForm('#form');
        $("#btnNuevo").text('Nuevo');
    });


});


     /* FUNCTIONS
     * ------------------------
     */
function initForm() {
    $.DesabilitarForm('#form');
    $.LimpiarForm('#form');
    $("#btnNuevo").text('Nuevo');
    loadCombos();}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        ignoreCase:true,
        width: 500,
        caption: "Lista Expedienterequisito",
        colNames: ["Edit", "Del","inexpedienterequisito","idrequisitos","idexpediente","fecha","estado"],
        colModel: [
            {
                name: 'edit',
                index: 'edit',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: false
            },
            {
                name: 'del',
                index: 'del',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: false
            },
{
                name: 'inexpedienterequisito',
                index: 'inexpedienterequisito',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'idrequisitos',
                index: 'idrequisitos',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'idexpediente',
                index: 'idexpediente',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'fecha',
                index: 'fecha',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: false
            }        ],
        pager: '#pager',
        //onSelectRow: viewGeometry,
        viewrecords: true,
        shrinkToFit: false,
        //multiselect: true
    });
    jQuery("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false});
}

function cargarGrilla() {
    $.ajaxCall(urlApp +'/ExpedienterequisitoController/listarRegistrosExpedienterequisitoBE.htm', {poExpedienterequisitoBE: {IndOpSp: 1}}, false, function(response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Expedienterequisito = {
 inexpedienterequisito: $('#txtInexpedienterequisito').val(),
 idrequisitos: $('#txtIdrequisitos').val(),
 idexpediente: $('#txtIdexpediente').val(),
 fecha: $('#txtFecha').val(),
 estado: true
            };
            $.ajaxCall(urlApp +'/ExpedienterequisitoController/insertarExpedienterequisitoBE.htm', {poActividadBE: Actividad}, false, function(response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }
            });
            break;
        case -1:
            bootbox.alert(Mensajes.camposRequeridos);
            break;
        case -2:
            bootbox.alert(Mensajes.camposIncorrectos);
            break;

    }
}

function edit(id) {
    $('#container').data('idedit', id);
    var rowIds = $('#grid').jqGrid('getDataIDs');

    for (var i = 1; i <= rowIds.length; i++) {
        rowData = $('#grid').jqGrid('getRowData', i);
        if (rowData.idexpedienterequisito === id.toString()) {
            $('#txtInexpedienterequisito').val(rowData.inexpedienterequisito);
            $('#txtIdrequisitos').val(rowData.idrequisitos);
            $('#txtIdexpediente').val(rowData.idexpediente);
            $('#txtFecha').val(rowData.fecha);
             $('#txtEstado').val(rowData.estado);
            $("#btnNuevo").text('Actualizar');
            $.HabilitarForm('#form');
        } //if
    } //for
}

function actualizar() {

    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Expedienterequisito = {
 inexpedienterequisito: $('#container').data('idedit'),
 idrequisitos: $('#txtIdrequisitos').val(),
 idexpediente: $('#txtIdexpediente').val(),
 fecha: $('#txtFecha').val(),
 estado: true
};
            $.ajaxCall(urlApp +'/ExpedienterequisitoController/actualizarExpedienterequisitoBE.htm', {poExpedienterequisitoBE: Expedienterequisito}, false, function(response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }
            });
            break;
        case -1:
            bootbox.alert(Mensajes.camposRequeridos);
            break;
        case -2:
            bootbox.alert(Mensajes.camposIncorrectos);
            break;

    }
}

function del(id) {
    var eliminar = function() {
        var Expedienterequisito = {
            IndOpSp: 2,
            idexpedienterequisito: id //1=consulta por ids
        };
        $.ajaxCall(urlApp +'/ExpedienterequisitoController/eliminarExpedienterequisitoBE.htm', {poExpedienterequisitoBE: Expedienterequisito}, false, function(response) {
            if (response > 0) {
                bootbox.alert(Mensajes.operacionCorrecta);
                $("#btnNuevo").text('Nuevo');
                $.DesabilitarForm('#form');
                $.LimpiarForm('#form');
                cargarGrilla();
            }
        });
    };

    bootbox.confirm(Mensajes.deseaEliminar, function(result) {
        if (result == true) {
            eliminar();
        }
        else {

        }
    });


} function loadCombos() {
$.CargarCombo(urlApp + '/ExpedienterequisitoController/listObjectSectorBE.htm', {poExpedienterequisitoBE: {IndOpSp: 1}}, '#txtIdrequisitos');$.CargarCombo(urlApp + '/ExpedienterequisitoController/listObjectSectorBE.htm', {poExpedienterequisitoBE: {IndOpSp: 1}}, '#txtIdexpediente');}
