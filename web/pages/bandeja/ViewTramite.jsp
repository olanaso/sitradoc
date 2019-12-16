<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Bandeja Tramite Externo</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <link href="${pageContext.request.contextPath}/js/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/js/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- Ionicons -->
    <link href="${pageContext.request.contextPath}/js/plugins/ionicons/css/ionicons.min.css" rel="stylesheet" type="text/css" /> <!-- daterange picker -->
    <!-- Theme style -->
    <link rel="stylesheet" media="screen" href="${pageContext.request.contextPath}/js/plugins/jquery/css/redmond/jquery-ui-1.10.4.custom.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/jqgrid/css/ui.jqgrid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/sliptree-bootstrap-tokenfield/css/bootstrap-tokenfield.css">
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
    <style>
        .form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control {
            background-color: #DFEBF1 !important;
            cursor: not-allowed;
            opacity: 1;
        }
        .input-group{
            margin-top: 2px !important;
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
                                    <div class="col-md-3 col-sm-4">
                                        <!-- BOXES are complex enough to move the .box-header around.
                                             This is an example of having the box header within the box body -->

                                        <!-- Navigation - folders-->
                                        <div style="margin-top: 15px;">
                                            <ul class="nav nav-pills nav-stacked">
                                                <li class="header" style="font-size: 25px;">Carpetas</li>
                                            </ul>
                                            <ul  id="listestados" class="nav nav-pills nav-stacked">
                                                <li class="active"><a href="#"> Pendientes (14)</a></li>
                                                <li><a href="#"> Atendidos</a></li>
                                                <li><a href="#"> Observados</a></li>
                                            </ul>
                                        </div>
                                    </div><!-- /.col (LEFT) -->
                                    <div class="col-md-9 col-sm-8">
                                        <div class="box box-primary">
                                            <div class="box-header">
                                                <h3 class="box-title" id="txtestadoflujo">PENDIENTES</h3>
                                            </div>

                                            <div id="containerGrilla" class="box-body">
                                                <div class="input-group">
                                                    <span class="input-group-addon"><i >Año.</i></span>
                                                    <input id="pre_txtbusquedaanio" type="text" placeholder="Ingrese el Año" class="form-control clearable grilla">
                                                    <span class="input-group-addon"><i>Codigo Expediente.</i></span>
                                                    <input id="pre_txtbusquedacodigoexpediente" type="text" placeholder="Codigo Expediente" class="form-control clearable grilla">

                                                </div>

                                                <div class="input-group">
                                                    <span class="input-group-addon"><i class="fa fa-search-plus"></i></span>
                                                    <input id="pre_txtbusqueda" type="text" placeholder="Nombres y Apellidos, DNI o Asunto, presione Enter" class="form-control clearable grilla">
                                                    <!--<span class="input-group-addon">Cantidad</span>
                                                    <input id="post_cantidad" type="text" placeholder="Cantidad a mostrar" class="form-control clearable grilla_recepcionados">
                                                    -->
                                                    <span class="input-group-addon"><label style="color:#035BC7">* Para realizar una b&uacute;squeda Presione Enter</label></span>

                                                </div>
                                                <table id="grid"></table>
                                                <div id="pager"></div>

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


    <!-- COMPOSE MESSAGE MODAL -->
    <div class="modal fade" id="myModal2" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><i class="fa fa-envelope-o"></i> Derivar Expediente </h4>
                </div>

                <div class="modal-body">
                    <form id="frmderivar" role="form" enctype="multipart/form-data" >

                        <div class="form-group">
                            <div class="input-group">
                                <span class="input-group-addon">TIPO DE DOCUMENTO:</span>
                                <select obligatorio id="drptipodocumento" class="form-control input-sm">
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <span class="input-group-addon">AREA:</span>
                                <select obligatorio id="drparea" class="form-control input-sm">
                                </select>
                            </div>
                        </div>
                        <!-- <div class="form-group">
                             <div class="input-group">
                                 <span class="input-group-addon">PARA:</span>
                                 <input id="txtusuario" type="text" class="form-control" placeholder="Derivar a usuario">
                             </div>
                         </div>-->
                        <div class="form-group">
                            <div class="input-group">
                                <span class="input-group-addon">CODIGO DE DOCUMENTO:</span>
                                <input obligatorio id="txtcodigodocumento"  type="text" class="form-control" placeholder="" disabled="">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <span class="input-group-addon">ASUNTO:</span>
                                <input obligatorio id="txtAsunto"  type="text" class="form-control" placeholder="Ingrese el Asunto">
                            </div>
                        </div>
                        <div class="form-group">
                            <textarea obligatorio id="txaMensaje" name="message" id="email_message" class="form-control" placeholder="Message" style="height: 120px;"></textarea>
                        </div>
                        <div class="form-group">
                            <p class="help-block">Archivos Adjuntos</p>
                            <input onclick="generarUploadImg('#uploadfile')" type="button" value="+">

                            <div id="uploadfile">

                            </div>

                            <p class="help-block">Max. 100MB por archivo</p>
                        </div>
                    </form>
                </div>
                <div class="modal-footer clearfix">
                    <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Descartar</button>
                    <button id="btnenviarmensaje" type="button" class="btn btn-primary pull-left"> Derivar</button>
                </div>

            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->


    <div class="modal fade" id="mdlDetalleExpediente" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><i class="fa fa-envelope-o"></i> Detalle de Expediente </h4>
                </div>

                <div class="modal-body">
                    <form id="frmderivar" role="form" enctype="multipart/form-data" >
                        <h5>DATOS DEL EXPEDIENTE</h5>
                        <hr>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">C&oacute;digo</span>
                                        <input id="txtdt_codigo" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Asunto</span>
                                        <input id="txtdt_asunto" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">&Aacute;rea</span>
                                        <input id="txtdt_area" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Procedimiento</span>
                                        <input id="txtdt_procedimiento" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Fecha Ingreso</span>
                                        <input id="txtdt_fechaingreso" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Fecha Recepci&oacute;n</span>
                                        <input id="txtdt_fecharecepcion" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <h5>DATOS DEL ADMINITRADO</h5>
                        <hr>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Nro DNI/RUC</span>
                                        <input  id="txtdt_nrodoc" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Nombres</span>
                                        <input id="txtdt_nombres" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Apellidos</span>
                                        <input id="txtdt_apellidos" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Direcci&oacute;n</span>
                                        <input id="txtdt_direccion" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Tel&eacute;fonos</span>
                                        <input id="txtdt_telefonos" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-12">
                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-addon">Correo</span>
                                        <input id="txtdt_correo" disabled="disabled" type="text" class="form-control" placeholder="">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer clearfix">
                    <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cerrar</button>

                </div>

            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->


    <div class="modal fade" id="mdlResolverExpediente" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h4 class="modal-title"><i class="fa fa-envelope-o"></i> Estado de Expediente </h4>
                </div>

                <div class="modal-body">
                    <form id="frmderivar" role="form" enctype="multipart/form-data" >

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>Estados</label>
                                    <div id="listaestadoflujo" >
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Observaci&oacute;n</label>
                                    <textarea id="txaobservacioncambioestado" placeholder="Ingrese alguna Observaci&oacute;n" rows="3" class="form-control"></textarea>
                                </div>
                                <label style="color:red" id="txtmensajealerta">
                                </label>
                            </div>

                        </div>


                    </form>
                </div>
                <div class="modal-footer clearfix">
                    <button type="button" class="btn btn-danger" data-dismiss="modal"><i class="fa fa-times"></i> Cerrar</button>
                    <button id="btncambiarestado" type="button" class="btn btn-primary pull-left"><i class="fa fa-envelope"></i> Guardar</button>

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
    <script src="${pageContext.request.contextPath}/js/plugins/sliptree-bootstrap-tokenfield/bootstrap-tokenfield.js"></script>

    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/app.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/select2/js/select2.full.js"></script>

    <!-- AdminLTE for demo purposes -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/JSFlujo.js" type="text/javascript"></script>

</body>
</html>
