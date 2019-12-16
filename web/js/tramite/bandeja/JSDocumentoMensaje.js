/*!
 * Author: Erick Escalante Olano
 * Description:
 *      Archivo JS para adminitracion 
 !**/

/*
 * Global variables. If you change any of these vars, don't forget 
 * to change the values in the less files!
 */
(function () {

    var BUSQ_DETALLADA_regDocumento = false;

    /*Oculatando los overligths*/
    /*Oculatando los overligths*/
    $('#overlayViewDocumento').hide();
    $('#overlayRecepcionExterna').hide();
    $('#overlayRecepcionInterna').hide();
    $('#overlayTramiteExterno').hide();
    $('#overlaymensaje').hide();
    $('#overlaymail').hide();
    $('#overlayViewDocumentoMensaje').hide();

    function cargarBandeja() {
        cargarGrilla_mensaje();
        setTimeout("cargarBandeja()", 60000);
    }
    window.cargarBandeja = cargarBandeja;

    var idsUploadImg_regDocumento = new Array();
    var arrayDocumentoReferencia_regDocumento = new Array();


    /*Asignando las Prioridades al documento*/
    var PRIORIDAD = 3;

    function setPrioridad(prioridad) {
        PRIORIDAD = prioridad;
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
        initForm_regDocumento();
        crearGrilla_regDocumento();//+
        cargarGrillaDocumento_regDocumento();//+
        crearGrillaDocumentoBusqueda_regDocumento();
        //var codigoexpediente = getUrlParameter("codigoexpediente");
        $('#container').data('idexpediente', 0);
        $('#txtCodigoexpediente_regDocumento').val(0);
        $('#containerGrilla_regDocumento').bind('resize', function () {
            $("#grid_regDocumento").setGridWidth($('#containerGrilla_regDocumento').width());
        }).trigger('resize');
    });

    $(function () {

        $("#btnNuevo_regDocumento").click(function (e) {

            if ($("#btnNuevo_regDocumento").text() === 'Nuevo') {
                $.HabilitarForm('#form_regDocumento');
                $("#btnNuevo_regDocumento").text('Guardar');
                return;
            }
            if ($("#btnNuevo_regDocumento").text() === 'Guardar') {
                saveDocumento_regDocumento();
                return;
            }

//            if ($("#btnNuevo_regDocumento").text() === 'Actualizar') {
//                actualizar();
//            }
            e.stopPropagation();
        });

        $("#btnCancelar_regDocumento").click(function (e) {
            limpiarcontroles();
        });

        $('#drptipodocumento_regDocumento').on('change', function (e) {
            geneCodDocumento_regDocumento();
        });

        $("#btnmostrarbsq_detallada_regDocumento").click(function () {
            if (BUSQ_DETALLADA_regDocumento) {
                $('#frombusq_detallada_regDocumento').hide();
                BUSQ_DETALLADA_regDocumento = false;
            }
            else {
                $('#frombusq_detallada_regDocumento').show();
                BUSQ_DETALLADA_regDocumento = true;
            }

        });

        $("#btnlimpiarbusqdetallada_regDocumento").click(function (e) {
            limpiarbusquedadetallada();
        });

        $("#btnbusqdetallada_regDocumento").click(function (e) {
            cargarGrillaDocumentoBusqueda_regdocumento();
        });

        loadevents();

        $('.grilla').on('keypress', function (e) {
            if (e.keyCode === 13) {
                //debugger;
                cargarGrilla_mensaje();
            }
        });
        /*cambiar al cambio del tipo de documento*/
        $('#drptipodocumento').on('change', function (e) {
            geneCodDocumento();
        });

        $(".btn-group > .btn").click(function () {
            $(".btn-group > .btn").removeClass("active");
            $(this).addClass("active");
        });

        $("#listestados_bandeja > li").click(function () {
            $("#listestados_bandeja > li").removeClass("active");
            $(this).addClass("active");
        });


        $("#btnenviarmensaje").click(function (e) {
            crearMensaje();
        });

        $("#btn_resolver_expediente").click(function (e) {
            //alert(1);
            $('#overlayTramiteExterno').show(500);
            initFormTramiteExterno();
            $('#pre_txtbusquedacodigoexpediente_tramite_externo').val($('#msj_codigo_expediente').text());
            cargarGrilla_TramiteExterno()
        });

        $("#printmensaje").click(function () {
            // $('div#overlaymail').printArea();
            printer('overlaymail');
        });

        $("#busq_avanzada_mensaje").click(function () {
            // alert(1);
            $("#busq_avanzada_mensaje_triguer").click();
        });

        $("#rbnt_rpta_no").click(function () {
            // alert(1);
            alert($(this).val());
        });
        $("#rbnt_rpta_si").click(function () {
            // alert(1);
            alert($(this).val());
        });
    });

    /*no va*/
    function isjefe() {
        //alert(Usuario.bindjefe);
        if (Usuario.bindjefe === true) {
            $('#tramiteExterno').show()
        } else {
            $('#tramiteExterno').hide()
        }
    }

    /* function setPrioridad(prioridad) {
     PRIORIDAD = prioridad;
     }*/

    /*EVENTS
     * ------------------------
     */
//    $(function () {
//        $("#btnNuevo_regDocumento").click(function (e) {
//
//            if ($("#btnNuevo_regDocumento").text() === 'Nuevo') {
//                $.HabilitarForm('#form_regDocumento');
//                $("#btnNuevo_regDocumento").text('Guardar');
//                return;
//            }
//            if ($("#btnNuevo_regDocumento").text() === 'Guardar') {
//                saveDocumento_regDocumento();
//                return;
//            }
//
//            if ($("#btnNuevo_regDocumento").text() === 'Actualizar') {
//                actualizar();
//            }
//            e.stopPropagation();
//        });
//
//        $("#btnCancelar_regDocumento").click(function (e) {
//            limpiarcontroles();
//        });
//
//        $('#drptipodocumento_regDocumento').on('change', function (e) {
//            geneCodDocumento_regDocumento();
//        });
//
//        $("#btnmostrarbsq_detallada_regDocumento").click(function () {
//            if (BUSQ_DETALLADA_regDocumento) {
//                $('#frombusq_detallada_regDocumento').hide();
//                BUSQ_DETALLADA_regDocumento = false;
//            }
//            else {
//                $('#frombusq_detallada_regDocumento').show();
//                BUSQ_DETALLADA_regDocumento = true;
//            }
//
//        });
//
//        $("#btnlimpiarbusqdetallada_regDocumento").click(function (e) {
//            limpiarbusquedadetallada();
//        });
//
//        $("#btnbusqdetallada_regDocumento").click(function (e) {
//            cargarGrillaDocumentoBusqueda_regdocumento();
//        });
//        
//        loadevents();
//    });

    function loadevents() {
        $('.overlay_close_docMensaje').click(function () {
            $('#overlayViewDocumentoMensaje').hide(500);
            cleantokens();
        });
        $('.overlay_open_docMensaje').click(function () {
            $('#overlayViewDocumentoMensaje').show(500);
            cleantokens();
        });
    }

    function initFormBandeja() {
        showcantidadnoleidos();
//        autocompletarUsuario();
        autocompletarArea();
        $('#frombusq_detallada').hide();
        $("#b_fecha_inicio").mask("9999-99-99", {placeholder: "aaaa-mm-dd"});
        $("#b_fecha_fin").mask("9999-99-99", {placeholder: "aaaa-mm-dd"});
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
            height: 300,
            width: 500,
            ignoreCase: true,
            multiselect: true,
            caption: "",
            colNames: ["idbandeja", "idmensaje", "Usuario Envia", "Asunto ", "Mensaje", "Fecha Envio", "Adjunto", "Recepcionado"],
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
            rowNum: "10",
            rowList: [10, 20, 30],
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

    function mostrarmensaje2(rowid) {
        
  

        var idmensaje = $('#gridbandeja').jqGrid('getRowData', rowid).idmensaje;
        var idbandeja = $('#gridbandeja').jqGrid('getRowData', rowid).idbandeja;
        var Bandeja = new Object();

        Bandeja.idmensaje = idmensaje;
        Bandeja.IndOpSp = 4;

        $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
            console.log(response);
            var datos=response[0][0];
            loadMensaje(datos.mensaje);
            loadDocumentos(datos.documentos);
            loadfiles(datos.archivos)
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

    var indopsp = 1;

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

    function loadMensaje(response) {
        $('#msj_asunto').text(response.asunto);
        $('#msj_text').text(response.mensaje);
        $('#msj_areacreacion').text(response.areacreacion);
        var prioridad = parseInt(response.prioridad);
        $('#msj_prioridad').text(prioridad == 1 ? 'ALTA' : prioridad == 2 ? 'MEDIA' : 'BAJA');
        $('#msj_respuesta').text(response.bindrespuesta === 't' ? 'SI' : 'NO');
        $('#msj_diasrespuesta').text(response.diasrespuesta);
        $('#msj_usuarioenvia').text(response.usuarioenvia);
        $('#msj_fechaenvia').text(response.fechacreacion);
        $('#msj_codigo_expediente').text(response.codigo);
        if (!/^([0-9])*$/.test(response.codigo)) {
            $('#btn_resolver_expediente').hide()
        } else {
            $('#btn_resolver_expediente').show()
        }
    }

    function loadDocumentos(response) {
        $('#listareferencia').empty();
        $.each(response, function (index, value) {
            $('#listareferencia').append('<a target="_blank" href="' + urlApp + '/pages/documento/ViewDoc.jsp?iddocumento=' + value[0] + '" > <div class="myButton" role="alert"> <h5 style="color:#FFF;">' + value[1] + '</h5> </div> </a>');
        });
    }

    function loadfiles(response) {
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
                    $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-image-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.xls':
                case '.xlsx':
                    $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-excel-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.doc':
                case '.docx':
                    $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-word-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.ppt':
                case '.pptx':
                    $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-powerpoint-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.mp3':
                case '.wma':
                case '.wav':
                    $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-audio-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;

                case '.avi':
                case '.mp4':
                case '.mpg':
                case '.wmv':
                case '.mov':
                    $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file-video-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.pdf':
                    $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file-pdf-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '':
                    break;
                default:
                    $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
            }
        });
    }



    window.cargarGrilla_mensaje = cargarGrilla_mensaje;

    function cargarflujosecundario(li, idestadoflujo, idusuario, estado) {
        $('.estado').removeClass('active');
        $(li).addClass('active');
        console.log(idestadoflujo, idusuario, estado)
        cargarGrillaSecundaria(idusuario, idestadoflujo);
        alert(idestadoflujo)
        $('#container').data('estadoflujo', idestadoflujo);
        $('#container').data('idusuario', idusuario)
        $('#txtestadoflujo').text(estado);
    }

    /*limpiar controles*/
    function limpiarcontroles() {
        $.DesabilitarForm('#form_regDocumento');
        $.LimpiarForm('#form_regDocumento');
        idsUploadImg_regDocumento = new Array();
        arrayDocumentoReferencia_regDocumento = new Array();
        $('#listreferencia_regDocumento').empty();
        $("#btnNuevo_regDocumento").text('Nuevo');
        $('#addupload_regDocumento').val('+');
        $('#uploadfile_regDocumento').empty();
    }

    /* FUNCTIONS
     * ------------------------
     */
    function initForm_regDocumento() {
        $.DesabilitarForm('#form_regDocumento');
        $.LimpiarForm('#form_regDocumento');
        $("#btnNuevo_regDocumento").text('Nuevo');
        $('#txtcodigodocumentogenerado_regDocumento').attr("disabled", "disabled");
        $('#frombusq_detallada_regDocumento').hide();
        loadCombos_regDocumento();
        //jQuery.Calendario('#b_fecha_inicio')
        //jQuery.Calendario('#b_fecha_fin');
        //jQuery.Calendario('#txtCodigoexpediente');
        $('#addupload_regDocumento').val('+');
        $("#b_fecha_inicio_regDocumento").mask("9999-99-99", {placeholder: "aaaa-mm-dd"});
        $("#b_fecha_fin_regDocumento").mask("9999-99-99", {placeholder: "aaaa-mm-dd"});
        $.FechaToday('#b_fecha_inicio_regDocumento');
        $.FechaToday('#b_fecha_fin_regDocumento');
//        autocompletarUsuario();
//        autocompletarArea();
        autocompletarUsuario_regDocumento();
    }

    /*funcion que permite la creacion de la grilla de documentos*/
    function crearGrilla_regDocumento() {
        $("#grid_regDocumento").jqGrid({
            /*data: mydata,*/
            datatype: "local",
            height: 300,
            caption: "Lista Documento",
            colNames: ["Ver", "Del", "iddocumento", "Tipo Documento", "C&oacute;digo Documento", "Denominaci&oacute;n", "Descripci&oacute;n", "prioridad", "bindrespuesta", "diasrespuesta", "bindllegadausuario", "idareacioncreacion", "idusuariocreacion", "Fecha de Creaci&oacute;n", "idexpediente", "C&oacute;digo Expediente", "estado"],
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
                    hidden: true
                },
                {
                    name: 'iddocumento',
                    index: 'iddocumento',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'tipodocumento',
                    index: 'tipodocumento',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'codigo',
                    index: 'codigo',
                    editable: false,
                    width: 300,
                    hidden: false
                }, {
                    name: 'asunto',
                    index: 'asunto',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'mensaje',
                    index: 'mensaje',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'prioridad',
                    index: 'prioridad',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'bindrespuesta',
                    index: 'bindrespuesta',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'diasrespuesta',
                    index: 'diasrespuesta',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'bindllegadausuario',
                    index: 'bindllegadausuario',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'idareacioncreacion',
                    index: 'idareacioncreacion',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'idusuariocreacion',
                    index: 'idusuariocreacion',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'fecha_envio',
                    index: 'fecha_envio',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'idexpediente',
                    index: 'idexpediente',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'codigoexpediente',
                    index: 'codigoexpediente',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'estado',
                    index: 'estado',
                    editable: false,
                    width: 150,
                    hidden: true
                }],
            pager: '#pager_regDocumento',
            //onSelectRow: viewGeometry,
            viewrecords: true,
            shrinkToFit: false,
            //multiselect: true
        });
        jQuery("#grid_regDocumento").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false});
    }

    function cargarGrillaDocumento_regDocumento() {
        $.ajaxCall(urlApp + '/DocumentoController/listarRegistrosDocumentoBE.htm', {poDocumentoBE: {IndOpSp: 1, idusuariocreacion: Usuario.idusuario}}, false, function (response) {
            $('#grid_regDocumento').jqGrid('clearGridData');
            jQuery("#grid_regDocumento").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
        });
    }

    /*Funcion para eliminar duplicados de array*/
    function eliminateDuplicates(arr) {
        var i,
                len = arr.length,
                out = [],
                obj = {};
        for (i = 0; i < len; i++) {
            obj[arr[i]] = 0;
        }
        for (i in obj) {
            out.push(i);
        }
        return out;
    }

    var arrayUsuarioArea = new Array();

    /*no va*/
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
                    } else {
                        bootbox.alert("Ocurrio un error en el envio, comuniquese con el administrador");
                    }
                });
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

    function show(iddocumento) {

        a = document.createElement('a');
        a.href = urlApp + '/pages/documento/ViewDoc.jsp?iddocumento=' + iddocumento;
        a.target = "_blank";
        document.body.appendChild(a);
        a.click();
    }

    var open = false

    function showsiderbar() {
        if (open) {
            getidsAreaUsuario
            $('#configsiderbar').removeClass('control-sidebar-open'), open = false;
        } else {
            $('#configsiderbar').addClass('control-sidebar-open'), open = true;
        }
    }
    window.showsiderbar = showsiderbar;

    function autocompletarUsuario() {
        $("#txtusuario").AutocompleteMultiple(urlApp + "/UsuarioController/autocompletarUsuariosWithArea.htm", "#txtusuario", null,
                function (item) {
                    return {
                        label: item.nombres,
                        idusuario: item.idusuario,
                        idarea: item.idarea
                    }
                },
                function (event, ui) {
                    arrayUsuarioArea.push([ui.item.idusuario, ui.item.idarea, ui.item.label]);
                    arrayUsuarioArea = eliminateDuplicates(arrayUsuarioArea);

                });

        $('#txtusuario').on('tokenfield:removedtoken', function (e) {
            eliminarUsuarioAreaMensaje(e.attrs.value);
        }).tokenfield();
    }

    function autocompletarArea() {
        $("#txtarea").AutocompleteMultiple(urlApp + "/AreaController/autocompletarAreawithjefeBE.htm", "#txtarea", null,
                function (item) {
                    return {
                        label: item.denominacion,
                        idusuario: item.idusuariojefe,
                        idarea: item.idarea
                    }
                },
                function (event, ui) {
                    arrayUsuarioArea.push([ui.item.idusuario, ui.item.idarea, ui.item.label]);
                    arrayUsuarioArea = eliminateDuplicates(arrayUsuarioArea);
                });

        $('#txtarea').on('tokenfield:removedtoken', function (e) {
            eliminarUsuarioAreaMensaje(e.attrs.value);
        }).tokenfield();
//        alert(""+ arrayUsuarioArea.length);
    }

    function eliminarUsuarioAreaMensaje(valor) {
        arrayUsuarioArea = jQuery.grep(arrayUsuarioArea, function (value) {
            return (value.substring(value.lastIndexOf(",") + 1) !== valor);
        });
    }

    function getidsAreaUsuario() {
        var idsAreaUsuario = {
            idarea: [],
            listausuarios: []
        };
        $.each(arrayUsuarioArea, function (index, value) {
            var array = value.split(',');
            idsAreaUsuario.idarea.push(array[1]);
            idsAreaUsuario.listausuarios.push({idarea: array[1], idusuario: array[0]});
        });
        idsAreaUsuario.idarea = idsAreaUsuario.idarea.unique();
        idsAreaUsuario.listausuarios = idsAreaUsuario.listausuarios.unique();
//        alert(""+idsAreaUsuario);
        return idsAreaUsuario;
    }

    Array.prototype.unique = function (a) {
        return function () {
            return this.filter(a)
        }
    }(function (a, b, c) {
        return c.indexOf(a, b + 1) < 0
    });

    function cleantokens() {
        $('#txtarea').tokenfield('setTokens', ',');
        $('#txtplazodias').val(3);
        $('#txtusuario').tokenfield('setTokens', ',');
        $('#txtAsunto_regDocumento').val('');
        $('#txaMensaje_regDocumento').val('');
        $('#listreferencia_regDocumento').empty();
        $('#listexpediente_mensaje').empty();
        arrayDocumentoReferencia_regDocumento = new Array();
        arrayExpedienteReferencia = new Array();
        arrayUsuarioArea = new Array();
        idsUploadImg_regDocumento = new Array();

        $('#uploadfile').empty();

        $("#rbnt_rpta_no").prop("checked", true);
        $("#rbnt_recepcion_si").prop("checked", true);
    }

    function getArrayObjectArchivos() {
        var arrayObjectArchivos = new Array();
        $.each(idsUploadImg_regDocumento, function (index, value) {
            var archivo = {
                name: "img_" + value,
                nombre: $("#textdenominacion_" + value).val(),
                estado: true
            }
            arrayObjectArchivos.push(archivo);
        });
        return arrayObjectArchivos;
    }

    function saveDocumento_regDocumento() {
        var resulValidacion = 0;
        resulValidacion = $.ValidarData('#form_regDocumento');
        switch (resulValidacion) {
            case 0:
                var crearDocumento = function () {
                    var DocumentoBE = {
                        idtipodocumento: $('#drptipodocumento_regDocumento').val(),
                        codigo: $('#txtcodigodocumentogenerado_regDocumento').val(),
                        asunto: $('#txtAsunto_regDocumento').val(),
                        mensaje: $('#txaMensaje_regDocumento').val(),
                        prioridad: 0,
                        bindrespuesta: false,
                        diasrespuesta: 0,
                        bindllegadausuario: false,
                        idareacioncreacion: Usuario.idarea,
                        idusuariocreacion: Usuario.idusuario,
                        idexpediente: 0,
                        codigoexpediente: 0,
                        listaidsdocumento: arrayDocumentoReferencia_regDocumento,
                        estado: true
                    };

//                    var Mensaje = {
//                        asunto: $('#txtAsunto_regDocumento').val(),
//                        mensaje: $('#txaMensaje_regDocumento').val(),
//                        prioridad: PRIORIDAD,
//                        bindrespuesta: $("input[name=optradio]:checked").val(),
////                        bindrecepcion: $("input[name=optenviorecepcion]:checked").val(),
//                        bindrecepcion: true,
//                        diasrespuesta: $('#txtplazodias').val(),
//                        idareacioncreacion: Usuario.idarea,
//                        idusuariocreacion: Usuario.idusuario,
//                        idexpediente: (arrayExpedienteReferencia.length === 0) ? 0 : arrayExpedienteReferencia[0],
//                        estado: true,
//                        idareas: getidsAreaUsuario().idarea,
//                        listausuarios: getidsAreaUsuario().listausuarios,
//                        iddocumentos: arrayDocumentoReferencia_regDocumento,
//                        archivosmensaje: getArrayObjectArchivos()
//                    };

                    $.ajaxCall(urlApp + '/DocumentoController/crearDocumentoBE.htm', {poDocumentoBE: DocumentoBE, listVolumen: getArrayObjectArchivos_regDocumento()}, false, function (response) {
//                        var crearMensaje = function () {
                        arrayDocumentoReferencia_regDocumento.push(response);
                        var Mensaje = {
                            asunto: $('#txtAsunto_regDocumento').val(),
                            mensaje: $('#txaMensaje_regDocumento').val(),
                            prioridad: PRIORIDAD,
                            bindrespuesta: $("input[name=optradio]:checked").val(),
                            //bindrecepcion: $("input[name=optenviorecepcion]:checked").val(),
                            bindrecepcion: true,
                            diasrespuesta: $('#txtplazodias').val(),
                            idareacioncreacion: Usuario.idarea,
                            idusuariocreacion: Usuario.idusuario,
                            idexpediente: (arrayExpedienteReferencia.length === 0) ? 0 : arrayExpedienteReferencia[0],
                            estado: true,
                            idareas: getidsAreaUsuario().idarea,
                            listausuarios: getidsAreaUsuario().listausuarios,
                            iddocumentos: arrayDocumentoReferencia_regDocumento,
                            archivosmensaje: getArrayObjectArchivos()
                        };

                        $.ajaxCall(urlApp + '/MensajeController/crearMensajeBE.htm', {poMensajeBE: Mensaje}, false, function (response) {
                            $.ajaxUpload(urlApp + '/MensajeController/insertarArchivoMensaje.htm', 'form_regDocumento', function (response) {
                                $.ajaxUpload(urlApp + '/DocumentoController/insertarArchivoDocumento.htm', 'form_regDocumento', function (response) {
//                                    cargarGrillaDocumento_regDocumento();
                                    limpiarcontroles();
                                    $("#btnNuevo_regDocumento").text('Nuevo');
                                    bootbox.alert("El registro del DOCUMENTO fue exitoso.");
                                });
                            });
                        });



//                        };


//                        if (getidsAreaUsuario().idarea.length === 0 && getidsAreaUsuario().idusuario.length === 0) {
//                            bootbox.alert("Debe seleccionar como minimo un Usuario o Area.");
//                        } else
//                        if (arrayDocumentoReferencia_regDocumento.length === 0 && $("input[name=optenviorecepcion]:checked").val() == 'true') {
//                            bootbox.alert("Debe adjuntar un <b>Documento</b> para que se realice la recepcion en las Areas detinos.");
//                        } else {
//                            bootbox.confirm('<h4>¿ Realmente desea enviar este mensaje  ?</h4>' + '<BR><h4>Recuerde que al crear este mensaje ya no podra modificar ni eliminar.</h4> ', function (result) {
//                                if (result === true) {
//                                    crearMensaje();
//                                } else {
//
//                                }
//                            });
//                        }
                    });
                };

                if (getidsAreaUsuario().idarea.length === 0 && getidsAreaUsuario().listausuarios.length === 0) {
                    bootbox.alert("Debe seleccionar como minimo un Usuario o Area.");
//                    alert(""+ getidsAreaUsuario().idarea.length);
                } else
                if (arrayDocumentoReferencia_regDocumento.length === 0 && $("input[name=optenviorecepcion]:checked").val() == 'true') {
                    bootbox.alert("Debe adjuntar un <b>Documento</b> para que se realice la recepcion en las Areas detinos.");
                } else {
                    bootbox.confirm("<h4>¿ Realmente desea crear el Documento ?</h4> <br><h4><b>" + $('#txtcodigodocumentogenerado_regDocumento').val() + '</b></h4> '
                            + '<BR><h4>Recuerde que al crear este Documento este ya no se p&oacute;dra modificar ni eliminar.</h4> '
                            , function (result) {
                                if (result === true) {
                                    crearDocumento();
                                }
                                else {

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


    function loadCombos_regDocumento() {
        $.CargarCombo(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 6}}, '#drptipodocbusqueda_regDocumento');
        $.CargarCombo(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 6}}, '#drptipodocumento_regDocumento');
        $.CargarCombo(urlApp + '/AreaController/listObjectAreaBE.htm', {poAreaBE: {IndOpSp: 2}}, '#drpareabusqueda_regDocumento');
    }

    //FUNCION QUE ME PERMITE CREAR INPUT TYPE FILE PARA SUBIR ARCHIVOS
    var banderaUploadImg = 0;
    var idsUploadImg = new Array();

    function generarUploadImg(div) {
        if (idsUploadImg.length === 10) {
            bootbox.alert("Solo se permiten como maximo 10 archivos.");
        } else {
            var id = banderaUploadImg + 1;
            $(div).append('<div id="blq' + id + '" class="row">' +
                    '<div class="col-lg-4">' +
                    '        <input obligatorio id="textdenominacion_' + id + '" name="textdenominacion_' + id + '" placeholder="Ingrese denominacion" type="text">' +
                    '</div>' +
                    '<div class="col-lg-7">' +
                    '        <input obligatorio style="float:left" id="img_' + id + '" name="img_' + id + '" type="file" >' +
                    '</div>' +
                    '<div class="col-lg-1">' +
                    '    <input onclick="eliminarUploadImg(' + id + ')" type="button" value="X">' +
                    '</div>' +
                    '</div>')
            idsUploadImg.push(id);
            banderaUploadImg = id;
        }
    }

    window.generarUploadImg = generarUploadImg;

    //funcion que elimina un upload generado
    function eliminarUploadImg(id) {
        $('#blq' + id).remove();
        eliminarElmentoArray(idsUploadImg, id);
    }
    window.eliminarUploadImg = eliminarUploadImg;

    /*Area para subir adjuntos vincualdos a un documento*/

    //FUNCION QUE ME PERMITE CREAR INPUT TYPE FILE PARA SUBIR ARCHIVOS
    var banderaUploadImg_regDocumento = 0;
    var idsUploadImg_regDocumento = new Array();
    window.idsUploadImg_regDocumento = idsUploadImg_regDocumento;

    window.generarUploadImgDoc_regDocumento = generarUploadImgDoc_regDocumento;
    function generarUploadImgDoc_regDocumento(div) {

        console.log(idsUploadImg_regDocumento);
        if (idsUploadImg_regDocumento.length === 10) {
            bootbox.alert("Solo se permiten como maximo 10 archivos.");
        }
        else {
            var id = banderaUploadImg_regDocumento + 1;
            $(div).append('<div id="blq_regDocumento' + id + '" class="row">' +
                    '<div class="col-lg-4">' +
                    '        <input obligatorio id="textdenominacion_regDocumento_' + id + '" name="textdenominacion_' + id + '" placeholder="Ingrese denominacion" type="text">' +
                    '</div>' +
                    '<div class="col-lg-7">' +
                    '        <input obligatorio style="float:left" id="img_regDocumento' + id + '" name="img_regDocumento_registro' + id + '" type="file" >' +
                    '</div>' +
                    '<div class="col-lg-1">' +
                    '    <input onclick="eliminarUploadImg_regDocumento(' + id + ')" type="button" value="X">' +
                    '</div>' +
                    '</div>')
            idsUploadImg_regDocumento.push(id);
            banderaUploadImg_regDocumento = id;
        }
    }

    //funcion que elimina un upload generado
    window.eliminarUploadImg_regDocumento = eliminarUploadImg_regDocumento;
    function eliminarUploadImg_regDocumento(id) {

        $('#blq_regDocumento' + id).remove();
        eliminarElmentoArray(idsUploadImg_regDocumento, id);
        console.log(idsUploadImg_regDocumento);
    }

    window.getArrayObjectArchivos_regDocumento = getArrayObjectArchivos_regDocumento;

    /*bandeja.js*/
    function getArrayObjectArchivos() {
        var arrayObjectArchivos = new Array();
        $.each(idsUploadImg, function (index, value) {
            var archivo = {
                name: "img_" + value,
                nombre: $("#textdenominacion_" + value).val(),
                estado: true
            }
            arrayObjectArchivos.push(archivo);
        });
        return arrayObjectArchivos;
    }

    function getArrayObjectArchivos_regDocumento() {
        var arrayObjectArchivos = new Array();
        console.log('array de archivos: ' + idsUploadImg_regDocumento)
        $.each(idsUploadImg_regDocumento, function (index, value) {
            var archivo = {
                name: "img_regDocumento_registro" + value,
                nombre: $("#textdenominacion_regDocumento_" + value).val(),
                estado: true
            }
            arrayObjectArchivos.push(archivo);
        });
        return arrayObjectArchivos;
    }

    window.eliminarElmentoArray = eliminarElmentoArray;
    function eliminarElmentoArray(array, elem) {
        var idx = array.indexOf(parseInt(elem));
        if (idx != -1)
            array.splice(idx, 1);
    }





    /*Funcion que te trae y genera el proximo nombre del documento a generar*/
    function geneCodDocumento_regDocumento() {
        var Flujo = {
            IndOpSp: 7,
            idtipodocumento: $('#drptipodocumento_regDocumento').val(),
            idarea: Usuario.idarea,
            idusuario: Usuario.idusuario,
            idcargo: Usuario.idcargo,
            firma: (Usuario.area == 'ALCALDIA') ? true : false
        };
        $.ajaxCall(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: Flujo}, false, function (response) {
            $('#txtcodigodocumentogenerado_regDocumento').val(response[0])
        });
    }
    /*Funciones para la implementacion de los documentos*/

    function crearGrillaDocumentoBusqueda_regDocumento() {
        $("#gridDocumentoBusqueda_regDocumento").jqGrid({
            /*data: mydata,*/
            datatype: "local",
            height: 300,
            width: 860,
            caption: "Busqueda de documento",
            colNames: ["+", "Ver", "iddocumento", "Tipo Documento", "C&oacute;digo Documento", "Autor", "Denominaci&oacute;n", "Descripci&oacute;n", "prioridad", "bindrespuesta", "diasrespuesta", "bindllegadausuario", "idareacioncreacion", "idusuariocreacion", "Fecha de Creaci&oacute;n", "idexpediente", "C&oacute;digo Expediente", "estado"],
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
                    name: 'iddocumento',
                    index: 'iddocumento',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'tipodocumento',
                    index: 'tipodocumento',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'codigo',
                    index: 'codigo',
                    editable: false,
                    width: 150,
                    hidden: false
                }
                , {
                    name: 'usuario',
                    index: 'usuario',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'asunto',
                    index: 'asunto',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'mensaje',
                    index: 'mensaje',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'prioridad',
                    index: 'prioridad',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'bindrespuesta',
                    index: 'bindrespuesta',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'diasrespuesta',
                    index: 'diasrespuesta',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'bindllegadausuario',
                    index: 'bindllegadausuario',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'idareacioncreacion',
                    index: 'idareacioncreacion',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'idusuariocreacion',
                    index: 'idusuariocreacion',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'fecha_envio',
                    index: 'fecha_envio',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'idexpediente',
                    index: 'idexpediente',
                    editable: false,
                    width: 150,
                    hidden: true
                }, {
                    name: 'codigoexpediente',
                    index: 'codigoexpediente',
                    editable: false,
                    width: 150,
                    hidden: false
                }, {
                    name: 'estado',
                    index: 'estado',
                    editable: false,
                    width: 150,
                    hidden: true
                }],
            pager: '#pagerDocumentoBusqueda_regDocumento',
            //onSelectRow: viewGeometry,
            viewrecords: true,
            shrinkToFit: false,
            //multiselect: true
        });
        jQuery("#gridDocumentoBusqueda_regDocumento").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false});
    }

    function cargarGrillaDocumentoBusqueda_regdocumento() {

        var DocumentoBE = {
            IndOpSp: 5,
            idtipodocumento: $('#drptipodocbusqueda_regDocumento').val(),
            idareacioncreacion: $('#drpareabusqueda_regDocumento').val(),
            idusuariocreacion: $('#container').data('idusuario_busqueda_regDocumento'),
            fecha_inicio: $('#b_fecha_inicio_regDocumento').val(),
            fecha_fin: $('#b_fecha_fin_regDocumento').val(),
            asunto: $('#txtbusquedadetallada').val()

        };

        $.ajaxCall(urlApp + '/DocumentoController/listarRegistrosDocumentoBE.htm', {poDocumentoBE: DocumentoBE}, false, function (response) {
            $('#gridDocumentoBusqueda_regDocumento').jqGrid('clearGridData');
            jQuery("#gridDocumentoBusqueda_regDocumento").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
        });
    }

    function cargarDocumentoBusqueda_regDocumento() {
        var DocumentoBE = {
            IndOpSp: 5,
            idareacioncreacion: $('#drpareabusqueda_regDocumento').val(),
            idusuariocreacion: $('#container').data('idusuario_busqueda_regDocumento')
        };
        $.ajaxCall(urlApp + '/DocumentoController/listarRegistrosDocumentoBE.htm', {poDocumentoBE: DocumentoBE}, false, function (response) {
            $('#gridDocumentoBusqueda_regDocumento').jqGrid('clearGridData');
            jQuery("#gridDocumentoBusqueda_regDocumento").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
        });
    }

    function autocompletarUsuario_regDocumento() {

        $("#txt_usuario_busqueda_regDocumento").AutocompleteWithPobject(urlApp + "/UsuarioController/autocompletarUsuarios.htm", {}, "#txt_usuario_busqueda_regDocumento", null,
                function (item) {
                    //console.log(item);
                    return {
                        label: item.nombres,
                        idusuario: item.idusuario
                    }
                },
                function (event, ui) {
                    $('#container').data('idusuario_busqueda_regDocumento', ui.item.idusuario);
                });



    }

    function limpiarbusquedadetallada() {

        $('#drptipodocbusqueda_regDocumento_regDocumento').val(0);
        $('#drpareabusqueda_regDocumento_regDocumento').val(0);
        $('#txt_usuario_busqueda_regDocumento').val('');
        $('#txtbusquedadetallada_regDocumento').val('');
        $('#container').data('idusuario_busqueda_regDocumento', 0);
    }

    /*agregando la referncia de un documeto*/


    function addreferencia_regDocumento(iddocumento, codigo) {

        var addref = function () {

            if (arrayDocumentoReferencia_regDocumento.indexOf(iddocumento) >= 0) {
                bootbox.alert("Esta REFENCIA ya fue agregada");
            } else {
                $('#listreferencia_regDocumento').append('<div id="alert_' + iddocumento + '" class="alert alert-success alert-dismissible fade in" role="alert"> <button onclick="eliminarReferencia_regDocumento(' + iddocumento + ')" type="button" class="close"  aria-label="Close"><span aria-hidden="true">×</span></button> ' + codigo + ' </div>');
                arrayDocumentoReferencia_regDocumento.push(iddocumento);
            }



        };

        bootbox.confirm("¿ Desea agregar el Documento : <b>" + codigo + "</b> como REFERENCIA ?", function (result) {
            if (result == true) {
                addref();
            }
            else {

            }
        });



    }
    window.addreferencia_regDocumento = addreferencia_regDocumento;

    function agregarReferencias_regdocumento() {
        $('#ModalDocRef_regDocumento').modal('show');
    }
    window.agregarReferencias_regdocumento = agregarReferencias_regdocumento;

    function eliminarReferencia_regDocumento(iddocumento) {
        bootbox.confirm("¿ Desea eliminar la REFERENCIA ?", function (result) {
            if (result == true) {
                eliminarElmentoArray(arrayDocumentoReferencia_regDocumento, iddocumento);
                $('#alert_' + iddocumento).alert('close');
            }
            else {
            }
        });
    }
    window.eliminarReferencia_regDocumento = eliminarReferencia_regDocumento;

    function show_regDocumento(iddocumento) {
        var a = document.createElement('a');
        a.href = urlApp + '/pages/documento/ViewDoc.jsp?iddocumento=' + iddocumento;
        a.target = "_blank";
        document.body.appendChild(a);
        a.click();
    }

    window.show_regDocumento = show_regDocumento;

})();


//
///*!
// * Author: Erick Escalante Olano
// * Description:
// *      Archivo JS para adminitracion 
// !**/
//
///*
// * Global variables. If you change any of these vars, don't forget 
// * to change the values in the less files!
// */
//
//
//(function () {
//
//    var BUSQ_DETALLADA = false;
//
//    /*Oculatando los overligths*/
//    $('#overlayViewDocumento').hide();
//    $('#overlayRecepcionExterna').hide();
//    $('#overlayRecepcionInterna').hide();
//    $('#overlayTramiteExterno').hide();
//    $('#overlaymensaje').hide();
//    $('#overlaymail').hide();
////    $('#overlayViewDocumentoMensaje').hide();
//    /* */
//
//    function cargarBandeja() {
//        cargarGrilla_mensaje();
//        setTimeout("cargarBandeja()", 60000);
//    }
//    window.cargarBandeja = cargarBandeja;
//
//
//    $(function () {
//        getAreaCargo();
//        getRoles();
//        SelectArea();
//        initFormBandeja();
//        $('#container').data('estadoflujo', 1);
//        $('#container').data('idusuario', Usuario.idusuario);
//        crearGrilla_mensaje();
//        cargarBandeja();
//
//    });
//
//    function isjefe() {
//        //alert(Usuario.bindjefe);
//        if (Usuario.bindjefe === true) {
//            $('#tramiteExterno').show()
//        } else {
//            $('#tramiteExterno').hide()
//        }
//    }
//
//    /*
//     * EVENTS
//     * ------------------------
//     */
//    $(function () {
//        $('.grilla').on('keypress', function (e) {
//            if (e.keyCode === 13) {
//                //debugger;
//                cargarGrilla_mensaje();
//            }
//        });
//        /*cambiar al cambio del tipo de documento*/
//        $('#drptipodocumento').on('change', function (e) {
//            geneCodDocumento();
//        });
//
//        $(".btn-group > .btn").click(function () {
//            $(".btn-group > .btn").removeClass("active");
//            $(this).addClass("active");
//        });
//
//        $("#listestados_bandeja > li").click(function () {
//            $("#listestados_bandeja > li").removeClass("active");
//            $(this).addClass("active");
//        });
//
//
////        $("#btnenviarmensaje").click(function (e) {
////            crearMensaje();
////        });
//
//        $("#btn_resolver_expediente").click(function (e) {
//            //alert(1);
//            $('#overlayTramiteExterno').show(500);
//            initFormTramiteExterno();
//            $('#pre_txtbusquedacodigoexpediente_tramite_externo').val($('#msj_codigo_expediente').text());
//            cargarGrilla_TramiteExterno()
//        });
//
//        $("#printmensaje").click(function () {
//            // $('div#overlaymail').printArea();
//            printer('overlaymail');
//        });
//
//        $("#busq_avanzada_mensaje").click(function () {
//            // alert(1);
//            $("#busq_avanzada_mensaje_triguer").click();
//        });
//
//        loadeventsoverlay();
//
//
//    });
//
//    /*Manejo de los overlays*/
//    function loadeventsoverlay() {
//        /*area de overlays*/
//        $('.overlay_close_mensaje').click(function () {
//            $('#overlaymensaje').hide(500);
//            cleantokens();
//        });
//        $('.overlay_open_mensaje').click(function () {
//            $('#overlaymensaje').show(500);
//            cleantokens();
//        });
//
//        $('.overlay_close_docMensaje').click(function () {
//            $('#overlayViewDocumentoMensaje').hide(500);
//            cleantokens();
//        });
//        $('.overlay_open_docMensaje').click(function () {
//            $('#overlayViewDocumentoMensaje').show(500);
//            cleantokens();
//        });
//
//        //===============
//
//        //===============
//
//        //===============
//
//        $('.overlay_close_mail').click(function () {
//            $('#overlaymail').hide(500);
//        });
//
//
//    }
//
//    /* FUNCTIONS
//     * ------------------------
//     */
//    function initFormBandeja() {
//        //$('#overlayViews').hide();
//
//        showcantidadnoleidos();
//
////        autocompletarUsuario();
////        autocompletarArea();
//        //autocompletarUsuarioBusqueda();
//        //autocompletarAreaBusqueda();
//        //createRangePicker();
//        $('#frombusq_detallada').hide();
//        $("#b_fecha_inicio").mask("9999-99-99", {placeholder: "aaaa-mm-dd"});
//        $("#b_fecha_fin").mask("9999-99-99", {placeholder: "aaaa-mm-dd"});
//

/*lo ultimo de bandeja.js*/

/*Registrando un documentos*/
function crearMensaje() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#formMensaje');
    switch (resulValidacion) {
        case 0:

            var crearMensaje = function () {
                var Mensaje = {
                    asunto: $('#txtAsunto').val(),
                    mensaje: $('#txaMensaje').val(),
                    prioridad: PRIORIDAD,
                    bindrespuesta: $("input[name=optradio]:checked").val(),
                    bindrecepcion: $("input[name=optenviorecepcion]:checked").val(),
                    diasrespuesta: $('#txtplazodias').val(),
                    idareacioncreacion: Usuario.idarea,
                    idusuariocreacion: Usuario.idusuario,
                    idexpediente: (arrayExpedienteReferencia.length === 0) ? 0 : arrayExpedienteReferencia[0],
                    estado: true,
                    idareas: getidsAreaUsuario().idarea,
                    listausuarios: getidsAreaUsuario().listausuarios,
                    iddocumentos: arrayDocumentoReferencia_documento,
                    archivosmensaje: getArrayObjectArchivos()
                };

                $.ajaxCall(urlApp + '/MensajeController/crearMensajeBE.htm', {poMensajeBE: Mensaje}, false, function (response) {
                    $.ajaxUpload(urlApp + '/MensajeController/insertarArchivoMensaje.htm', 'formMensaje', function (response) {
                    });
                    bootbox.alert("El mensaje fue correctamente enviado a su destinos.");
                    $('#overlaymensaje').hide();

                });
            };


            if (getidsAreaUsuario().idarea.length === 0 && getidsAreaUsuario().idusuario.length === 0) {
                bootbox.alert("Debe seleccionar como minimo un Usuario o Area.");
            } else
            if (arrayDocumentoReferencia_documento.length === 0 && $("input[name=optenviorecepcion]:checked").val() == 'true') {
                bootbox.alert("Debe adjuntar un <b>Documento</b> para que se realice la recepcion en las Areas detinos.");
            } else {
                bootbox.confirm('<h4>¿ Realmente desea enviar este mensaje  ?</h4>' + '<BR><h4>Recuerde que al crear este mensaje ya no podra modificar ni eliminar.</h4> ', function (result) {
                    if (result === true) {
                        crearMensaje();
                    } else {

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

function showDiv() {
    document.getElementById('containerGrillabandeja').style.display = 'block';
}

//    function hideDiv() {
//        document.getElementById('containerGrillabandeja').style.display = 'none';
//    }
//
//    /*funcion para cargar la cantidad de mensaje no liedos*/
//    function showcantidadnoleidos() {
//        $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: {IndOpSp: 3, idusuariodestino: Usuario.idusuario}}, false, function (response) {
//            $('#cantnoleidos').text(response[0][0]);
//        });
//    }
//
//
//    $('#textInicio').text('BANDEJA DE TRAMITE');
//    function crearGrilla_mensaje() {
//        $("#gridbandeja").jqGrid({
//            datatype: function () {
//                cargarGrilla_mensaje();
//            },
//            height: 460,
//            width: 500,
//            ignoreCase: true,
//            multiselect: true,
//            caption: "",
//            colNames: ["idbandeja", "idmensaje", "Usuario Envia", "Asunto ", "Mensaje", "Fecha Envio", "Adjunto", "Recepcionado"],
//            colModel: [{
//                    name: 'idbandeja',
//                    index: 'idbandeja',
//                    editable: false,
//                    align: "center",
//                    width: 80,
//                    search: false,
//                    hidden: true
//                }, {
//                    name: 'idmensaje',
//                    index: 'idmensaje',
//                    editable: false,
//                    align: "center",
//                    width: 80,
//                    search: false,
//                    hidden: true
//                }, {
//                    name: 'usuarioenvia',
//                    index: 'usuarioenvia',
//                    editable: false,
//                    align: "left",
//                    width: 200,
//                    search: false,
//                    hidden: false
//                }, {
//                    name: 'asunto',
//                    index: 'asunto',
//                    editable: false,
//                    align: "left",
//                    width: 330,
//                    search: false,
//                    hidden: false
//                }, {
//                    name: 'mensaje',
//                    index: 'mensaje',
//                    editable: false,
//                    align: "left",
//                    width: 300,
//                    search: false,
//                    hidden: false
//                }, {
//                    name: 'fechaenvio',
//                    index: 'fechaenvio',
//                    editable: false,
//                    align: "center",
//                    width: 180,
//                    search: false,
//                    hidden: false
//                }, {
//                    name: 'adjunto',
//                    index: 'adjunto',
//                    editable: false,
//                    width: 75,
//                    hidden: false,
//                    search: false,
//                    align: "center"
//                }, {
//                    name: 'recepcion',
//                    index: 'recepcion',
//                    editable: false,
//                    width: 150,
//                    hidden: false,
//                    search: false,
//                    align: "center"
//                }],
//            pager: '#pagerbandeja',
//            storname: 'idexpediente',
//            loadtext: 'Cargando datos...',
//            recordtext: "{0} - {1} de {2} elementos",
//            emptyrecords: 'No hay resultados',
//            pgtext: 'Pág: {0} de {1}',
//            rowNum: "10",
//            rowList: [10, 20, 30],
//            //onSelectRow: viewGeometry,
//            viewrecords: true,
//            rownumbers: true,
//            shrinkToFit: false,
//            ondblClickRow: mostrarmensaje
//
//                    //multiselect: true
//        });
//        $("#gridbandeja").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
//        /**Ajustando grilla a contenedor */
//        $('#containerGrillabandeja').bind('resize', function () {
//            $("#gridbandeja").setGridWidth($('#containerGrillabandeja').width());
//        }).trigger('resize');
//    }
//
//    function mostrarmensaje(rowid) {
//
//        var idmensaje = $('#gridbandeja').jqGrid('getRowData', rowid).idmensaje;
//        var idbandeja = $('#gridbandeja').jqGrid('getRowData', rowid).idbandeja;
//        var Bandeja = new Object();
//
//        Bandeja.idmensaje = idmensaje;
//        Bandeja.IndOpSp = 4;
//
//        $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
//            $('#msj_asunto').text(response[0][0]);
//            $('#msj_text').text(response[0][1]);
//
//            $('#msj_areacreacion').text(response[0][6]);
//            var prioridad = parseInt(response[0][2]);
//            $('#msj_prioridad').text(prioridad == 1 ? 'ALTA' : prioridad == 2 ? 'MEDIA' : 'BAJA');
//
//
//            $('#msj_respuesta').text(response[0][4] === 't' ? 'SI' : 'NO');
//            $('#msj_diasrespuesta').text(response[0][5]);
//
//            $('#msj_usuarioenvia').text(response[0][7]);
//            $('#msj_fechaenvia').text(response[0][8]);
//            $('#msj_codigo_expediente').text(response[0][9]);
//
//            if (!/^([0-9])*$/.test(response[0][9])) {
//                $('#btn_resolver_expediente').hide()
//            } else {
//                $('#btn_resolver_expediente').show()
//            }
//
//
//        });
//        Bandeja.IndOpSp = 5;
//        $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
//            $('#listareferencia').empty();
//            $.each(response, function (index, value) {
//                $('#listareferencia').append('<a target="_blank" href="' + urlApp + '/pages/documento/ViewDoc.jsp?iddocumento=' + value[0] + '" > <div class="myButton" role="alert"> <h5 style="color:#FFF;">' + value[1] + '</h5> </div> </a>');
//            });
//        });
//        Bandeja.IndOpSp = 6;
//        $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
//
//            $('#listaadjuntos').empty();
//            var archivo = '';
//            var extension = '';
//            $.each(response, function (index, value) {
//                archivo = value[1];
//                extension = (archivo === null ? '' : archivo.substring(archivo.lastIndexOf("."))).toLowerCase();
//
//
//                switch (extension) {
//                    case '.jpg':
//                    case '.png':
//                    case '.gif':
//                    case '.bmp':
//                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-image-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
//                        break;
//                    case '.xls':
//                    case '.xlsx':
//                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-excel-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
//                        break;
//                    case '.doc':
//                    case '.docx':
//                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-word-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
//                        break;
//                    case '.ppt':
//                    case '.pptx':
//                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-powerpoint-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
//                        break;
//                    case '.mp3':
//                    case '.wma':
//                    case '.wav':
//                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-audio-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
//                        break;
//
//                    case '.avi':
//                    case '.mp4':
//                    case '.mpg':
//                    case '.wmv':
//                    case '.mov':
//                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file-video-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
//                        break;
//                    case '.pdf':
//                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file-pdf-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
//                        break;
//                    case '':
//                        break;
//                    default:
//                        $('#listaadjuntos').append('<a target="_blank" href="' + URL_FTP + '/' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
//                        break;
//                }
//            });
//        });
//
//        Bandeja.IndOpSp = 7;
//        Bandeja.idbandeja = idbandeja;
//
//        if ($.trim(idbandeja) !== '') {
//
//            $.ajaxCall(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
//                showcantidadnoleidos();
//                cargarGrilla_mensaje();
//            });
//
//        }
//        $('#overlaymail').show(500);
//    }
//
//    var indopsp = 1;
//
//    function cargarGrilla_mensaje() {
//
//        var Bandeja = {
//            IndOpSp: indopsp,
//            idusuariodestino: Usuario.idusuario,
//            rows: $("#gridbandeja").getGridParam("rowNum"),
//            page: $("#gridbandeja").getGridParam("page"),
//            /*para la busqueda avanzada*/
//            b_idsarea: $('#container').data('_idsarea'),
//            b_idsusuarioenvia: $('#container').data('_idsusuarioenvia'),
//            b_asunto: $('#container').data('_asunto'),
//            b_mensaje: $('#container').data('_mensaje'),
//            b_indsrecepcion: $('#container').data('_indsrecepcion'),
//            b_indsrespuesta: $('#container').data('_indsrespuesta'),
//            b_indsprioridad: $('#container').data('_indsprioridad'),
//            b_vencidosactivos: $('#container').data('_vencidosactivos'),
//            b_fechainicio: $('#container').data('fechainicio'),
//            b_fechafin: $('#container').data('fechafin'),
//            limite: $("#gridbandeja").getGridParam("rowNum"),
//            offsete: $("#gridbandeja").getGridParam("page")
//
//
//        };
//
//        $.ajaxCall(urlApp + '/BandejaController/listarJQRegistrosBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
//            $('#gridbandeja').jqGrid('clearGridData');
//            $("#gridbandeja")[0].addJSONData(response);
//        });
//    }
//
//    window.cargarGrilla_mensaje = cargarGrilla_mensaje;
//
//    function cargarflujosecundario(li, idestadoflujo, idusuario, estado) {
//        $('.estado').removeClass('active');
//        $(li).addClass('active');
//        console.log(idestadoflujo, idusuario, estado)
//        cargarGrillaSecundaria(idusuario, idestadoflujo);
//        alert(idestadoflujo)
//        $('#container').data('estadoflujo', idestadoflujo);
//        $('#container').data('idusuario', idusuario)
//        $('#txtestadoflujo').text(estado);
//    }
//
////FUNCION QUE ME PERMITE CREAR INPUT TYPE FILE PARA SUBIR ARCHIVOS
////    var banderaUploadImg = 0;
////    var idsUploadImg = new Array();
//
////    function generarUploadImg(div) {
////        if (idsUploadImg.length === 10) {
////            bootbox.alert("Solo se permiten como maximo 10 archivos.");
////        } else {
////            var id = banderaUploadImg + 1;
////            $(div).append('<div id="blq' + id + '" class="row">' +
////                    '<div class="col-lg-4">' +
////                    '        <input obligatorio id="textdenominacion_' + id + '" name="textdenominacion_' + id + '" placeholder="Ingrese denominacion" type="text">' +
////                    '</div>' +
////                    '<div class="col-lg-7">' +
////                    '        <input obligatorio style="float:left" id="img_' + id + '" name="img_' + id + '" type="file" >' +
////                    '</div>' +
////                    '<div class="col-lg-1">' +
////                    '    <input onclick="eliminarUploadImg(' + id + ')" type="button" value="X">' +
////                    '</div>' +
////                    '</div>')
////            idsUploadImg.push(id);
////            banderaUploadImg = id;
////        }
////    }
////
////    window.generarUploadImg = generarUploadImg;
//
////funcion que elimina un upload generado
////    function eliminarUploadImg(id) {
////        $('#blq' + id).remove();
////        eliminarElmentoArray(idsUploadImg, id);
////    }
////    window.eliminarUploadImg = eliminarUploadImg;
//
////    function getArrayObjectArchivos() {
////        var arrayObjectArchivos = new Array();
////        $.each(idsUploadImg, function (index, value) {
////            var archivo = {
////                name: "img_" + value,
////                nombre: $("#textdenominacion_" + value).val(),
////                estado: true
////            }
////            arrayObjectArchivos.push(archivo);
////        });
////        return arrayObjectArchivos;
////    }
//
////    window.eliminarElmentoArray = eliminarElmentoArray;
////    function eliminarElmentoArray(array, elem) {
////        var idx = array.indexOf(parseInt(elem));
////        if (idx != -1)
////            array.splice(idx, 1);
////    }
//
//
//    /* 
//     *  Funcion que me permite autocomepletar multiplemente los daos de un usuario
//     * */
////    var arrayUsuarioArea = new Array();
////    var arrayArea = new Array();
//
////    function autocompletarUsuario() {
////        $("#txtusuario_mensaje").AutocompleteMultiple(urlApp + "/UsuarioController/autocompletarUsuariosWithArea.htm", "#txtusuario_mensaje", null,
////                function (item) {
////                    return {
////                        label: item.nombres,
////                        idusuario: item.idusuario,
////                        idarea: item.idarea
////                    }
////                },
////                function (event, ui) {
////                    arrayUsuarioArea.push([ui.item.idusuario, ui.item.idarea, ui.item.label]);
////                    arrayUsuarioArea = eliminateDuplicates(arrayUsuarioArea);
////
////                });
////
////        $('#txtusuario_mensaje').on('tokenfield:removedtoken', function (e) {
////            eliminarUsuarioAreaMensaje(e.attrs.value);
////        }).tokenfield();
////    }
//
//
//    /*===========================Fin de busqueda de usuario ==========================*/
//
////    function autocompletarArea() {
////        $("#txtareasdestino").AutocompleteMultiple(urlApp + "/AreaController/autocompletarAreawithjefeBE.htm", "#txtareasdestino", null,
////                function (item) {
////                    return {
////                        label: item.denominacion,
////                        idusuario: item.idusuariojefe,
////                        idarea: item.idarea
////                    }
////                },
////                function (event, ui) {
////                    arrayUsuarioArea.push([ui.item.idusuario, ui.item.idarea, ui.item.label]);
////                    arrayUsuarioArea = eliminateDuplicates(arrayUsuarioArea);
////                });
////
////        $('#txtareasdestino').on('tokenfield:removedtoken', function (e) {
////            eliminarUsuarioAreaMensaje(e.attrs.value);
////        }).tokenfield();
////
////    }
//
////    function eliminarUsuarioAreaMensaje(valor) {
////        arrayUsuarioArea = jQuery.grep(arrayUsuarioArea, function (value) {
////            return (value.substring(value.lastIndexOf(",") + 1) !== valor);
////        });
////    }
//    /*Funcion para eliminar duplicados de array*/
////    function eliminateDuplicates(arr) {
////        var i,
////                len = arr.length,
////                out = [],
////                obj = {};
////        for (i = 0; i < len; i++) {
////            obj[arr[i]] = 0;
////        }
////        for (i in obj) {
////            out.push(i);
////        }
////        return out;
////    }
//
//
//
//    function crearListaFlujo() {
//        var arrayFlujoEnviar = new Array();
//        $.each(arrayUsuario, function (index, value) {
//            var flujo = {
//                idexpediente: $('#container').data('idexpediente'),
//                idflujoparent: $('#container').data('idflujoparent'),
//                idestadoflujo: 1, //pendiente
//                idusuario: Usuario.idusuario,
//                idusuarioenvia: Usuario.idusuario,
//                idusuariorecepciona: value.substring(0, value.lastIndexOf(",")),
//                asunto: $('#txtAsunto').val(),
//                descripcion: $('#txaMensaje').val(),
//                observacion: $('#txaMensaje').val(),
//                binderror: false,
//                estado: true
//            }
//            arrayFlujoEnviar.push(flujo)
//        });
//        return arrayFlujoEnviar;
//    }
//
//    function enviarmensaje(idusuario, idexpediente) {
//        var Flujo = {
//            idexpediente: idexpediente,
//            idestadoflujo: 1, //pendiente
//            idusuario: Usuario.idusuario,
//            idusuarioenvia: Usuario.idusuario,
//            idusuariorecepciona: idusuario,
//            asunto: $('#txtAsunto').val(),
//            descripcion: $('#txaMensaje').val(),
//            observacion: $('#txaMensaje').val(),
//            binderror: false,
//            estado: true
//        };
//        $.ajaxCall(urlApp + '/FlujoController/insertarFlujodetalleExpedienteBE.htm', {poFlujoBE: Flujo, listVolumen: getArrayObjectArchivos()}, false, function (response) {
//            if (response > 0) {
//            }
//        });
//    }
//
//    function registrarEnvioArchivos() {
//
//        $.ajaxCall(urlApp + '/FlujoController/insertarEnvio.htm', {poFlujoBE: {idusuario: Usuario.idusuario}, listVolumen: getArrayObjectArchivos()}, false, function (response) {
//
//            if (response > 0) {
//
//                $.ajaxUpload(urlApp + '/FlujoController/insertarArchivoFlujo.htm', 'frmderivar', function (response) {
//
//                });
//
//                $.ajaxCall(urlApp + '/FlujoController/insertarListaFlujo.htm', {listflujo: crearListaFlujo()}, false, function (response) {
//                    if (response > 0) {
//                        bootbox.alert("Tu mensaje fue correctamente enviado a los destinos");
//                        $('#myModal2').modal('hide');
//                    } else {
//                        bootbox.alert("Ocurrio un error en el envio, comuniquese con el administrador");
//                    }
//                });
//            }
//        });
//
//    }
//
//
//    function visualizar(idflujo, idexpediente, asunto) {
//
//        var Flujo = {
//            idflujo: idflujo
//
//        };
//
//        $.ajaxCall(urlApp + '/FlujoController/lecturaFlujoBE.htm', {poFlujoBE: Flujo}, false, function (response) {
//            if (response > 0) {
//                $('#mdlDetalleExpediente').modal('show');
//                $.ajaxCall(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 4, idflujo: idflujo}}, false, function (response) {
//                    console.log(response);
//                    $('#txtdt_codigo').val(response[0][0]);
//                    $('#txtdt_asunto').val(response[0][1]);
//                    $('#txtdt_area').val(response[0][10]);
//                    $('#txtdt_procedimiento').val(response[0][11]);
//                    $('#txtdt_fechaingreso').val(response[0][8]);
//                    $('#txtdt_fecharecepcion').val(response[0][9]);
//
//                    $('#txtdt_nrodoc').val(response[0][2]);
//                    $('#txtdt_nombres').val(response[0][3]);
//                    $('#txtdt_apellidos').val(response[0][4]);
//                    $('#txtdt_direccion').val(response[0][5]);
//                    $('#txtdt_telefonos').val(response[0][6]);
//                    $('#txtdt_correo').val(response[0][7]);
//                });
//            }
//        });
//
//    }
//
//    function PintarRowGrillaavanzado(idgrilla, namecolumn, valorComparar, operacion, color, colorletra) {
//
//        var qfunciont =
//                ' var idgrilla="' + idgrilla + '";' +
//                ' var namecolumn="' + namecolumn + '";' +
//                ' var valorComparar="' + valorComparar + '";' +
//                ' var color="' + color + '";' +
//                ' var colorletra="' + colorletra + '";' +
//                ' actualizarIDGrid(idgrilla); ' +
//                'columns = $("#" + idgrilla).jqGrid("getGridParam", "colNames"); ' +
//                '$("#" + idgrilla + " tr [aria-describedby=" + idgrilla + "_" + namecolumn + "]").each(function (r) {' +
//                ' var c = columns.length;' +
//                ' while (c > 0) {' +
//                '   c--;' +
//                '  if ($(this).text() ' + operacion + ' valorComparar)' +
//                '  jQuery("#" + idgrilla).setCell(r + 1, c, "", {' +
//                '"background-color": color,' +
//                '"color": colorletra' +
//                '});' +
//                '}' +
//                '});'
//
//        eval(qfunciont);
//    }
//
//    /*Asignando las Prioridades al documento*/
////    var PRIORIDAD = 3;
//
//    function setPrioridad(prioridad) {
//        PRIORIDAD = prioridad;
//    }
//
//
//
//
//
//
//
//
//    function show(iddocumento) {
//
//        a = document.createElement('a');
//        a.href = urlApp + '/pages/documento/ViewDoc.jsp?iddocumento=' + iddocumento;
//        a.target = "_blank";
//        document.body.appendChild(a);
//        a.click();
//    }
//
//    var open = false
//
//    function showsiderbar() {
//        if (open) {
//            $('#configsiderbar').removeClass('control-sidebar-open'), open = false;
//        } else {
//            $('#configsiderbar').addClass('control-sidebar-open'), open = true;
//        }
//    }
//    window.showsiderbar = showsiderbar;
//
//
////    function getidsAreaUsuario() {
////        var idsAreaUsuario = {
////            idarea: [],
////            listausuarios: []
////        };
////        $.each(arrayUsuarioArea, function (index, value) {
////            var array = value.split(',');
////            idsAreaUsuario.idarea.push(array[1])
////            idsAreaUsuario.listausuarios.push({idarea: array[1], idusuario: array[0]})
////        });
////        idsAreaUsuario.idarea = idsAreaUsuario.idarea.unique();
////        idsAreaUsuario.listausuarios = idsAreaUsuario.listausuarios.unique();
////        return idsAreaUsuario;
////    }
//
////    Array.prototype.unique = function (a) {
////        return function () {
////            return this.filter(a)
////        }
////    }(function (a, b, c) {
////        return c.indexOf(a, b + 1) < 0
////    });
//
////    function cleantokens() {
////        $('#txtareasdestino').tokenfield('setTokens', ',');
////        $('#txtplazodias').val(3);
////        $('#txtusuario_mensaje').tokenfield('setTokens', ',');
////        $('#txtAsunto').val('');
////        $('#txaMensaje').val('');
////        $('#listreferencia_mensaje').empty();
////        $('#listexpediente_mensaje').empty();
////        arrayDocumentoReferencia_documento = new Array();
////        arrayExpedienteReferencia = new Array();
////        arrayUsuarioArea = new Array();
////        idsUploadImg = new Array();
////
////        $('#uploadfile').empty();
////
////        $("#rbnt_rpta_no").prop("checked", true);
////        $("#rbnt_recepcion_si").prop("checked", true);
////    }
//
//    /*Registrando un documentos*/
////    function crearMensaje() {
////        var resulValidacion = 0;
////        resulValidacion = $.ValidarData('#formMensaje');
////        switch (resulValidacion) {
////            case 0:
////
////                var crearMensaje = function () {
////                    var Mensaje = {
////                        asunto: $('#txtAsunto').val(),
////                        mensaje: $('#txaMensaje').val(),
////                        prioridad: PRIORIDAD,
////                        bindrespuesta: $("input[name=optradio]:checked").val(),
////                        bindrecepcion: $("input[name=optenviorecepcion]:checked").val(),
////                        diasrespuesta: $('#txtplazodias').val(),
////                        idareacioncreacion: Usuario.idarea,
////                        idusuariocreacion: Usuario.idusuario,
////                        idexpediente: (arrayExpedienteReferencia.length === 0) ? 0 : arrayExpedienteReferencia[0],
////                        estado: true,
////                        idareas: getidsAreaUsuario().idarea,
////                        listausuarios: getidsAreaUsuario().listausuarios,
////                        iddocumentos: arrayDocumentoReferencia_documento,
////                        archivosmensaje: getArrayObjectArchivos()
////                    };
////
////                    $.ajaxCall(urlApp + '/MensajeController/crearMensajeBE.htm', {poMensajeBE: Mensaje}, false, function (response) {
////                        $.ajaxUpload(urlApp + '/MensajeController/insertarArchivoMensaje.htm', 'formMensaje', function (response) {
////                        });
////                        bootbox.alert("El mensaje fue correctamente enviado a su destinos.");
////                        $('#overlaymensaje').hide();
////
////                    });
////                };
////
////
////                if (getidsAreaUsuario().idarea.length === 0 && getidsAreaUsuario().idusuario.length === 0) {
////                    bootbox.alert("Debe seleccionar como minimo un Usuario o Area.");
////                } else
////                if (arrayDocumentoReferencia_documento.length === 0 && $("input[name=optenviorecepcion]:checked").val() == 'true') {
////                    bootbox.alert("Debe adjuntar un <b>Documento</b> para que se realice la recepcion en las Areas detinos.");
////                } else {
////                    bootbox.confirm('<h4>¿ Realmente desea enviar este mensaje  ?</h4>' + '<BR><h4>Recuerde que al crear este mensaje ya no podra modificar ni eliminar.</h4> ', function (result) {
////                        if (result === true) {
////                            crearMensaje();
////                        } else {
////
////                        }
////                    });
////                }
////
////
////
////                break;
////            case -1:
////                bootbox.alert(Mensajes.camposRequeridos);
////                break;
////            case -2:
////                bootbox.alert(Mensajes.camposIncorrectos);
////                break;
////
////        }
////
////    }
//
//    function showDiv() {
//        document.getElementById('containerGrillabandeja').style.display = 'block';
//    }
//
////    function hideDiv() {
////        document.getElementById('containerGrillabandeja').style.display = 'none';
////    }
//
//    function showbandejaentrada() {
//        showDiv();
//        indopsp = 1;
//        cargarGrilla_mensaje();
//    }
//    window.showbandejaentrada = showbandejaentrada;
//
//    function showbandejasalida() {
//        showDiv();
//        indopsp = 2;
//        cargarGrilla_mensaje();
//    }
//    window.showbandejasalida = showbandejasalida;
//
//
//
//    /*
//     * Funcion que me permite el cambio de el area que le pertenece a un usuario 
//     * @type type
//     */
//    var datosUsuario = {};
//
//    function getAreaCargo() {
//        $.ajaxCall(urlApp + '/UsuariocargoController/listarRegistrosUsuariocargoBE.htm', {poUsuariocargoBE: {IndOpSp: 3, idusuario: Usuario.idusuario}}, false, function (response) {
//            if (response.length === 0) {
//                bootbox.alert("Es necesario asignar un cargo a este usuario");
//            } else {
//                datosUsuario.listacargos = response;
//            }
//            console.log(response)
//        });
//    }
//
//    function getRoles() {
//        $.ajaxCall(urlApp + '/UsuarioController/listObjectUsuarioBE.htm', {poUsuarioBE: {IndOpSp: 2, idusuario: Usuario.idusuario}}, false, function (response) {
//
//
//            datosUsuario.roles = response[0][0];
//            setDataUsuario(datosUsuario);
//        });
//    }
//    var checkedselect = 0;
//
//    function SelectArea() {
//
//        $.ajaxCall(urlApp + '/UsuarioController/initlogin.htm', {}, false, function (response) {
//
//
//            if (response.bindcargoseleccionado === null || response.bindcargoseleccionado === 'null' || response.bindcargoseleccionado === false) {
//                var opciones = '';
//                $.each(response.listacargos, function (index, value) {
//                    if (response.listacargos.length === 0) {
//                        bootbox.alert("Es necesario asignar un cargo a este usuario");
//                    } else {
//                        if (response.listacargos.length === 1) {
//                            //cargar area seleccionada
//                            //$('#container').data('container_' + value.idarea, value)
//                            console.log('VALOR ');
//                            console.log(value);
//                            setArea(value);
//                            $('#areacargo').text(value.area + ' - ' + value.cargo)
//
//
//                        } else {
//                            opciones += '<div class="radio"> ' +
//                                    '<label for="areas-' + value.idarea + '"> ' +
//                                    '<input ' + (checkedselect == 0 ? 'checked' : '') + ' type="radio" name="areas" id="areas-' + value.idarea + '" value="' + value.idarea + '" > ' +
//                                    value.area +
//                                    '</label> ' +
//                                    '</div>';
//                            checkedselect = 1;
//
//                            $('#container').data('container_' + value.idarea, value);
//
//                        }
//                    }
//                });
//
//                /**/
//                if (opciones.length > 0) {
//                    bootbox.dialog({
//                        closeButton: false,
//                        title: "Seleccionar AREA de operacion.",
//                        message: '<div class="row">  ' +
//                                '<div class="col-md-12"> ' +
//                                '<form class="form-horizontal"> ' +
//                                '<div class="form-group"> ' +
//                                '<label class="col-md-4 control-label" for="awesomeness">¿Cual es el AREA en donde desea laborar?</label> ' +
//                                '<div class="col-md-4">' +
//                                opciones +
//                                '</div> ' +
//                                '</div>' +
//                                '</form> </div>  </div>',
//                        buttons: {
//                            success: {
//                                label: "Seleccionar",
//                                className: "btn-success",
//                                callback: function () {
//                                    var id_container = $("input[name='areas']:checked").val()
//
//                                    //alert(id_container);
//
//                                    if (typeof id_container === "undefined") {
//                                        bootbox.alert("Es necesario selecccionar un area para poder trabajar");
//
//
//                                    } else {
//                                        setArea($('#container').data('container_' + id_container));
//                                        $('#areacargo').text($('#container').data('container_' + id_container).area + ' - ' +
//                                                $('#container').data('container_' + id_container).cargo)
//                                        $('#area_seleccionada').text("AREA");
//                                        $('#area_seleccionada').attr('title', 'Area Seleccionada:  ' + response.area);
//                                        //location.reload();
//
//                                    }
//                                    // alert("Hello " + name + ". You've chosen <b>" + id_container + "</b>");
//                                    isjefe();
//
//                                }
//                            }
//                        }
//
//                    });
//                } else {
//
//                }
//
//
//            } else {
//                $('#areacargo').text(response.area + ' - ' + response.cargo)
//            }
//
//
//        });
//        isjefe();
//    }
//
//    function setDataUsuario() {
//
//
//        $.ajaxCall(urlApp + '/UsuarioController/setDataUsuario.htm', {poUsuarioBE: datosUsuario}, false, function (response) {
//            console.log(response);
//
//        });
//    }
//    /*Fin de cambio de usuario*/
//
//
//    /*busqueda de grilla*/
//
//    function loadCombos() {
//        $.CargarCombo(urlApp + '/UsuariocargoController/listObjectUsuariocargoBE.htm', {poUsuariocargoBE: {IndOpSp: 1}}, '#drpusuariobusqueda_grid');
//
//    }
//
//})();
//
//
//
//
//
//
//

function showbandejaentrada() {
    showDiv();
    indopsp = 1;
    cargarGrilla_mensaje();
}
window.showbandejaentrada = showbandejaentrada;

function showbandejasalida() {
    showDiv();
    indopsp = 2;
    cargarGrilla_mensaje();
}
window.showbandejasalida = showbandejasalida;



/*
 * Funcion que me permite el cambio de el area que le pertenece a un usuario 
 * @type type
 */
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
                                value.area +
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
                                isjefe();

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
    isjefe();
}

function setDataUsuario() {


    $.ajaxCall(urlApp + '/UsuarioController/setDataUsuario.htm', {poUsuarioBE: datosUsuario}, false, function (response) {
        console.log(response);

    });
}
/*Fin de cambio de usuario*/


/*busqueda de grilla*/

function loadCombos() {
    $.CargarCombo(urlApp + '/UsuariocargoController/listObjectUsuariocargoBE.htm', {poUsuariocargoBE: {IndOpSp: 1}}, '#drpusuariobusqueda_grid');

}

//})();

