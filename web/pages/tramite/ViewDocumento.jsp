<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Registro Documento</title>
    <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
    <link href="${pageContext.request.contextPath}/js/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/js/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <!-- Ionicons -->
    <link href="${pageContext.request.contextPath}/js/plugins/ionicons/css/ionicons.min.css" rel="stylesheet" type="text/css" /> <!-- daterange picker -->
    <!-- Theme style -->
    <link rel="stylesheet" media="screen" href="${pageContext.request.contextPath}/js/plugins/jquery/css/redmond/jquery-ui-1.10.4.custom.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/jqgrid/css/ui.jqgrid.css">
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

        /*.ui-datepicker  { position: relative; z-index: 10000 !important; }
        .ui-datepicker-year select option{
            position: relative; z-index: 10001 !important;
        }*/
    </style>
</head>
<body class="skin-blue">

    <%@include file="../includes/header.html" %>
    <div class="wrapper row-offcanvas row-offcanvas-left">
        <!-- Left side column. contains the logo and sidebar-->
        <%@include file="../includes/sidebar_1.html" %> 

        <!-- Right side column. Contains the navbar and content of the page -->
        <aside class="right-side">
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1>
                    Registro de Documento
                    <small>Administracion de Documento</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-unlock-alt"></i> Documento</a></li>
                    <li class="active">Registro de Documento</li>
                </ol>
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                    <div class="col-md-6">

                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">Mis Documentos Generados</h3>
                            </div>
                            <div id="containerGrilla" class="box-body">

                                <table id="grid"></table>
                                <div id="pager"></div>

                            </div><!-- /.box-body -->
                        </div><!-- /.box -->

                    </div><!-- /.col (left) -->
                    <div class="col-md-6">
                        <form id="form" role="form">
                            <div class="box box-primary">
                                <div class="box-header">
                                    <h3 class="box-title">Registro de Documento</h3>
                                </div>
                                <div class="box-body">
                                    <!-- Date range -->
                                    <div class="form-group">
                                        <label>Tipo de Documento :</label>
                                        <select class="form-control input-sm" id="drptipodocumento" obligatorio="">

                                        </select>

                                    </div>  
                                    <div class="form-group">
                                        <label>C&oacute;digo de Documento Generado :</label>
                                        <input obligatorio id="txtcodigodocumentogenerado" class="form-control input-sm" type="text" placeholder="Codigo Documento Generado"
                                               disabled="disabled" inafecto="">
                                    </div> 
                                    <div class="form-group">
                                        <label>Asunto :</label>
                                        <input obligatorio id="txtAsunto" class="form-control input-sm" type="text" placeholder="Ingrese Asunto">
                                    </div>  
                                    <div class="form-group">
                                        <label>Descripcion :</label>
                                        <textarea id="txaMensaje" obligatorio class="form-control input-sm"></textarea>
                                    </div>  








                                    <div class="form-group">
                                        <label>Codigo Expediente :</label>
                                        <input disabled="disabled" inafecto="" obligatorio id="txtCodigoexpediente" class="form-control input-sm" type="text" placeholder="Ingrese Codigo Expediente">
                                    </div>  
                                    <hr>
                                    <div class="form-group">
                                        <label>Referencias :</label>
                                        <br>
                                        <div onclick="agregarReferencias();" style="width: 220px;" class="btn btn-default btn-file">
                                            <i class="fa fa-paperclip"></i> Busqueda Documentos
                                        </div>

                                        <br>
                                        <br>
                                        <div id="listreferencia">
                                            
                                       </div> 

                                    </div>


                                    <div class="form-group">
                                        <p class="help-block">Archivos Adjuntos</p>
                                        <input id="addupload" onclick="generarUploadImg('#uploadfile')" type="button" value="+">

                                        <div id="uploadfile">

                                        </div>

                                        <p class="help-block">Max. 100MB por archivo</p>
                                    </div>
                                </div><!-- /.box-body -->
                                <div class="box-footer">
                                    <button id="btnNuevo" type="button" class="btn btn-primary btn-sm">Guardar</button>
                                    <button id="btnCancelar" type="button" class="btn btn-default btn-sm">Cancelar</button>
                                </div>
                            </div><!-- /.box -->



                        </form>

                    </div><!-- /.col (right) -->
                </div><!-- /.row -->


            </section><!-- /.content -->
        </aside><!-- /.right-side -->
    </div><!-- ./wrapper -->



    <!-- Large modal -->
   

    <div id="ModalDocRef" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span></button>
                    <h4 class="modal-title">Agregar Referencia a Documento</h4>
                </div>
                <div class="modal-body">

                    <div class="input-group">
                        <div class="input-group-btn">
                            <button type="button" class="btn btn-danger"><i class="fa fa-search" aria-hidden="true"></i></button>
                        </div>
                        <input id="txtbusquedadetallada" type="text" class="form-control" placeholder="Ingrese el Codigo o Asunto del Documento.">
                        <span class="input-group-btn">
                            <button id="btnmostrarbsq_detallada" type="button" class="btn btn-info btn-flat" data-toggle="tooltip" data-placement="top" title="Activar la busqueda detallada."><i class="fa fa-bars" aria-hidden="true"></i></button>
                        </span>
                    </div>
                    <hr>
                    <div class="form-group" id="frombusq_detallada">

                        <label>Tipo de Documento</label>
                        <select class="form-control input-sm" id="drptipodocbusqueda">

                        </select>
                        <label>Area creaci&oacute;n</label>
                        <select class="form-control input-sm" id="drpareabusqueda">

                        </select>

                        <label>Rango fecha de creaci&oacute;n</label>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <input type="text"  class="form-control pull-right input-sm" id="b_fecha_inicio">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <input type="text" class="form-control pull-right input-sm" id="b_fecha_fin">
                                </div>
                            </div>
                        </div>
                        <label>Usuario creaci&oacute;n</label>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-user" aria-hidden="true"></i>
                                    </div>
                                    <input type="text" class="form-control pull-right input-sm" id="txt_usuario_busqueda">
                                </div>
                            </div>
                        </div>
                    </div>
                    <br>
                    <div class="box-footer">
                        <div class="pull-right">
                            <button id="btnlimpiarbusqdetallada" type="button" class="btn btn-default"><i class="fa fa-eraser" aria-hidden="true"></i> Limpiar</button>
                            <button id="btnbusqdetallada" type="submit" class="btn btn-primary"><i class="fa fa-search" aria-hidden="true"></i> Buscar</button>
                        </div>

                    </div>
                    <br>
                    <hr>

                    <div class="form-group" >
                        <table id="gridDocumentoBusqueda"></table>
                        <div id="pagerDocumentoBusqueda"></div>
                    </div>
                </div>
                <div class="modal-footer">
                   

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
    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/maskedinput/maskedinput.js"></script>
    <!-- AdminLTE App -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/app.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/js/tramite/JSDocumento.js" type="text/javascript"></script>

</body>
</html>
