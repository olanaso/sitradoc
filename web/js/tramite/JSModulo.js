/*!
 * Author:Lito Ventura 
 * Fecha Culminación: 01/09/2015
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
    loadCombos();
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        ignoreCase:true,
        width: 500,
        caption: "Lista Modulo",
        colNames: ["Editar", "Eliminar", "idmodulo", "Nombre de Módulo", "Página de Inicio", "estado"],
        colModel: [
            {
                name: 'edit',
                index: 'edit',
                editable: false,
                align: "center",
                width: 45,
                search: false,
                hidden: false
            },
            {
                name: 'del',
                index: 'del',
                editable: false,
                align: "center",
                width: 60,
                search: false,
                hidden: false
            },
            {
                name: 'idmodulo',
                index: 'idmodulo',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'denominacion',
                index: 'denominacion',
                editable: false,
                width: 180,
                hidden: false
            }, {
                name: 'paginainicio',
                index: 'paginainicio',
                editable: false,
                width: 180,
                hidden: false
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: true
            }],
        pager: '#pager',
        //onSelectRow: viewGeometry,
     viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        //multiselect: true
    });
    $("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}

function cargarGrilla() {
    $.ajaxCall(urlApp + '/ModuloController/listarRegistrosModuloBE.htm', {poModuloBE: {IndOpSp: 1}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Modulo = {
                idmodulo: $('#txtIdmodulo').val(),
                denominacion: $('#txtDenominacion').val(),
                paginainicio: $('#txtPaginainicio').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/ModuloController/insertarModuloBE.htm', {poModuloBE: Modulo}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }

                if (response == -1) {
                    bootbox.alert(Mensajes.moduloDuplicado);
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
        if (rowData.idmodulo === id.toString()) {
            $('#txtIdmodulo').val(rowData.idmodulo);
            $('#txtDenominacion').val(rowData.denominacion);
            $('#txtPaginainicio').val(rowData.paginainicio);
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
            var Modulo = {
                idmodulo: $('#container').data('idedit'),
                denominacion: $('#txtDenominacion').val(),
                paginainicio: $('#txtPaginainicio').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/ModuloController/actualizarModuloBE.htm', {poModuloBE: Modulo}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }
                
                if(response==-1){
                    bootbox.alert(Mensajes.moduloActualizar);
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
        var Modulo = {
            IndOpSp: 2,
            idmodulo: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/ModuloController/eliminarModuloBE.htm', {poModuloBE: Modulo}, false, function (response) {
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
