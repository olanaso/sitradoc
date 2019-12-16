<%-- 
    Document   : templateEmpty
    Author     : ERIK-PC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Bandeja Trámite</title>
        <meta content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no' name='viewport'>
        <link href="${pageContext.request.contextPath}/js/plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/js/plugins/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
        <!-- Ionicons -->
        <link href="${pageContext.request.contextPath}/js/plugins/ionicons/css/ionicons.min.css" rel="stylesheet" type="text/css" /> <!-- daterange picker -->
        <!-- Theme style -->
        <link rel="stylesheet" media="screen" href="${pageContext.request.contextPath}/js/plugins/jquery/css/redmond/jquery-ui-1.10.4.custom.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/jqgrid/css/ui.jqgrid.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/sliptree-bootstrap-tokenfield/css/bootstrap-tokenfield.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/js/plugins/daterangepicker/daterangepicker.css">


        <link href="${pageContext.request.contextPath}/css/AdminLTE.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/styles.css" rel="stylesheet" type="text/css" />
        <link href="${pageContext.request.contextPath}/css/megamenu.css" rel="stylesheet" type="text/css" />
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
          <script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
        <![endif]-->

        <link href="${pageContext.request.contextPath}/css/bandejainterna.css" rel="stylesheet" type="text/css" />

        <script>
            var urlApp = '${pageContext.request.contextPath}';
        </script>

        <style>

            .applyBtn{

                color: #fff !important;
            }
            .applyBtn:hover{

                background:#0088CC !important;
            }

            body {font-family: "Lato", sans-serif;}

            ul.tab {
                list-style-type: none;
                margin: 0;
                padding: 0;
                overflow: hidden;
                border: 1px solid #ccc;
                background-color: #f1f1f1;
            }

            /* Float the list items side by side */
            ul.tab li {float: left;}

            /* Style the links inside the list items */
            ul.tab li a {
                display: inline-block;
                color: black;
                text-align: center;
                padding: 14px 16px;
                text-decoration: none;
                transition: 0.3s;
                font-size: 17px;
            }

            /* Change background color of links on hover */
            ul.tab li a:hover {
                background-color: #ddd;
            }

            /* Create an active/current tablink class */
            ul.tab li a:focus, .active {
                background-color: #ccc;
            }

            /* Style the tab */
            div.tab {
                overflow: hidden;
                border: 1px solid #ccc;
                background-color: #f1f1f1;
            }

            /* Style the links inside the tab */
            div.tab a {
                float: left;
                display: block;
                color: black;
                text-align: center;
                padding: 14px 16px;
                text-decoration: none;
                transition: 0.3s;
                font-size: 17px;
            }

            /* Change background color of links on hover */
            div.tab a:hover {
                background-color: #fff;
            }

            /* Create an active/current tablink class */
            div.tab a:focus, .active {
                background-color: #fff;
            }

            /* Style the tab content */
            .tabcontent {
                display: none;
                padding: 6px 12px;
                border: 1px solid #ccc;
                border-top: none;
            }
            .btn-default.active {
                background-color: #0088CA;
                color: white;
            }

            #buton_float .btn-s {
                width: 32px;
                height: 32px;
                line-height: 32px;
                font-size: 14px;
            }
            #buton_float .btn-m {
                width: 48px;
                height: 48px;
                line-height: 48px;
                font-size: 18px;
            }
            #buton_float .btn-l {
                width: 64px;
                height: 64px;
                line-height: 64px;
                font-size: 24px;
            }
            #buton_float .btn-circle, .btn-circle a {
                border-radius: 50%;
            }
            #buton_float .orange {
                background:#E77E22;
                right: 10px;
            }
            #buton_float .green {
                background:#8FC02F;
                right: 52px;
            }
            #buton_float .pink {
                background:#D93160;
                right: 110px;
            }
            #buton_float .btn_f {
                text-align: center;
                -webkit-transition: .8s all;
                -moz-transition: .8s all;
                transition: .8s all;
            }
            #buton_float .btn_f a {
                display:block;
                color:#fff;
                text-decoration:none;
                -webkit-transition: .8s all;
                -moz-transition: .8s all;
                transition: .8s all;
            }
            #buton_float .btn_f a:hover {
                background:rgba(0, 0, 0, .5);
            }
            #buton_float .btn-float {
                position: fixed;
                bottom:10px;
                z-index:999;
            }
            #buton_float .btn-float:hover {
                -moz-box-shadow: 0px 2px 4px rgba(0, 0, 0, .5);
                -webkit-box-shadow: 0px 2px 4px rgba(0, 0, 0, .5);
                box-shadow: 0px 2px 4px rgba(0, 0, 0, .5);
            }
            
           
        </style>

    </head>
    <body class="skin-blue">
        <div id="buton_float">


            <div title="Crear Documento" class="btn btn-float btn-l btn-circle  orange overlay_open_docMensaje"><a style="color: #ffffff;" href="#">+</a>
            </div>

        </div>

        <script>
            function hideDivRecInterna() {
                document.getElementById('containerGrillabandeja').style.display = 'none';
            }

            function hideDivExp() {
                document.getElementById('divEstadoExpediente').style.display = 'none';
            }

            function showDivRecExp() {
                document.getElementById('divEstadoExpediente').style.display = 'none';
            }
            
            function openTab(evt, tramite, href1, href2, href3, href4, href5, href6) {
                var i, tabcontent, tablinks;
                tabcontent = document.getElementsByClassName("tabcontent");
                for (i = 0; i < tabcontent.length; i++) {
                    tabcontent[i].style.display = "none";
                }
                tablinks = document.getElementsByClassName("tablinks");
                for (i = 0; i < tablinks.length; i++) {
                    tablinks[i].className = tablinks[i].className.replace(" active", "");
                }
                document.getElementById(tramite).style.display = "block";
                evt.currentTarget.className += " active";
                document.getElementById(href1).className = "tablinks active";
                document.getElementById(href2).className = "tablinks";
                document.getElementById(href3).className = "tablinks";
                document.getElementById(href4).className = "tablinks active";
                document.getElementById(href5).className = "tablinks";
                document.getElementById(href6).className = "tablinks";
            }
        </script>
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
                                        <!--<div class="col-md-3">
                                            <div class="box box-solid">
                                                <a href="#" class="btn btn-primary btn-block margin-bottom overlay_open_docMensaje" >Registrar Documento</a>
                                            </div>
                                            <div class="box box-solid">
                                                <div class="box-header with-border">
                                                    <h3 class="box-title">Bandejas</h3>
                                                    <div class="box-tools">
                                                    </div>
                                                </div>
                                                <div class="box-body no-padding">
                                                    <ul class="nav nav-pills nav-stacked" id="listestados_bandeja">
                                                        <li id="liTramExterno" class="tablinks active"><a href="javascript:void(0)" class="tablinks fa fa-share" onclick="openTab(event, 'divTramite_externo', 'hrefTramExterno', 'hrefTramInterno', 'hrefMisDocumentos', 'liTramExterno', 'hrefTramInterno2', 'liMisDocumentos')">
                                                                Trámite Externo</a></li>
                                                        <li id="liTramInterno"><a href="javascript:void(0)" class="tablinks fa fa-retweet" onclick="openTab(event, 'divTramite_interno', 'hrefTramInterno', 'hrefTramExterno', 'hrefMisDocumentos', 'liTramInterno', 'liTramExterno', 'liMisDocumentos');
                                                                cargarGrilla_pre_recepcionInterna()"> Trámite Interno</a></li>
                                                        <li id="liMisDocumentos"><a href="javascript:void(0)" class="tablinks fa fa-file-text-o" onclick="openTab(event, 'divMis_documentos', 'hrefMisDocumentos', 'hrefTramExterno', 'hrefTramInterno', 'liMisDocumentos', 'liTramExterno', 'liTramInterno');
                                                                cargarGrillaDocumento_regDocumento()"> Mis Documentos</a></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>-->
                                        <div class="col-md-12 col-sm-12">
                                            <div class="box box-primary">
                                                <!--                                                <ul class="tab">
                                                                                                    <li id="lidivTramite_externo" role="presentation" class="active"><a href="#divTramite_externo" id="divTramite_externo-tab" role="tab" data-toggle="tab" aria-controls="divTramite_externo" aria-expanded="true">Trámite Externo</a></li>
                                                                                                    <li id="lidivTramite_interno" role="presentation"><a href="#divTramite_interno" role="tab" id="divTramite_interno-tab" data-toggle="tab" aria-controls="divTramite_interno">Trámite Interno</a></li>
                                                                                                    <li id="lidivMis_documentos" role="presentation"><a href="#divMis_documentos" role="tab" id="divMis_documentos-tab" data-toggle="tab" aria-controls="divMis_documentos">Mis Documentos</a></li>
                                                                                                </ul>-->
                                                <div class="tab">
                                                    <a id="hrefTramExterno" href="javascript:void(0)" class="tablinks active" onclick="openTab(event, 'divTramite_externo', 'hrefTramExterno', 'hrefTramInterno', 'hrefMisDocumentos', 'liTramExterno', 'liTramInterno', 'liMisDocumentos')"><i class="fa fa-external-link" aria-hidden="true"></i> Trámite Externo</a>
                                                    <a id="hrefTramInterno" href="javascript:void(0)" class="tablinks" onclick="openTab(event, 'divTramite_interno', 'hrefTramInterno', 'hrefTramExterno', 'hrefMisDocumentos', 'liTramInterno', 'liTramExterno', 'liMisDocumentos');
                                                            cargarGrilla_pre_recepcionInterna()"><i class="fa fa-get-pocket" aria-hidden="true"></i> Trámite Interno</a>
                                                    <a id="hrefMisDocumentos" href="javascript:void(0)" class="tablinks" onclick="cargarGrillaDocumento_regDocumento();
                                                        openTab(event, 'divMis_documentos', 'hrefMisDocumentos', 'hrefTramExterno', 'hrefTramInterno', 'liMisDocumentos', 'liTramExterno', 'liTramInterno');
                                                            "><i class="fa fa-file-text-o" aria-hidden="true"></i> Mis Documentos</a>


                                                </div>
                                                <!--                                                <div id="myTabContent2" class="tab-content">-->
                                                <!--                                                <div role="tabpanel" id="divTramite_externo" class="tab-pane fade in active" aria-labelledby="home-tab">-->
                                                <div id="divTramite_externo" class="tabcontent" style="display: block;">
                                                    <!-- inicio viewRecepcionExterna-->
                                                    <section class="content">
                                                        <div class="row">
                                                            <div class="col-md-12">
                                                                <ul id="myTabs" class="nav nav-tabs" role="tablist">
                                                                    <li id="te_tab_recepcion_expediente" role="presentation" onclick="cargarGrillaporRecibir_recepcionExterna()" class="active"><a href="#home" id="home-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true"><i class="fa fa-arrow-down" aria-hidden="true"></i> Recepción de Expedientes</a></li>
                                                                    <li id="te_tab_recepcionado_expediente" role="presentation" onclick="cargarGrillaRecibido_recepcionExterna()"><a href="#profile" role="tab" id="profile-tab" data-toggle="tab" aria-controls="profile"><i class="fa fa-arrow-right" aria-hidden="true"></i> Expedientes Recepcionados</a></li>
                                                                    <li id="te_tab_absolucion_expediente" role="presentation" onclick="cargarGrilla_TramiteExterno()"><a href="#profile2" role="tab" id="profile2-tab" data-toggle="tab" aria-controls="profile2"><i class="fa fa-check-square-o" aria-hidden="true"></i> Resolución de Expedientes</a></li>
                                                                </ul>
                                                                <div id="myTabContent" class="tab-content">
                                                                    <div role="tabpanel" class="tab-pane fade " id="home" aria-labelledby="home-tab">
                                                                        <div class="row">

                                                                            <div class="col-md-9">
                                                                                <div class="input-group">
                                                                                    <span class="input-group-addon"><i >Año.</i></span>
                                                                                    <input id="pre_txtbusquedaanio_recepcionExterna"  type="text" placeholder="Ingrese el Año" class="form-control clearable grilla_recibidos_recepcionExterna">
                                                                                    <span class="input-group-addon"><i>Codigo Expediente.</i></span>
                                                                                    <input id="pre_txtbusquedacodigoexpediente_recepcionExterna"  type="text" placeholder="Codigo Expediente" class="form-control clearable grilla_recibidos_recepcionExterna">
                                                                                </div>
                                                                                <div class="input-group">
                                                                                    <span class="input-group-addon"><i class="fa fa-search-plus"></i></span>
                                                                                    <input id="pre_txtbusqueda_recepcionExterna"  type="text" placeholder="Nombres y Apellidos, DNI o Asunto, presione Enter" class="form-control clearable grilla_recibidos_recepcionExterna">

                                                                                    <span class="input-group-addon" style="background-color: #89E6C4">
                                                                                        <input id="showfechamanual" type="checkbox"/> Fecha de registro manual</span>
                                                                                    <input   id="pre_fecha_registro_manual_recepcionExterna" style="background: #B6D0FC;display: none;"  type="text" placeholder="dd/mm/aaaa hh:ss" class="form-control clearable grilla_recibidos_recepcionExterna">
                                                                                </div>
                                                                            </div>
                                                                            <div class="col-md-3">
                                                                                <div id="divbtn_recepinterna" style="padding-top: 5px;">

                                                                                    <button id="btnRecibir_recepcionExterna" type="button" class="btn btn-warning btn-lg btn-block">
                                                                                        <i class="fa fa-arrow-circle-down"></i> Recibir  
                                                                                    </button>
                                                                                </div>
                                                                            </div>

                                                                        </div>
                                                                        <table id="grid_recepcion_externa"></table>
                                                                        <div id="pager_recepcion_externa"></div>

                                                                    </div>
                                                                    <div role="tabpanel" class="tab-pane fade" id="profile" aria-labelledby="profile-tab">
                                                                        <div class="input-group">
                                                                            <span class="input-group-addon"><i >Año</i></span>
                                                                            <input id="post_txtbusquedaanio_recepcionExterna" type="text" placeholder="Ingrese el Año" class="form-control clearable grilla_recepcionados_recepcionExterna">
                                                                            <span class="input-group-addon"><i>Codigo Expediente</i></span>
                                                                            <input id="post_txtbusquedacodigoexpediente_recepcionExterna" type="text" placeholder="Codigo Expediente" class="form-control clearable grilla_recepcionados_recepcionExterna">
                                                                        </div>
                                                                        <div class="input-group">
                                                                            <span class="input-group-addon"><i class="fa fa-search-plus"></i></span>
                                                                            <input id="post_txtbusqueda_recepcionExterna" type="text" placeholder="Nombres y Apellidos, DNI o Asunto, presione Enter" class="form-control clearable grilla_recepcionados_recepcionExterna">
                                                                        </div>
                                                                        <table id="gridRecibido_recepcionExterna"></table>
                                                                        <div id="pagerRecibido_recepcionExterna"></div>
                                                                    </div>
                                                                    <div role="tabpanel" id="profile2" class="tab-pane" aria-labelledby="profile2-tab">
                                                                        <section class="content">
                                                                            <div class="row">
                                                                                <div class="col-md-12">
                                                                                    <ul id="myTabs2" class="nav nav-tabs" role="tablist">
                                                                                        <li role="presentation" onclick="cargarflujo(this, 1, 9, 'PENDIENTE');" class="active"><a href="#home2" id="home2-tab" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">Pendientes</a></li>
                                                                                        <li role="presentation" onclick="cargarflujo(this, 3, 9, 'OBSERVADO');"><a href="#profile4" role="tab" id="profile4-tab" data-toggle="tab" aria-controls="profile">Observados</a></li>
                                                                                        <li role="presentation" onclick="cargarflujo(this, 2, 9, 'RESUELTO');"><a href="#profile5" role="tab" id="profile5-tab" data-toggle="tab" aria-controls="profile">Resueltos</a></li>
                                                                                        <li role="presentation" onclick="cargarflujo(this, 4, 9, 'DERIVADO');"><a href="#profile6" role="tab" id="profile6-tab" data-toggle="tab" aria-controls="profile">Derivados</a></li>
                                                                                    </ul>
                                                                                    <div id="myTabContent2" class="tab-content">
                                                                                        <div role="tabpanel" class="tab-pane fade in active" id="home2" aria-labelledby="home-tab"></div>
                                                                                        <div role="tabpanel" class="tab-pane fade" id="profile4" aria-labelledby="profile-tab"></div>
                                                                                        <div role="tabpanel" class="tab-pane fade" id="profile5" aria-labelledby="profile-tab"></div>
                                                                                        <div role="tabpanel" class="tab-pane fade" id="profile6" aria-labelledby="profile-tab"></div>
                                                                                        <div id="divEstadoExpediente" class="box box-primary">
                                                                                            <div id="containerGrilla_tramiteExterno" class="box-body">
                                                                                                <div class="input-group">
                                                                                                    <span class="input-group-addon"><i >A&ntilde;o.</i></span>
                                                                                                    <input id="pre_txtbusquedaanio_tramite_externo" type="text" placeholder="Ingrese el A&ntilde;o" class="form-control clearable grilla">
                                                                                                    <span class="input-group-addon"><i>Codigo Expediente.</i></span>
                                                                                                    <input id="pre_txtbusquedacodigoexpediente_tramite_externo" type="text" placeholder="Codigo Expediente" class="form-control clearable grilla">
                                                                                                </div>
                                                                                                <div class="input-group">
                                                                                                    <span class="input-group-addon"><i class="fa fa-search-plus"></i></span>
                                                                                                    <input id="pre_txtbusqueda_tramite_externo" type="text" placeholder="Nombres y Apellidos, DNI o Asunto, presione Enter" class="form-control clearable grilla">
                                                                                                    <span class="input-group-addon"><label style="color:#035BC7">* Para realizar una b&uacute;squeda Presione Enter</label></span>
                                                                                                </div>
                                                                                                <table id="grid_tramiteExterno"></table>
                                                                                                <div id="pager_tramiteExterno"></div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </section>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <hr>
                                                    </section>
                                                    <!-- fin viewRecepcionExterna-->
                                                </div>
                                                <!--                                                <div role="tabpanel" id="divTramite_interno" class="tab-pane fade" aria-labelledby="home-tab">-->
                                                <div id="divTramite_interno" class="tabcontent" style="display: none;">
                                                    <section class="content">
                                                        <div class="row">
                                                            <div class="col-md-12">
                                                                <ul id="myTabs_recepcion_interna" class="nav nav-tabs" role="tablist">
                                                                    <li id="ti_tab_recepcion_documento" role="presentation" onclick="hideDivRecInterna();
                                                                            cargarGrilla_pre_recepcionInterna()"class="active"><a href="#home_recepcion_interna" id="home-tab_recepcion_interna" role="tab" data-toggle="tab" aria-controls="home" aria-expanded="true">Recepción de Documentos</a></li>
                                                                    <li id="ti_tab_recepcionado_documento" role="presentation" onclick="hideDivRecInterna();
                                                                            cargarGrilla_post_recepcionInterna()"><a href="#profile_recepcion_interna" role="tab" id="profile-tab_recepcion_interna" data-toggle="tab" aria-controls="profile">Documentos Recepcionados</a></li>
                                                                    <li id="ti_tab_poratender_documento" role="presentation" onclick="showbandejaentrada()"><a href="#profile_recepcion_interna2" role="tab" id="profile-tab_recepcion_interna2" data-toggle="tab" aria-controls="profile">Documentos por Atender</a></li>
                                                                    <li id="ti_tab_finalizados_documento"  role="presentation" onclick="showbandejasalida()"><a href="#profile_recepcion_interna3" role="tab" id="profile-tab_recepcion_interna3" data-toggle="tab" aria-controls="profile">Documentos Atendidos</a></li>
                                                                    <li id="ti_tab_enviados"  role="presentation" onclick="showbandejaenviados()"><a href="#profile_recepcion_interna3" role="tab" id="profile-tab_recepcion_interna3" data-toggle="tab" aria-controls="profile">Documentos Enviados</a></li>

                                                                </ul>
                                                                <div id="myTabContent_recepcion_interna" class="tab-content">
                                                                    <div role="tabpanel" class="tab-pane fade in active" id="home_recepcion_interna" aria-labelledby="home-tab">
                                                                        <div class="row">

                                                                            <div class="col-md-9">
                                                                                <div class="input-group">
                                                                                    <span class="input-group-addon"><i> C&oacute;digo Expediente:</i></span>
                                                                                    <input id="pre_txtbusquedacodigo_expediente_recepcion_interna"  type="text" placeholder="Codigo Expediente" class="form-control clearable grilla_recibidos">

                                                                                    <span class="input-group-addon"><i> C&oacute;digo Documento:</i></span>
                                                                                    <input id="pre_txtbusquedacodigodocumento_codigo_documento"  type="text" placeholder="Codigo Documento" class="form-control clearable grilla_recibidos">

                                                                                    <span class="input-group-addon" ><i >Asunto:</i></span>
                                                                                    <input id="pre_txtasunto_recepcion_interna"  type="text" placeholder="Ingrese asunto" class="form-control clearable grilla_recibidos">
                                                                                </div>
                                                                                <div class="input-group">
                                                                                    <span class="input-group-addon"><i >Remitente:</i></span>
                                                                                    <input id="pre_remitente_recepcion_interna"  type="text" placeholder="Remitente" class="form-control clearable grilla_recibidos">
                                                                                    <span class="input-group-addon"><i>Area:</i></span>
                                                                                    <input id="pre_area_recepcion_interna"  type="text" placeholder="Area proveniente" class="form-control clearable grilla_recibidos">
                                                                                </div>
                                                                                <div class="input-group">
                                                                                    <span class="input-group-addon"><i >Rango de fecha:</i></span>
                                                                                    <input type="text" id="fecha_rango_busqueda_por_recibir_ri" class="form-control clearable">
                                                                                </div>


                                                                                <!--
                                                                                
                                                                                fecha manual
                                                                                -->

                                                                                <div class="input-group">

                                                                                    <span class="input-group-addon" style="background-color: #89E6C4">
                                                                                        <input id="showfechamanual_interno" type="checkbox"/> Fecha de registro manual</span>
                                                                                    <input id="pre_fecha_registro_manual_recepcionInterno" style="background: #B6D0FC;display: none;"  type="text" placeholder="dd/mm/aaaa hh:ss" class="form-control clearable grilla_recibidos_recepcionExterna">
                                                                                </div>
                                                                            </div>
                                                                            <div class="col-md-3">
                                                                                <div style="padding-top: 5px;">   

                                                                                    <button id="btnRecibir_recepcion_interna" type="button" class="btn btn-warning btn-lg btn-block" >
                                                                                        <i class="fa fa-arrow-circle-down"></i> Recibir  
                                                                                    </button>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <table id="grid_recepcion_interna"></table>
                                                                        <div id="pager_recepcion_interna"></div>

                                                                    </div>
                                                                    <div role="tabpanel" class="tab-pane fade" id="profile_recepcion_interna" aria-labelledby="profile-tab">
                                                                        <div class="input-group">
                                                                            <span class="input-group-addon"><i> C&oacute;digo Expediente:</i></span>
                                                                            <input id="post_txtbusquedacodigo_expediente_recepcion_interna"  type="text" placeholder="Codigo Expediente" class="form-control clearable grilla_recepcionados">

                                                                            <span class="input-group-addon"><i>Codigo Documento:</i></span>
                                                                            <input id="post_txtbusquedacodigodocumento"  type="text" placeholder="Codigo Documento" class="form-control clearable grilla_recepcionados">
                                                                            <span class="input-group-addon" ><i >Asunto:</i></span>
                                                                            <input id="post_txtasunto_recepcion_interna"  type="text" placeholder="Ingrese asunto" class="form-control clearable grilla_recepcionados">
                                                                        </div>
                                                                        <div class="input-group">
                                                                            <span class="input-group-addon"><i >Remitente:</i></span>
                                                                            <input id="post_remitente_recepcion_interna"  type="text" placeholder="Remitente" class="form-control clearable grilla_recepcionados">
                                                                            <span class="input-group-addon"><i>Area:</i></span>
                                                                            <input id="post_area_recepcion_interna"  type="text" placeholder="Area proveniente" class="form-control clearable grilla_recepcionados">
                                                                        </div>
                                                                        <div class="input-group">
                                                                            <span class="input-group-addon"><i >Rango de fecha:</i></span>
                                                                            <input type="text" id="fecha_rango_busqueda_ri" class="form-control clearable">
                                                                        </div>
                                                                        <table id="gridRecibido_recepcion_interna"></table>
                                                                        <div id="pagerRecibido_recepcion_interna"></div>
                                                                    </div>
                                                                    <div role="tabpanel" class="tab-pane fade" id="profile_recepcion_interna2" aria-labelledby="profile-tab">

                                                                    </div>
                                                                    <div role="tabpanel" class="tab-pane fade" id="profile_recepcion_interna3" aria-labelledby="profile-tab">

                                                                    </div>
                                                                    <div id="containerGrillabandeja" class="box-body" style="display:none;">


                                                                        <%@include file="TramiteInterno/part/BusquedaBandeja.html" %>



                                                                        <table id="gridbandeja"></table>
                                                                        <div id="pagerbandeja"></div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </section>
                                                </div>
                                                <!--                                                <div role="tabpanel" id="divMis_documentos" class="tab-pane fade" aria-labelledby="home-tab">-->
                                                <div id="divMis_documentos" class="tabcontent" style="display: none;">
                                                    <section class="content">
                                                        <div class="box box-primary">
                                                            <div id="containerGrilla_regDocumento" class="box-body">
                                                                <table id="grid_regDocumento"></table>
                                                                <div id="pager_regDocumento"></div>
                                                            </div>
                                                        </div>
                                                    </section>
                                                </div>
                                                <!--                                                </div>-->
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
        <!-- Modals -->
        <%@include file="TramiteInterno/modals/modalDocref.html" %>
        <%@include file="TramiteInterno/modals/modalExpediente.html" %>
        <%@include file="TramiteInterno/modals/modalBusqDocumento.html" %>
        <!-- Overlays -->
        <%@include file="TramiteInterno/overlays/overlayMail.html" %>
        <%@include file="TramiteInterno/overlays/overlayViewsTramiteExterno.html" %>
        <%@include file="TramiteInterno/overlays/overlayViewsDocumentoMensaje.html" %>
        <!-- Siderbas -->
        <%@include file="TramiteInterno/siderbars/siderbarTramiteInterno.html" %>
        <!-- Uploaders -->
        <%@include file="../includes/uploader.html" %>


        <script src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-1.10.2.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jquery/js/jquery-ui-1.10.4.custom.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/i18n/grid.locale-es.js"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/jqgrid/js/jquery.jqGrid.min.js"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/BotBox/bootbox.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/sliptree-bootstrap-tokenfield/bootstrap-tokenfield.js"></script>
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/maskedinput/maskedinput.js"></script>
        <script src="${pageContext.request.contextPath}/js/plugins/daterangepicker/moment.js"></script>    
        <script src="${pageContext.request.contextPath}/js/plugins/daterangepicker/daterangepicker.js"></script>
        <!-- AdminLTE App -->
        <script src="${pageContext.request.contextPath}/js/AdminLTE/app.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/app_gene.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/app_validator.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/JSMensajes.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/jquery.tmpl.min.js" type="text/javascript"></script>
        <!--<script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/select2/js/select2.full.js"></script> -->
        <script type="application/javascript" src="${pageContext.request.contextPath}/js/plugins/maskedinput/maskedinput.js"></script>
        <!-- AdminLTE for demo purposes -->
        <script src="${pageContext.request.contextPath}/js/AdminLTE/demo.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/helper/JSSession.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSBandeja.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSBusquedaBandeja.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSModalExpediente.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSModalDocumentoRef.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSRecepcionExterna.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSTramiteExterno.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSRecepcionInterna.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSUploaderDocumento.js" type="text/javascript"></script>
        <!--<script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSDocumento.js" type="text/javascript"></script>-->
        <!--<script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSDocumentoMensaje.js" type="text/javascript"></script>-->
        <!--<script src="${pageContext.request.contextPath}/js/tramite/bandeja/JSBandeja.js" type="text/javascript"></script>-->
    </body>
</html>
