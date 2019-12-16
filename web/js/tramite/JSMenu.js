
$(function () {

    getAreaCargo();
    getRoles();
    initlogin();
    generarModulos();
    $('#textInicio').text('MODULOS');
    SelectArea();
});


function SelectArea() {
    
    
    $.ajaxCall(urlApp + '/UsuarioController/initlogin.htm', {}, false, function (response) {


        if (response.bindcargoseleccionado === null || response.bindcargoseleccionado === 'null' || response.bindcargoseleccionado === false)
        {
            var opciones = '';
            $.each(response.listacargos, function (index, value) {
                if (response.listacargos.length === 0) {
                    bootbox.alert("Es necesario asignar un cargo a este usuario");
                } else {
                    if (response.listacargos.length === 1) {
                        //cargar area seleccionada
                        //$('#container').data('container_' + value.idarea, value)
                        console.log('VALOR ');
                        console.log(value);
                        setArea(value);
                        $('#areacargo').text(value.area + ' - ' + value.cargo)


                    } else {
                        opciones += '<div class="radio"> ' +
                                '<label for="areas-' + value.idarea + '"> ' +
                                '<input type="radio" name="areas" id="areas-' + value.idarea + '" value="' + value.idarea + '" > ' +
                                value.area +
                                '</label> ' +
                                '</div>';

                        $('#container').data('container_' + value.idarea, value);

                    }
                }
            });

            /**/
            if (opciones.length > 0) {
                bootbox.dialog({
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
                                    location.reload;

                                } else {
                                    setArea($('#container').data('container_' + id_container));
                                    $('#areacargo').text($('#container').data('container_' + id_container).area + ' - ' +
                                            $('#container').data('container_' + id_container).cargo)
                                }
                                // alert("Hello " + name + ". You've chosen <b>" + id_container + "</b>");


                            }
                        }
                    }
                });
            } else {

            }


        }
        else {
            $('#areacargo').text(response.area + ' - ' + response.cargo)
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

function generarModulos() {
    $.ajaxCall(urlApp + '/UsuarioController/listObjectUsuarioBE.htm', {poUsuarioBE: {IndOpSp: 4, idusuario: Usuario.idusuario}}, false, function (response) {


        $('#menuModulos').html('');
        $.each(response, function (index, value) {
            $('#menuModulos').append(' <a href="' + urlApp + '/' + value[2] + '">' + '<div class="col-md-3 cursor">' +
                    '<div class="info-box">' +
                    '<span class="info-box-icon ' + randomColor() + '">' + value[1].substring(0, 1).toUpperCase() + '</span>' +
                    '<div class="info-box-content">' +
                    '<span class="info-box-text"></span>' +
                    '<span class="info-box-number">' + value[1] + '</span>' + '</div>' +
                    '</div>' +
                    '</div>' +
                    '</a>');
        });
    });
}


var datosUsuario = {};
function getAreaCargo() {
    $.ajaxCall(urlApp + '/UsuariocargoController/listarRegistrosUsuariocargoBE.htm', {poUsuariocargoBE: {IndOpSp: 3, idusuario: Usuario.idusuario}}, false, function (response) {
        if (response.length === 0) {
            bootbox.alert("Es necesario asignar un cargo a este usuario");
        } else {
            datosUsuario.listacargos = response;
        }
        console.log(response)
    });
}



function getRoles() {
    $.ajaxCall(urlApp + '/UsuarioController/listObjectUsuarioBE.htm', {poUsuarioBE: {IndOpSp: 2, idusuario: Usuario.idusuario}}, false, function (response) {


        datosUsuario.roles = response[0][0];
        setDataUsuario(datosUsuario);
    });
}

function setDataUsuario() {


    $.ajaxCall(urlApp + '/UsuarioController/setDataUsuario.htm', {poUsuarioBE: datosUsuario}, false, function (response) {
        console.log(response);

    });
}




var Color = ['bg-green', 'bg-aqua', 'bg-red', 'bg-yellow', 'bg-blue', 'bg-light-blue', 'bg-navy', 'bg-teal',
    'bg-olive', 'bg-olive', 'bg-orange', 'bg-fuchsia', 'bg-purple', 'bg-black'];
function randomColor() {
    return Color[Math.floor((Math.random() * 14) + 1)];
}