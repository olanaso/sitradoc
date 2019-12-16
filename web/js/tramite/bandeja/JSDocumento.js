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
    /*
     /* INITIALIZE 
     * ------------------------
     */


    $(function () {

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

    /*EVENTS
     * ------------------------
     */
    $(function () {


        /*Abrir Overlay Recepcion Externa*/
        $("#misdocumentos").click(function (e) {
            // alert(1)
            $('#overlayViewDocumento').show(500);
        });

        $('.overlay_close_documento').click(function () {
            $('#overlayViewDocumento').hide(500);
        });


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

            if ($("#btnNuevo_regDocumento").text() === 'Actualizar') {
                actualizar();
            }
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
    });


    /*limpiar controles*/

    function limpiarcontroles() {
        $.DesabilitarForm('#form_regDocumento');
        $.LimpiarForm('#form_regDocumento');
        idsUploadImg_regDocumento=new Array();
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

                    $.ajaxCall(urlApp + '/DocumentoController/crearDocumentoBE.htm', {poDocumentoBE: DocumentoBE, listVolumen: getArrayObjectArchivos_regDocumento()}, false, function (response) {
                        $.ajaxUpload(urlApp + '/DocumentoController/insertarArchivoDocumento.htm', 'form_regDocumento', function (response) {
                            cargarGrillaDocumento_regDocumento();
                            limpiarcontroles();
                            $("#btnNuevo_regDocumento").text('Nuevo');
                            bootbox.alert("El registro del DOCUMENTO fue exitoso.");
                        });
                    });
                };

                bootbox.confirm("<h4>¿ Realmente desea crear el Documento ?</h4> <br><h4><b>" + $('#txtcodigodocumentogenerado_regDocumento').val() + '</b></h4> '
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

    }


    function loadCombos_regDocumento() {
        $.CargarCombo(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 6}}, '#drptipodocbusqueda_regDocumento');
        $.CargarCombo(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 6}}, '#drptipodocumento_regDocumento');
        $.CargarCombo(urlApp + '/AreaController/listObjectAreaBE.htm', {poAreaBE: {IndOpSp: 2}}, '#drpareabusqueda_regDocumento');
    }


    /*Area para subir adjuntos vincualdos a un documento*/

//FUNCION QUE ME PERMITE CREAR INPUT TYPE FILE PARA SUBIR ARCHIVOS
    var banderaUploadImg_regDocumento = 0;
    var idsUploadImg_regDocumento = new Array();
    window.idsUploadImg_regDocumento=idsUploadImg_regDocumento;

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

    var arrayDocumentoReferencia_regDocumento = new Array();
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



