<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Bandeja Tramite Interno</title>
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

    <script>
        var urlApp = '${pageContext.request.contextPath}';
    </script>

    <style>

        .applyBtn{

            color: #fff !important;
        }
        .applyBtn:hover{

            background:#0088CC !important;
        }
    </style>

</head>
<body class="skin-blue">


    <%@include file="../includes/header.html" %>
    <div class="wrapper row-offcanvas row-offcanvas-left">
        <!-- Left side column. contains the logo and sidebar -->
        <!-- Right side column. Contains the navbar and content of the page -->
        <aside class="">
            <!-- Content Header (Page header) -->
            <!-- Main content -->
            <section class="content">
                <!-- MAILBOX BEGIN -->
                <div class="row">
                    <div class="col-xs-12">
                        <div class="">
                            <div class="">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="box box-solid">
                                            <a href="#" class="btn btn-primary btn-block margin-bottom overlay_open_mensaje" >Crear Mensaje</a>
                                        </div>

                                        <div class="box box-solid">
                                            <div class="box-header with-border">
                                                <h3 class="box-title">Carpetas</h3>
                                                <div class="box-tools">
                                                </div>
                                            </div>
                                            <div class="box-body no-padding">
                                                <ul class="nav nav-pills nav-stacked" id="listestados_bandeja">
                                                    <li class="active" onclick="showbandejaentrada()"><a href="#"><i class="fa fa-inbox"></i> Entrada <span id="cantnoleidos"  class="label label-primary pull-right">0</span></a></li>
                                                    <li><a href="#" onclick="showbandejasalida()"><i class="fa fa-envelope-o"></i> Salida </a></li>
                                                </ul>
                                            </div>

                                        </div>

                                    </div>
                                    <div class="col-md-9 col-sm-8">
                                        <div class="box box-primary">
                                            <div class="box-header" >
                                                <h3 class="box-title" id="txtestadoflujo" >BANDEJA </h3>


                                                <button onclick="showsiderbar();" type="button" class="btn btn-default" data-toggle="tooltip" data-placement="top" title="Configuraci&oacute;n de la bandeja de entrada" style="float: left;margin-right: 10px;margin-top: 10px;">
                                                    <i class="fa fa-gears"></i> Mas Opciones de Tramite
                                                </button>


                                            </div>

                                            <div id="containerGrillabandeja" class="box-body">

                                                <div class="input-group">


                                                    <div class="input-group" id="adv-search">
                                                        <input type="text" class="form-control" placeholder="Buscar Mensajes" />
                                                        <div class="input-group-btn">
                                                            <div class="btn-group" role="group">
                                                                <div class="dropdown dropdown-lg">
                                                                    <button id="btn_show_search" type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><span class="caret"></span></button>
                                                                    <div class="dropdown-menu dropdown-menu-right" role="menu">
                                                                        <form class="form-horizontal" role="form" id="form_search">
                                                                            <div class="form-group">
                                                                                <label for="filter">Buscar en:</label>
                                                                                <select  id="optionsearch" class="form-control input-sm">

                                                                                    <option value="3">Entrada</option>
                                                                                    <option value="4">Salida</option>
                                                                                </select>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label for="filter">Area:</label>
                                                                                <input id="txtareabusqueda_correo" class="form-control input-sm" type="text" placeholder="Ingrese las areas de busqueda">
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label for="filter">Usuario:</label>
                                                                                <input id="txtusuariobusqueda_correo" class="form-control input-sm" type="text" placeholder="Ingrese los usuario">
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label for="contain">Asunto:</label>
                                                                                <input id="txtAsunto_busq" class="form-control input-sm" type="text" placeholder="Ingrese asunto">
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label for="contain">Contiene Palabras:</label>
                                                                                <input id="txtMensaje_busq" class="form-control input-sm" type="text" placeholder="Ingrese palabras que contiene el contenido">
                                                                            </div>

                                                                            <div class="row">
                                                                                <div class="col-md-6">
                                                                                    <div class="form-group">
                                                                                        <label for="contain">Recepcion:</label>
                                                                                        <div class="btn-group" role="group" aria-label="Default button group">
                                                                                            <label class="radio-inline">
                                                                                                <input type="checkbox" name="opt_recepcion_busqueda" value="true" checked > Si
                                                                                            </label>
                                                                                            <label class="radio-inline">
                                                                                                <input type="checkbox" name="opt_recepcion_busqueda" value="false" checked> No
                                                                                            </label>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="form-group">
                                                                                        <label for="contain">Respuesta:</label>
                                                                                        <div class="btn-group" role="group" aria-label="Default button group">
                                                                                            <label class="radio-inline">
                                                                                                <input  name="opt_respuesta_busqueda" value="true" type="checkbox" checked> Si
                                                                                            </label>
                                                                                            <label class="radio-inline">
                                                                                                <input name="opt_respuesta_busqueda" value="false" type="checkbox" checked> No
                                                                                            </label>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>

                                                                            <div class="row">

                                                                                <div class="col-md-6">
                                                                                    <div class="form-group">
                                                                                        <label for="contain">Prioridad:</label>
                                                                                        <div class="btn-group" role="group" aria-label="Default button group">
                                                                                            <label class="radio-inline">
                                                                                                <input name="opt_prioridad_busqueda" value="1" type="checkbox" checked> Alta
                                                                                            </label>
                                                                                            <label class="radio-inline">
                                                                                                <input name="opt_prioridad_busqueda" value="2" type="checkbox" checked> Media
                                                                                            </label>
                                                                                            <label class="radio-inline">
                                                                                                <input name="opt_prioridad_busqueda" value="3" type="checkbox" checked> Baja
                                                                                            </label>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-12">
                                                                                    <div class="form-group">
                                                                                        <label for="contain">Estado Atencion:</label>
                                                                                        <div class="btn-group" role="group" aria-label="Default button group">
                                                                                            <label class="radio-inline">
                                                                                                <input  id="estado_vigente" name="opt_estado_atencion_busqueda" value="true" type="checkbox" checked> Vigentes 
                                                                                            </label>
                                                                                            <label class="radio-inline">
                                                                                                <input id="estado_vencido" name="opt_estado_atencion_busqueda" value="false" type="checkbox" checked> Vencidos
                                                                                            </label>

                                                                                        </div>
                                                                                    </div> 
                                                                                </div>
                                                                            </div>

                                                                            <div class="row">

                                                                                <div class="col-md-12">
                                                                                    <label for="contain">Rango Fecha:</label>
                                                                                    <input type="text" id="fecha_rango_busqueda" class="form-control">

                                                                                </div>
                                                                            </div>

                                                                            <hr>
                                                                            <div class="btn-group" role="group" aria-label="Default button group">
                                                                                <button id="btnsearch_avanzado" type="button" class="btn btn-primary">
                                                                                    <span class="glyphicon glyphicon-search" aria-hidden="true"></span> Buscar
                                                                                </button>
                                                                            </div>




                                                                        </form>
                                                                    </div>
                                                                </div>
                                                                <button type="button" class="btn btn-primary"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></button>
                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>

                                                <h1 class="page-header" id="glyphicons"></h1>
                                                <table id="gridbandeja"></table>
                                                <div id="pagerbandeja"></div>

                                            </div><!-- /.box-body -->


                                        </div><!-- /.box -->
                                    </div><!-- /.col (RIGHT) -->
                                </div><!-- /.row -->
                            </div><!-- /.box-body -->
                            <div class="box-footer clearfix">
                                <div class="pull-right">

                                </div>
                            </div><!-- box-footer -->
                        </div><!-- /.box -->
                    </div><!-- /.col (MAIN) -->
                </div>
                <!-- MAILBOX END -->

            </section><!-- /.content -->
        </aside><!-- /.right-side -->
    </div><!-- ./wrapper -->
    <!-- modals -->
    <%@include file="TramiteInterno/modals/modalDocref.html" %>
    <%@include file="TramiteInterno/modals/modalExpediente.html" %>
    <!-- Overlays -->
    <%@include file="TramiteInterno/overlays/overlayMensaje.html" %>
    <%@include file="TramiteInterno/overlays/overlayMail.html" %>
    <%@include file="TramiteInterno/overlays/overlayViewsRecepcionExterna.html" %>
    <%@include file="TramiteInterno/overlays/overlayViewsRecepcionInterna.html" %>
    <%@include file="TramiteInterno/overlays/overlayViewsTramiteExterno.html" %>
    <%@include file="TramiteInterno/overlays/overlayViewsDocumento.html" %>

    <!-- siderbas -->
    <%@include file="TramiteInterno/siderbars/siderbarTramiteInterno.html" %>

    <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-ui-1.10.4.custom.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/i18n/grid.locale-es.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/jquery.jqGrid.min.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/sliptree-bootstrap-tokenfield/bootstrap-tokenfield.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/daterangepicker/moment.js"></script>    
    <script src="${pageContext.request.contextPath}/js/plugins/daterangepicker/daterangepicker.js"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/app.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
    <!--<script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/select2/js/select2.full.js"></script> -->
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/maskedinput/maskedinput.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSBandeja.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSBusquedaBandeja.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSModalExpediente.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSModalDocumentoRef.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSRecepcionExterna.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSTramiteExterno.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSRecepcionInterna.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSDocumento.js" type="text/javascript"></script>

</body>
</html>
