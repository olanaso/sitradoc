<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Bandeja</title>
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

        .pulse {
            
            display: block;
            width: 10px;
            height: 10px;
            border-radius: 100%;
            cursor: pointer;
            box-shadow: 0 0 0 rgba(204,169,44, 0.4);
            animation: pulse 2s infinite;
        }
        @-webkit-keyframes pulse {
            0% {
                -webkit-box-shadow: 0 0 0 0 rgba(204,169,44, 0.4);
            }
            70% {
                -webkit-box-shadow: 0 0 0 10px rgba(204,169,44, 0);
            }
            100% {
                -webkit-box-shadow: 0 0 0 0 rgba(204,169,44, 0);
            }
        }
        @keyframes pulse {
            0% {
                -moz-box-shadow: 0 0 0 0 rgba(204,169,44, 0.4);
                box-shadow: 0 0 0 0 rgba(204,169,44, 0.4);
            }
            70% {
                -moz-box-shadow: 0 0 0 10px rgba(204,169,44, 0);
                box-shadow: 0 0 0 10px rgba(204,169,44, 0);
            }
            100% {
                -moz-box-shadow: 0 0 0 0 rgba(204,169,44, 0);
                box-shadow: 0 0 0 0 rgba(204,169,44, 0);
            }
        }
    </style>
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
                    Resolucion de Expedientes
                    <small>Resolucion de expedientes provenientes del Tramite Externo</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-unlock-alt"></i> Tramite Externo</a></li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                    <div class="col-md-12">




                        <ul id="myTabs2" class="nav nav-tabs" role="tablist">
                            <li id="expedientes_pendientes" role="presentation" onclick="cargarflujo(this, 1, 9, 'PENDIENTE');" class="active"><a href="#home2" id="home2-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">Pendientes</a></li>
                            <li role="presentation" onclick="cargarflujo(this, 3, 9, 'OBSERVADO');"><a href="#profile4" role="tab" id="profile4-tab" data-toggle="tab" aria-controls="profile">Observados</a></li>
                            <li role="presentation" onclick="cargarflujo(this, 2, 9, 'RESUELTO');"><a href="#profile5" role="tab" id="profile5-tab" data-toggle="tab" aria-controls="profile">Resueltos</a></li>
                            <li role="presentation" onclick="cargarflujo(this, 4, 9, 'DERIVADO');"><a href="#profile6" role="tab" id="profile6-tab" data-toggle="tab" aria-controls="profile">Derivados</a></li>
                        </ul>
                        <div id="myTabContent2" class="tab-content">
                            <div role="tabpanel" class="tab-pane fade in active" id="home2" aria-labelledby="home-tab"></div>
                            <div role="tabpanel" class="tab-pane fade" id="profile4" aria-labelledby="profile-tab"></div>
                            <div role="tabpanel" class="tab-pane fade" id="profile5" aria-labelledby="profile-tab"></div>
                            <div role="tabpanel" class="tab-pane fade" id="profile6" aria-labelledby="profile-tab"></div>
                            <div id="divEstadoExpediente" class="box box-primary">
                                <div id="containerGrilla_tramiteExterno" class="box-body">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i >A&ntilde;o.</i></span>
                                        <input id="pre_txtbusquedaanio_tramite_externo" type="text" placeholder="Ingrese el A&ntilde;o" class="form-control clearable grilla">
                                        <span class="input-group-addon"><i>Codigo Expediente.</i></span>
                                        <input id="pre_txtbusquedacodigoexpediente_tramite_externo" type="text" placeholder="Codigo Expediente" class="form-control clearable grilla">
                                    </div>
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <i class="fa fa-search-plus"></i>
                                        </span>
                                        <input id="pre_txtbusqueda_tramite_externo" type="text" placeholder="Nombres y Apellidos, DNI o Asunto, presione Enter" class="form-control clearable grilla">
                                        <span class="input-group-addon">
                                            <label style="color:#035BC7">* Para realizar una b&uacute;squeda Presione Enter</label>

                                        </span>


                                    </div>
                                    <table id="grid_tramiteExterno"></table>
                                    <div id="pager_tramiteExterno"></div>
                                
                                </div>
                            </div>
                        </div>


                    </div><!-- /.col (left) -->

                </div><!-- /.row -->


            </section><!-- /.content -->
        </aside><!-- /.right-side -->
    </div><!-- ./wrapper -->

    <%@include file="modals/tramite-externo/modalDerivarExpediente.html" %>
    <%@include file="modals/tramite-externo/modalDetalleExpediente.html" %>
    <%@include file="modals/tramite-externo/modalResolverExpediente.html" %>


    <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-ui-1.10.4.custom.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/i18n/grid.locale-es.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/jquery.jqGrid.min.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>

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
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/JSTramiteExterno.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/bandejav2/menu.js" type="text/javascript"></script>


</body>
</html>
