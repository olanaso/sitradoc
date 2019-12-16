<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Registro Procedimiento</title>
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
<body class="skin-blue">
    <%@include file="../includes/header.html" %>
    <div class="wrapper row-offcanvas row-offcanvas-left">
        <!-- Left side column. contains the logo and sidebar -->
        <%@include file="../includes/sidebar.html" %>

        <!-- Right side column. Contains the navbar and content of the page -->
        <aside class="right-side">
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1>
                    Registro de Procedimiento
                    <small>Administración de Procedimientos</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-unlock-alt"></i> Procedimiento</a></li>
                    <li class="active">Registro de Procedimiento</li>
                </ol>
            </section>
            <!-- Main content -->
            <section class="content">
                <div class="row">
                    <div class="col-md-6">
                        <div class="box box-primary">
                            <div class="box-header">
                                <h3 class="box-title">Lista de Procedimientos por Área</h3>
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
                                    <h3 class="box-title">Registro de Procedimiento</h3>
                                </div>
                                <div class="box-body">
                                    <!-- Date range -->
                                    <div class="form-group">
                                        <label>Área<i style="color:red ">*</i> :</label>
                                        <select obligatorio id="txtIdarea" class="form-control input-sm">
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Tipo Procedimiento<i style="color:red ">*</i> :</label>
                                        <select obligatorio id="txtIdtipoprocedimiento" class="form-control input-sm">
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Código<i style="color:red ">*</i> :</label>
                                        <input maxlength="20" obligatorio id="txtCodigo" class="form-control input-sm" type="text" placeholder="Ingrese Codigo">
                                    </div>
                                    <div class="form-group">
                                        <label>Denominación<i style="color:red ">*</i> :</label>
                                        <input UpperCase obligatorio id="txtDenominacion" class="form-control input-sm" type="text" placeholder="Ingrese Denominacion">
                                    </div>
                                    <div class="form-group">
                                        <label>Plazo(días)<i style="color:red ">*</i> :</label>
                                        <input maxlength="3" SoloNumeros obligatorio id="txtPlazodias" class="form-control input-sm" type="text" placeholder="Ingrese Plazodias">
                                    </div>
                                    <div class="form-group">
                                        <label>Monto<i style="color:red ">*</i> :</label>
                                        <input maxlength="3" SoloNumeros obligatorio id="txtMontoTotal" class="form-control input-sm" type="text" placeholder="Ingrese Monto">
                                    </div>
                                    <div class="form-group">
                                        <label>Cargo<i style="color:red ">*</i> :</label>
                                        <select obligatorio id="txtIdcargoresolutor" class="form-control input-sm">
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Descripción<i style="color:red ">*</i> :</label>
                                        <input obligatorio id="txtDescripcion" class="form-control input-sm" type="text" placeholder="Ingrese Descripcion">
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
    <script src="${pageContext.request.contextPath}/js/tramite/JSProcedimiento.js" type="text/javascript"></script>

</body>
</html>
