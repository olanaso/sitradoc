<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Registro de Documento | Tramite Interno</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <link href="${pageContext.request.contextPath}/js/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/js/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- Ionicons -->
    <link href="${pageContext.request.contextPath}/js/plugins/ionicons/css/ionicons.min.css" rel="stylesheet" type="text/css" /> <!-- daterange picker -->
    <!-- Theme style -->
    <link rel="stylesheet" media="screen" href="${pageContext.request.contextPath}/js/plugins/jquery/css/redmond/jquery-ui-1.10.4.custom.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/jqgrid/css/ui.jqgrid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/sliptree-bootstrap-tokenfield/css/bootstrap-tokenfield.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/daterangepicker/daterangepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/TimeSelect/jquery.ptTimeSelect.css">

    <link href="${pageContext.request.contextPath}/css/AdminLTE.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/megamenu.css" rel="stylesheet" type="text/css" />
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->

    <link href="${pageContext.request.contextPath}/css/bandejainterna.css" rel="stylesheet" type="text/css" />
    <style>
        .active{
            background: #0080FF !important;
            color:#fff !important;
        }
        .filtros .area{
            float: left;


        }
        .area i{
            font-size: 8px;
            border: 0.5px solid #B6D0FC; 
            border-radius: 3px;
        }
        .area i a{
            cursor: pointer;
        }

    </style>



    <script>
        var urlApp = '${pageContext.request.contextPath}';
    </script>
</head>
<body class="skin-blue">
    <%@include file="component/btn_mensaje.html" %>
    <%@include file="siderbars/header.html" %>
    <div class="wrapper row-offcanvas row-offcanvas-left">
        <!-- Left side column. contains the logo and sidebar -->
        <%@include file="siderbars/siderbarBandeja.html" %>

        <!-- Right side column. Contains the navbar and content of the page -->
        <aside class="right-side">
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1>
                    Registro de Documento
                    <small>Registro de Documento</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-unlock-alt"></i> Tramite Interno</a></li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                    <div class="col-md-12">




                        <section class="content">
                            <div class="row">
                                <div class="col-md-12">
                                    <form id="form_regDocumento" role="form">
                                        <div class="row">


                                            <div class="form-group col-md-12">
                                                <label style="font-weight: bold;"> Destinatarios :</label>
                                                <br>
                                                <div onclick="agregardestinos();" style="width: 220px;" class="btn btn-default btn-file">
                                                    <i class="fa fa-users" aria-hidden="true"></i> Destinos ( Areas o Usuario )
                                                </div>
                                                <br>
                                                <br>
                                                <div >

                                                    <div class="form-group col-md-12">
                                                        <label>&Aacute;rea Destino :</label>
                                                        <input  id="txtareasdestino" type="text" class="form-control input-sm" placeholder="&Aacute;reas Destino">
                                                    </div>
                                                    <div class="form-group col-md-12">
                                                        <label>Usuario Destino :</label>
                                                        <input  id="txtusuario_mensaje" type="text" class="form-control input-sm" placeholder="Usuarios Destino">
                                                    </div>
                                                </div> 
                                            </div>
                                            <div class="form-group col-md-12" >
                                                <div style="height: 12px; border-color: #f44336!important;border-bottom: 1px solid #ccc!important; margin-bottom: 12px;"></div>
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label>Tipo Documento :</label>
                                                <select class="form-control input-sm" id="drptipodocumento_regDocumento" obligatorio="">
                                                </select>
                                            </div>  
                                            <div class="form-group col-md-6">
                                                <label>C&oacute;digo Documento :</label>
                                                <input obligatorio id="txtcodigodocumentogenerado_regDocumento" class="form-control input-sm" type="text" placeholder="Codigo Documento Generado">
                                            </div> 


                                            <div class="form-group col-md-12">
                                                <label>Asunto :</label>
                                                <input obligatorio id="txtAsunto_regDocumento" class="form-control input-sm" type="text" placeholder="Ingrese Asunto">
                                            </div>
                                            <div class="form-group col-md-12">
                                                <label>Descripci&oacute;n :</label>
                                                <textarea id="txaMensaje_regDocumento" obligatorio class="form-control input-sm"></textarea>
                                            </div>  
                                            <div class="form-group col-md-12" style="display: none;">
                                                <label>C&oacute;digo Expediente :</label>
                                                <input disabled="disabled" inafecto="" obligatorio id="txtCodigoexpediente_regDocumento" class="form-control input-sm" type="text" placeholder="Ingrese Codigo Expediente">
                                            </div>
                                            <hr>

                                            <div class="form-group col-md-6">
                                                <p><label>Requiere Respuesta (SI/NO)</label></p>
                                                <div class="btn-group" role="group" aria-label="Default button group">
                                                    <label class="radio-inline">
                                                        <input id="rbnt_rpta_si"   type="radio" name="optradio" value="true"> Si
                                                    </label>
                                                    <label class="radio-inline">
                                                        <input id="rbnt_rpta_no"  type="radio" name="optradio" value="false">No
                                                    </label>
                                                </div>

                                            </div>
                                            <div class="form-group col-md-6 req_rpt">
                                                <p><label>Prioridad (1:Alta/2:Media/3:Baja) : </label></p>
                                                <div class="btn-group" role="group" aria-label="Default button group">
                                                    <!--<button type="button" onclick="setPrioridad(1);" class="btn btn-default">1</button>-->
                                                    <button type="button" onclick="setPrioridad(this, 1);" class="btn btn-default">1</button>
                                                    <button type="button" onclick="setPrioridad(this, 2);" class="btn btn-default">2</button>
                                                    <button type="button" onclick="setPrioridad(this, 3);" class="btn btn-default">3</button>
                                                </div>
                                            </div>
                                            <div class="form-group col-md-6 req_rpt">
                                                <p><label>Plazo D&iacute;as para Atenci&oacute;n de Documento :</label></p>
                                                <div class="btn-group" role="group" aria-label="Default button group">
                                                    <input solonumeros obligatorio id="txtplazodias" type="text" class="form-control" placeholder="Ingrese plazo en d&iacute;as">
                                                </div>
                                            </div>

                                            <div class="form-group col-md-6">

                                                <div class="btn-group" role="group" aria-label="Default button group">
                                                    <input style="color: red;" id="md_showfechamanual" type="checkbox"/> Fecha de registro manual</span>

                                                </div>
                                                <div class="row" id="bloq_fecha_manual">
                                                    <div class="form-group col-md-6">
                                                        <label>Fecha Envio :</label>
                                                        <input obligatorio id="txtfecha_manual" class="form-control input-sm" type="text" placeholder="Fecha Manual">
                                                    </div>  
                                                    <div class="form-group col-md-6">
                                                        <label>Hora :</label>
                                                        <input obligatorio id="txthora_manual" class="form-control input-sm" type="text" placeholder="Hora Manual">
                                                    </div> 
                                                </div>
                                            </div>
                                            <div class="form-group col-md-12">
                                                <p><label>Referenciar Expediente :</label></p>
                                                <div onclick="agregarExpediente_mensaje();" style="width: 220px;" class="btn btn-default btn-file">
                                                    <i class="fa fa-folder-open-o" aria-hidden="true"></i> B&uacute;squeda de Expediente
                                                </div>
                                                <br>
                                                <br>
                                                <div id="listexpediente_mensaje">
                                                </div>
                                            </div>
                                            <div class="form-group col-md-12">
                                                <label>Referenciar Documento :</label>
                                                <br>
                                                <div onclick="agregarReferencias_regdocumento();" style="width: 220px;" class="btn btn-default btn-file">
                                                    <i class="fa fa-paperclip"></i> B&uacute;squeda de Documento
                                                </div>
                                                <br>
                                                <br>
                                                <div id="listreferencia_regDocumento">
                                                </div> 
                                            </div>
                                            <div class="form-group col-md-12">
                                                <p class="help-block">Archivos Adjuntos (Max 2 Mb.)</p>
                                                <div>
                                                    <span class="fileUpload btn btn-default">
                                                        <span class="glyphicon glyphicon-upload"></span> Subir Archivo
                                                        <input type="file" id="uploadFile" />
                                                    </span>
                                                </div>
                                                <br>
                                                <p id="fileUploadError" class="text-danger hide"></p>
                                                <div class="list-group" id="files"></div>
                                                <!--<input id="addupload_regDocumento" onclick="generarUploadImgDoc_regDocumento('#uploadfile_regDocumento')" type="button" value="+">
                                                <div id="uploadfile_regDocumento">
                                                </div>
                                                <p class="help-block">Max. 100 MB por archivo</p>-->
                                            </div>
                                        </div>
                                        <div class="box-footer">
                                            <button id="btnNuevo_regDocumento" type="button" class="btn btn-primary btn-sm">Guardar</button>
                                            <button id="btnCancelar_regDocumento" type="button" class="btn btn-default btn-sm">Cancelar</button>
                                        </div>

                                    </form>
                                </div>
                            </div>
                        </section>

                    </div><!-- /.col (left) -->

                </div><!-- /.row -->


            </section><!-- /.content -->
        </aside><!-- /.right-side -->
    </div><!-- ./wrapper -->

    <%@include file="modals/documento-mensaje/modalExpediente.html" %>
    <%@include file="modals/documento-mensaje/modalDocref.html" %>
    <%@include file="modals/documento-mensaje/modalAreaUsuario.html" %>

    <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-ui-1.10.4.custom.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/i18n/grid.locale-es.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/jquery.jqGrid.min.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/sliptree-bootstrap-tokenfield/bootstrap-tokenfield.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/maskedinput/maskedinput.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/daterangepicker/moment.js"></script>    
    <script src="${pageContext.request.contextPath}/js/plugins/daterangepicker/daterangepicker.js"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/app.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/jquery.tmpl.min.js" type="text/javascript"></script>
    <!--<script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/select2/js/select2.full.js"></script> -->
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/maskedinput/maskedinput.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/TimeSelect/jquery.ptTimeSelect.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script>

    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/documento-mensaje/JSModalExpediente.js" type="text/javascript"></script>

    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/documento-mensaje/JSUploaderDocumento.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/JSDocumentoMensaje.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/menu.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/documento-mensaje/JSModalAreaUsuarioDestinos.js" type="text/javascript"></script>


</body>
</html>
