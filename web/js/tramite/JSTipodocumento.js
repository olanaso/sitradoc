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
$(function () {
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
$(function () {

    $("#btnNuevo").click(function (e) {

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

    $("#btnCancelar").click(function (e) {
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
    //loadCombos();
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        caption: "Lista Tipo de Documento",
        colNames: ["Edit", "Del", "idtipodocumento", "denominacion", "descripcion", "subida", "igual", "bajada", "estado"],
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
                name: 'idtipodocumento',
                index: 'idtipodocumento',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'denominacion',
                index: 'denominacion',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'descripcion',
                index: 'descripcion',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'subida',
                index: 'subida',
                width: 70,
                align: 'center',
                formatter: 'checkbox',
                edittype: 'checkbox',
                editoptions: {value: 'Si:No', defaultValue: 'Yes'},
                stype: 'select',
                searchoptions: {sopt: ['eq', 'ne'], value: ':All;true:Si;false:No'}
            },
            {
                name: 'igual',
                index: 'igual',
                width: 70,
                align: 'center',
                formatter: 'checkbox',
                edittype: 'checkbox',
                editoptions: {value: 'Si:No', defaultValue: 'Yes'},
                stype: 'select',
                searchoptions: {sopt: ['eq', 'ne'], value: ':All;true:Si;false:No'}
            },
            {
                name: 'bajada',
                index: 'bajada',
                width: 70,
                align: 'center',
                formatter: 'checkbox',
                edittype: 'checkbox',
                editoptions: {value: 'Si:No', defaultValue: 'Yes'},
                stype: 'select',
                searchoptions: {sopt: ['eq', 'ne'], value: ':All;true:Si;false:No'}
            },
//            {
//                name: 'jefe',
//                index: 'jefe',
//                width: 70,
//                align: 'center',
//                formatter: 'checkbox',
//                edittype: 'checkbox',
//                editoptions: {value: 'Si:No', defaultValue: 'Yes'},
//                stype: 'select',
//                searchoptions: {sopt: ['eq', 'ne'], value: ':All;true:Si;false:No'}
//            },
            {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: true
            }],
        pager: '#pager',
        //onSelectRow: viewGeometry,
        viewrecords: true,
        shrinkToFit: false,
        //multiselect: true
    });
    jQuery("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false});
}

function cargarGrilla() {
    $.ajaxCall(urlApp + '/TipodocumentoController/listarRegistrosTipodocumentoBE.htm', {poTipodocumentoBE: {IndOpSp: 1}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Tipodocumento = {
                idregla: 0,
                denominacion: $('#txtDenominacion').val(),
                descripcion: $('#txtDescripcion').val(),
                subida: $('#txtbsubida').prop("checked"),
                igual: $('#txtbigual').prop("checked"),
                bajada: $('#txtbbajada').prop("checked"),
//                jefe: $('#txtbindjefe').prop("checked"),
                estado: true
            };
            $.ajaxCall(urlApp + '/TipodocumentoController/insertarTipodocumentoBE.htm', {poTipodocumentoBE: Tipodocumento}, false, function (response) {
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
        if (rowData.idtipodocumento === id.toString()) {
            console.log(rowData);
            //$('#txtIdtipodocumento').val(rowData.idtipodocumento);
            $('#txtDenominacion').val(rowData.denominacion);
            $('#txtDescripcion').val(rowData.descripcion);
            (rowData.subida === 'Si') ? $('#txtbsubida').prop("checked", true) : $('#txtbsubida').prop("checked", false);
            (rowData.igual === 'Si') ? $('#txtbigual').prop("checked", true) : $('#txtbigual').prop("checked", false);
            (rowData.bajada === 'Si') ? $('#txtbbajada').prop("checked", true) : $('#txtbbajada').prop("checked", false);
//            (rowData.jefe === 'Si') ? $('#txtbindjefe').prop("checked", true) : $('#txtbindjefe').prop("checked", false);
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
            var Tipodocumento = {
                idtipodocumento: $('#container').data('idedit'),
                idregla: 0,
                denominacion: $('#txtDenominacion').val(),
                descripcion: $('#txtDescripcion').val(),
                subida: $('#txtbsubida').prop("checked"),
                igual: $('#txtbigual').prop("checked"),
                bajada: $('#txtbbajada').prop("checked"),
//                jefe: $('#txtbindjefe').prop("checked"),
                estado: true
            };
            $.ajaxCall(urlApp + '/TipodocumentoController/actualizarTipodocumentoBE.htm', {poTipodocumentoBE: Tipodocumento}, false, function (response) {
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
    var eliminar = function () {
        var Tipodocumento = {
            IndOpSp: 2,
            idtipodocumento: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/TipodocumentoController/eliminarTipodocumentoBE.htm', {poTipodocumentoBE: Tipodocumento}, false, function (response) {
            if (response > 0) {
                bootbox.alert(Mensajes.operacionCorrecta);
                $("#btnNuevo").text('Nuevo');
                $.DesabilitarForm('#form');
                $.LimpiarForm('#form');
                cargarGrilla();
            }
        });
    };

    bootbox.confirm(Mensajes.deseaEliminar, function (result) {
        if (result == true) {
            eliminar();
        }
        else {

        }
    });


}
function loadCombos() {
}
