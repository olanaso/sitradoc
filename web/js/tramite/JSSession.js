var Usuario;
$(function() {
    initlogin();

    $("#btncerrarsession").click(function(e) {
        cerrarsession();
    });

    $("#btnperfil").click(function(e) {
        $('#btnModal').click();
        $('#txtnombresusuario').val(Usuario.nombres);
        $('#txtapellidosusuario').val(Usuario.apellidos);
        //$('#txttelefonosusuario').val(Usuario.nrocontacto);
        $('#txtpasswordusuario').val(Usuario.contrasenia);
    });



    $('#activarPass').on('ifChecked', function(event) {
        $('#txtpasswordusuario').attr('type', 'text');
    });
    $('#activarPass').on('ifUnchecked', function(event) {
        $('#txtpasswordusuario').attr('type', 'password');
    });
    
    $("#btnsaveperfil").click(function() {
        guardarPerfil();
    });

});

function initlogin() {

    $.ajaxCall(urlApp + '/UsuarioController/initlogin.htm', {}, false, function(response) {
        if (response == null) {
            window.location.href = urlApp + '/login';
        }
        else {
            Usuario = response;
            console.log(Usuario);
            var admin = 'Administrador';
            var user = 'Usuario';
            $('#nomcompleto').text(response.nombres + ' ' + response.apellidos);
            $('#rol').text((response.idrol === 0) ? 'Administrador' : 'Usuario');
            $('#lblUsuario').text('Bienvenido ' + response.nombres);
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
    $.ajaxCall(urlApp + '/UsuarioController/cerrarsession.htm', {}, false, function(response) {
        if (response === null) {
            window.location.href = urlApp + '/pages/loginadmin.jsp';
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
            Usuario.constrasenia = $('#txtpasswordusuario').val();
            $.ajaxCall(urlApp + '/UsuarioController/actualizarUsuarioBE.htm', {poUsuarioBE: Usuario}, false, function(response) {
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
