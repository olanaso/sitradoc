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

function previewphoto() {
    document.getElementById("txtIcono").onchange = function () {
        var reader = new FileReader();

        reader.onload = function (e) {
            // get loaded data and render thumbnail.
            document.getElementById("image").src = e.target.result;
        };
        // read the image file as a data URL.
        reader.readAsDataURL(this.files[0]);
        if (this.files[0].size > 102400) {
            bootbox.alert("La imagen sobre pasa el tamaño permitido", function (e) {
                document.getElementById("image").src = 'http://placehold.it/150x200';
                $('#txtIcono').val('');
            })
        }
    };
}

$(function () {
    previewphoto()
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
        document.getElementById("image").src = 'http://placehold.it/150x200';
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
        width: 500,
        ignoreCase: true,
        caption: "Lista Usuario",
        colNames: ["Editar", "Eliminar", "idusuario", "Nombres", "Apellidos", "DNI", "DirecciÓn", "Teléfono", "Usuario", "Password", "Estado", "Foto","Iniciales"],
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
                name: 'idusuario',
                index: 'idusuario',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'nombres',
                index: 'nombres',
                editable: false,
                width: 130,
                hidden: false
            }, {
                name: 'apellidos',
                index: 'apellidos',
                editable: false,
                width: 170,
                hidden: false
            }, {
                name: 'dni',
                index: 'dni',
                editable: false,
                width: 110,
                hidden: false
            }, {
                name: 'direccion',
                index: 'direccion',
                editable: false,
                width: 180,
                hidden: false
            }, {
                name: 'telefono',
                index: 'telefono',
                editable: false,
                width: 110,
                hidden: false
            }, {
                name: 'usuario',
                index: 'usuario',
                editable: false,
                width: 160,
                hidden: false
            }, {
                name: 'password',
                index: 'password',
                editable: false,
                width: 160,
                hidden: false
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'foto',
                index: 'foto',
                editable: false,
                width: 150,
                hidden: true
            }
            , {
                name: 'iniciales',
                index: 'iniciales',
                editable: false,
                width: 150,
                hidden: false
            }
        ],
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
    $.ajaxCall(urlApp + '/UsuarioController/listarRegistrosUsuarioBE.htm', {poUsuarioBE: {IndOpSp: 1}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Usuario = {
                idusuario: $('#txtIdusuario').val(),
                nombres: $('#txtNombres').val().trim(),
                apellidos: $('#txtApellidos').val().trim(),
                dni: $('#txtDni').val(),
                direccion: $('#txtDireccion').val(),
                telefono: $('#txtTelefono').val(),
                usuario: $('#txtUsuario').val().trim(),
                password: $('#txtPassword').val(),
                foto: $('#image').attr('src'),
                iniciales:$('#txtIniciales').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/UsuarioController/insertarUsuarioBE.htm', {poUsuarioBE: Usuario}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();
                    document.getElementById("image").src = 'http://placehold.it/150x200';

                }

                if (response == -1) {
                    bootbox.alert(Mensajes.usuarioDuplicado);
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
        if (rowData.idusuario === id.toString()) {
            $('#txtIdusuario').val(rowData.idusuario);
            $('#txtNombres').val(rowData.nombres);
            $('#txtApellidos').val(rowData.apellidos);
            $('#txtDni').val(rowData.dni);
            $('#txtDireccion').val(rowData.direccion);
            $('#txtTelefono').val(rowData.telefono);
            $('#txtUsuario').val(rowData.usuario);
            document.getElementById("image").src = rowData.foto;
            $('#txtPassword').val(rowData.password);
            $('#txtIniciales').val(rowData.iniciales);
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
            var Usuario = {
                idusuario: $('#container').data('idedit'),
                nombres: $('#txtNombres').val(),
                apellidos: $('#txtApellidos').val(),
                dni: $.trim($('#txtDni').val()),
                direccion: $('#txtDireccion').val(),
                telefono: $('#txtTelefono').val(),
                usuario: $.trim($('#txtUsuario').val()),
                password: $('#txtPassword').val(),
                foto: $('#image').attr('src'),
                iniciales:$('#txtIniciales').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/UsuarioController/actualizarUsuarioBE.htm', {poUsuarioBE: Usuario}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();
                    document.getElementById("image").src = 'http://placehold.it/150x200';

                }
                if (response === -1) {
                    bootbox.alert(Mensajes.usuarioDuplicado);
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
        var Usuario = {
            IndOpSp: 2,
            idusuario: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/UsuarioController/eliminarUsuarioBE.htm', {poUsuarioBE: Usuario}, false, function (response) {
            if (response > 0) {
                bootbox.alert(Mensajes.operacionCorrecta);
                $("#btnNuevo").text('Nuevo');
                $.DesabilitarForm('#form');
                $.LimpiarForm('#form');
                cargarGrilla();
                document.getElementById("image").src = 'http://placehold.it/150x200';
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
