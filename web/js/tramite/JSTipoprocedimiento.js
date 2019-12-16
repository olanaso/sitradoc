/*!
 * Author: Denis Jack Ochoa Berrocal
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
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        caption: "Lista Tipo de Procedimiento",
        colNames: ["Edit", "Del", "idtipoprocedimiento", "Denominacion", "Descripcion", "Nro.", "Vigente", "estado"],
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
                name: 'idtipoprocedimiento',
                index: 'idtipoprocedimiento',
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
                width: 300,
                hidden: false
            },
            {
                name: 'orden',
                index: 'orden',
                editable: false,
                width: 50,
                hidden: false
            },
            {
                name: 'bindactual',
                index: 'bindactual',
                editable: false,
                width: 70,
                align: 'center',
                formatter: 'checkbox',
                edittype: 'checkbox',
                editoptions: {value: 'Si:No', defaultValue: 'Yes'},
                stype: 'select',
                searchoptions: {sopt: ['eq', 'ne'], value: ':All;true:Si;false:No'}
            },
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
    $.ajaxCall(urlApp + '/TipoprocedimientoController/listarRegistrosTipoprocedimientoBE.htm', {poTipoprocedimientoBE: {IndOpSp: 1}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Tipoprocedimiento = {
                denominacion: $('#txtDenominacion').val(),
                descripcion: $('#txtDescripcion').val(),
                orden: $('#txtOrden').val(),
                bindactual: $('#txtbindactual').prop("checked"),
                estado: true
            };
            $.ajaxCall(urlApp + '/TipoprocedimientoController/insertarTipoprocedimientoBE.htm', {poTipoprocedimientoBE: Tipoprocedimiento}, false, function (response) {
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
        if (rowData.idtipoprocedimiento === id.toString()) {
            console.log(rowData);
            $('#txtDenominacion').val(rowData.denominacion);
            $('#txtDescripcion').val(rowData.descripcion);
            $('#txtOrden').val(rowData.orden);
            (rowData.bindactual === 'Si') ? $('#txtbindactual').prop("checked", true) : $('#txtbindactual').prop("checked", false);
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
            var Tipoprocedimiento = {
                idtipoprocedimiento: $('#container').data('idedit'),
                denominacion: $('#txtDenominacion').val(),
                descripcion: $('#txtDescripcion').val(),
                orden: $('#txtOrden').val(),
                bindactual: $('#txtbindactual').prop("checked"),
                estado: true
            };
            $.ajaxCall(urlApp + '/TipoprocedimientoController/actualizarTipoprocedimientoBE.htm', {poTipoprocedimientoBE: Tipoprocedimiento}, false, function (response) {
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
        var Tipoprocedimiento = {
            IndOpSp: 2,
            idtipoprocedimiento: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/TipoprocedimientoController/eliminarTipoprocedimientoBE.htm', {poTipoprocedimientoBE: Tipoprocedimiento}, false, function (response) {
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