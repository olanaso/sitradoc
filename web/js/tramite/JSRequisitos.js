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
        cargarGrilla();
    });

    $("#txtIdprocedimiento").change(function (e) {
        cargarGrilla($(this).val());
    });

    $("#txtIdarea").change(function (e) {
        cargarComboProcedimiento($(this).val());
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
    $(".select2").select2();
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        ignoreCase: true,
        caption: "Lista Requisitos",
//        colNames: ["Edit", "Del", "idrequisitos", "idprocedimiento", "procdenominacion", "estado"],
        colNames: ["Edit", "Del", "idrequisitos", "idprocedimiento", "Procedimiento", "Requisitos", "estado"],
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
                name: 'idrequisitos',
                index: 'idrequisitos',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'idprocedimiento',
                index: 'idprocedimiento',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'procdenominacion',
                index: 'procdenominacion',
                editable: false,
                width: 250,
                hidden: false
            }, {
                name: 'denominacion',
                index: 'denominacion',
                editable: false,
                width: 250,
                hidden: false
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 80,
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

function cargarGrilla(idprocedimiento) {
    $.ajaxCall(urlApp + '/RequisitosController/listarRegistrosRequisitosBE.htm', {poRequisitosBE: {IndOpSp: 1, idprocedimiento: idprocedimiento}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Requisitos = {
                idrequisitos: $('#txtIdrequisitos').val(),
                idprocedimiento: $('#txtIdprocedimiento').val(),
                denominacion: $('#txtDenominacion').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/RequisitosController/insertarRequisitosBE.htm', {poRequisitosBE: Requisitos}, false, function (response) {
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
        if (rowData.idrequisitos === id.toString()) {
            $('#txtIdrequisitos').val(rowData.idrequisitos);
            $('#txtIdprocedimiento').val(rowData.idprocedimiento);
            $('#txtDenominacion').val(rowData.denominacion);
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
            var Requisitos = {
                idrequisitos: $('#container').data('idedit'),
                idprocedimiento: $('#txtIdprocedimiento').val(),
                denominacion: $('#txtDenominacion').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/RequisitosController/actualizarRequisitosBE.htm', {poRequisitosBE: Requisitos}, false, function (response) {
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
        var Requisitos = {
            IndOpSp: 2,
            idrequisitos: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/RequisitosController/eliminarRequisitosBE.htm', {poRequisitosBE: Requisitos}, false, function (response) {
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
    $.CargarCombo(urlApp + '/RequisitosController/listObjectRequisitosBE.htm', {poRequisitosBE: {IndOpSp: 1}}, '#txtIdarea');
}

function cargarComboProcedimiento(idprocedimiento) {//cargar combo segun area
    $.CargarCombo(urlApp + '/RequisitosController/listObjectRequisitosBE.htm', {poRequisitosBE: {IndOpSp: 2, idprocedimiento: idprocedimiento}}, '#txtIdprocedimiento');
}