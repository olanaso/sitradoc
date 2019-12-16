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
var Usuario;
$(function () {

    initConfig();
    initlogin();

    $("#btnLogin").click(function (e) {
        login();
    });

    /*evento del boton guardar la configuracion en un xml*/
    $('#btnGuardarConfig').click(function () {
        guardarConfig();
    });
    $('#btntestconeccion').click(function () {
        testconeccion();
    });

    $('#txtpassword').on('keypress', function (e) {

        if (e.keyCode === 13) {
            login();
        }


    });

    $("#txtusuario").focusout(function (e) {
        if ($("#txtusuario").val() !== '')
        {
            $('#msg').text('');
        }
        else {
            $('#msg').text(Mensajes.camposRequeridos2);
        }
    });

    $("#txtpassword").focusout(function (e) {
        if ($("#txtpassword").val() !== '')
        {
            $('#msg').text('');
        }
        else {
            $('#msg').text(Mensajes.camposRequeridos2);
        }
    });
    /*para crear la url*/
    $('.geneUrl').on('keyup', function (e) {
        construirUrl();
    });


});


function  construirUrl() {
    $('#txtUrl').val("jdbc:postgresql://" + $('#txtIpServidor').val() + ":" + $('#txtPuertoServidor').val() + "/" + $('#txtBaseDatos').val());

}


function guardarConfig() {

    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#formConfig');

    switch (resulValidacion) {
        case 0:
            var ParametrosSystem = {
                driverPostgres: $('#txtDriver').val(),
                urlPostgres: $('#txtUrl').val(),
                ipServidor: $('#txtIpServidor').val(),
                nombrePcServidor: $('#txtNombreServidor').val(),
                ipCliente: '',
                nombrePcCliente: '',
                puertoPostgres: $('#txtPuertoServidor').val(),
                baseDatos: $('#txtBaseDatos').val(),
                usuarioPostgres: $('#txtUsuariobd').val(),
                passwordPostgres: $('#txtContrasenia').val(),
                pathPgDumpPostgres: '',
                pathReport: '',
                pathBackup: '',
                nickSistema: 'Zoom Corp',
                txtEditorLayer: $('#txtEditorLayer').val(),
            };

            $.ajaxCall('UsuarioController/guardarConfiguracion.htm', {poParametrosSystem: ParametrosSystem}, false, function (response) {
                if (response === 'true' || response === true ) {
                    bootbox.alert(Mensajes.configuracionGuardada,
                            function () {
                                $('#ModalCofig').modal('hide');
                                bootbox.alert(Mensajes.reinicioSistema, function () {
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

function initlogin() {
    $.ajaxCall(urlApp + '/UsuarioController/initlogin.htm', {}, false, function (response) {
        if (response == null) {

        }
        else {
//            window.location.href = urlApp + '/bandeja';
            //window.location.href = urlApp + '/bandejaTramite';
            window.location.href = urlApp + '/menu';
        }

    });
}

function testconeccion() {

    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#formConfig');

    switch (resulValidacion) {
        case 0:
            var ParametrosSystem = {
                driverPostgres: $('#txtDriver').val(),
                urlPostgres: $('#txtUrl').val(),
                ipServidor: $('#txtIpServidor').val(),
                nombrePcServidor: $('#txtNombreServidor').val(),
                ipCliente: '',
                nombrePcCliente: '',
                puertoPostgres: $('#txtPuertoServidor').val(),
                baseDatos: $('#txtBaseDatos').val(),
                usuarioPostgres: $('#txtUsuariobd').val(),
                passwordPostgres: $('#txtContrasenia').val(),
                pathPgDumpPostgres: '',
                pathReport: '',
                pathBackup: '',
                nickSistema: 'Zoom Corp',
                txtEditorLayer: $('#txtEditorLayer').val(),
            };

            $.ajaxCall('UsuarioController/testConeccion.htm', {poParametrosSystem: ParametrosSystem}, false, function (response) {
                console.log(response);
                if (response === 'true') {
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

function initConfig() {

    $.ajaxCall('UsuarioController/init.htm', {}, false, function (response) {
        console.log(response);
        if (response === 'false') {
            bootbox.alert(Mensajes.errorConeccionBD);
            $('#txtusuario').prop('disabled', true);
            $('#txtpassword').prop('disabled', true);
            $('#btnLogin').prop('disabled', true);
        }
        if (response == 'null' || response == null) {
            $('#ModalCofig').modal('show');

        }
        if (response === 'true') {

            $('#txtusuario').prop('disabled', false);
            $('#txtpassword').prop('disabled', false);
            $('#btnLogin').prop('disabled', false);
        }


    });
}




function login() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Usuario = {
                IndOpSp: 2,
                usuario: $('#txtusuario').val(),
                password: $('#txtpassword').val()
            };
            $.ajaxCall(urlApp + '/UsuarioController/iniciarsession.htm', {poUsuarioBE: Usuario}, false, function (response) {
                console.log('response:');
                console.log(response);
                if (response === null) {
                    $('#msg').text("El usuario y/o contraseñas son incorrectas.");
                }
                else {
                    Usuario = response;
                    $('#msg').text("");
                    //redireccionar
//                    window.location.href = urlApp + '/bandeja';
                    window.location.href = urlApp + '/bandejaTramite';
                    window.location.href = urlApp + '/menu';
                }
            });
            break;
        case -1:
            $('#msg').text(Mensajes.camposRequeridos2);
            break;
        case -2:
            $('#msg').text(Mensajes.camposIncorrectos2);
            break;

    }
}






