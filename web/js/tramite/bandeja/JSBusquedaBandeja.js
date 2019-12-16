(function () {

    var indopsp = 3;
    $(function () {
        autocompletarUsuarioBusqueda();
        autocompletarAreaBusqueda();
        createRangePicker();
        $("#btnsearch_avanzado").click(function (e) {
            busquedaAvanzada();
        });
    });

    /*====================BUSQUEDA DE USUARIO BUSQUEDA ======================*/
    var arrayUsuarioBusqueda = new Array();
    function autocompletarUsuarioBusqueda() {
        $("#txtusuariobusqueda_correo").AutocompleteMultiple(urlApp + "/UsuarioController/autocompletarUsuariosWithArea.htm", "#txtusuariobusqueda_correo", null,
                function (item) {
                    return {
                        label: item.nombres,
                        idusuario: item.idusuario,
                        idarea: item.idarea
                    }
                },
                function (event, ui) {
                    arrayUsuarioBusqueda.push([ui.item.idusuario]);

                    $('#container').data(ui.item.label, ui.item.idusuario);
                    console.log(ui.item.label);
                    console.log(ui.item.idusuario);
                    arrayUsuarioBusqueda = eliminateDuplicates(arrayUsuarioBusqueda);
                });

        $('#txtusuariobusqueda_correo').on('tokenfield:removedtoken', function (e) {
            console.log(e.attrs.value);
            eliminarUsuarioBusqueda($('#container').data(e.attrs.value));
        }).tokenfield();
    }

    function eliminarUsuarioBusqueda(valor) {
        console.log(valor);
        console.log(arrayUsuarioBusqueda);
        arrayUsuarioBusqueda = jQuery.grep(arrayUsuarioBusqueda, function (value) {
            return  parseInt(value) !== parseInt(valor);
        });
    }

    /*====================FIN BUSQUEDA DE USUARIO BUSQUEDA ======================*/



    /*====================BUSQUEDA DE AREA BUSQUEDA ======================*/
    var arrayAreaBusqueda = new Array();
    function autocompletarAreaBusqueda() {
        $("#txtareabusqueda_correo").AutocompleteMultiple(urlApp + "/AreaController/autocompletarAreawithjefeBE.htm", "#txtareabusqueda_correo", null,
                function (item) {
                    return {
                        label: item.denominacion,
                        idusuario: item.idusuariojefe,
                        idarea: item.idarea
                    }
                },
                function (event, ui) {
                    arrayAreaBusqueda.push([ui.item.idarea]);
                    $('#container').data(ui.item.label, ui.item.idarea);
                    arrayAreaBusqueda = eliminateDuplicates(arrayAreaBusqueda);
                    console.log(arrayAreaBusqueda);
                });
        $('#txtareabusqueda_correo').on('tokenfield:removedtoken', function (e) {
            eliminarareaBusqueda($('#container').data(e.attrs.value));
        }).tokenfield();

    }

    function eliminarareaBusqueda(valor) {
        arrayAreaBusqueda = jQuery.grep(arrayAreaBusqueda, function (value) {
            return  parseInt(value) !== parseInt(valor);
        });
        console.log(arrayAreaBusqueda);
    }



    /*Funcion para eliminar duplicados de array*/
    function eliminateDuplicates(arr) {
        var i,
                len = arr.length,
                out = [],
                obj = {};
        for (i = 0; i < len; i++) {
            obj[arr[i]] = 0;
        }
        for (i in obj) {
            out.push(i);
        }
        return out;
    }
    /*====================FIN BUSQUEDA DE AREA BUSQUEDA ======================*/

    /*=================CREADO EL CALENDARIO DE RANGOS =========================*/
    var fecha_inicio_busqueda = moment().startOf('month').format('DD/MM/YYYY')
            , fecha_fin_busqueda = moment().format('DD/MM/YYYY');
    function createRangePicker() {
        $('#fecha_rango_busqueda').daterangepicker(
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
                    'Mes Anterior': [moment().startOf('month').subtract(1,'month'), moment().endOf('month').subtract(1,'month')],
                    'Este año': [moment().startOf('year'), moment().endOf('month')],
                    'Año Anterior': [moment().startOf('year').subtract(1,'year'), moment().endOf('year').subtract(1,'year')]
             
                    },
                    opens: "center",
                    drops: "up",
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

        $('#fecha_rango_busqueda').on('apply.daterangepicker', function (ev, picker) {
            fecha_inicio_busqueda = picker.startDate.format('DD/MM/YYYY');
            fecha_fin_busqueda = picker.endDate.format('DD/MM/YYYY');
            ;
        });


    }

    /*=================CREADO EL CALENDARIO DE RANGOS =========================*/

    var array__indsrecepcion = new Array();
    var array__indsrespuesta = new Array();
    var array__prioridad_busqueda = new Array();
    var ind_vig_vencido=null;
    var ind_vigentes = true;
    var ind_vencido = true;

    array__indsrecepcion = ["true", "false"];
    array__indsrespuesta = ["true", "false"];
    array__prioridad_busqueda = ["1", "2", "3"];

    $(function () {


        $('#optionsearch').change(function (e) {
            alert($(this).val());
            indopsp = $(this).val();
        });



        $('input[name=opt_recepcion_busqueda').click(function (e) {
            var txt = $(this).val()
            if ($(this).is(":checked")) {
                array__indsrecepcion.push(txt);
            } else {
                array__indsrecepcion = jQuery.grep(array__indsrecepcion, function (n, i) {
                    return (n !== txt);
                });
            }
        });

        /*Activado y desactivado de filtro de busqueda*/
        $('input[name=opt_respuesta_busqueda').click(function (e) {
            var txt = $(this).val()
            if ($(this).is(":checked")) {
                array__indsrespuesta.push(txt);
            } else {
                array__indsrespuesta = jQuery.grep(array__indsrespuesta, function (n, i) {
                    return (n !== txt);
                });
            }
        });
        /*Activado y desactivado de prioridad de busqueda*/
        $('input[name=opt_prioridad_busqueda').click(function (e) {
            var txt = $(this).val()
            if ($(this).is(":checked")) {
                array__prioridad_busqueda.push(txt);
            } else {
                array__prioridad_busqueda = jQuery.grep(array__prioridad_busqueda, function (n, i) {
                    return (n !== txt);
                });
            }
        });


        /*vigente no vigentes de prioridad de busqueda*/
        $('#estado_vigente').click(function (e) {
            if ($(this).is(":checked")) {
                ind_vigentes = true;
            }
            else{
                ind_vigentes = false;
            }
        });
         $('#estado_vencido').click(function (e) {
            if ($(this).is(":checked")) {
                ind_vencido = true;
            }
            else{
                ind_vencido = false;
            }
        });
        
    });
    /*Crear buscador avanzado*/

    function busquedaAvanzada() {

        if(ind_vigentes===true && ind_vencido===false){
            ind_vig_vencido=false;
        }
         if(ind_vigentes===false && ind_vencido===true){
            ind_vig_vencido=true;
        }
         if((ind_vigentes===true && ind_vencido===true) ||(ind_vigentes===false && ind_vencido===false) ){
            ind_vig_vencido=null;
        }
        $('#container').data('_vencidosactivos', ind_vig_vencido);

        $('#container').data('_idsarea', arrayAreaBusqueda.join());
        $('#container').data('_idsusuarioenvia', arrayUsuarioBusqueda.join());
        $('#container').data('_asunto', $('#txtAsunto_busq').val());
        $('#container').data('_mensaje', $('#txtMensaje_busq').val());
        $('#container').data('_indsrecepcion', array__indsrecepcion.join());
        $('#container').data('_indsrespuesta', array__indsrespuesta.join());
        $('#container').data('_indsprioridad', array__prioridad_busqueda.join());
        $('#container').data('fechainicio', fecha_inicio_busqueda);
        $('#container').data('fechafin', fecha_fin_busqueda);

        cargarGrilla_mensaje_busqueda()

    }


    function cargarGrilla_mensaje_busqueda() {

        var Bandeja = {
            IndOpSp: indopsp,
            idusuariodestino: Usuario.idusuario,
            rows: $("#gridbandeja").getGridParam("rowNum"),
            page: $("#gridbandeja").getGridParam("page"),
            /*para la busqueda avanzada*/
            b_idsarea: $('#container').data('_idsarea'),
            b_idsusuarioenvia: $('#container').data('_idsusuarioenvia'),
            b_asunto: $('#container').data('_asunto'),
            b_mensaje: $('#container').data('_mensaje'),
            b_indsrecepcion: $('#container').data('_indsrecepcion'),
            b_indsrespuesta: $('#container').data('_indsrespuesta'),
            b_indsprioridad: $('#container').data('_indsprioridad'),
            b_vencidosactivos: $('#container').data('_vencidosactivos'),
            b_fechainicio: $('#container').data('fechainicio'),
            b_fechafin: $('#container').data('fechafin'),
            limite: $("#gridbandeja").getGridParam("rowNum"),
            offsete: 0
        };

        $.ajaxCall(urlApp + '/BandejaController/listarJQRegistrosBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
            $('#gridbandeja').jqGrid('clearGridData');
            $("#gridbandeja")[0].addJSONData(response);
        });
    }

})();