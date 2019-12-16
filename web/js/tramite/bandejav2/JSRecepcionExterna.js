/*!
 * Author: Erick Escalante Olano
 * Description:
 *      Archivo JS para adminitracion 
 !**/

var loadfechas = function () {
    $('#txtfecha_manual').val('');
    $('#txthora_manual').val('');
    $('#txtfecha_manual').mask("99/99/9999", {placeholder: "dd/mm/aaaa"});
    $('#txthora_manual').mask("99:99", {placeholder: "HH:MM"});
    jQuery.Calendario('#txtfecha_manual');
    jQuery.Hora('#txthora_manual');

    $('#showfechamanual').click(function (e) {

        if ($('#showfechamanual').is(":checked")) {
            $('#txtfecha_manual').show();
            $('#txthora_manual').show();
        } else {
            $('#txtfecha_manual').hide();
            $('#txthora_manual').hide();
            $('#txtfecha_manual').val('');
            $('#txthora_manual').val('');
        }
    });

}

$(function () {
    loadfechas();
    //  initFormRecepcionInterna();
    $('#pre_fecha_registro_manual_recepcionExterna').mask("99/99/9999 99:99", {placeholder: "dd/mm/aaaa hh:mm"});
    crearGrillapoRecibir_recepcionExterna();
    //cargarGrillaporRecibir_recepcionExterna();
    //cargarGrilla();
    crearGrillaRecibido_recepcionExterna();
    // cargarGrillaRecibido();
    $('#home').bind('resize', function () {
        $("#grid_recepcion_externa").setGridWidth($('#home').width());
    }).trigger('resize');

    $('#profile').bind('resize', function () {
        $("#gridRecibido_recepcionExterna").setGridWidth($('#profile').width());
    }).trigger('resize');


});

/*EVENTS
 * ------------------------
 */
$(function () {



    /*Abrir Overlay Recepcion Externa*/
    $("#recepcionExterna").click(function (evento) {
        $('#overlayRecepcionExterna').show(500);
    });

    $('.overlay_recepcion_externa').click(function () {
        $('#overlayRecepcionExterna').hide(500);
    });



    $("#recibido").click(function (e) {
        $("#containerGrilla").hide();
        $("#recibidoH").show();
    });

    $("#porRecibir").click(function (e) {
        $("#recibidoH").hide();
        $("#containerGrilla").show();
    });


    $('.grilla_recibidos_recepcionExterna').on('keypress', function (e) {
        if (e.keyCode === 13) {
            //  alert(1)
            cargarGrillaporRecibir_recepcionExterna();
        }
    });

    /*Evento que carga la grilla de recibidos*/
    $('.grilla_recepcionados_recepcionExterna').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrillaRecibido_recepcionExterna();

        }
    });

    $("#btnRecibir_recepcionExterna").click(function (e) {
        recibir_Expediente_recepcionExterna();
    });


});

/* FUNCTIONS
 * ------------------------
 */
function initFormRecepcionInterna() {
    //  $('#containerGrilla a:first').tab('show')
//alert(1)

}
/* grilla recepcion
 * ------------------------
 */
function crearGrillapoRecibir_recepcionExterna() {

    $("#grid_recepcion_externa").jqGrid({
        datatype: function () {
            cargarGrillaporRecibir_recepcionExterna();
        },
        height: 250,
        width: 500,
        ignoreCase: true,
        multiselect: true,
        caption: "Lista de Recepción de Expedientes",
        colNames: ["Derivar", "Edit", "Del", "idrecepcion", "idexpediente", "Codigo", "Area", "Procedimiento", "Asunto", "Nombre/RazonSocial", "Apellidos", "Dirección", "Telefono", "correo", "Fecha Registro", "estado", "bindentregado"],
        colModel: [
            {
                name: 'derivar',
                index: 'derivar',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            }

            ,
            {
                name: 'edit',
                index: 'edit',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: true
            },
            {
                name: 'del',
                index: 'del',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: true
            },
            {
                name: 'idrecepcion',
                index: 'idrecepcion',
                editable: false,
                align: "center",
                width: 80,
                search: false,
                hidden: true
            },
            {
                name: 'idexpediente',
                index: 'idexpediente',
                editable: false,
                width: 150,
                search: false,
                hidden: true
            },
            {
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 70,
                hidden: false,
                search: false,
                align: "center"
            },
            {
                name: 'area',
                index: 'area',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'procedimiento',
                index: 'procedimiento',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'asunto',
                index: 'asunto',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            }, {
                name: 'nombre_razonsocial',
                index: 'nombre_razonsocial',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'apellidos',
                index: 'apellidos',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'direccion',
                index: 'direccion',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'telefono',
                index: 'telefono',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'correo',
                index: 'correo',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            }, {
                name: 'sfecharegistro',
                index: 'sfecharegistro',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                search: false,
                hidden: true
            }, {
                name: 'bindentregado',
                index: 'bindentregado',
                editable: false,
                width: 150,
                search: false,
                hidden: true
            }],
        pager: '#pager_recepcion_externa',
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
        //multiselect: true
    });
    $("#grid_recepcion_externa").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}
var firt_search_recibir = false;
function cargarGrillaporRecibir_recepcionExterna() {
    firt_search_recibir = true;
    var ExpedienteBE = {
        IndOpSp: 4
        , idarea: Usuario.idarea
        , idusuariocargo: ($.trim($('#pre_txtbusquedaanio_recepcionExterna').val()) === '') ? 0 : $.trim($('#pre_txtbusquedaanio_recepcionExterna').val())
        , codigo: ($.trim($('#pre_txtbusquedacodigoexpediente_recepcionExterna').val()) === '') ? 0 : $.trim($('#pre_txtbusquedacodigoexpediente_recepcionExterna').val())
        , nombre_razonsocial: $('#pre_txtbusqueda_recepcionExterna').val()
        , rows: $("#grid_recepcion_externa").getGridParam("rowNum")
        , page: $("#grid_recepcion_externa").getGridParam("page")
    };

    $.ajaxCall(urlApp + '/ExpedienteController/listarJQRegistrosExpedienteBE.htm', {poExpedienteBE: ExpedienteBE}, false, function (response) {
        $('#cantporrecibir').text(response.records);
        if (response.records > 0) {
            $('#grid_recepcion_externa').jqGrid('clearGridData');
            $("#grid_recepcion_externa")[0].addJSONData(response);
        }
        else {
            if (firt_search_recibir) {
                bootbox.alert("No se encontro ningun registro para esta busqueda.");
            } else {
                firt_search_recibir = true;
            }
            $('#grid_recepcion_externa').jqGrid('clearGridData');
        }
    });
}
/* grilla recibidos
 * ------------------------
 */
function crearGrillaRecibido_recepcionExterna() {

    $("#gridRecibido_recepcionExterna").jqGrid({
        //  data: mydata,
        datatype: function () {
            cargarGrillaRecibido_recepcionExterna();
        },
        height: 250,
        width: 500,
        ignoreCase: true,
        //multiselect: true,
        caption: "Lista de Expedientes Recepcionados",
        colNames: ["Edit", "Del", "idexpediente", "C&oacute;digo", "Area", "Procedimiento", "Asunto", "Nombre/RazonSocial", "Apellidos", "Dirección", "Tel&eacute;fono", "Correo", "Fecha Recepci&oacute;n", "estado", "bindentregado"],
        colModel: [
            {
                name: 'edit',
                index: 'edit',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: true
            },
            {
                name: 'del',
                index: 'del',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: true
            },
            {
                name: 'idexpediente',
                index: 'idexpediente',
                editable: false,
                width: 150,
                search: false,
                hidden: true
            },
            {
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 70,
                hidden: false,
                search: false,
                align: "center"
            },
            {
                name: 'area',
                index: 'area',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'procedimiento',
                index: 'procedimiento',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'asunto',
                index: 'asunto',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            }, {
                name: 'nombre_razonsocial',
                index: 'nombre_razonsocial',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'apellidos',
                index: 'apellidos',
                editable: false,
                width: 150,
                search: false,
                hidden: false

            },
            {
                name: 'direccion',
                index: 'direccion',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'telefono',
                index: 'telefono',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'correo',
                index: 'correo',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            }, {
                name: 'sfecharegistro',
                index: 'sfecharegistro',
                editable: false,
                width: 150,
                search: false,
                hidden: false
            },
            {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                search: false,
                hidden: true
            }, {
                name: 'bindentregado',
                index: 'bindentregado',
                editable: false,
                width: 150,
                hidden: true
            }],
        pager: '#pagerRecibido_recepcionExterna',
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
        //multiselect: true
    });
    $("#gridRecibido_recepcionExterna").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}
var firt_search_recibido = false;
function cargarGrillaRecibido_recepcionExterna() {

    var ExpedienteBE = {
        IndOpSp: 5
        , idarea: Usuario.idarea
        , idusuariocargo: ($.trim($('#post_txtbusquedaanio_recepcionExterna').val()) === '') ? 0 : $.trim($('#post_txtbusquedaanio_recepcionExterna').val())
        , codigo: ($.trim($('#post_txtbusquedacodigoexpediente_recepcionExterna').val()) === '') ? 0 : $.trim($('#post_txtbusquedacodigoexpediente_recepcionExterna').val())
        , nombre_razonsocial: $('#post_txtbusqueda_recepcionExterna').val()
        , rows: $("#gridRecibido_recepcionExterna").getGridParam("rowNum")
        , page: $("#gridRecibido_recepcionExterna").getGridParam("page")

    };

    $.ajaxCall(urlApp + '/ExpedienteController/listarJQRegistrosExpedienteBE.htm', {poExpedienteBE: ExpedienteBE}, false, function (response) {
        firt_search_recibido = true;
        $('#cantporrecibidos').text(response.records);
        if (response.records > 0) {

            $("#gridRecibido_recepcionExterna")[0].addJSONData(response);
        }
        else {
            $('#gridRecibido_recepcionExterna').jqGrid('clearGridData');
            if (firt_search_recibido) {
                bootbox.alert("No se encontro ningun registro para esta busqueda.");
            } else {
                firt_search_recibido = true;
            }
        }




    });


}
/* recepcion de expediente
 * ------------------------
 */
function  recibir_Expediente_recepcionExterna() {
    var s;
    s = jQuery("#grid_recepcion_externa").jqGrid('getGridParam', 'selarrrow');

    if (s == 0) {
        bootbox.alert(Mensajes.sinExpediente);
    }
    else {
        var recibir = function () {
            Arrayexpediente = new Array();
            for (i = 0; i < s.length; i++) {
                Arrayexpediente.push({
                    idexpediente: jQuery("#grid_recepcion_externa").getRowData(s[i]).idrecepcion,
                    idusuariorecepciona: Usuario.idusuario,
                    sfecharecepciona: ($.trim($('#pre_fecha_registro_manual_recepcionExterna').val()) == ''
                            || $.trim($('#pre_fecha_registro_manual_recepcionExterna').val()) == 'dd/mm/aaaa hh:mm') ? '' : $('#pre_fecha_registro_manual_recepcionExterna').val(),
                    idarea: Usuario.idarea
                });
            }

            $.ajaxCall(urlApp + '/ExpedienteController/actualizarRegistrosExpedienteBE.htm', {polistExpedienteBE: Arrayexpediente}, false, function (response) {
                if (response === -1) {
                    bootbox.alert("Falta asignar un usuario resolutor a esta area.");
                }
                else {
                    cargarGrillaporRecibir_recepcionExterna();
                    cargarGrillaRecibido_recepcionExterna();

                }
            });
        };



        bootbox.confirm(Mensajes.deseaRecibirExpedientes, function (result) {
            if (result == true) {
                recibir();
            }
            else {

            }
        });

        /* bootbox.dialog({message: ' <div class="form-group"> <label>Fecha de recepci&oacute;n:</label> <input obligatorio id="txt_fecha_recepcion_Interna" class="form-control input-sm" type="text" placeholder="Ingrese fecha de recepci&oacute;n" maxlength="100"> </div>'
         +'<hr><button  type="button" class="btn btn-primary btn-sm">Guardar</button> <button onclick="document.getElementsByClassName(\'bootbox-close-button close\').click();" type="button" class="btn btn-default btn-sm">Cancelar</button> '
         ,title:'Registro de recepci&oacute;n externa'})*/


    }
}

