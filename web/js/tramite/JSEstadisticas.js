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

var fecha = new Date();
var anio = fecha.getFullYear();

$(function () {
    getCaptcha();
    document.getElementById("txtIanio").value = anio;
    //autocompletarProcedimientos();
});


/*EVENTS
 * ------------------------
 */
$(function () {


    $("#btnCancelar").click(function (e) {
        $('.form-control').val('');
    });
    $("#btnNuevo").click(function (e) {
        //alert(1);
        mostrarestadisticas($('#txtIanio').val(), $('#txtCodigo').val());
    });

});


/* FUNCTIONS
 * ------------------------
 */



function getCaptcha() {

    $.ajax({
        url: urlApp + '/EstadisticaController/getCaptcha.htm',
        cache: false,
        type: 'POST',
        async: false,
        success: function (data) {
            $('#imgcatpcha').attr('src', data);
        }
    });
    //PintarRowGrilla("grid", 'bindobservado', 'false', '#E21E27', '#FFFFFF')
}


function mostrarestadisticas(anio) {

    var area = "";
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#formexpediente');
    switch (resulValidacion) {
        case 0:

            $.ajaxCall(urlApp + '/EstadisticaController/listObjectEstadisticaBE.htm', {poEstadoflujoBE: {IndOpSp: 2, idestadoflujo: anio}}, false, function (respuesta) {




                $('#estadistica').highcharts({
                    title: {
                        text: 'Estadistica de Ingresos de Mesa de Partes',
                        x: -20 //center
                    },
                    subtitle: {
                        text: 'Fuente: SISTDOC',
                        x: -20
                    },
                    xAxis: {
                        categories: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                            'Jul', 'Ago', 'Set', 'Oct', 'Nov', 'Dic']
                    },
                    yAxis: {
                        title: {
                            text: 'Unidades'
                        },
                        plotLines: [{
                                value: 0,
                                width: 1,
                                color: '#808080'
                            }]
                    },
                    tooltip: {
                        valueSuffix: ' Unid'
                    },
                    legend: {
                        layout: 'vertical',
                        align: 'right',
                        verticalAlign: 'middle',
                        borderWidth: 0
                    },
                    series: [{
                            name: 'Tokyo',
                            data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
                        }, {
                            name: 'New York',
                            data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
                        }, {
                            name: 'Berlin',
                            data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
                        }, {
                            name: 'London',
                            data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
                        }]
                });
            });

            break;
        case -1:
            bootbox.alert(Mensajes.camposRequeridos);
            break;
        case -2:
            bootbox.alert(Mensajes.camposIncorrectos);
            break;

    }



}

function createSeries(response) {
    var series = new Array();
    var item_series = new Object();
    item_series.name = ""
    item_series.data = [];
    $.each(response, function (item, value) {


    })
    return series;
}

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

function getarrayArea(response) {
    var array_areas = new Array();
    for (j = 0; j < response.length; j++) {
        array_areas.push(response[j][1]);
    }
    return eliminateDuplicates(array_areas);
}

function obtenerCantidadMes(response) {
    for (i = 0; i < meses.length; i++) {
        for (j = 0; j < response.length; j++) {

            if (meses[i].numes === response[j][0]) {

            }
            else {

            }

        }
    }
}

function checkAdult(age) {
    return age >= 18;
}

var meses = [
    {nummes: 1, mes: 'Enero'}, {nummes: 2, mes: 'Febrero'}, {nummes: 3, mes: 'Marzo'}, {nummes: 4, mes: 'Abril'}, {nummes: 5, mes: 'Mayo'}, {nummes: 6, mes: 'Junio'},
    {nummes: 7, mes: 'Julio'}, {nummes: 8, mes: 'Agosto'}, {nummes: 9, mes: 'Setiembre'}, {nummes: 10, mes: 'Octubre'}, {nummes: 11, mes: 'Noviembre'}, {nummes: 12, mes: 'Diciembre'}
];











