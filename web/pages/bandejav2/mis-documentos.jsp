<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Mis Documentos | Tramite Interno</title>
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
                    Mis Documentos 
                    <small>Mis Documentos Gerados</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-unlock-alt"></i> Tramite Interno</a></li>

                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                    <div class="col-md-12">

                        <div class="input-group">
                            <div class="input-group-btn">
                                <button type="button" class="btn btn-danger"><i class="fa fa-search" aria-hidden="true"></i></button>
                            </div>
                            <input id="txtbusquedadetallada_documento" type="text" class="form-control" placeholder="Ingrese el Codigo o Asunto del Documento.">
                        </div>
                        <hr>
                        <div class="form-group" id="frombusq_detallada_documento">
                            <div class="row">
                                <div class="col-md-6">
                                    <label>Tipo de Documento</label>
                                    <select class="form-control input-sm" id="drptipodocbusqueda_documento">
                                    </select>
                                </div>
                                <div class="col-md-6" class="col-md-3" style="display: none;">
                                    <label>Area creaci&oacute;n</label>
                                    <select class="form-control input-sm" id="drpareabusqueda_documento">
                                    </select> 
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <label>Rango fecha de creaci&oacute;n</label>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="input-group">
                                                <div class="input-group-addon">
                                                    <i class="fa fa-calendar"></i>
                                                </div>
                                                <input type="text"  class="form-control pull-right input-sm" id="b_fecha_inicio_documento">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="input-group">
                                                <div class="input-group-addon">
                                                    <i class="fa fa-calendar"></i>
                                                </div>
                                                <input type="text" class="form-control pull-right input-sm" id="b_fecha_fin_documento">
                                            </div>
                                        </div>

                                    </div>
                                </div>
                                <div class="col-md-3" style="display: none;">
                                    <div class="input-group">
                                        <label>Usuario creaci&oacute;n</label>
                                        <select id="txtIdusuario_creaciondocumento_documento" class="form-control input-sm">
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-3" style="margin-top: 15px;">
                                    <div class="pull-right">
                                        <button id="btnlimpiarbusqdetallada_documento" type="button" class="btn btn-default"><i class="fa fa-eraser" aria-hidden="true"></i> Limpiar</button>
                                        <button id="btnbusqdetallada_documento" type="submit" class="btn btn-primary"><i class="fa fa-search" aria-hidden="true"></i> Buscar</button>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div id="containergrid" class="form-grouppp" >
                            <table id="gridDocumentoBusqueda_documento"></table>
                            <div id="pagerDocumentoBusqueda_documento"></div>
                        </div>
                    </div>
                </div>

            </section><!-- /.content -->
        </aside><!-- /.right-side -->
    </div><!-- ./wrapper -->



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

    <!-- AdminLTE for demo purposes -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/JSDocumento.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/menu.js" type="text/javascript"></script>


</body>
</html>
