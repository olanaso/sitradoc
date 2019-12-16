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
        caption: "Lista Referencia",
        colNames: ["Edit", "Del","idreferencia","iddocumento","iddocumentoreferencia","fecharegistro","idusuarioregistra","estado"],
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
                name: 'idreferencia',
                index: 'idreferencia',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'iddocumento',
                index: 'iddocumento',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'iddocumentoreferencia',
                index: 'iddocumentoreferencia',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'fecharegistro',
                index: 'fecharegistro',
                editable: false,
                width: 150,
                hidden: false
            },{
                name: 'idusuarioregistra',
                index: 'idusuarioregistra',
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
    $.ajaxCall(urlApp +'/ReferenciaController/listarRegistrosReferenciaBE.htm', {poReferenciaBE: {IndOpSp: 1}}, false, function(response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Referencia = {
 idreferencia: $('#txtIdreferencia').val(),
 iddocumento: $('#txtIddocumento').val(),
 iddocumentoreferencia: $('#txtIddocumentoreferencia').val(),
 fecharegistro: $('#txtFecharegistro').val(),
 idusuarioregistra: $('#txtIdusuarioregistra').val(),
 estado: true
            };
            $.ajaxCall(urlApp +'/ReferenciaController/insertarReferenciaBE.htm', {poReferenciaBE: Referencia}, false, function(response) {
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
        if (rowData.idreferencia === id.toString()) {
            $('#txtIdreferencia').val(rowData.idreferencia);
            $('#txtIddocumento').val(rowData.iddocumento);
            $('#txtIddocumentoreferencia').val(rowData.iddocumentoreferencia);
            $('#txtFecharegistro').val(rowData.fecharegistro);
            $('#txtIdusuarioregistra').val(rowData.idusuarioregistra);
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
            var Referencia = {
 idreferencia: $('#container').data('idedit'),
 iddocumento: $('#txtIddocumento').val(),
 iddocumentoreferencia: $('#txtIddocumentoreferencia').val(),
 fecharegistro: $('#txtFecharegistro').val(),
 idusuarioregistra: $('#txtIdusuarioregistra').val(),
 estado: true
};
            $.ajaxCall(urlApp +'/ReferenciaController/actualizarReferenciaBE.htm', {poReferenciaBE: Referencia}, false, function(response) {
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
        var Referencia = {
            IndOpSp: 2,
            idreferencia: id //1=consulta por ids
        };
        $.ajaxCall(urlApp +'/ReferenciaController/eliminarReferenciaBE.htm', {poReferenciaBE: Referencia}, false, function(response) {
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
$.CargarCombo(urlApp + '/ReferenciaController/listObjectReferenciaBE.htm', {poReferenciaBE: {IndOpSp: 1}}, '#txtIddocumento');$.CargarCombo(urlApp + '/ReferenciaController/listObjectReferenciaBE.htm', {poReferenciaBE: {IndOpSp: 1}}, '#txtIddocumentoreferencia');$.CargarCombo(urlApp + '/ReferenciaController/listObjectReferenciaBE.htm', {poReferenciaBE: {IndOpSp: 1}}, '#txtIdusuarioregistra');}
