/*!
 * Author: Erick Escalante Olano
 * Description:
 *      Archivo JS para adminitracion 
 !**/

/*
 * Global variables. If you change any of these vars, don't forget 
 * to change the values in the less files!
 */
/*
 /* INITIALIZE 
 * ------------------------
 */
$('#container').data('idusuario_ri', 0);
$('#container').data('idarea_ri', 0);

$(function () {

    $('#pre_fecha_registro_manual_resolucion_recepcionExterna').mask("99/99/9999 99:99", {placeholder: "dd/mm/aaaa hh:mm"});

    initFormRecepcionInterna();
    // cargarGrillaRecibido();
    $('#home_recepcion_interna').bind('resize', function () {
        $("#grid_recepcion_interna").setGridWidth($('#home_recepcion_interna').width());
    }).trigger('resize');

    $('#profile_recepcion_interna').bind('resize', function () {
        $("#gridRecibido_recepcion_interna").setGridWidth($('#profile_recepcion_interna').width());
    }).trigger('resize');

});

/*EVENTS
 * ------------------------
 */
$(function () {

    $('#md_showfechamanual').click(function (e) {

        if ($('#md_showfechamanual').is(":checked")) {
            $('#md_pre_fecha_registro_manual_recepcionExterna').show();
        } else {
            $('#md_pre_fecha_registro_manual_recepcionExterna').hide();
            $('#md_pre_fecha_registro_manual_recepcionExterna').val('');
        }
    });
    /*Abrir Overlay Recepcion Externa*/
    $("#recepcionInterna").click(function (e) {
        $('#overlayRecepcionInterna').show(500);

    });
    $('.overlay_close_recepcion_interna').click(function (e) {
        $('#overlayRecepcionInterna').hide(500);

    });
    /*""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""*/
    $('.grilla_recibidos').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrilla_pre_recepcionInterna();
        }
    });

    /*Evento que carga la grilla de recibidos*/
    $('.grilla_recepcionados').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrilla_post_recepcionInterna();
        }
    });

    $("#btnRecibir_recepcion_interna").click(function (e) {
        pasarValoresJqgrid_recepcionInterna();
    });

    $('#showfechamanual_interno').click(function (e) {

        if ($('#showfechamanual_interno').is(":checked")) {
            $('#pre_fecha_registro_manual_recepcionInterno').show();
        } else {
            $('#pre_fecha_registro_manual_recepcionInterno').hide();
            $('#pre_fecha_registro_manual_recepcionInterno').val('');
        }
    });
});

/*-------------------*/
/* FUNCTIONS
 * ------------------------
 */

function initFormRecepcionInterna() {

    createRangePicker_por_recibir_ri();
    createRangePicker_recibidos_ri();

    autocompletarUsuarioPre_recepcionInterna();
    autocompletarArea_pre_recepcionInterna();
    crearGrilla_pre_recepcionInterna();

    autocompletarUsuarioPost_recepcionInterna()
    autocompletarArea_post_recepcionInterna()
    crearGrilla_post_recepcionInterna();




    $('#containerGrilla a:first').tab('show')
}

function crearGrilla_pre_recepcionInterna() {

    $("#grid_recepcion_interna").jqGrid({
//        data: mydata,
        datatype: function () {
            cargarGrilla_pre_recepcionInterna();
        },
        // url:'server.php?q=2',

        height: 250,
        width: 500,
        ignoreCase: true,
        multiselect: true,
        caption: "Lista de Recepción de Documentos",
        colNames: ["idrecepcioninterna", "iddocumento", "idmensaje", "idareacreacion", "idusuariocreacion", "Cod. Expediente", "Area Proviente", "Usuario Remitente", "Documento", "Asunto", "Fecha Envio"],
        colModel: [
            {
                name: 'idrecepcioninterna',
                index: 'idrecepcioninterna',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            },
            {
                name: 'iddocumento',
                index: 'iddocumento',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            },
            {
                name: 'idmensaje',
                index: 'idmensaje',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            },
            {
                name: 'idareacioncreacion',
                index: 'idareacioncreacion',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            },
            {
                name: 'idusuariocreacion',
                index: 'idusuariocreacion',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            },
            {
                name: 'codigoexpediente',
                index: 'codigoexpediente',
                editable: false,
                width: 90,
                search: false,
                hidden: true,
                align: "center"
            },
            {
                name: 'area_proviene',
                index: 'area_proviene',
                editable: false,
                width: 350,
                search: false,
                hidden: false
            },
            {
                name: 'remitente',
                index: 'remitente',
                editable: false,
                width: 350,
                hidden: false,
                search: false,
                align: "left"
            }
            ,
            {
                name: 'codigo_documento',
                index: 'codigo_documento',
                editable: false,
                width: 200,
                search: false,
                hidden: true
            },
            {
                name: 'asunto',
                index: 'asunto',
                editable: false,
                width: 350,
                search: false,
                hidden: false
            },
            {
                name: 'fecha_envio',
                index: 'fecha_envio',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            }
        ],
        pager: '#pager_recepcion_interna',
        storname: 'idexpediente',
        loadtext: 'Cargando datos...',
        recordtext: "{0} - {1} de {2} elementos",
        emptyrecords: 'No hay resultados',
        pgtext: 'Pág: {0} de {1}',
        rowNum: "10",
//        rowList: [10, 20, 30],
        //onSelectRow: viewGeometry,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        subGrid: true,
        subGridRowExpanded: function (subgrid_id, row_id) {
            var rowData = $('#grid_recepcion_interna').jqGrid('getRowData', row_id);
            var idmensaje = rowData.idmensaje;
            var subgrid_table_id, pager_id;
            subgrid_table_id = subgrid_id + "_t";
            pager_id = "p_" + subgrid_table_id;
            $("#" + subgrid_id).html("<table id='" + subgrid_table_id + "' class='scroll'></table><div id='" + pager_id + "' class='scroll'></div>");
            jQuery("#" + subgrid_table_id).jqGrid({
                //url: "subgrid.php?q=2&id=" + row_id,
                datatype: "local",
                height: 200,
                width: 650,
                // caption: "Alternativas",
                colNames: ['iddocumento', 'Codigo', 'Asunto'],
                colModel: [
                    {name: "iddocumento", index: "iddocumento", width: 50, key: true, hidden: true},
                    {name: "codigo", index: "codigo", width: 250, hidden: false},
                    {name: "asunto", index: "asunto", width: 400, hidden: false},
                ],
                rowNum: 20,
                pager: pager_id,
                sortname: 'num',
                sortorder: "asc",
                height: '100%'
            });

            $.ajaxCall(urlApp + '/DocumentoController/listarRegistrosDocumentoBE.htm', {poDocumentoBE: {IndOpSp: 6, iddocumento: idmensaje}}, false, function (response) {
                $("#" + subgrid_table_id).jqGrid('clearGridData');
                jQuery("#" + subgrid_table_id).jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
            });

//                    alert("akiiii"+rowData.iddocumento);
        }
        //multiselect: true
    });
    $("#grid_recepcion_interna").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}

function cargarGrillaDocumento_regDocumento() {
    $.ajaxCall(urlApp + '/DocumentoController/listarRegistrosDocumentoBE.htm', {poDocumentoBE: {IndOpSp: 1, idusuariocreacion: Usuario.idusuario}}, false, function (response) {
        $('#grid_regDocumento').jqGrid('clearGridData');
        jQuery("#grid_regDocumento").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}

function cargarGrilla_pre_recepcionInterna() {
    var UsuarioBE = {
        IndOpSp: 7,
        idusuario: Usuario.idusuario
    };
    $.ajaxCall(urlApp + '/UsuarioController/listObjectUsuarioBE.htm', {poUsuarioBE: UsuarioBE}, false, function (response) {
        if (response.length > 0) {
            var DocumentoBE = {
                IndOpSp: 1
                , idareadestino: Usuario.idarea
                , asunto: $('#pre_txtasunto_recepcion_interna').val()
                , codigo_documento: $.trim($('#pre_txtbusquedacodigodocumento_codigo_documento').val())
                , idremitente: ($.trim($('#pre_remitente_recepcion_interna').val()) === '') ? 0 : $('#container').data('idusuario_pre_ri')
                , idareacioncreacion: ($.trim($('#pre_area_recepcion_interna').val()) === '') ? 0 : $('#container').data('idarea_pre_ri')
                , codigoexpediente: ($.trim($('#pre_txtbusquedacodigo_expediente_recepcion_interna').val()) === '') ? 0 : $('#pre_txtbusquedacodigo_expediente_recepcion_interna').val()
                , fecha_inicio: fecha_inicio_busqueda_por_recibir_ri
                , fecha_fin: fecha_fin_busqueda_por_recibir_ri
                , rows: $("#grid_recepcion_interna").getGridParam("rowNum")
                , page: $("#grid_recepcion_interna").getGridParam("page")
            };
            $.ajaxCall(urlApp + '/DocumentoController/listarJQRegistrosDocumentoBE.htm', {poDocumentoBE: DocumentoBE}, false, function (response) {

                $("#grid_recepcion_interna").jqGrid('clearGridData');
                $("#grid_recepcion_interna")[0].addJSONData(response);
            });
        }

        else {
            bootbox.alert("No se encontro ningun registro para esta busqueda.");
        }

    });
}
function autocompletarUsuarioPre_recepcionInterna() {
    $("#pre_remitente_recepcion_interna").AutocompleteWithPobject(urlApp + "/UsuarioController/autocompletarUsuarios.htm", {}, "#pre_remitente_recepcion_interna", null,
            function (item) {
                console.log(item);
                return {
                    label: item.nombres,
                    idusuario: item.idusuario,
                }
            },
            function (event, ui) {
                $('#container').data('idusuario_pre_ri', ui.item.idusuario);


            });
}
function autocompletarArea_pre_recepcionInterna() {
    $("#pre_area_recepcion_interna").AutocompleteWithPobject(urlApp + "/AreaController/autocompletarAreaBE.htm", {}, "#pre_area_recepcion_interna", null,
            function (item) {
                console.log(item);
                return {
                    label: item.denominacion,
                    idarea: item.idarea,
                }
            },
            function (event, ui) {
                $('#container').data('idarea_pre_ri', ui.item.idarea);
            });
}
var fecha_inicio_busqueda_por_recibir_ri = moment().startOf('month').format('YYYY-MM-DD')
        , fecha_fin_busqueda_por_recibir_ri = moment().format('YYYY-MM-DD');
function createRangePicker_por_recibir_ri() {
    $('#fecha_rango_busqueda_por_recibir_ri').daterangepicker(
            {
                startDate: moment().startOf('month'),
                endDate: moment(),
                showDropdowns: true,
                showWeekNumbers: true,
                timePicker: false,
                timePickerIncrement: 1,
                timePicker12Hour: true,
                ranges: {
                    'Hoy': [moment(), moment()],
                    'Ayer': [moment().subtract('days', 1), moment().subtract('days', 1)],
                    'Hace 7 dias': [moment().subtract('days', 6), moment()],
                    'Hace 30 Dias': [moment().subtract('days', 29), moment()],
                    'Este mes': [moment().startOf('month'), moment().endOf('month')],
                    'Mes Anterior': [moment().startOf('month').subtract(1, 'month'), moment().endOf('month').subtract(1, 'month')],
                    'Este año': [moment().startOf('year'), moment().endOf('month')],
                    'Año Anterior': [moment().startOf('year').subtract(1, 'year'), moment().endOf('year').subtract(1, 'year')]
                },
                opens: "right",
                drops: "button",
                buttonClasses: ['btn btn-default'],
                applyClass: 'btn-small btn-primary',
                cancelClass: 'btn-small',
                format: 'DD/MM/YYYY',
                separator: ' a ',
                locale: {
                    format: 'DD/MM/YYYY',
                    applyLabel: 'Aplicar',
                    fromLabel: 'Desde',
                    toLabel: 'Hasta',
                    customRangeLabel: 'Personalizado',
                    daysOfWeek: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa'],
                    monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Setiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                    firstDay: 1
                }
            },
    function (start, end) {
        console.log("Callback has been called!");
        $('#reportrange span').html(start.format('D MMMM YYYY') + ' - ' + end.format('D MMMM YYYY'));
        startDate = start;
        endDate = end;

    }
    );
    //Set the initial state of the picker label
    $('#reportrange span').html(moment().subtract('days', 29).format('D MMMM YYYY') + ' - ' + moment().format('D MMMM YYYY'));

    $('#saveBtn').click(function () {
        console.log(startDate.format('D MMMM YYYY') + ' - ' + endDate.format('D MMMM YYYY'));
    });


    $('.dropdown-menu').click(function (event) {
        event.stopPropagation();
    });
    //seleccionando el data range

    $('#fecha_rango_busqueda_por_recibir_ri').on('apply.daterangepicker', function (ev, picker) {

        fecha_inicio_busqueda_por_recibir_ri = picker.startDate.format('YYYY-MM-DD');
        fecha_fin_busqueda_por_recibir_ri = picker.endDate.format('YYYY-MM-DD');
        cargarGrilla_pre_recepcionInterna();

    });


}



function crearGrilla_post_recepcionInterna() {

    $("#gridRecibido_recepcion_interna").jqGrid({
        datatype: function () {
            cargarGrilla_post_recepcionInterna();
        },
        // url:'server.php?q=2',

        height: 250,
        width: 500,
        ignoreCase: true,
        multiselect: false,
        caption: "Lista de Documentos Recepcionados",
        colNames: ["idmensaje", "idrecepcioninterna", "Cod. Expediente", "Area Proviente", "Usuario Remitente", "Documento", "Asunto", "Fecha Derivacion", "Fecha Recepcion"],
        colModel: [
            {
                name: 'idmensaje',
                index: 'idmensaje',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            },
            {
                name: 'idrecepcioninterna',
                index: 'idrecepcioninterna',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            },
            {
                name: 'codigoexpediente',
                index: 'codigoexpediente',
                editable: false,
                width: 90,
                search: false,
                hidden: true,
                align: "center"
            }
            ,
            {
                name: 'area_proviene',
                index: 'area_proviene',
                editable: false,
                width: 200,
                search: false,
                hidden: false
            },
            {
                name: 'remitente',
                index: 'remitente',
                editable: false,
                width: 200,
                hidden: false,
                search: false,
                align: "left"
            },
            {
                name: 'codigo_documento',
                index: 'codigo_documento',
                editable: false,
                width: 200,
                search: false,
                hidden: true
            },
            {
                name: 'asunto',
                index: 'asunto',
                editable: false,
                width: 250,
                search: false,
                hidden: false
            }
            , {
                name: 'fecha_envio',
                index: 'fecha_envio',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            }, {
                name: 'fechaderivacion',
                index: 'fechaderivacion',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            }
        ],
        pager: '#pagerRecibido_recepcion_interna',
        loadtext: 'Cargando datos...',
        recordtext: "{0} - {1} de {2} elementos",
        emptyrecords: 'No hay resultados',
        pgtext: 'Pág: {0} de {1}',
        rowNum: "10",
//        rowList: [10, 20, 30],
        //onSelectRow: viewGeometry,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        subGrid: true,
        subGridRowExpanded: function (subgrid_id, row_id) {
            var rowData = $('#gridRecibido_recepcion_interna').jqGrid('getRowData', row_id);
            var idmensaje = rowData.idmensaje;
            var subgrid_table_id, pager_id;
            subgrid_table_id = subgrid_id + "_t";
            pager_id = "p_" + subgrid_table_id;
            $("#" + subgrid_id).html("<table id='" + subgrid_table_id + "' class='scroll'></table><div id='" + pager_id + "' class='scroll'></div>");
            jQuery("#" + subgrid_table_id).jqGrid({
                //url: "subgrid.php?q=2&id=" + row_id,
                datatype: "local",
                height: 200,
                width: 650,
                // caption: "Alternativas",
                colNames: ['iddocumento', 'Codigo', 'Asunto'],
                colModel: [
                    {name: "iddocumento", index: "iddocumento", width: 50, key: true, hidden: true},
                    {name: "codigo", index: "codigo", width: 250, hidden: false},
                    {name: "asunto", index: "asunto", width: 400, hidden: false},
                ],
                rowNum: 20,
                pager: pager_id,
                sortname: 'num',
                sortorder: "asc",
                height: '100%'
            });

            $.ajaxCall(urlApp + '/DocumentoController/listarRegistrosDocumentoBE.htm', {poDocumentoBE: {IndOpSp: 6, iddocumento: idmensaje}}, false, function (response) {
                $("#" + subgrid_table_id).jqGrid('clearGridData');
                jQuery("#" + subgrid_table_id).jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
            });

//                    alert("akiiii"+rowData.iddocumento);
        }
        //multiselect: true
    });
    $("#gridRecibido_recepcion_interna").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});

}
function cargarGrilla_post_recepcionInterna() {
    var UsuarioBE = {
        IndOpSp: 7,
        idusuario: Usuario.idusuario
    };
    $.ajaxCall(urlApp + '/UsuarioController/listObjectUsuarioBE.htm', {poUsuarioBE: UsuarioBE}, false, function (response) {
        if (response.records > 0) {
            var DocumentoBE = {
                IndOpSp: 2
                , idareadestino: Usuario.idarea
                , asunto: $('#post_txtasunto_recepcion_interna').val()
                , codigo_documento: $.trim($('#post_txtbusquedacodigodocumento').val())
                , idremitente: ($.trim($('#post_remitente_recepcion_interna').val()) === '') ? 0 : $('#container').data('idusuario_post_ri')
                , idareacioncreacion: ($.trim($('#post_area_recepcion_interna').val()) === '') ? 0 : $('#container').data('idarea_post_ri')
                , codigoexpediente: ($.trim($('#post_txtbusquedacodigo_expediente_recepcion_interna').val()) === '') ? 0 : $('#post_txtbusquedacodigo_expediente_recepcion_interna').val()
                , fecha_inicio: fecha_inicio_busqueda_recibido_ri
                , fecha_fin: fecha_fin_busqueda_recibido_ri
                        /*============*/
                , rows: $("#gridRecibido_recepcion_interna").getGridParam("rowNum")
                , page: $("#gridRecibido_recepcion_interna").getGridParam("page")
            };

            $.ajaxCall(urlApp + '/DocumentoController/listarJQRegistrosDocumentoBE.htm', {poDocumentoBE: DocumentoBE}, false, function (response) {
                $('#gridRecibido_recepcion_interna').jqGrid('clearGridData');
                $("#gridRecibido_recepcion_interna")[0].addJSONData(response);
            });
        }
         else {
            bootbox.alert("No se encontro ningun registro para esta busqueda.");
        }
        ;
    });
}
function autocompletarUsuarioPost_recepcionInterna() {
    $("#post_remitente_recepcion_interna").AutocompleteWithPobject(urlApp + "/UsuarioController/autocompletarUsuarios.htm", {}, "#post_remitente_recepcion_interna", null,
            function (item) {
                console.log(item);
                return {
                    label: item.nombres,
                    idusuario: item.idusuario,
                }
            },
            function (event, ui) {
                $('#container').data('idusuario_post_ri', ui.item.idusuario);
            });
}
function autocompletarArea_post_recepcionInterna() {
    $("#post_area_recepcion_interna").AutocompleteWithPobject(urlApp + "/AreaController/autocompletarAreaBE.htm", {}, "#post_area_recepcion_interna", null,
            function (item) {
                console.log(item);
                return {
                    label: item.denominacion,
                    idarea: item.idarea,
                }
            },
            function (event, ui) {
                $('#container').data('idarea_post_ri', ui.item.idarea);
            });
}
var fecha_inicio_busqueda_recibido_ri = moment().startOf('month').format('YYYY-MM-DD')
        , fecha_fin_busqueda_recibido_ri = moment().format('YYYY-MM-DD');
function createRangePicker_recibidos_ri() {
    $('#fecha_rango_busqueda_ri').daterangepicker(
            {
                startDate: moment().startOf('month'),
                endDate: moment(),
                showDropdowns: true,
                showWeekNumbers: true,
                timePicker: false,
                timePickerIncrement: 1,
                timePicker12Hour: true,
                ranges: {
                    'Hoy': [moment(), moment()],
                    'Ayer': [moment().subtract('days', 1), moment().subtract('days', 1)],
                    'Hace 7 dias': [moment().subtract('days', 6), moment()],
                    'Hace 30 Dias': [moment().subtract('days', 29), moment()],
                    'Este mes': [moment().startOf('month'), moment().endOf('month')],
                    'Mes Anterior': [moment().startOf('month').subtract(1, 'month'), moment().endOf('month').subtract(1, 'month')],
                    'Este año': [moment().startOf('year'), moment().endOf('month')],
                    'Año Anterior': [moment().startOf('year').subtract(1, 'year'), moment().endOf('year').subtract(1, 'year')]

                },
                opens: "right",
                drops: "button",
                buttonClasses: ['btn btn-default'],
                applyClass: 'btn-small btn-primary',
                cancelClass: 'btn-small',
                format: 'DD/MM/YYYY',
                separator: ' a ',
                locale: {
                    format: 'DD/MM/YYYY',
                    applyLabel: 'Aplicar',
                    fromLabel: 'Desde',
                    toLabel: 'Hasta',
                    customRangeLabel: 'Personalizado',
                    daysOfWeek: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa'],
                    monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Setiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                    firstDay: 1
                }
            },
    function (start, end) {
        console.log("Callback has been called!");
        $('#reportrange span').html(start.format('D MMMM YYYY') + ' - ' + end.format('D MMMM YYYY'));
        startDate = start;
        endDate = end;

    }
    );
    //Set the initial state of the picker label
    $('#reportrange span').html(moment().subtract('days', 29).format('D MMMM YYYY') + ' - ' + moment().format('D MMMM YYYY'));

    $('#saveBtn').click(function () {
        console.log(startDate.format('D MMMM YYYY') + ' - ' + endDate.format('D MMMM YYYY'));
    });


    $('.dropdown-menu').click(function (event) {
        event.stopPropagation();
    });
    //seleccionando el data range

    $('#fecha_rango_busqueda_ri').on('apply.daterangepicker', function (ev, picker) {

        fecha_inicio_busqueda_recibido_ri = picker.startDate.format('YYYY-MM-DD');
        fecha_fin_busqueda_recibido_ri = picker.endDate.format('YYYY-MM-DD');
        cargarGrilla_post_recepcionInterna();

    });


}

function  pasarValoresJqgrid_recepcionInterna() {

    var s;
    s = jQuery("#grid_recepcion_interna").jqGrid('getGridParam', 'selarrrow');

    if (s === 0) {
        bootbox.alert("Seleccionar como minimo 01 Documento a recibir.");
    }
    else {

        var recibir = function () {
            Arrayexpediente = new Array();
            for (i = 0; i < s.length; i++) {
                Arrayexpediente.push({
                    idrecepcioninterna: jQuery("#grid_recepcion_interna").getRowData(s[i]).idrecepcioninterna,
                    iddocumento: jQuery("#grid_recepcion_interna").getRowData(s[i]).iddocumento,
                    idmensaje: jQuery("#grid_recepcion_interna").getRowData(s[i]).idmensaje,
                    idusuariocreacion: jQuery("#grid_recepcion_interna").getRowData(s[i]).idusuariocreacion,
                    idusuariorecepciona: Usuario.idusuario,
                    idareadestino: Usuario.idarea,
                    fecha_envio: ($.trim($('#pre_fecha_registro_manual_recepcionInterno').val()) == ''
                            || $.trim($('#pre_fecha_registro_manual_recepcionInterno').val()) == 'dd/mm/aaaa hh:mm') ? '' : $('#pre_fecha_registro_manual_recepcionInterno').val(),
                    idareaproviene: jQuery("#grid_recepcion_interna").getRowData(s[i]).idareacioncreacion
                });
            }

            $.ajaxCall(urlApp + '/DocumentoController/actualizarRegistrosDocumentoBE.htm', {polistDocumentoBE: Arrayexpediente}, false, function (response) {
                if (response === -1) {
                    bootbox.alert("Falta asignar un usuario resolutor a esta area.");
                }
                else {
                    cargarGrilla_pre_recepcionInterna();
                    cargarGrilla_post_recepcionInterna();
                }
            });
        }

        bootbox.confirm(Mensajes.deseaRecibirDocumentos, function (result) {
            if (result == true) {
                recibir();
            }
            else {

            }
        });
    }
}





