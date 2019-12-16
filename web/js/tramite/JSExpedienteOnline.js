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
    getCaptcha();
    autocompletarProcedimientos();
});


/*EVENTS
 * ------------------------
 */
$(function () {
    $("#txtDni_ruc").focusout(function (e) {
        seleccionarDNI($("#txtDni_ruc").val());
    });
    $("#txtIdprocedimiento").keyup(function (e) {
        if ($("#txtIdprocedimiento").val() === '') {
            $('#txtIdprocedimiento').css('background', '#FFF');
        }
    });
});


/* FUNCTIONS
 * ------------------------
 */



function getCaptcha() {

    $.ajax({
        url: urlApp + '/ExpedienteOnlineController/getCaptcha.htm',
        cache: false,
        type: 'POST',
        async: false,
        success: function (data) {
            $('#imgcatpcha').attr('src', data);
        }
    });
    //PintarRowGrilla("grid", 'bindobservado', 'false', '#E21E27', '#FFFFFF')
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var guardarExpediente = function (Expediente) {
                $.ajaxCall(urlApp + '/ExpedienteController/insertarExpedienteBE.htm', {poExpedienteBE: Expediente}, false, function (response) {
                    if (response > 0) {
                        var listExpedienterequisitoBE = new Array();
                        $($.getAlloptionsSelect('#destino')).each(function (index, value) {
                            listExpedienterequisitoBE.push(
                                    {
                                        idrequisitos: value,
                                        idexpediente: response,
                                        estado: true
                                    });
                        });
                        $.ajaxCall(urlApp + '/ExpedienterequisitoController/insertarRegistrosExpedienterequisitoBE.htm', {polistExpedienterequisitoBE: listExpedienterequisitoBE}, false, function (respuesta) {
                            bootbox.alert("<H2>CODIGO EXPEDIENTE :</H2><H1>" + response + "</H1>");
                            $("#btnNuevo").text('Nuevo');
                            $("#destino").html("");
                            $("#origen").html("");
                            $.DesabilitarForm('#form');
                            $.LimpiarForm('#form');
                            cargarGrilla();
                        });
                    }

                });
            };

            if (cantidadrequisitosentregar === $.getAlloptionsSelect('#destino').length) {
                //REGISTRAR COMO EXPEDIENTE SIN OBSERVADO
                var Expediente = {
                    idexpediente: $('#txtIdexpediente').val(),
                    idusuariocargo: Usuario.idusuario,
                    idprocedimiento: $('#txtIdprocedimiento').val(),
                    idarea: $('#txtIdarea').val(),
                    codigo: $('#txtCodigo').val(),
                    dni_ruc: $('#txtDni_ruc').val(),
                    nombre_razonsocial: $('#txtNombre_razonsocial').val(),
                    apellidos: $('#txtApellidos').val(),
                    direccion: $('#txtDireccion').val(),
                    telefono: $('#txtTelefono').val(),
                    correo: $('#txtCorreo').val(),
                    asunto: $('#txtAsunto').val(),
                    estado: true,
                    bindentregado: false,
                    bindobservado: false

                };
                guardarExpediente(Expediente);

            } else {
                bootbox.confirm("Faltan adjuntar REQUISITOS el expediente sera OBSERVADO.", function (result) {
                    if (result == true) {
                        //REGISTRAR COMO EXPEDIENTE OBSERVADO
                        var Expediente = {
                            idexpediente: $('#txtIdexpediente').val(),
                            idusuariocargo: Usuario.idusuario,
                            idprocedimiento: $('#txtIdprocedimiento').val(),
                            idarea: $('#txtIdarea').val(),
                            codigo: $('#txtCodigo').val(),
                            dni_ruc: $('#txtDni_ruc').val(),
                            nombre_razonsocial: $('#txtNombre_razonsocial').val(),
                            apellidos: $('#txtApellidos').val(),
                            direccion: $('#txtDireccion').val(),
                            telefono: $('#txtTelefono').val(),
                            correo: $('#txtCorreo').val(),
                            asunto: $('#txtAsunto').val(),
                            estado: true,
                            bindentregado: false,
                            bindobservado: true

                        };
                        guardarExpediente(Expediente);
                    }
                    else {
                        alert('cancelo')
                        return;
                    }
                });

            }


            break;
        case -1:
            bootbox.alert(Mensajes.camposRequeridos);
            break;
        case -2:
            bootbox.alert(Mensajes.camposIncorrectos);
            break;

    }
}


function autocompletarProcedimientos() {
    $("#txtIdprocedimiento").AutocompleteWithPobject(urlApp + "/ProcedimientoController/autocompletarProcedimiento.htm", {}, "#txtIdprocedimiento", 960,
            function (item) {
                console.log(item);
                return {
                    label: item.denominacion,
                    area: item.area,
                    idprocedimiento: item.idprocedimiento
                }
            },
            function (event, ui) {
                $('#txtIdarea').val(ui.item.area);
                generarRequisitos(ui.item.idprocedimiento)
                $('#txtIdprocedimiento').css('background', '#C7F0AA');
                //$('#txtIdarea').val(ui.item.area);

            });
}


function seleccionarDNI(dni_ruc) {
    $.ajaxCall(urlApp + '/ExpedienteController/listarRegistrosExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 3, dni_ruc: dni_ruc}}, false, function (response) {

        if (response.length === 0) {
            $("#txtNombre_razonsocial").val('');
            $("#txtApellidos").val('');
            $("#txtDireccion").val('');
            $("#txtTelefono").val('');
            $("#txtCorreo").val('');
        }
        else {
            $("#txtNombre_razonsocial").val(response[0].nombre_razonsocial);
            $("#txtApellidos").val(response[0].apellidos);
            $("#txtDireccion").val(response[0].direccion);
            $("#txtTelefono").val(response[0].telefono);
            $("#txtCorreo").val(response[0].correo);
        }


    });
}

function generarRequisitos(idprocedimiento) {
    $.ajaxCall(urlApp + '/RequisitosController/listarRegistrosRequisitosBE.htm', {poRequisitosBE: {IndOpSp: 3, idprocedimiento: idprocedimiento}}, false, function (response) {
        $('#listrequisitos').html('');
        $.each(response, function (index, value) {
            $('#listrequisitos').append('<tr>' +
                    '<th scope="row">' + (index + 1) + '</th>' +
                    '<td>' + value.denominacion + '</td>' +
                    '<td><input type="file" /></td>' +
                    '</tr>');
        });
    });
}










