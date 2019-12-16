<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html >
    <meta charset="UTF-8">
    <title>Registro Expediente Online</title>
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
                        &nbsp;&nbsp;&nbsp;MESA DE PARTES EN LINEA&nbsp;&nbsp;&nbsp;
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
                            <h5 class="box-title" style="font-weight: bold;">REGISTRO DE EXPEDIENTE</h5>
                        </div>
                        <div class="barrita"><hr class="celeste"></div>
                        <form id="formexpediente" role="form" enctype="multipart/form-data">
                            <div class="box-body">
                                <!-- Date range -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Procedimiento :</label>
                                            <input obligatorio id="txtIdprocedimiento" class="form-control input-sm" type="text" placeholder="Ingrese el procedimiento que desea solicitar">

                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Area :</label>

                                            <input disabled="disabled" obligatorio id="txtIdarea" class="form-control input-sm" type="text" placeholder="Ingrese el procedimiento que desea solicitar">

                                        </div>
                                    </div>

                                </div>
                                <div class="row">

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>DNI/RUC :</label>
                                            <input solonumeros obligatorio id="txtDni_ruc" class="form-control input-sm" type="text" placeholder="Ingrese Dni o Ruc" maxlength="12">
                                        </div> 
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Nombre/RazónSocial :</label>
                                            <input UpperCases obligatorio id="txtNombre_razonsocial" class="form-control input-sm" type="text" placeholder="Ingrese Nombre o RazonSocial">
                                        </div>  
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Apellidos :</label>
                                            <input UpperCases obligatorio id="txtApellidos" class="form-control input-sm" type="text" placeholder="Ingrese Apellidos">
                                        </div> 
                                    </div> 

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Dirección :</label>
                                            <input  UpperCases obligatorio id="txtDireccion" class="form-control input-sm" type="text" placeholder="Ingrese Dirección">
                                        </div>   
                                    </div>

                                </div> 
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Teléfono :</label>
                                            <input obligatorio id="txtTelefono" class="form-control input-sm" type="text" placeholder="Ingrese Teléfono">
                                        </div>   
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Correo :</label>
                                            <input obligatorio id="txtCorreo" class="form-control input-sm" placeholder="Ingrese Correo" type="text">
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                            <label>Asunto :</label>
                                            <input UpperCases obligatorio id="txtAsunto" class="form-control input-sm" type="text" placeholder="Ingrese Asunto">
                                        </div>  
                                    </div>


                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Codigo del comprobante de pago:</label>
                                            <input UpperCases obligatorio id="txtAsunto" class="form-control input-sm" type="text" placeholder="Ingrese codigo de comprobante de pago">
                                        </div>  
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Imagen del comprobante de Pago :</label>
                                            <input  obligatorio id="txtrecibo" class="" type="file" >
                                        </div>  
                                    </div>
                                </div>
                            </div>
                        </form>
                        <div class="box-header">
                            <h5 class="box-title" style="font-weight: bold;">LISTA DE REQUISITOS</h5>
                        </div>
                        <div class="barrita"><hr class="celeste" ></div>
                        <form id="formrequisitos" role="form" enctype="multipart/form-data">
                            <div data-example-id="hoverable-table" class="bs-example">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Nº</th>
                                            <th>Requisito</th>

                                            <th>Adjunto</th>
                                        </tr>
                                    </thead>
                                    <tbody id="listrequisitos">

                                    </tbody>
                                </table>
                            </div>
                        </form>
                        <div class="barrita"><hr class="celeste" ></div>
                        <div class="box-header">
                            <input type="checkbox" name="vehicle" value="Car" checked style="float:left;"> <h3> &nbsp; Acepto los <a href="#" data-toggle="modal" data-target=".bs-example-modal-lg">Terminos y Condiciones</a></h3>
                        </div>

                        <div class="barrita"><hr class="celeste" ></div>

                        <!-- /.box-body -->
                        <div class="box-footer"> 
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Operacion  :</label>
                                        <img id="imgcatpcha" />
                                        <button id="btnNuevo" onclick="getCaptcha();" type="button" class="btn btn-primary btn-sm"><i class="fa fa-refresh"></i></button>
                                    </div>  
                                </div>


                                <div class="col-md-3">
                                    <div class="form-group">
                                        <label>Ingrese la suma :</label>
                                        <input obligatorio id="txt" class="form-control input-sm" placeholder="Resultado Catpcha" type="text">
                                    </div>  
                                </div>
                            </div>

                            <div class="barrita"><hr class="celeste" ></div>

                            <button id="btnNuevo" type="button" class="btn btn-primary btn-sm">Enviar</button>
                            <button id="btnCancelar" type="button" class="btn btn-default btn-sm">Limpiar</button>
                        </div>
                    </div><!-- /.box -->



                    </form>

                </div><!-- /.col (right) -->
            </div><!-- /.row -->


        </section><!-- /.content -->
    </aside><!-- /.right-side -->

    <footer>
        <hr>
        <div class="container" style="width: 960px; margin-top: 10px;">
            <p>&copy; CopyRigth Gestion 2015 - 2018 | Municipalidad Provincial de Huamanga | Dr. Hugo Aedo Mendoza.</p>
        </div>
    </footer>

    <!-- Large modal -->

    <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="embed-responsive embed-responsive-16by9">


                    <!-- Main content -->
                    <section class="content">
                        <div class="row">

                            <div id="form2" class="col-md-12">

                                <div class="box box-primary">

                                    <div class="box-body">
                                        <!-- Date range -->

                                        <div class="row">
                                            <div class="col-md-12">
                                                TÉRMINOS Y CONDICIONES DE USO DEL “SISTEMA DE TRÁMITES Y PAGOS EN LÍNEA DEL COPNIA”
                                                Este documento describe los términos y condiciones generales de uso aplicables al SISTEMA DE TRÁMITES Y PAGOS EN LÍNEA DEL COPNIA, que incluye la expedición en línea de Certificados de Vigencia y Antecedentes Disciplinarios con firma digital, y el servicio de recaudo y pago por medios electrónicos de los trámites que legalmente se hacen en el Consejo Profesional Nacional de Ingeniería - COPNIA.
                                                TÉRMINOS Y CONDICIONES DE USO DEL SISTEMA DE TRÁMITES Y PAGOS EN LÍNEA DEL COPNIA
                                                CUALQUIER PERSONA QUE NO ACEPTE ESTOS TÉRMINOS Y CONDICIONES GENERALES, QUE TIENEN UN CARÁCTER OBLIGATORIO Y VINCULANTE, DEBERÁ ABSTENERSE DE UTILIZAR EL SISTEMA DE TRÁMITES Y PAGOS EN LÍNEA DEL COPNIA.
                                                El usuario debe leer y aceptar todas las condiciones establecidas en éste documento, junto con todas las demás Políticas y Principios que rigen al COPNIA, previo a realizar el trámite a través del SISTEMA DE TRÁMITES Y PAGOS EN LÍNEA DEL COPNIA.

                                            </div>

                                        </div> 




                                    </div><!-- /.box-body -->

                                </div><!-- /.box -->





                            </div><!-- /.col (right) -->

                        </div><!-- /.row -->


                    </section><!-- /.content -->

                </div>
            </div>
        </div>
    </div>




    <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-ui-1.10.4.custom.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/i18n/grid.locale-es.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/jquery.jqGrid.min.js"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>

    <!-- AdminLTE App -->

    <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>

    <!-- AdminLTE for demo purposes -->


    <script src="${pageContext.request.contextPath}/js/tramite/JSExpedienteOnline.js" type="text/javascript"></script>

</body>
</html>
