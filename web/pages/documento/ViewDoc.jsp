<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <title>Vista de Documento</title>
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
        .myButton {
            -moz-box-shadow:inset 0px 1px 0px 0px #54a3f7;
            -webkit-box-shadow:inset 0px 1px 0px 0px #54a3f7;
            box-shadow:inset 0px 1px 0px 0px #54a3f7;
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #007dc1), color-stop(1, #0061a7));
            background:-moz-linear-gradient(top, #007dc1 5%, #0061a7 100%);
            background:-webkit-linear-gradient(top, #007dc1 5%, #0061a7 100%);
            background:-o-linear-gradient(top, #007dc1 5%, #0061a7 100%);
            background:-ms-linear-gradient(top, #007dc1 5%, #0061a7 100%);
            background:linear-gradient(to bottom, #007dc1 5%, #0061a7 100%);
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#007dc1', endColorstr='#0061a7',GradientType=0);
            background-color:#007dc1;
            -moz-border-radius:3px;
            -webkit-border-radius:3px;
            border-radius:3px;
            border:1px solid #124d77;
            display:inline-block;
            cursor:pointer;
            color:#ffffff;
            font-family:Arial;
            font-size:13px;
            padding:6px 24px;
            text-decoration:none;
            text-shadow:0px 1px 0px #154682;
        }
        .myButton:hover {
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #0061a7), color-stop(1, #007dc1));
            background:-moz-linear-gradient(top, #0061a7 5%, #007dc1 100%);
            background:-webkit-linear-gradient(top, #0061a7 5%, #007dc1 100%);
            background:-o-linear-gradient(top, #0061a7 5%, #007dc1 100%);
            background:-ms-linear-gradient(top, #0061a7 5%, #007dc1 100%);
            background:linear-gradient(to bottom, #0061a7 5%, #007dc1 100%);
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#0061a7', endColorstr='#007dc1',GradientType=0);
            background-color:#0061a7;
        }
        .myButton:active {
            position:relative;
            top:1px;
        }


        /**/

        .Buttonref {
            -moz-box-shadow:inset 0px 1px 0px 0px #ffffff;
            -webkit-box-shadow:inset 0px 1px 0px 0px #ffffff;
            box-shadow:inset 0px 1px 0px 0px #ffffff;
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #f9f9f9), color-stop(1, #e9e9e9));
            background:-moz-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background:-webkit-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background:-o-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background:-ms-linear-gradient(top, #f9f9f9 5%, #e9e9e9 100%);
            background:linear-gradient(to bottom, #f9f9f9 5%, #e9e9e9 100%);
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#f9f9f9', endColorstr='#e9e9e9',GradientType=0);
            background-color:#f9f9f9;
            -moz-border-radius:6px;
            -webkit-border-radius:6px;
            border-radius:6px;
            border:1px solid #dcdcdc;
            display:inline-block;
            cursor:pointer;
            color:#666666;
            font-family:Arial;
            font-size:15px;
            font-weight:bold;
            padding:6px 24px;
            text-decoration:none;
            text-shadow:0px 1px 0px #ffffff;
        }
        .Buttonref:hover {
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0.05, #e9e9e9), color-stop(1, #f9f9f9));
            background:-moz-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background:-webkit-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background:-o-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background:-ms-linear-gradient(top, #e9e9e9 5%, #f9f9f9 100%);
            background:linear-gradient(to bottom, #e9e9e9 5%, #f9f9f9 100%);
            filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#e9e9e9', endColorstr='#f9f9f9',GradientType=0);
            background-color:#e9e9e9;
        }
        .Buttonref:active {
            position:relative;
            top:1px;
        }


    </style>
</head>
<body class="skin-blue">



    <div class="wrapper row-offcanvas row-offcanvas-left">
        <!-- Left side column. contains the logo and sidebar -->


        <!-- Right side column. Contains the navbar and content of the page -->
        <aside class="right-side" style="width: 1000px; margin-left: auto;margin-right: auto;">
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <h1 id="codigo_documento">
                    Detalle de Documento

                </h1>

            </section>
            <section class="content">
                <div class="row">
                    <div class="col-md-12">

                        <div class="box box-info">
                            <div class="box-header ui-sortable-handle" style="cursor: move;">
                                <i class="fa fa-file-text-o" aria-hidden="true"></i>
                                <h3 class="box-title">Detalle</h3>
                            </div>
                            <div class="box-body">
                                <h5>-- Autor : <label id="autor_documento"></label></h5>
                                <h5>-- &Aacute;rea Creaci&oacute;n : <label id="area_documento"></h5>
                                <h5>-- Fecha Creaci&oacute;n : <label id="fecha_documento"></h5>

                                <h3  id="asunto_documento"></h3>

                                <p id="mensaje_documento"></p>
                            </div>
                        </div>
                        <div class="box box-info">
                            <div class="box-header ui-sortable-handle" style="cursor: move;">
                                <i class="fa fa-paperclip" aria-hidden="true"></i>
                                <h3 class="box-title">Adjuntos</h3>
                            </div>
                            <div class="box-body">
                                <div id="listaadjuntos">

                                </div>
                            </div>
                        </div>
                        <div class="box box-info">
                            <div class="box-header ui-sortable-handle" style="cursor: move;">
                                <i class="fa fa-file-o" aria-hidden="true"></i>
                                <h3 class="box-title">Documentos Referencia</h3>
                            </div>
                            <div class="box-body">
                                <div id="listareferencia">

                                </div>
                            </div>
                        </div>


                    </div>
                </div>
            </section><!-- /.content -->





        </aside><!-- /.right-side -->
    </div><!-- ./wrapper -->



    <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
    <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>

    <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>

    <!-- AdminLTE App -->

    <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>

    <!-- AdminLTE for demo purposes -->

    <script src="${pageContext.request.contextPath}/js/tramite/JSViewDoc.js" type="text/javascript"></script>

</body>
</html>
