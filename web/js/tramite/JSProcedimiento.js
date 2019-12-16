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
        cargarGrilla();
//        initForm();
        $("#txtIdarea").select2();
        $("#txtIdtipoprocedimiento").select2();
        $("#txtIdcargoresolutor").select2();
    });

    $("#txtIdarea").change(function (e) {
        cargarComboCargo($(this).val());
        cargarGrilla($(this).val());
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
    $("#txtIdarea").select2();
    $("#txtIdtipoprocedimiento").select2();
    $("#txtIdcargoresolutor").select2();
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        ignoreCase:true,
        caption: "Lista Procedimiento",
        colNames: ["Edit", "Del", "idprocedimiento", "idarea", "Código", "Denominacion", "Plazo", "idcargoresolutor", "Cargo", "idtipoprocedimiento", "Tipoprocedimiento", "Descripcion", "Monto", "estado"],
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
                name: 'idprocedimiento',
                index: 'idprocedimiento',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'idarea',
                index: 'idarea',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 120,
                hidden: false
            },
            {
                name: 'denominacion',
                index: 'denominacion',
                editable: false,
                width: 350,
                hidden: false
            },
            {
                name: 'plazodias',
                index: 'plazodias',
                editable: false,
                width: 50,
                hidden: false
            },
            {
                name: 'idcargoresolutor',
                index: 'idcargoresolutor',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'cargoresolutor',
                index: 'cargoresolutor',
                editable: false,
                width: 150,
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
                name: 'tipoprocedimiento',
                index: 'tipoprocedimiento',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'descripcion',
                index: 'descripcion',
                editable: false,
                width: 250,
                hidden: false
            },
            {
                name: 'montototal',
                index: 'montototal',
                editable: false,
                width: 70,
                hidden: false
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

function cargarGrilla(idarea) {
    $.ajaxCall(urlApp + '/ProcedimientoController/listarRegistrosProcedimientoBE.htm', {poProcedimientoBE: {IndOpSp: 1, idarea: idarea}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Procedimiento = {
                idprocedimiento: $('#txtIdprocedimiento').val(),
                idarea: $('#txtIdarea').val(),
                idtipoprocedimiento: $('#txtIdtipoprocedimiento').val(),
                codigo: $('#txtCodigo').val(),
                denominacion: $('#txtDenominacion').val(),
                plazodias: $('#txtPlazodias').val(),
                idcargoresolutor: $('#txtIdcargoresolutor').val(),
                descripcion: $('#txtDescripcion').val(),
                montototal: $('#txtMontoTotal').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/ProcedimientoController/insertarProcedimientoBE.htm', {poProcedimientoBE: Procedimiento}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    cargarGrilla($('#txtIdarea').val());
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    //initForm();
                    $("#txtIdarea").select2();
                    $("#txtIdtipoprocedimiento").select2();
                    $("#txtIdcargoresolutor").select2();
                }
                if (response == -1) {
                    bootbox.alert(Mensajes.codProcedimientoDuplicado);
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
        if (rowData.idprocedimiento === id.toString()) {
            $('#txtIdprocedimiento').val(rowData.idprocedimiento);
            $('#txtIdarea').val(rowData.idarea);
            $("#txtIdtipoprocedimiento").select2().select2('val', rowData.idtipoprocedimiento);
            $('#txtCodigo').val(rowData.codigo);
            $('#txtDenominacion').val(rowData.denominacion);
            $('#txtPlazodias').val(rowData.plazodias);
            $("#txtIdcargoresolutor").select2().select2('val', rowData.idcargoresolutor);
            $('#txtDescripcion').val(rowData.descripcion);
            $('#txtMontoTotal').val(rowData.montototal);
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
            var Procedimiento = {
                idprocedimiento: $('#container').data('idedit'),
                idarea: $('#txtIdarea').val(),
                idtipoprocedimiento: $('#txtIdtipoprocedimiento').val(),
                codigo: $('#txtCodigo').val(),
                denominacion: $('#txtDenominacion').val(),
                plazodias: $('#txtPlazodias').val(),
                idcargoresolutor: $('#txtIdcargoresolutor').val(),
                descripcion: $('#txtDescripcion').val(),
                montototal: $('#txtMontoTotal').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/ProcedimientoController/actualizarProcedimientoBE.htm', {poProcedimientoBE: Procedimiento}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    cargarGrilla($('#txtIdarea').val());
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    //initForm();
                    $("#txtIdarea").select2();
                    $("#txtIdtipoprocedimiento").select2();
                    $("#txtIdcargoresolutor").select2();
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
        var Procedimiento = {
            IndOpSp: 2,
            idprocedimiento: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/ProcedimientoController/eliminarProcedimientoBE.htm', {poProcedimientoBE: Procedimiento}, false, function (response) {
            if (response > 0) {
                bootbox.alert(Mensajes.operacionCorrecta);
                $("#btnNuevo").text('Nuevo');
                cargarGrilla($('#txtIdarea').val());
                $.DesabilitarForm('#form');
                $.LimpiarForm('#form');
                //initForm();
                $("#txtIdarea").select2();
                $("#txtIdtipoprocedimiento").select2();
                $("#txtIdcargoresolutor").select2();
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
    $.CargarCombo(urlApp + '/ProcedimientoController/listObjectProcedimientoBE.htm', {poProcedimientoBE: {IndOpSp: 1}}, '#txtIdarea');
    $.CargarCombo(urlApp + '/ProcedimientoController/listObjectProcedimientoBE.htm', {poProcedimientoBE: {IndOpSp: 3}}, '#txtIdtipoprocedimiento');
}

function cargarComboCargo(idarea) {//cargar combo segun area
    $.CargarCombo(urlApp + '/ProcedimientoController/listObjectProcedimientoBE.htm', {poProcedimientoBE: {IndOpSp: 2, idarea: idarea}}, '#txtIdcargoresolutor');
    $("#txtIdcargoresolutor").select2();
}