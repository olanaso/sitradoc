var Usuario;
$(function () {
    initlogin();

    $("#btncerrarsession").click(function (e) {
        cerrarsession();
    });

    $("#btnperfil").click(function (e) {
        $('#btnModal').click();
        $('#txtnombresusuario').val(Usuario.nombres);
        $('#txtapellidosusuario').val(Usuario.apellidos);
        //$('#txttelefonosusuario').val(Usuario.nrocontacto);
        $('#txtpasswordusuario').val(Usuario.password);
    });



    $('#activarPass').on('ifChecked', function (event) {
        $('#txtpasswordusuario').attr('type', 'text');
    });
    $('#activarPass').on('ifUnchecked', function (event) {
        $('#txtpasswordusuario').attr('type', 'password');
    });

    $("#btnsaveperfil").click(function () {
        guardarPerfil();
    });

    $("#cambiar_area").click(function () {
        SelectAreamenu();
    });

    /* configuracion ftp */
    $("#configuracion").click(function (e) {
        $('#mymodal_configuraciones').modal({
            show: true
        });
    });

    $("#btn_testear_ftp").click(function () {
        testearFTP();
    });

    $("#btn_guardar_ftp").click(function () {
        guardarConfig()();
    });

    /* fin configuracion ftp */

});

function initlogin() {

    $.ajaxCall(urlApp + '/UsuarioController/initlogin.htm', {}, false, function (response) {
        if (response == null) {
            window.location.href = urlApp + '/login';
        }
        else {
            Usuario = response;
            console.log(Usuario);
            var admin = 'Administrador';
            var user = 'Usuario';
            $('#nomcompleto').text(response.nombres + ' ' + response.apellidos);
            $('#rol').text(response.roles);
            $('#areacargo').text(response.area + ' - ' + response.cargo);
            $('#lblUsuario').text('Bienvenido ' + response.nombres);

            $('#area_seleccionada').text("AREA");
            $('#area_seleccionada').attr('title', 'Area Seleccionada:  ' + response.area);
            $('#area_seleccionada').text($('#area_seleccionada').text().substring(0, 35));
            document.getElementById("imguser").src = response.foto;
            if (response.idusuario === 0) {

//                $("#side-menu").empty();
//                $("#side-menu").load(urlApp + '/html/principal/menuAdminWrapper.html', function() {
//                    cargarJS(urlApp + '/js/lib/metisMenu/jquery.metisMenu.js', 'menumetis');
//                    cargarJS(urlApp + '/js/app/plugin/sb-admin.js', 'sb-admin');
//                    cargarJS(urlApp + '/js/app/menu/JSMenu.js', 'menuPrincipal');
//                });
            }
            else {
//                $("#side-menu").empty();
//                $("#side-menu").load(urlApp + '/html/principal/menuUserWrapper.html', function() {
//                    cargarJS(urlApp + '/js/lib/metisMenu/jquery.metisMenu.js', 'menumetis');
//                    cargarJS(urlApp + '/js/app/plugin/sb-admin.js', 'sb-admin');
//                    cargarJS(urlApp + '/js/app/menu/JSMenu.js', 'menuPrincipal');
//                });
            }
        }

    });
}


function cerrarsession() {
    $.ajaxCall(urlApp + '/UsuarioController/cerrarsession.htm', {}, false, function (response) {
        if (response === null) {
            window.location.href = urlApp + '';
        }
    });
}


function guardarPerfil() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#formPerfil');
    switch (resulValidacion) {
        case 0:
            Usuario.nombres = $('#txtnombresusuario').val();
            Usuario.apellidos = $('#txtapellidosusuario').val();
            //nrocontacto = $('#txttelefonosusuario').val();
            Usuario.password = $('#txtpasswordusuario').val();
            $.ajaxCall(urlApp + '/UsuarioController/actualizarUsuarioBE.htm', {poUsuarioBE: Usuario}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $('#btncloseperfil').click();
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
var checkedselect = 0;
function SelectAreamenu() {

    $.ajaxCall(urlApp + '/UsuarioController/initlogin.htm', {}, false, function (response) {
        var opciones = '';
        $.each(response.listacargos, function (index, value) {
            if (response.listacargos.length === 0) {

                bootbox.alert("Es necesario asignar un cargo a este usuario");
            } else {
                if (response.listacargos.length === 1) {
                    //cargar area seleccionada


                } else {
                   console.log(value);
                 
                    opciones += '<div class="radio"> ' +
                            '<label for="areas-' + value.idarea + '"> ' +
                            '<input ' + (checkedselect == 0 ? 'checked' : '') + ' type="radio" name="areas" id="areas-' + value.idarea + '" value="' + value.idarea + '" > ' +
                              value.area + ' <i style="font-size:10px;">' + value.cargo+'</i>'
                            '</label> ' +
                            '</div>';
                    $('#container').data('container_' + value.idarea, value);

                }
            }
        });

        /**/
        if (opciones.length > 0) {
            bootbox.dialog({
                closeButton: false,
                title: "Seleccionar AREA de operacion.",
                message: '<div class="row">  ' +
                        '<div class="col-md-12"> ' +
                        '<form class="form-horizontal"> ' +
                        '<div class="form-group"> ' +
                        '<label class="col-md-4 control-label" for="awesomeness">¿Cual es el AREA en donde desea laborar?</label> ' +
                        '<div class="col-md-4">' +
                        opciones +
                        '</div> ' +
                        '</div>' +
                        '</form> </div>  </div>',
                buttons: {
                    success: {
                        label: "Seleccionar",
                        className: "btn-success",
                        callback: function () {
                            var id_container = $("input[name='areas']:checked").val()
                            //alert(id_container);
                            if (typeof id_container === "undefined") {
                                bootbox.alert("Es necesario selecccionar un area para poder trabajar");
                                location.reload();

                            } else {
                                setArea($('#container').data('container_' + id_container));
                                $('#areacargo').text($('#container').data('container_' + id_container).area + ' - ' +
                                        $('#container').data('container_' + id_container).cargo)
                                location.reload();
                            }
                            // alert("Hello " + name + ". You've chosen <b>" + id_container + "</b>");


                        }
                    }
                }
            });
        } else {

        }





    });
}

/**/

function setArea(objcargousuario) {

    $.ajaxCall(urlApp + '/UsuarioController/setDataUsuarioArea.htm', {poUsuarioBE: objcargousuario}, false, function (response) {
        console.log(response);

    });
    initlogin();
}


/*=============FUNCIONES DE FTP==============*/

function guardarConfig() {

    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form_ftp_config');

    switch (resulValidacion) {
        case 0:
            var ParametrosSystem = {
                ftp_ip_address: $('#txt_ip_ftp').val(),
                ftp_url_access: $('#txt_acceso_ftp').val(),
                ftp_folder_save: $('#txt_foldersave_ftp').val(),
                ftp_user: $('#txt_usuario_ftp').val(),
                ftp_password: $('#txt_password_ftp').val(),
                ftp_port: $('#txt_port_ftp').val(),
            };

            $.ajaxCall('FTPController/guardarConfiguracionFTP.htm', {poParametrosSystem: ParametrosSystem}, false, function(response) {
                console.log(response);
                if (response === true) {
                    bootbox.alert(Mensajes.configuracionGuardada,
                            function() {
                                $('#ModalCofig').modal('hide');
                                bootbox.alert(Mensajes.reinicioSistema, function() {
                                    location.reload();
                                });
                            });
                }
                else {
                    bootbox.alert(Mensajes.errorguardarConfig);
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

function testearFTP() {

    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form_ftp_config');

    switch (resulValidacion) {
        case 0:
            var ParametrosSystem = {
                ftp_ip_address: $('#txt_ip_ftp').val(),
                ftp_url_access: $('#txt_acceso_ftp').val(),
                ftp_folder_save: $('#txt_foldersave_ftp').val(),
                ftp_user: $('#txt_usuario_ftp').val(),
                ftp_password: $('#txt_password_ftp').val(),
                ftp_port: $('#txt_port_ftp').val(),
            };

            $.ajaxCall('FTPController/testConeccionFTP.htm', {poParametrosSystem: ParametrosSystem}, false, function(response) {
                console.log(response);
                if (response == true || response == 'true') {
                    bootbox.alert("Conectividad correcta ...");
                }
                else {
                    bootbox.alert("Conectividad erronea ...");
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

/*=============FIN FUNCIONES DE FTP==============*/