<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Rececion de Documento Interno</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <link href="${pageContext.request.contextPath}/js/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/js/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- Ionicons -->
    <link href="${pageContext.request.contextPath}/js/plugins/ionicons/css/ionicons.min.css" rel="stylesheet" type="text/css" /> <!-- daterange picker -->
    <!-- Theme style -->
    <link rel="stylesheet" media="screen" href="${pageContext.request.contextPath}/js/plugins/jquery/css/redmond/jquery-ui-1.10.4.custom.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/jqgrid/css/ui.jqgrid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/select2/css/select2.min.css">
    <link href="${pageContext.request.contextPath}/css/AdminLTE.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet" type="text/css" />
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
      <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
    <![endif]-->
    <style>
        select{
            color: black;
        }
        select option{
            z-index: 99999;
            color: black;
        }

        select option .ui-datepicker-month{

            z-index: 8888;
        }

    </style>
    <script>
        var urlApp = '${pageContext.request.contextPath}';
    </script>
    <style>
        #btnRecibir{
            float:right;
            margin-top: 0px;
            border-style: solid;
            border-width: 2px;
        }       
    </style>
</head>
<body class="skin-blue">


    <%@include file="../includes/header.html" %>
    <div class="wrapper row-offcanvas row-offcanvas-left">
        <!-- Left side column. contains the logo and sidebar -->


        <!-- Right side column. Contains the navbar and content of the page -->
        <aside class="right-side" style="width: 960px; margin-left: auto;margin-right: auto;"  >
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1>
                    Recepción Documento
                    <small>Administracion de recepcion de documento</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-unlock-alt"></i> Documento</a></li>
                    <li class="active">Recepcion de documento</li>
                </ol>
            </section>
            <section class="content">
                <div class="row">
                    <div class="col-md-12">
                        <div>   
                            <button id="btnRecibir" type="button" class="btn btn-warning "><i class="fa fa-arrow-circle-down"></i> Recibir</button>
                        </div>
                        <ul id="myTabs" class="nav nav-tabs" role="tablist">
                            <li role="presentation" class="active"><a href="#home" id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">Documentos a Recibir</a></li>
                            <li role="presentation"><a href="#profile" role="tab" id="profile-tab" data-toggle="tab" aria-controls="profile">Documentos Recibidos</a></li>

                        </ul>
                        <div id="myTabContent" class="tab-content">
                            <div role="tabpanel" class="tab-pane fade in active" id="home" aria-labelledby="home-tab">
                                <div class="input-group">
                                    <span class="input-group-addon"><i>Codigo Documento</i></span>
                                    <input id="pre_txtbusquedacodigodocumento"  type="text" placeholder="Codigo Documento" class="form-control clearable grilla_recibidos">
                                    <span class="input-group-addon" ><i >Asunto</i></span>
                                    <input id="pre_txtasunto"  type="text" placeholder="Ingrese asunto" class="form-control clearable grilla_recibidos">

                                </div>

                                <div class="input-group">
                                    <span class="input-group-addon"><i >Remitente</i></span>
                                    <input id="pre_remitente"  type="text" placeholder="Remitente" class="form-control clearable grilla_recibidos">
                                    <span class="input-group-addon"><i>Area</i></span>
                                    <input id="pre_area"  type="text" placeholder="Area proveniente" class="form-control clearable grilla_recibidos">
                                </div>
                                <div class="input-group">
                                    <span class="input-group-addon"><i >Fecha Inicio</i></span>
                                    <input id="pre_fechaInicio"  type="text" placeholder="Fecha Inicio" class="form-control clearable grilla_recibidos">
                                    <span class="input-group-addon"><i>Fecha Fin</i></span>
                                    <input id="pre_fechaFin"  type="text" placeholder="Fecha Fin" class="form-control clearable grilla_recibidos">
                                </div>
                                <table id="grid"></table>
                                <div id="pager"></div>
                            </div>
                            <div role="tabpanel" class="tab-pane fade" id="profile" aria-labelledby="profile-tab">
                                <div class="input-group">
                                    <span class="input-group-addon"><i>Codigo Documento</i></span>
                                    <input id="post_txtbusquedacodigodocumento"  type="text" placeholder="Codigo Documento" class="form-control clearable grilla_recibidos">
                                    <span class="input-group-addon" ><i >Asunto</i></span>
                                    <input id="post_txtasunto"  type="text" placeholder="Ingrese asunto" class="form-control clearable grilla_recibidos">

                                </div>

                                <div class="input-group">
                                    <span class="input-group-addon"><i >Remitente</i></span>
                                    <input id="post_remitente"  type="text" placeholder="Remitente" class="form-control clearable grilla_recibidos">
                                    <span class="input-group-addon"><i>Area</i></span>
                                    <input id="post_area"  type="text" placeholder="Area proveniente" class="form-control clearable grilla_recibidos">
                                </div>
                                <div class="input-group">
                                    <span class="input-group-addon"><i >Fecha Inicio</i></span>
                                    <input id="post_fechaInicio"  type="text" placeholder="Fecha Inicio" class="form-control clearable grilla_recibidos">
                                    <span class="input-group-addon"><i>Fecha Fin</i></span>
                                    <input id="post_fechaFin"  type="text" placeholder="Fecha Fin" class="form-control clearable grilla_recibidos">
                                </div>
                                <table id="gridRecibido"></table>
                                <div id="pagerRecibido"></div>
                            </div>

                        </div>
                    </div>
                </div>
            </section><!-- /.content -->





        </aside><!-- /.right-side -->
    </div><!-- ./wrapper -->


    <div class="modal fade" id="mdlResolverExpediente" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><i class="fa fa-envelope-o"></i> Derivar Expediente a otra Area </h4>
                </div>

                <div class="modal-body">
                    <form id="frmderivar" role="form" enctype="multipart/form-data" >

                        <div class="row">
                            <div class="col-md-12">

                                <h3>Expediente seleccionado : <label id="idexpedienteselec" ></label></h3>
                                <div class="form-group">
                                    <label>Área <i style="color:red ">* </i>:</label>
                                    <select obligatorio id="txtIdarea" class="form-control input-sm select2">
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Procedimiento <i style="color:red ">* </i> :</label>
                                    <select obligatorio id="txtIdprocedimiento" class="form-control input-sm select2">
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Sustento <i style="color:red ">* </i>:</label>
                                    <textarea obligatorio id="txaobservacioncambioestado" placeholder="Ingrese alguna Observaci&oacute;n" rows="3" class="form-control"></textarea>
                                </div>
                                <label style="color:red" id="txtmensajealerta">
                                </label>
                            </div>

                        </div>


                    </form>
                </div>
                <div class="modal-footer clearfix">
                    <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cerrar</button>
                    <button id="btncambiarestado" type="button" class="btn btn-primary pull-left"><i class="fa fa-envelope"></i> Derivar</button>

                </div>

            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

    <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-ui-1.10.4.custom.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/i18n/grid.locale-es.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/jquery.jqGrid.min.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/select2/js/select2.full.js"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/app.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/JSRecepcionInterna.js" type="text/javascript"></script>

</body>
</html>
