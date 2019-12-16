<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Registro Expediente</title>
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

        <style>

            .ui-autocomplete{
                font-size:13px;
                color:#000;

            }

            .ui-corner-all{
                border-bottom: 1px dotted  #000;
            }
            input:focus{
                border: solid 3px red;
            }

        </style>
    </head>
    <body class="skin-blue">


        <%@include file="../includes/header.html" %>
        <div class="wrapper row-offcanvas row-offcanvas-left">
            <!-- Left side column. contains the logo and sidebar -->


            <!-- Right side column. Contains the navbar and content of the page -->
            <aside class="right-side" style="width: 960px; margin-left: auto;margin-right: auto;" >
                <!-- Content Header (Page header) -->
                <section class="content-header">
                    <h1>
                        Registro de Expediente
                        <small>Administracion de expedientes</small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><button class="btn btn-warning btn-xs"  data-toggle="modal" data-target=".bs-example-modal-lg">
                                <i class="fa fa-file-code-o"></i> Reporte de Expedientes
                            </button></li>

                    </ol>
                </section>

                <!-- Main content -->
                <section class="content">
                    <div class="row">
                        <div class="col-md-6">

                            <div class="box box-primary">
                                <div class="box-header">
                                    <h3 class="box-title">Lista de Expedientes</h3>


                                </div>
                                <div class="box-body">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i >Año.</i></span>
                                        <input id="txtbusquedaanio" type="text" placeholder="Ingrese el Año" class="form-control clearable">
                                        <span class="input-group-addon"><i>Codigo Expediente.</i></span>
                                        <input id="txtbusquedacodigoexpediente" type="text" placeholder="Codigo Expediente" class="form-control clearable">

                                    </div>

                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-search-plus"></i></span>
                                        <input id="txtbusqueda" type="text" placeholder="Nombres y Apellidos, DNI o Asunto, presione Enter" class="form-control clearable">
                                    </div>
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
                                        <h3 class="box-title">Registro de Expediente</h3>
                                    </div>
                                    <div class="box-body">
                                        <!-- Date range -->

                                        <div class="form-group">
                                            <label>Procedimiento <i style="color:red">*</i> : </label>
                                            <input obligatorio id="txtIdprocedimiento" class="form-control input-sm clearable" type="text" placeholder="Ingrese el procedimiento que desea solicitar">


                                        </div>   
                                        <div class="form-group">
                                            <label>Area <i style="color:red">*</i>:</label>
                                            <input inafecto disabled="disabled" obligatorio id="txtIdarea" class="form-control input-sm" type="text" placeholder="Ingrese el procedimiento que desea solicitar">
                                        </div>                                                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label id="formTipoDocumento">Nº Doc. <i style="color:red">*</i>(<input id="rbnDNI" inafecto type="radio" name="TipoDocumento" valor="DNI" checked="checked"><i style="font-size: 10px;">DNI</i>
                                                        <input inafecto  type="radio" name="TipoDocumento" valor="RUC" ><i style="font-size: 10px;">RUC</i> <input inafecto  type="radio" name="TipoDocumento" valor="SINDOC" ><i style="font-size: 10px;">S/N</i>)
                                                    </label>
                                                    <input solonumeros obligatorio id="txtDni_ruc" class="form-control input-sm selectAll" type="text" placeholder="Ingrese Dni o Ruc" maxlength="12">
                                                </div> 
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Nombre/RazónSocial <i style="color:red">*</i> :</label>
                                                    <input uppercases obligatorio id="txtNombre_razonsocial" class="form-control input-sm selectAll" type="text" placeholder="Ingrese Nombre o RazonSocial">
                                                </div>  
                                            </div>
                                        </div>
                                        <div class="row">

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Apellidos <i style="color:red">*</i> :</label>
                                                    <input uppercases obligatorio id="txtApellidos" class="form-control input-sm selectAll" type="text" placeholder="Ingrese Apellidos">
                                                </div> 
                                            </div> 
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Dirección <i style="color:red">*</i> :</label>
                                                    <input  uppercases obligatorio id="txtDireccion" class="form-control input-sm selectAll" type="text" placeholder="Ingrese Dirección">
                                                </div>   
                                            </div>
                                        </div> 
                                        <div class="row">

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Teléfono :</label>
                                                    <input  id="txtTelefono" class="form-control input-sm selectAll" type="text" placeholder="Ingrese Teléfono">
                                                </div>   
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Correo :</label>
                                                    <input  id="txtCorreo" class="form-control input-sm selectAll" placeholder="Ingrese Correo" type="text">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    <label>Nº folios <i style="color:red">*</i> :</label>
                                                    <input solonumeros obligatorio id="txtfolios" class="form-control input-sm selectAll" type="text" placeholder="Folios" maxlength="4">
                                                </div> 
                                            </div>
                                            <div class="col-md-9">
                                                <div class="form-group">
                                                    <label>Documento Principal <i style="color:red">*</i> :</label>
                                                    <input uppercases obligatorio id="txtdocumento" class="form-control input-sm selectAll" type="text" placeholder="Documento principal">
                                                </div> 
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label>Asunto <i style="color:red">*</i> :</label>
                                            <input uppercases obligatorio id="txtAsunto" class="form-control input-sm selectAll" type="text" placeholder="Ingrese Asunto">
                                        </div>   


                                    </div>

                                    <div class="box-body">
                                        <div class="form-group">
                                            <label>Requisitos :</label>
                                            <div class="row">
                                                <div class="col-md-5">
                                                    <select  name="origen[]" id="origen"  class="form-control input-sm" multiple="multiple" size="8">

                                                    </select>
                                                </div>
                                                <div class="col-md-2">

                                                    <p><button type="button" class="btn btn-success btn-xs pasar izq">&nbsp;>&nbsp;</button></p>
                                                    <p><button type="button" class="btn btn-success btn-xs quitar der">&nbsp;<&nbsp;</button></p>
                                                    <p><button type="button" class="btn btn-success btn-xs pasartodos izq">>></button></p>
                                                    <p><button type="button" class="btn btn-success btn-xs quitartodos der"><<</button></p>

                                                </div>
                                                <div class="col-md-5">
                                                    <select class="form-control input-sm" name="destino[]" id="destino" multiple="multiple" size="8"></select>
                                                </div>

                                            </div>




                                        </div>  

                                        <div class="form-group">
                                            <label>Observacion <i style="color:red">*</i> :</label>
                                            <input uppercases obligatorio id="txtObservacion" class="form-control input-sm selectAll" type="text" placeholder="Ingrese Observacion">
                                        </div>  
                                    </div>
                                    <!-- /.box-body -->
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


        <div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="embed-responsive embed-responsive-16by9">


                        <!-- Main content -->
                        <section class="content">
                            <div class="row">

                                <div id="form2" class="col-md-4">

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

                                                <div class="col-md-12">
                                                    <div class="form-group">
                                                        <label>Solo del Usuario:</label>
                                                        <input  id="chksolousuario" type="checkbox" class="form-control"  >
                                                    </div>
                                                </div>
                                            </div> 
                                            <div class="row" style="height: 10px"></div>


                                        </div><!-- /.box-body -->
                                        <div class="box-footer">
                                            <button id="btnReporte" type="button" class="btn btn-primary btn-sm" >Mostrar</button>

                                        </div>
                                    </div><!-- /.box -->





                                </div><!-- /.col (right) -->
                                <div class="col-md-8">

                                    <div class="box box-primary">
                                        <div class="box-header">
                                            <h3 class="box-title">Visualizacion del Reporte </h3>
                                        </div>
                                        <div id="containerGrilla" class="box-body">

                                            <div class="embed-responsive embed-responsive-4by3">
                                                <iframe width="550" height="500" class="embed-responsive-item" id="reportview" src=""></iframe>
                                            </div>

                                        </div><!-- /.box-body -->
                                    </div><!-- /.box -->

                                </div><!-- /.col (left) -->
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
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/maskedinput/maskedinput.js"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/select2/js/select2.full.js"></script>
        <!-- AdminLTE App -->

        <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>

        <!-- AdminLTE for demo purposes -->
        <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script> 
        <script src="${pageContext.request.contextPath}/js/tramite/JSExpediente.js" type="text/javascript"></script>

    </body>
</html>
