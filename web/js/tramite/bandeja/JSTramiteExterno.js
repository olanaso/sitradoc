/*!
 * Author: Erick Escalante Olano
 * Description:
 *      Archivo JS para adminitracion 
 !**/



$(function () {


    $("#tramiteExterno").click(function (evento) {
        $('#overlayTramiteExterno').show(500);
        initFormTramiteExterno();
    });

    initFormTramiteExterno();

    $('.overlay_close_tramite_externo').click(function () {
        $('#overlayTramiteExterno').hide(500);
    });
    /*''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''*/
    $("#btncambiarestado").click(function (e) {
        cambiarestadoflujo();
    });
    $('.grilla').on('keypress', function (e) {
        if (e.keyCode === 13) {
            //debugger;
            cargarEstados(Usuario.idarea);
            cargarGrilla_TramiteExterno();
        }
    });
    /*cambiar al cambio del tipo de documento*/
    $('#drptipodocumento_derivar').on('change', function (e) {
        geneCodDocumento();
    });
    $('#btnderivardocumento').on('click', function (e) {
        derivarDocumento();
    });


});


/* FUNCTIONS
 * ------------------------
 */
function initFormTramiteExterno() {
    crearGrilla_tramiteExtermo();
    cargarEstados(Usuario.idarea);

    $('#container').data('estadoflujo', 1);
    $('#container').data('idusuario', Usuario.idusuario);
    $('#containerGrilla_tramiteExterno').bind('resize', function () {
        $("#grid_tramiteExterno").setGridWidth($('#containerGrilla_tramiteExterno').width());
    }).trigger('resize');
    $('#container').data('idestado', 1);
}

$('#textInicio').text('BANDEJA DE TRAMITE');
function crearGrilla_tramiteExtermo() {

    $("#grid_tramiteExterno").jqGrid({
        /*data: mydata,*/
        datatype: function () {
            cargarGrilla_TramiteExterno(Usuario.idusuario, 1);
        },
        height: 300,
        width: 500,
        ignoreCase: true,
        //caption: "LISTA DE FLUJO DE EXPEDIENTES",
        colNames: ["Visualizar", "Resolver", "Derivar Interno", "Derivar a Area", "idflujo", "idexpediente", "C&oacute;digo Expediente", "Administrado", "Asunto", "Remitente", "Dias restantes", "Fecha Ingreso", "Fecha Envio", "¿Leido?"],
        colModel: [
            {
                name: 'visualizar',
                index: 'visualizar',
                editable: false,
                align: "center",
                width: 90,
                search: false,
                hidden: false
            },
            {
                name: 'resolver',
                index: 'resolver',
                editable: false,
                align: "center",
                width: 90,
                search: false,
                hidden: false
            }
            ,
            {
                name: 'gentraminterno',
                index: 'gentraminterno',
                editable: false,
                align: "center",
                width: 120,
                search: false,
                hidden: false
            },
            {
                name: 'derivar',
                index: 'derivar',
                editable: false,
                align: "center",
                width: 140,
                search: false,
                hidden: false
            },
            {
                name: 'idflujo',
                index: 'idflujo',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'idexpediente',
                index: 'idexpediente',
                editable: false,
                width: 150,
                hidden: true,
                search: false
            }, {
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 90,
                align: 'right',
                hidden: false,
                search: false
            }, {
                name: 'nombres',
                index: 'nombres',
                editable: false,
                width: 250,
                hidden: false,
                search: false
            }, {
                name: 'asunto',
                index: 'asunto',
                editable: false,
                width: 300,
                hidden: false,
                search: false
            }, {
                name: 'remitente',
                index: 'remitente',
                editable: false,
                width: 250,
                hidden: false,
                search: false
            }, {
                name: 'diasrestantes',
                index: 'diasrestantes',
                editable: false,
                width: 80,
                hidden: false,
                align: 'right',
                search: false
            }, {
                name: 'fechaingreso',
                index: 'fechaingreso',
                editable: false,
                width: 150,
                hidden: false,
                align: 'center',
                search: false
            }, {
                name: 'fecharecepcion',
                index: 'fecharecepcion',
                editable: false,
                width: 150,
                hidden: false,
                align: 'center',
                search: false
            }, {
                name: 'isleido',
                index: 'isleido',
                editable: false,
                width: 60,
                hidden: false,
                align: 'center',
                search: false
            }],
        pager: '#pager_tramiteExterno',
        //onSelectRow: viewGeometry,
        // storname: 'idexpediente',
        loadtext: 'Cargando datos...',
        recordtext: "{0} - {1} de {2} elementos",
        emptyrecords: 'No hay resultados',
        pgtext: 'Pág: {0} de {1}',
        rowNum: "20",
//        rowList: [10, 20, 30],
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        //multiselect: true
    });
    $("#grid_tramiteExterno").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}

function cargarGrilla_TramiteExterno() {
    var UsuarioBE = {
        IndOpSp: 6,
        idusuario: Usuario.idusuario
    };
    $.ajaxCall(urlApp + '/UsuarioController/listObjectUsuarioBE.htm', {poUsuarioBE: UsuarioBE}, false, function (response) {
        if (response.length > 0) {
            var FlujoBE = {
                IndOpSp: 2,
                idusuariorecepciona: $('#container').data('idusuario'),
                idestadoflujo: $('#container').data('estadoflujo'),
                idarea: Usuario.idarea
                , anio: ($.trim($('#pre_txtbusquedaanio_tramite_externo').val()) === '') ? 0 : $.trim($('#pre_txtbusquedaanio_tramite_externo').val())
                , codigo: ($.trim($('#pre_txtbusquedacodigoexpediente_tramite_externo').val()) === '') ? 0 : $.trim($('#pre_txtbusquedacodigoexpediente_tramite_externo').val())
                , nombre_razonsocial: $.trim($('#pre_txtbusqueda_tramite_externo').val()),
                rows: $("#grid_tramiteExterno").getGridParam("rowNum"),
                page: $("#grid_tramiteExterno").getGridParam("page")

            };

            $.ajaxCall(urlApp + '/FlujoController/listarJQRegistrosFlujoBE.htm', {poFlujoBE: FlujoBE}, false, function (response) {
                $('#grid_tramiteExterno').jqGrid('clearGridData');
                $("#grid_tramiteExterno")[0].addJSONData(response);
                if ($('#container').data('idusuario') == 2 || $('#container').data('idusuario') == 3) {

                }
                else {
                    PintarRowGrilla('grid', 'isleido', 'NO', null, '#136641');
                    PintarRowGrilla('grid', 'isleido', 'SI', null, 'blue');
                    PintarRowGrillaavanzado('grid', 'diasrestantes', '0', '<', '#FF9D9F', '#000')
                }

            });
        }
        ;
    });
}

function cargarGrillaSecundaria(idusuariorecepciona, idestadoflujo) {
    $.ajaxCall(urlApp + '/FlujoController/listarRegistrosFlujoBE.htm', {poFlujoBE: {IndOpSp: 3, idusuariorecepciona: idusuariorecepciona, bindatendido: (idestadoflujo === 'f') ? false : true, idarea: Usuario.idarea}}, false, function (response) {
        $('#grid_tramiteExterno').jqGrid('clearGridData');
        jQuery("#grid_tramiteExterno").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
        PintarRowGrilla('grid', 'isleido', 'NO', null, '#136641');
        PintarRowGrilla('grid', 'isleido', 'SI', null, 'blue');
    });
}


function derivarmensaje() {

    // alert(1)
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#frmderivar');
    switch (resulValidacion) {
        case 0:
            //
            //registrarEnvioArchivos();
            break;
        case -1:
            bootbox.alert(Mensajes.camposRequeridos);
            break;
        case -2:
            bootbox.alert(Mensajes.camposIncorrectos);
            break;

    }
}

//Funcion de derivar mensaje des
function derivarmensaje() {

    var generarCodiDocumento = function (e) {


    };
}


window.cargarEstados = cargarEstados;
function cargarEstados(idusuariorecepciona) {

    if (Usuario.bindjefe) {

        $.ajaxCall(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 2, idusuariorecepciona: idusuariorecepciona}}, false, function (response) {
            if (response.length > 0) {

                $('#listestados').html('');
                $.each(response, function (index, value) {
                    if (index === 0) {
                        $('#listestados').append('<li class="active estado" onclick="cargarflujo(this,' + value[0] + ',' + Usuario.idusuario + ',\'' + value[1] + '\')"><a href="#"> ' + value[1] + ' (' + value[2] + ')</a></li>');
                    } else {
                        $('#listestados').append('<li class="estado" onclick="cargarflujo(this,' + value[0] + ',' + Usuario.idusuario + ',\'' + value[1] + '\')"><a href="#"> ' + value[1] + ' (' + value[2] + ')</a></li>');
                    }
                });
            }
        });
    }
    else {

        $.ajaxCall(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 3, idusuariorecepciona: idusuariorecepciona}}, false, function (response) {
            if (response.length > 0) {

                $('#listestados').html('');
                $.each(response, function (index, value) {
                    if (index === 0) {
                        $('#listestados').append('<li class="active estado" onclick="cargarflujosecundario(this,\'' + value[2] + '\',' + Usuario.idusuario + ',\'' + value[0] + '\')"><a href="#"> ' + value[0] + ' (' + value[1] + ')</a></li>');
                    } else {
                        $('#listestados').append('<li class="estado" onclick="cargarflujosecundario(this,\'' + value[2] + '\',' + Usuario.idusuario + ',\'' + value[0] + '\')"><a href="#"> ' + value[0] + ' (' + value[1] + ')</a></li>');
                    }
                });
            }
        });

    }

}


function cargarflujosecundario(li, idestadoflujo, idusuario, estado) {
    $('.estado').removeClass('active');
    $(li).addClass('active');
    console.log(idestadoflujo, idusuario, estado)
    cargarGrillaSecundaria(idusuario, idestadoflujo);
    // alert(idestadoflujo)
    $('#container').data('estadoflujo', idestadoflujo);
    $('#container').data('idusuario', idusuario)


}

/*Permite cargar los datos de acuedo al estado del expediente UTILIZADO: SI*/
function cargarflujo(li, idestadoflujo, idusuario, estado) {
    $('.estado').removeClass('active');
    $(li).addClass('active');
    $('#container').data('estadoflujo', idestadoflujo);
    $('#container').data('idusuario', idusuario)
    if (idestadoflujo == 2 || idestadoflujo == 3 || idestadoflujo == 4) {
        jQuery("#grid_tramiteExterno").setGridParam().hideCol("derivar").trigger("reloadGrid");
        jQuery("#grid_tramiteExterno").setGridParam().hideCol("resolver").trigger("reloadGrid");
        jQuery("#grid_tramiteExterno").setGridParam().hideCol("gentraminterno").trigger("reloadGrid");

    }
    else {
        jQuery("#grid_tramiteExterno").setGridParam().showCol("derivar").trigger("reloadGrid");
        jQuery("#grid_tramiteExterno").setGridParam().showCol("resolver").trigger("reloadGrid");
        jQuery("#grid_tramiteExterno").setGridParam().showCol("gentraminterno").trigger("reloadGrid");
    }
    cargarGrilla_TramiteExterno();
}


function crearListaFlujo() {

    var arrayFlujoEnviar = new Array();


    $.each(arrayUsuario, function (index, value) {
        var flujo = {
            idexpediente: $('#container').data('idexpediente'),
            idflujoparent: $('#container').data('idflujoparent'),
            idestadoflujo: 1, //pendiente
            idusuario: Usuario.idusuario,
            idusuarioenvia: Usuario.idusuario,
            idusuariorecepciona: value.substring(0, value.lastIndexOf(",")),
            asunto: $('#txtAsunto').val(),
            descripcion: $('#txaMensaje').val(),
            observacion: $('#txaMensaje').val(),
            binderror: false,
            estado: true
        }
        arrayFlujoEnviar.push(flujo)
    });

    return arrayFlujoEnviar;

}

function enviarmensaje(idusuario, idexpediente) {

    var Flujo = {
        idexpediente: idexpediente,
        idestadoflujo: 1, //pendiente
        idusuario: Usuario.idusuario,
        idusuarioenvia: Usuario.idusuario,
        idusuariorecepciona: idusuario,
        asunto: $('#txtAsunto').val(),
        descripcion: $('#txaMensaje').val(),
        observacion: $('#txaMensaje').val(),
        binderror: false,
        estado: true

    };

    $.ajaxCall(urlApp + '/FlujoController/insertarFlujodetalleExpedienteBE.htm', {poFlujoBE: Flujo, listVolumen: getArrayObjectArchivos()}, false, function (response) {

        if (response > 0) {


        }
    });




}

function registrarEnvioArchivos() {

    $.ajaxCall(urlApp + '/FlujoController/insertarEnvio.htm', {poFlujoBE: {idusuario: Usuario.idusuario}, listVolumen: getArrayObjectArchivos()}, false, function (response) {

        if (response > 0) {

            $.ajaxUpload(urlApp + '/FlujoController/insertarArchivoFlujo.htm', 'frmderivar', function (response) {
            });

            $.ajaxCall(urlApp + '/FlujoController/insertarListaFlujo.htm', {listflujo: crearListaFlujo()}, false, function (response) {
                if (response > 0) {
                    bootbox.alert("Tu mensaje fue correctamente enviado a los destinos");
                    $('#myModal2').modal('hide');
                }
                else {
                    bootbox.alert("Ocurrio un error en el envio, comuniquese con el administrador");
                }
            });
        }
    });

}



function cambiarestadoflujo() {
    if ($('#txaobservacioncambioestado').val().trim() === '') {
        $('#txtmensajealerta').text('Ingrese la observacion.');
    } else {
        $('#txtmensajealerta').text('');
        var flujo = {
            idflujo: $('#container').data('idflujocambio'),
            idestadoflujo: $('#container').data('idestado'),
            cuerporespuesta: $('#txaobservacioncambioestado').val(),
            idusuario: Usuario.idusuario,
            idarea: Usuario.idarea,
            sfecharegistro: ($.trim($('#pre_fecha_registro_manual_resolucion_recepcionExterna').val()) == ''
                    || $.trim($('#pre_fecha_registro_manual_resolucion_recepcionExterna').val()) == 'dd/mm/aaaa hh:mm')
                    ? '' : $('#pre_fecha_registro_manual_resolucion_recepcionExterna').val()
        };

        $.ajaxCall(urlApp + '/FlujoController/actualizarEstadoFlujoBE.htm', {poFlujoBE: flujo}, false, function (response) {
            if (response > 0) {
                bootbox.alert("El Expediente fue resuelto.");
                $('#mdlResolverExpediente').modal('hide');
            }
            if (response === -1) {
                bootbox.alert("El Expediente llego a un estado final y no se puede cambiar");
                $('#mdlResolverExpediente').modal('hide');
            }
        });
        cargarEstados(Usuario.idarea);
        cargarGrilla_TramiteExterno(Usuario.idusuario, 1);
    }
}

/*funcion que permite crear un nuevo flujo para derivar*/
function derivarFlujo() {

    var Flujo = {
        idflujo: $('#container').data('idflujo_derivar'),
        idexpediente: $('#container').data('idexpediente_derivar'),
        idusuario: Usuario.idusuario,
        idarea: eval($('#drparea_derivar').val())[0]
                //idareadestino:$('#drparea').val()

    };

    $.ajaxCall(urlApp + '/FlujoController/registroderivarflujo.htm', {poFlujoBE: Flujo}, false, function (response) {
        if (response > 0) {
            // alert(response);
        }
    });
}

/*============EVENTOS GENERADOS POR LAS FILAS =======================*/
/*Funcion para visualizar UTILIZADO*/
function visualizar(idflujo, idexpediente, asunto) {
    var Flujo = {
        idflujo: idflujo

    };

    $.ajaxCall(urlApp + '/FlujoController/lecturaFlujoBE.htm', {poFlujoBE: Flujo}, false, function (response) {
        if (response > 0) {
            $('#mdlDetalleExpediente').modal('show');
            $.ajaxCall(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 4, idflujo: idflujo}}, false, function (response) {
                console.log(response);
                $('#txtdt_codigo').val(response[0][0]);
                $('#txtdt_asunto').val(response[0][1]);
                $('#txtdt_area').val(response[0][10]);
                $('#txtdt_procedimiento').val(response[0][11]);
                $('#txtdt_fechaingreso').val(response[0][8]);
                $('#txtdt_fecharecepcion').val(response[0][9]);

                $('#txtdt_nrodoc').val(response[0][2]);
                $('#txtdt_nombres').val(response[0][3]);
                $('#txtdt_apellidos').val(response[0][4]);
                $('#txtdt_direccion').val(response[0][5]);
                $('#txtdt_telefonos').val(response[0][6]);
                $('#txtdt_correo').val(response[0][7]);
            });
        }
    });

}
/*Funcion que permite resolver UTILIZADO*/

function resolver(idflujo, idexpediente, asunto) {
    $('#container').data('idexpediente', idexpediente);
    $('#container').data('idflujocambio', idflujo);
    $('#mdlResolverExpediente').modal('show');
    $.ajaxCall(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 5}}, false, function (response) {
        $('#listaestadoflujo').html('');
        $.each(response, function (index, value) {
            $('#listaestadoflujo').append(' <div class="radio">' +
                    '<label>' +
                    '<input type="radio" checked="" value="' + value[0] + '"  name="optionsRadios">' +
                    value[1] +
                    '</label>' +
                    '</div>');
        });
        $("#frmderivar input[type='checkbox']:not(.simple), input[type='radio']:not(.simple)").iCheck({
            checkboxClass: 'icheckbox_minimal',
            radioClass: 'iradio_minimal'
        });
        console.log($('#container').data('estadoflujo'));
        $("input[value='" + $('#container').data('estadoflujo') + "']").iCheck('check');

        $('input').on('ifChecked', function (event) {
            $('#container').data('idestado', $(this).val());
        });
    });



}
/*funcion que deriva un documento a otra area UTILIZADO*/
function derivar(codigo, idflujo, idexpediente, asunto) {

    $('#container').data('codigo_derivar', codigo);
    $('#container').data('idflujo_derivar', idflujo);
    $('#container').data('idexpediente_derivar', idexpediente);
    $('#container').data('asunto_derivar', asunto);
    $('#myModal2').modal('show');
    $('#codigo_expediente_derivar').text(codigo);

    $.CargarCombo(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 6}}, '#drptipodocumento_derivar');
    $.CargarCombo(urlApp + '/AreaController/listObjectAreaBE.htm', {poAreaBE: {IndOpSp: 3}}, '#drparea_derivar');
    $('#txtAsunto').val('');
    $('#txaMensaje').val('');

}
//Permite generar tramite interno
function generartraminterno(idexpediente, codigoexpediente) {
    $('#overlayViewDocumentoMensaje').show(500);
    addExpedienteReferencia(idexpediente, codigoexpediente)
    cleantokens();
}





function PintarRowGrillaavanzado(idgrilla, namecolumn, valorComparar, operacion, color, colorletra) {

    var qfunciont =
            ' var idgrilla="' + idgrilla + '";' +
            ' var namecolumn="' + namecolumn + '";' +
            ' var valorComparar="' + valorComparar + '";' +
            ' var color="' + color + '";' +
            ' var colorletra="' + colorletra + '";' +
            ' actualizarIDGrid(idgrilla); ' +
            'columns = $("#" + idgrilla).jqGrid("getGridParam", "colNames"); ' +
            '$("#" + idgrilla + " tr [aria-describedby=" + idgrilla + "_" + namecolumn + "]").each(function (r) {' +
            ' var c = columns.length;' +
            ' while (c > 0) {' +
            '   c--;' +
            '  if ($(this).text() ' + operacion + ' valorComparar)' +
            '  jQuery("#" + idgrilla).setCell(r + 1, c, "", {' +
            '"background-color": color,' +
            '"color": colorletra' +
            '});' +
            '}' +
            '});'

    eval(qfunciont);
}

function geneCodDocumento() {
    var Flujo = {
        IndOpSp: 7,
        idtipodocumento: $('#drptipodocumento_derivar').val(),
        idarea: Usuario.idarea,
        idusuario: Usuario.idusuario,
        idcargo: Usuario.idcargo,
        firma: (Usuario.area == 'ALCALDIA') ? true : false
    };
    $.ajaxCall(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: Flujo}, false, function (response) {

        console.log(response);
        $('#txtcodigodocumento_derivar').val(response[0])

    });
}

/*Implementado los metodos para derivar los documentos*/
function derivarDocumento() {
    if (crearDocumentoDerivar() > 0) {
    }
    else {
    }
}
function crearDocumentoDerivar() {
    var retorno = 0;
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#frmderivar');
    switch (resulValidacion) {
        case 0:
            var crearDocumento = function () {
                var DocumentoBE = {
                    idtipodocumento: $('#drptipodocumento_derivar').val(),
                    codigo: $('#txtcodigodocumento_derivar').val(),
                    asunto: $('#txtAsunto_derivar').val(),
                    mensaje: $('#txaMensaje_derivar').val(),
                    prioridad: 0,
                    bindrespuesta: false,
                    diasrespuesta: 0,
                    bindllegadausuario: false,
                    idareacioncreacion: Usuario.idarea,
                    idusuariocreacion: Usuario.idusuario,
                    idexpediente: $('#container').data('idexpediente_derivar'),
                    codigoexpediente: $('#container').data('codigo_derivar'),
                    listaidsdocumento: [],
                    estado: true
                };
                $.ajaxCall(urlApp + '/DocumentoController/crearDocumentoBE.htm', {poDocumentoBE: DocumentoBE, listVolumen: []}, false, function (response) {
                    //alert(response);
                    crearMensajeDerivar(response);
                    derivarFlujo();
                    $.ajaxCall(urlApp + '/FlujoController/actualizarEstadoFlujoBE.htm', {poFlujoBE: {idflujo: $('#container').data('idflujo_derivar'), idestadoflujo: 4, cuerporespuesta: 'DOCUMENTO DERIVADO MEDIANTE ' + $('#txtcodigodocumento_derivar').val(), idusuario: Usuario.idusuario, idarea: Usuario.idarea}}, false, function (response) {
                        cargarEstados(Usuario.idarea);
                        cargarGrilla_TramiteExterno(Usuario.idusuario, 1);
                    });

                });
                $('#myModal2').modal('hide');
            };
            bootbox.confirm("<h4>¿ Realmente desea crear el Documento ?</h4> <br><h4><b>" + $('#txtcodigodocumento_derivar').val() + '</b></h4> '
                    + '<BR><h4>Recuerde que al crear este Documento este ya no se p&oacute;dra modificar ni eliminar.</h4> '
                    , function (result) {
                        if (result === true) {
                            crearDocumento();
                        }
                        else {

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

    return retorno;

}
function crearMensajeDerivar(retorno) {
    var drparea = eval($('#drparea_derivar').val())
    var Mensaje = {
        asunto: 'TRAMITE EXTERNO: ' + $('#txtAsunto_derivar').val(),
        mensaje: $('#txaMensaje_derivar').val(),
        prioridad: 1,
        bindrespuesta: false,
        bindrecepcion: true,
        diasrespuesta: 0,
        idareacioncreacion: Usuario.idarea,
        idusuariocreacion: Usuario.idusuario,
        idexpediente: $('#container').data('idexpediente_derivar'),
        estado: true,
        idareas: [drparea[0]],
        listausuarios: [{idarea: drparea[0], idusuario: drparea[1]}],
        iddocumentos: [retorno],
        archivosmensaje: []
    };

    $.ajaxCall(urlApp + '/MensajeController/crearMensajeBE.htm', {poMensajeBE: Mensaje}, false, function (response) {

        //codigo al terminar la dervacion

    });
}


