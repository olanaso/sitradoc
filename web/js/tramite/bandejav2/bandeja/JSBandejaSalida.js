/*!
 * Author: Erick Escalante Olano
 * Description:
 * Archivo JS para adminitracion 
 !**/

/*
 * Global variables. If you change any of these vars, don't forget 
 * to change the values in the less files!
 */


(function () {


    function cargarBandeja() {
        cargarGrilla_mensaje();
        //alert(1)
        setTimeout("cargarBandeja()", 60000);
    }




    $(function () {
        getAreaCargo();
        getRoles();
        SelectArea();
        initFormBandeja();
        $('#container').data('estadoflujo', 1);
        $('#container').data('idusuario', Usuario.idusuario);
        crearGrilla_mensaje();
        cargarBandeja();

        $('#containerGrillabandeja').bind('resize', function () {
            $("#gridbandeja").setGridWidth($('#containerGrillabandeja').width());
        }).trigger('resize');

    });


    $(function () {
        $('.grilla').on('keypress', function (e) {
            if (e.keyCode === 13) {
                //debugger;
                cargarGrilla_mensaje();
            }
        });







        $('.derivar_documento').click(function () {
            derivar_documento();
        });

        $('.finalizar_documento').click(function () {
            finalizarDocumento();
        });



    });

    function derivar_documento() {

        var derivar = function () {
            $.ajaxCall(urlApp + '/BandejaController/actualizarBandejaBE.htm', {poBandejaBE: {IndOpSp: 3, idbandeja: $('#container').data('idbandeja')}}, false, function (response) {
                if (response === 1) {


                    /*========*/
                    var a = document.createElement('a');

                    var urlparam = '?iddocumento=' + $('#container').data('variddocumento') +
                            '&codigodocumento=' + $('#container').data('varcoddocumento');
                    if ($('#container').data('codigoexpediente') !== 0) {
                        urlparam = urlparam + '&idexpediente=' + $('#container').data('idexpediente') +
                                '&codigoexpediente=' + 'Exp.' + $('#container').data('codigoexpediente') + '-' + $('#container').data('asuntoexpediente');
                    }

                    if ($('#container').data('idusuario_envia') !== 0) {
                        urlparam = urlparam + '&idusuario_envia=' + $('#container').data('idusuario_envia');
                        urlparam = urlparam + '&idarea=' + $('#container').data('idarea');
                        urlparam = urlparam + '&usuarioenvia=' + $('#container').data('usuarioenvia');
                    }
                    a.href = urlApp + '/tramite-interno/mensaje' + urlparam;
                    a.target = "_blank";
                    document.body.appendChild(a);
                    a.click();
                    /*========*/







                    //addreferencia_regDocumento($('#container').data('variddocumento'), $('#container').data('varcoddocumento'));
                } else {
                    bootbox.alert("Este documento no fue recepcionado por el secretario.<br>\n\
                    Para resolver tiene que ser recepcionado en fisico !!!");
                }
            });
        };

        bootbox.confirm(Mensajes.deseaResolverDocumento, function (result) {
            if (result === true) {
                derivar();
            }
            else {

            }
        });
    }


    /* FUNCTIONS
     * ------------------------
     */
    function initFormBandeja() {
        showcantidadnoleidos();
    }

    /*funcion para cargar la cantidad de mensaje no liedos*/
    function showcantidadnoleidos() {
        $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: {IndOpSp: 3, idusuariodestino: Usuario.idusuario}}, false, function (response) {
            $('#cantnoleidos').text(response[0][0]);
        });
    }


    $('#textInicio').text('BANDEJA DE TRAMITE');
    function crearGrilla_mensaje() {
        $("#gridbandeja").jqGrid({
            datatype: function () {
                cargarGrilla_mensaje();
            },
            height: 380,
            width: 960,
            ignoreCase: true,
            multiselect: false,
            caption: "Bandeja de Documentos Entrada",
            colNames: ["idbandeja", "idmensaje", "Usuario Envia", "Asunto ", "Mensaje", "Fecha Envio", "Adjunto", "Estado"],
            colModel: [{
                    name: 'idbandeja',
                    index: 'idbandeja',
                    editable: false,
                    align: "center",
                    width: 80,
                    search: false,
                    hidden: true
                }, {
                    name: 'idmensaje',
                    index: 'idmensaje',
                    editable: false,
                    align: "center",
                    width: 80,
                    search: false,
                    hidden: true
                }, {
                    name: 'usuarioenvia',
                    index: 'usuarioenvia',
                    editable: false,
                    align: "left",
                    width: 200,
                    search: false,
                    hidden: false
                }, {
                    name: 'asunto',
                    index: 'asunto',
                    editable: false,
                    align: "left",
                    width: 330,
                    search: false,
                    hidden: false
                }, {
                    name: 'mensaje',
                    index: 'mensaje',
                    editable: false,
                    align: "left",
                    width: 300,
                    search: false,
                    hidden: false
                }, {
                    name: 'fechaenvio',
                    index: 'fechaenvio',
                    editable: false,
                    align: "center",
                    width: 180,
                    search: false,
                    hidden: false
                }, {
                    name: 'adjunto',
                    index: 'adjunto',
                    editable: false,
                    width: 75,
                    hidden: false,
                    search: false,
                    align: "center"
                }, {
                    name: 'recepcion',
                    index: 'recepcion',
                    editable: false,
                    width: 150,
                    hidden: false,
                    search: false,
                    align: "center"
                }],
            pager: '#pagerbandeja',
            storname: 'idexpediente',
            loadtext: 'Cargando datos...',
            recordtext: "{0} - {1} de {2} elementos",
            emptyrecords: 'No hay resultados',
            pgtext: 'Pág: {0} de {1}',
            rowNum: "20",
//            rowList: [10, 20, 30],
            //onSelectRow: viewGeometry,
            viewrecords: true,
            rownumbers: true,
            shrinkToFit: false,
            ondblClickRow: mostrarmensaje2

                    //multiselect: true
        });
        $("#gridbandeja").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
        /**Ajustando grilla a contenedor */
        $('#containerGrillabandeja').bind('resize', function () {
            $("#gridbandeja").setGridWidth($('#containerGrillabandeja').width());
        }).trigger('resize');
    }


    /*=====================================*/

    function mostrarmensaje2(rowid) {


        $('#ModalDetalleBandeja').modal('show');

        var idmensaje = $('#gridbandeja').jqGrid('getRowData', rowid).idmensaje;
        var idbandeja = $('#gridbandeja').jqGrid('getRowData', rowid).idbandeja;
        $('#container').data('idbandeja', idbandeja);
        var Bandeja = new Object();

        Bandeja.idmensaje = idmensaje;
        Bandeja.IndOpSp = 4;
        Bandeja.idareaproviene = Usuario.idarea;

        $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {

            debugger;
            console.log(response[0][0]);
            //var c = response[0][0];

            //var datos = JSON.parse();
            var datos = jQuery.parseJSON(response[0][0]);

            loadMensaje(datos.mensaje);
            loadDocumentos(datos.documentos);
            loadfiles(datos.archivos);
        });

        Bandeja.IndOpSp = 7;
        Bandeja.idbandeja = idbandeja;

        if ($.trim(idbandeja) !== '') {

            $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
                showcantidadnoleidos();
                cargarGrilla_mensaje();
            });

        }
        $('#overlaymail').show(500);
    }

    /* var indopsp = 1;
     
     function cargarGrilla_mensaje() {
     
     var Bandeja = {
     IndOpSp: indopsp,
     idusuariodestino: Usuario.idusuario,
     rows: $("#gridbandeja").getGridParam("rowNum"),
     page: $("#gridbandeja").getGridParam("page"),
     
     b_idsarea: $('#container').data('_idsarea'),
     b_idsusuarioenvia: $('#container').data('_idsusuarioenvia'),
     b_asunto: $('#container').data('_asunto'),
     b_mensaje: $('#container').data('_mensaje'),
     b_indsrecepcion: $('#container').data('_indsrecepcion'),
     b_indsrespuesta: $('#container').data('_indsrespuesta'),
     b_indsprioridad: $('#container').data('_indsprioridad'),
     b_vencidosactivos: $('#container').data('_vencidosactivos'),
     b_fechainicio: $('#container').data('fechainicio'),
     b_fechafin: $('#container').data('fechafin'),
     limite: $("#gridbandeja").getGridParam("rowNum"),
     offsete: $("#gridbandeja").getGridParam("page")
     
     
     };
     
     $.ajaxCall(urlApp + '/BandejaController/listarJQRegistrosBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
     $('#gridbandeja').jqGrid('clearGridData');
     $("#gridbandeja")[0].addJSONData(response);
     });
     }
     */
    function loadMensaje(response) {
        debugger;
        $('#msj_asunto').text(response.asunto_mensaje);
        $('#msj_text').text(response.mensaje);
        $('#msj_areacreacion').text(response.areacreacion);
        var prioridad = parseInt(response.prioridad);
        $('#msj_prioridad').text(prioridad == 1 ? 'ALTA' : prioridad == 2 ? 'MEDIA' : 'BAJA');
        $('#msj_respuesta').text(response.bindrespuesta === 't' ? 'SI' : 'NO');
        $('#msj_diasrespuesta').text(response.diasrespuesta);
        $('#msj_usuarioenvia').text(response.usuarioenvia);
        $('#msj_fechaenvia').text(response.fechacreacion);
        $('#msj_codigo_expediente').text(response.codigo);


        $('#container').data('idexpediente', response.idexpediente_mensaje);
        $('#container').data('codigoexpediente', response.codigo_espediente);
        $('#container').data('asuntoexpediente', response.asunto_expediente);
        $('#container').data('usuarioenvia', response.usuarioenvia);
        $('#container').data('idusuario_envia', response.idusuario_envia);
        $('#container').data('idarea', response.idarea);

        $('#btnresolver_tramite_externo').html('');
        if (Usuario.bindjefe && response.idexpediente_mensaje !== null) {

            $('#btnresolver_tramite_externo').html(' <label>' +
                    '<button onclick="resolver(' + response.idflujo + ',' + response.idexpediente_mensaje + ',\'' + response.asunto_expediente + '\')" class="ui-state-default ui-corner-all" id="btn_resolver_expediente" > ' +
                    '    <i class="fa fa-check" aria-hidden="true"></i>' +
                    '    Resolver Tramite Externo' +
                    '</button>' +
                    '</label> ');
        }

    }

    function loadDocumentos(response) {
        if (response.isvacio === true) {

        } else {
            $('#listareferencia').empty();
            $.each(response, function (index, value) {
                $('#listareferencia').append('<a target="_blank" href="' + urlApp + '/documento/ver?iddocumento=' + value.iddocumento + '" > <div class="myButton" role="alert"> <h5 style="color:#FFF;">' + value.codigo + '</h5> </div> </a>');
                $('#container').data('variddocumento', value.iddocumento);
                $('#container').data('varcoddocumento', value.codigo);
            });
        }

    }

    function loadfiles(response) {
        if (response.isvacio === true) {

        } else {
            $('#listaadjuntos').empty();
            var archivo = '';
            var extension = '';
            $.each(response, function (index, value) {
                archivo = value[1];
                extension = (archivo === null ? '' : archivo.substring(archivo.lastIndexOf("."))).toLowerCase();
                switch (extension) {
                    case '.jpg':
                    case '.png':
                    case '.gif':
                    case '.bmp':
                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value.url + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-image-o fa-2x" aria-hidden="true"></i>   ' + value.nombre + ' </div> </a>');
                        break;
                    case '.xls':
                    case '.xlsx':
                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value.url + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-excel-o fa-2x" aria-hidden="true"></i>   ' + value.nombre + ' </div> </a>');
                        break;
                    case '.doc':
                    case '.docx':
                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value.url + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-word-o fa-2x" aria-hidden="true"></i>   ' + value.nombre + ' </div> </a>');
                        break;
                    case '.ppt':
                    case '.pptx':
                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value.url + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-powerpoint-o fa-2x" aria-hidden="true"></i>   ' + value.nombre + ' </div> </a>');
                        break;
                    case '.mp3':
                    case '.wma':
                    case '.wav':
                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value.url + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-audio-o fa-2x" aria-hidden="true"></i>   ' + value.nombre + ' </div> </a>');
                        break;

                    case '.avi':
                    case '.mp4':
                    case '.mpg':
                    case '.wmv':
                    case '.mov':
                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value.url + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file-video-o fa-2x" aria-hidden="true"></i>   ' + value.nombre + ' </div> </a>');
                        break;
                    case '.pdf':
                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value.url + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file-pdf-o fa-2x" aria-hidden="true"></i>   ' + value.nombre + ' </div> </a>');
                        break;
                    case '':
                        break;
                    default:
                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value.url + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file fa-2x" aria-hidden="true"></i>   ' + value.nombre + ' </div> </a>');
                        break;
                }
            });
        }

    }


    /*=====================================*/


    var indopsp = 2;

    function cargarGrilla_mensaje() {

        var Bandeja = {
            IndOpSp: indopsp,
            idusuariodestino: Usuario.idusuario,
            rows: $("#gridbandeja").getGridParam("rowNum"),
            page: $("#gridbandeja").getGridParam("page"),
            /*para la busqueda avanzada*/
            b_idsarea: $('#container').data('_idsarea'),
            b_idsusuarioenvia: $('#container').data('_idsusuarioenvia'),
            b_asunto: $('#container').data('_asunto'),
            b_mensaje: $('#container').data('_mensaje'),
            b_indsrecepcion: $('#container').data('_indsrecepcion'),
            b_indsrespuesta: $('#container').data('_indsrespuesta'),
            b_indsprioridad: $('#container').data('_indsprioridad'),
            b_vencidosactivos: $('#container').data('_vencidosactivos'),
            b_fechainicio: $('#container').data('fechainicio'),
            b_fechafin: $('#container').data('fechafin'),
            limite: $("#gridbandeja").getGridParam("rowNum"),
            offsete: $("#gridbandeja").getGridParam("page")


        };

        $.ajaxCall(urlApp + '/BandejaController/listarJQRegistrosBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
            $('#gridbandeja').jqGrid('clearGridData');
            $("#gridbandeja")[0].addJSONData(response);
        });
    }



//FUNCION QUE ME PERMITE CREAR INPUT TYPE FILE PARA SUBIR ARCHIVOS











    function finalizarDocumento() {
        var finalizar = function () {
            $.ajaxCall(urlApp + '/BandejaController/actualizarBandejaBE.htm', {poBandejaBE: {IndOpSp: 2, idbandeja: $('#container').data('idbandeja'), bindatendido: true, bindfinalizado: true}}, false, function (response) {
                if (response === -1) {
                    bootbox.alert("No se logro finalizar. Por que este documento no fue recepcionado por el SECRETARIO.");
                }
                else if (response > 0) {
                    bootbox.alert("El Documento ha sido Finalizado satisfactoriamente. Presione OK para continuar");
                    showbandejaentrada();
                } else {
                    bootbox.alert("Ocurrió un error en la Finalización del Documento. Presione OK para continuar");
                }
            });
        }

        bootbox.confirm(Mensajes.deseaFinalizarDocumento, function (result) {
            if (result === true) {
                finalizar();
            }
            else {

            }
        });
    }


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
    var checkedselect = 0;

    function SelectArea() {

        $.ajaxCall(urlApp + '/UsuarioController/initlogin.htm', {}, false, function (response) {


            if (response.bindcargoseleccionado === null || response.bindcargoseleccionado === 'null' || response.bindcargoseleccionado === false) {
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
                                    '<input ' + (checkedselect == 0 ? 'checked' : '') + ' type="radio" name="areas" id="areas-' + value.idarea + '" value="' + value.idarea + '" > ' +
                                    value.area + ' <i style="font-size:10px;">' + value.cargo + '</i>'
                            '</label> ' +
                                    '</div>';
                            checkedselect = 1;

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


                                    } else {
                                        setArea($('#container').data('container_' + id_container));
                                        $('#areacargo').text($('#container').data('container_' + id_container).area + ' - ' +
                                                $('#container').data('container_' + id_container).cargo)
                                        $('#area_seleccionada').text("AREA");
                                        $('#area_seleccionada').attr('title', 'Area Seleccionada:  ' + response.area);
                                        //location.reload();

                                    }
                                    // alert("Hello " + name + ". You've chosen <b>" + id_container + "</b>");
                                    // isjefe();

                                }
                            }
                        }

                    });
                } else {

                }


            } else {
                $('#areacargo').text(response.area + ' - ' + response.cargo)
            }


        });
        //isjefe();
    }

    function setDataUsuario() {


        $.ajaxCall(urlApp + '/UsuarioController/setDataUsuario.htm', {poUsuarioBE: datosUsuario}, false, function (response) {
            console.log(response);

        });
    }


})();