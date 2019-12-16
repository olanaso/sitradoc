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
        width: 500,
        caption: "Lista Archivodocumento",
        colNames: ["Edit", "Del","idarchivodocumento","documento","codigo","nombre","url","estado"],
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
                name: 'idarchivodocumento',
                index: 'idarchivodocumento',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'documento',
                index: 'documento',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'nombre',
                index: 'nombre',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'url',
                index: 'url',
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
    $.ajaxCall(urlApp +'/ArchivodocumentoController/listarRegistrosArchivodocumentoBE.htm', {poArchivodocumentoBE: {IndOpSp: 1}}, false, function(response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Archivodocumento = {
 idarchivodocumento: $('#txtIdarchivodocumento').val(),
 documento: $('#txtDocumento').val(),
 codigo: $('#txtCodigo').val(),
 nombre: $('#txtNombre').val(),
 url: $('#txtUrl').val(),
 estado: true
            };
            $.ajaxCall(urlApp +'/ArchivodocumentoController/insertarArchivodocumentoBE.htm', {poArchivodocumentoBE: Archivodocumento}, false, function(response) {
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
        if (rowData.idarchivodocumento === id.toString()) {
            $('#txtIdarchivodocumento').val(rowData.idarchivodocumento);
            $('#txtDocumento').val(rowData.documento);
            $('#txtCodigo').val(rowData.codigo);
            $('#txtNombre').val(rowData.nombre);
            $('#txtUrl').val(rowData.url);
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
            var Archivodocumento = {
 idarchivodocumento: $('#container').data('idedit'),
 documento: $('#txtDocumento').val(),
 codigo: $('#txtCodigo').val(),
 nombre: $('#txtNombre').val(),
 url: $('#txtUrl').val(),
 estado: true
};
            $.ajaxCall(urlApp +'/ArchivodocumentoController/actualizarArchivodocumentoBE.htm', {poArchivodocumentoBE: Archivodocumento}, false, function(response) {
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
        var Archivodocumento = {
            IndOpSp: 2,
            idarchivodocumento: id //1=consulta por ids
        };
        $.ajaxCall(urlApp +'/ArchivodocumentoController/eliminarArchivodocumentoBE.htm', {poArchivodocumentoBE: Archivodocumento}, false, function(response) {
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
}
