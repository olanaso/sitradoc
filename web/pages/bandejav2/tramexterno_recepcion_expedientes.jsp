<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Recepcion de Expediente de Mesa de Partes</title>
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
                    Recepcion de Expediente
                    <small>Recepcion de expedientes provenientes del Tramite Externo</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-unlock-alt"></i> Tramite Externo</a></li>

                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="bs-example bs-example-tabs" data-example-id="togglable-tabs">
                    <ul class="nav nav-tabs" id="myTabs" role="tablist">
                        <li role="presentation" class="active"><a href="#home" id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">
                                <i class="fa fa-arrow-down" aria-hidden="true"></i> Recepción de Expedientes - <label id="cantporrecibir" style="color: #005888;"></label>
                            </a>
                        </li>
                        <li role="presentation" class=""><a href="#profile" role="tab" id="profile-tab" data-toggle="tab" aria-controls="profile" aria-expanded="false">
                                <i class="fa fa-arrow-right" aria-hidden="true"></i> Expedientes Recepcionados - <label id="cantporrecibidos" style="color: #005888;"></label>
                            </a>
                        </li>

                    </ul>
                    <div class="tab-content" id="myTabContent">
                        <div class="tab-pane fade active in" role="tabpanel" id="home" aria-labelledby="home-tab">
                            <div class="row">

                                <div class="col-md-9">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i >Año.</i></span>
                                        <input id="pre_txtbusquedaanio_recepcionExterna"  type="text" placeholder="Ingrese el Año" class="form-control clearable grilla_recibidos_recepcionExterna">
                                        <span class="input-group-addon"><i>Codigo Expediente.</i></span>
                                        <input id="pre_txtbusquedacodigoexpediente_recepcionExterna"  type="text" placeholder="Codigo Expediente" class="form-control clearable grilla_recibidos_recepcionExterna">
                                    </div>
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-search-plus"></i></span>
                                        <input id="pre_txtbusqueda_recepcionExterna"  type="text" placeholder="Nombres y Apellidos, DNI o Asunto, presione Enter" class="form-control clearable grilla_recibidos_recepcionExterna">

                                        <span class="input-group-addon" style="background-color: #89E6C4">
                                            <input id="showfechamanual" type="checkbox"/> Fecha de registro manual</span>
                                            <input   id="txtfecha_manual" style="background: #B6D0FC;display: none;"  type="text" placeholder="Ingrese Fecha" class="form-control clearable grilla_recibidos_recepcionExterna">
                                            <input   id="txthora_manual" style="background: #B6D0FC;display: none;"  type="text" placeholder="Ingrese Hora" class="form-control clearable grilla_recibidos_recepcionExterna">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div id="divbtn_recepinterna" style="padding-top: 5px;">

                                        <button id="btnRecibir_recepcionExterna" type="button" class="btn btn-warning btn-lg btn-block">
                                            <i class="fa fa-arrow-circle-down"></i> Recibir  
                                        </button>
                                    </div>
                                </div>

                            </div>
                            <table id="grid_recepcion_externa"></table>
                            <div id="pager_recepcion_externa"></div>
                        </div>
                        <div class="tab-pane fade" role="tabpanel" id="profile" aria-labelledby="profile-tab">
                            <div class="input-group">
                                <span class="input-group-addon"><i >Año</i></span>
                                <input id="post_txtbusquedaanio_recepcionExterna" type="text" placeholder="Ingrese el Año" class="form-control clearable grilla_recepcionados_recepcionExterna">
                                <span class="input-group-addon"><i>Codigo Expediente</i></span>
                                <input id="post_txtbusquedacodigoexpediente_recepcionExterna" type="text" placeholder="Codigo Expediente" class="form-control clearable grilla_recepcionados_recepcionExterna">
                            </div>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-search-plus"></i></span>
                                <input id="post_txtbusqueda_recepcionExterna" type="text" placeholder="Nombres y Apellidos, DNI o Asunto, presione Enter" class="form-control clearable grilla_recepcionados_recepcionExterna">
                            </div>
                            <table id="gridRecibido_recepcionExterna"></table>
                            <div id="pagerRecibido_recepcionExterna"></div>
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
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/TimeSelect/jquery.ptTimeSelect.js"></script>
    <!-- AdminLTE for demo purposes -->
   
    <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/JSRecepcionExterna.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/menu.js" type="text/javascript"></script>


</body>
</html>
