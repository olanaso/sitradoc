<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html >
    <head>
        <meta charset="UTF-8">
        <title>Consulta de Tramite</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <link href="${pageContext.request.contextPath}/js/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/js/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <!-- Ionicons -->
        <link href="${pageContext.request.contextPath}/js/plugins/ionicons/css/ionicons.min.css" rel="stylesheet" type="text/css" /> <!-- daterange picker -->
        <!-- Theme style -->
        <link rel="stylesheet" media="screen" href="${pageContext.request.contextPath}/js/plugins/jquery/css/redmond/jquery-ui-1.10.4.custom.css">

        <link href="${pageContext.request.contextPath}/pages/tramiteonline/styletramOnline.css" rel="stylesheet" type="text/css" />
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
          <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
        <![endif]-->
        <style>

            .center-block {
                display: block;
                margin-left: auto;
                margin-right: auto;
            }
            .error{
                background-color: #FFD5D5; 
            }
            label{
                font-size: 11px;
                font-weight: normal;
                color: #2F0E4D;
            }
        </style>




        <script>
            var urlApp = '${pageContext.request.contextPath}';
        </script>
    </head>
    <body class="skin-blue" style="background: #FFF;">



        <header style="background: #0088CA;">
            <div class="container" style="width: 960px; margin-top: 0px;">
                <div class="relative">
                    <section class="content" >
                        <img style=" float:left;" src="../../img/logogestion.png"/>

                        <h3 style="color: #FFF; float:left;margin-top: 30px;">
                            &nbsp;&nbsp;&nbsp;ESTADISTICAS SISTDOC&nbsp;&nbsp;&nbsp;
                        </h3>

                        <img style=" float:right;" src="../../img/logomuni.png"/>

                        <h5 style="color: #fff; float:right;margin-top: 30px;">
                            Municipalidad Pronvicial de Huamanga
                        </h5>
                    </section>

                </div>
            </div>
            <div class="barrita"><hr ></div>
        </header>
        <!-- Left side column. contains the logo and sidebar -->

        <ul class="nav nav-tabs" id="myTab">
            <li class="active"><a data-target="#home" data-toggle="tab">Reportes</a></li>
            <li><a data-target="#profile" data-toggle="tab">Estadisticas </a></li>

        </ul>

        <div class="tab-content">
            <div class="tab-pane active" id="home">


            </div>
            <div class="tab-pane" id="profile">
                <!-- Right side column. Contains the navbar and content of the page -->
                <aside class="right-side" style="width: 960px;  margin:0 auto;">
                    <!-- Content Header (Page header) -->
                    <section class="content-header">


                    </section>

                    <!-- Main content -->
                    <section class="content">
                        <div class="row">

                            <div class="col-md-12 fondo">

                                <div class="box box-primary">
                                    <div class="box-header">
                                        <h5 class="box-title" style="font-weight: bold;">Datos de b&uacute;squeda</h5>
                                    </div>
                                    <div class="barrita"><hr class="celeste"></div>
                                    <form id="formexpediente" role="form" enctype="multipart/form-data">
                                        <div class="box-body">
                                            <!-- Date range -->
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="form-group">
                                                        <label>Año :</label>
                                                        <input solonumeros obligatorio id="txtIanio" class="form-control input-sm" type="text" placeholder="Ingrese el año registro el tr&aacute;mite">
                                                    </div>
                                                </div>
                                                <div class="col-md-4">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label>Operaci&oacute;n  :</label>

                                                                <button onclick="getCaptcha();" type="button" class="btn btn-primary btn-sm"><i class="fa fa-refresh"></i></button>
                                                                <img id="imgcatpcha" />
                                                            </div> 
                                                        </div>


                                                        <div class="col-md-5">
                                                            <div class="form-group">
                                                                <label>Ingrese la suma :</label>
                                                                <input obligatorio id="txt" class="form-control input-sm" placeholder="Resultado Catpcha" type="text">
                                                            </div>  
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="col-md-4">
                                                    <br>
                                                    <label>Generar Grafico :</label>
                                                    <button id="btnNuevo" type="button" class="btn btn-primary btn-sm">Generar</button>
                                                    <button id="btnCancelar" type="button" class="btn btn-default btn-sm">Limpiar</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="barrita"><hr class="celeste" ></div>

                                        <div id="estadistica" style="min-width: 310px; height: 400px; margin: 0 auto"></div>

                                    </form>
                                </div><!-- /.box -->
                            </div><!-- /.col (right) -->
                        </div><!-- /.row -->


                    </section><!-- /.content -->
                </aside><!-- /.right-side -->

            </div>

        </div>





        <footer>
            <hr>
            <div  style="width: 960px; margin-top: 10px;">
                <p>&copy; CopyRigth Gestion 2015 - 2018 | Municipalidad Provincial de Huamanga | Dr. Hugo Aedo Mendoza.</p>
            </div>  
        </footer>

        <!-- Large modal -->
        <!-- Button trigger modal -->



        <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-ui-1.10.4.custom.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/i18n/grid.locale-es.js"></script>

        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>

        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>

        <!-- AdminLTE App -->

        <script src="${pageContext.request.contextPath}/js/plugins/Highcharts-4.0.1/js/highcharts.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/Highcharts-4.0.1/js/highcharts-3d.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/Highcharts-4.0.1/js/modules/exporting.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/Highcharts-4.0.1/js/highcharts.js" type="text/javascript"></script>

        <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
        <!-- AdminLTE for demo purposes -->

        <script src="${pageContext.request.contextPath}/js/tramite/JSEstadisticas.js" type="text/javascript"></script>



    </body>
</html>
