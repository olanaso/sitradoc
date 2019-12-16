/*!
 * Author:Lito Ventura 
 * Fecha Culminación: 01/09/2015 
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

    $("#txtIdusuario").change(function () {
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
    $("#txtIdrol").select2();
    $("#txtIdusuario").select2();
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 500,
        width: 500,
        ignoreCase: true,
        caption: "Lista Usuariorol",
        colNames: ["Editar", "Eliminar", "idusuariorol", "idusuario", "idrol", "Usuario", "Rol", "Nombres", "Apellidos", "Fecha de asignacion", "estado"],
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
                name: 'idusuariorol',
                index: 'idusuariorol',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'idusuario',
                index: 'idusuario',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'idrol',
                index: 'idrol',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'telefono',
                index: 'telefono',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'denominacionrol',
                index: 'denominacionrol',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'nombres',
                index: 'nombres',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'apellidos',
                index: 'apellidos',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'fechaasignacion',
                index: 'fechaasignacion',
                editable: false,
                width: 150,
                hidden: false,
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
        rownumbers: true,
        shrinkToFit: false,
        //multiselect: true
    });


    $("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});

}

function cargarGrilla(idUsuario) {
    $.ajaxCall(urlApp + '/UsuariorolController/listarRegistrosUsuariorolBE.htm', {poUsuariorolBE: {IndOpSp: 1, idusuario: idUsuario}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Usuariorol = {
                idusuariorol: $('#txtIdusuariorol').val(),
                idusuario: $('#txtIdusuario').val(),
                idrol: $('#txtIdrol').val(),
                fechaasignacion: $('#txtFechaasignacion').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/UsuariorolController/insertarUsuariorolBE.htm', {poUsuariorolBE: Usuariorol}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }
                if (response == -1) {
                    bootbox.alert(Mensajes.usuariorolDuplicado);
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
        if (rowData.idusuariorol === id.toString()) {
            //$('#txtIdusuariorol').val(rowData.idusuariorol);
            $("#txtIdusuario").select2().select2('val', rowData.idusuario);
            $("#txtIdrol").select2().select2('val', rowData.idrol);
            $('#txtFechaasignacion').val(rowData.fechaasignacion);
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
            var Usuariorol = {
                idusuariorol: $('#container').data('idedit'),
                idusuario: $('#txtIdusuario').val(),
                idrol: $('#txtIdrol').val(),
                fechaasignacion: $('#txtFechaasignacion').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/UsuariorolController/actualizarUsuariorolBE.htm', {poUsuariorolBE: Usuariorol}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }

                if (response == -1) {
                    bootbox.alert(Mensajes.usuariorolActualizar);
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
        var Usuariorol = {
            IndOpSp: 2,
            idusuariorol: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/UsuariorolController/eliminarUsuariorolBE.htm', {poUsuariorolBE: Usuariorol}, false, function (response) {
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
    $.CargarCombo(urlApp + '/UsuariorolController/listObjectUsuariorolBE.htm', {poUsuariorolBE: {IndOpSp: 2}}, '#txtIdusuario');
    $.CargarCombo(urlApp + '/UsuariorolController/listObjectUsuariorolBE.htm', {poUsuariorolBE: {IndOpSp: 3}}, '#txtIdrol');
}
