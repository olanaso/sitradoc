<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html style="width:800px;">
    <meta charset="UTF-8">
    <title>Reporte de Expediente</title>
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

    <script>
        var urlApp = '${pageContext.request.contextPath}';
    </script>
</head>
<body class="skin-blue" >

   
    <div class="wrapper row-offcanvas row-offcanvas-left">
        <!-- Left side column. contains the logo and sidebar -->
    

        <!-- Right side column. Contains the navbar and content of the page -->
        <aside class="right-side">
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1>
                    Registro de Expediente
                    <small>Administracion de Expedientes</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-unlock-alt"></i> Expediente</a></li>
                    <li class="active">Registro de Expediente</li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                  
                    <div class="col-md-6">
                        <form id="form" role="form">
                            <div class="box box-primary">
                                <div class="box-header">
                                    <h3 class="box-title">Reporte:</h3>

                                   
                                </div>
                                <div class="box-body">
                                    <!-- Date range -->

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Fecha Inicio :</label>
                                                <input obligatorio id="txtFechaInicio" type="text" class="form-control"  placeholder="dd/mm/aaaa">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Fecha Fin:</label>
                                                <input obligatorio id="txtFechaFin" type="text" class="form-control "  placeholder="dd/mm/aaaa">
                                            </div>
                                        </div>
                                    </div> 
                                      <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Hora Inicio :</label>
                                                <input obligatorio id="txtHoraInicio" type="text" class="form-control"  placeholder="hh:mm">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Hora Fin:</label>
                                                <input obligatorio id="txtHoraFin" type="text" class="form-control "  placeholder="hh:mm">
                                            </div>
                                        </div>
                                    </div> 
                                    <div class="row" style="height: 10px"></div>

                                    <div class="row">
                                        <div class="col-md-12">
                                            <div class="form-group">
                                                <label>Usuario :</label>

                                                <select obligatorio id="txtUsuario" class="js-example-basic-single" >
                                                </select>
                                            </div>
                                        </div>

                                    </div> 

                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="btnNuevo" type="button" class="btn btn-primary btn-sm" onclick="gerenerarReporte()">Mostrar</button>
                                  
                                </div>
                            </div><!-- /.box -->



                        </form>

                    </div><!-- /.col (right) -->
                      <div class="col-md-6">

                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">Lista de expedientes</h3>
                            </div>
                            <div id="containerGrilla" class="box-body">

                                 <div class="embed-responsive embed-responsive-4by3">
                                        <iframe width="640" height="500" class="embed-responsive-item" id="reportview" src=""></iframe>
                                    </div>

                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                    </div><!-- /.col (left) -->
                </div><!-- /.row -->


            </section><!-- /.content -->
        </aside><!-- /.right-side -->
    </div><!-- ./wrapper -->

    <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-ui-1.10.4.custom.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/i18n/grid.locale-es.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/jquery.jqGrid.min.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/maskedinput/maskedinput.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/select2/js/select2.full.js"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/app.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
      <script src="${pageContext.request.contextPath}/js/tramite/reporte/JSReporte.js" type="text/javascript"></script>

</body>
</html>
