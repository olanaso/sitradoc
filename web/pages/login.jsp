<%-- 
    Document   : login
    Created on : Dec 3, 2014, 5:43:42 PM
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="bg-black">
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <link href="${pageContext.request.contextPath}/js/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/js/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <!-- Theme style -->
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
        <style>
         .modalservidor{
                color: black;
            }
            .bootbox-body{
                color: black;
            }
            
            
        </style>
    </head>
    <body class="bg-black">

        <div class="form-box" id="login-box">
            <div class="header"  style="background: #0088CA; font-size: 14px;height: 100px;">  
                <img style=" float:left;" src="${pageContext.request.contextPath}/img/logogestion.png"/> 
                Tramite Documentario -  MPH
                <img style=" float:right;" src="${pageContext.request.contextPath}/img/logomuni.png"/>
            </div>
            <form  >
                <div id="form" class="body bg-gray">
                    <div class="form-group">
                        <input obligatorio id="txtusuario" type="text" name="userid" class="form-control" placeholder="Usuario"/>
                    </div>
                    <div class="form-group">
                        <input obligatorio id="txtpassword" type="password" name="password" class="form-control" placeholder="Contraseña"/>
                    </div>          

                </div>
                <div class="footer">                                                               
                    <button  id="btnLogin" type="button" class="btn bg-light-blue btn-block">Entrar</button>  


                    <p id="msg" style="color: red"></p>

                </div>
            </form>

            <div class="margin text-center">
                <!--  <span>Entrar usando redes sociales</span>
                <br/>
                <button class="btn bg-light-blue btn-circle"><i class="fa fa-facebook"></i></button>
                <button class="btn bg-aqua btn-circle"><i class="fa fa-twitter"></i></button>
                <button class="btn bg-red btn-circle"><i class="fa fa-google-plus"></i></button>

            </div>-->
            </div>
        </div>

        <div class="modal fade" id="ModalCofig" tabindex="-1" role="dialog" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modalservidor">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Configuracion de Servidor</h4>
                    </div>
                    <div id="formConfig" class="modal-body">
                        <form id="contact-form">
                            <fieldset>
                                <div class="form-group">
                                    <label >Ip servidor:</label>
                                    <input id="txtIpServidor" type="text" class="geneUrl form-control input-sm"  value="localhost" obligatorio>
                                </div>
                                <div class="form-group">
                                    <label >Puerto servidor:</label>
                                    <input id="txtPuertoServidor" type="text" class="geneUrl form-control input-sm"  value="5432" obligatorio>
                                </div>

                                <div class="form-group">
                                    <label >Nombre servidor:</label>
                                    <input id="txtNombreServidor" type="text" class="form-control input-sm"  obligatorio>
                                </div>
                                <div class="form-group">
                                    <label >Base de datos:</label>
                                    <input id="txtBaseDatos" type="text" class="geneUrl form-control input-sm"  obligatorio>
                                </div>
                                <div class="form-group">
                                    <label >Driver:</label>
                                    <input id="txtDriver" type="text" class="form-control input-sm"  value="org.postgresql.Driver" obligatorio>
                                </div>
                                <div class="form-group">
                                    <label >URL:</label>
                                    <input id="txtUrl" type="text" class="form-control input-sm"  value="jdbc:postgresql://localhost:5432/" obligatorio>
                                </div>
                                <div class="form-group">
                                    <label >Usuario base de datos:</label>
                                    <input id="txtUsuariobd" type="text" class="form-control input-sm"  obligatorio>
                                </div>
                                <div class="form-group">
                                    <label >Contraseña:</label>
                                    <input id="txtContrasenia" type="password" class="form-control input-sm"  obligatorio>
                                </div>

                            </fieldset>
                        </form>
                    </div>
                    <div class="modal-footer ">
                        <button  id="btnGuardarConfig" type="button" class="btn btn-primary  btn-default btn-sm" style="color:#000">Guardar</button>
                        <button  id="btntestconeccion" type="button" class="btn btn-default pull-right btn-default btn-sm" style="color:#000">Test Coneccion BD</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->

        <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>

        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
        <!-- AdminLTE App -->
        <script src="${pageContext.request.contextPath}/js/AdminLTE/app.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/JSLogin.js" type="text/javascript"></script>


    </body>
</html>