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
$(function () {
    initForm();
    crearGrilla();
    cargarGrilla();
    $('#containerGrilla').bind('resize', function () {
        $("#grid").setGridWidth($('#containerGrilla').width());
    }).trigger('resize');
});

/*EVENTS
 * ------------------------
 */
$(function () {

    $("#btnNuevo").click(function (e) {

        if ($("#btnNuevo").text() === 'Nuevo') {
            $.HabilitarForm('#form');
            $("#btnNuevo").text('Guardar');
            return;
        }
        if ($("#btnNuevo").text() === 'Guardar') {
            save();
            return;
        }

        if ($("#btnNuevo").text() === 'Actualizar') {
            actualizar();
        }
        e.stopPropagation();
    });

    $("#btnCancelar").click(function (e) {
        $.DesabilitarForm('#form');
        $.LimpiarForm('#form');
        $("#btnNuevo").text('Nuevo');
    });


});


/* FUNCTIONS
 * ------------------------
 */
function initForm() {
    $.DesabilitarForm('#form');
    $.LimpiarForm('#form');
    $("#btnNuevo").text('Nuevo');
    loadCombos();
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        caption: "Lista Bandeja",
        colNames: ["Edit", "Del", "idbandeja", "iddocumento", "idareaproviene", "idareadestino", "idusuarioenvia", "idusuariodestino", "bindrecepcion", "idusuariorecepciona", "fecharecepciona", "fechalectura", "fechaderivacion", "fecharegistro", "estado"],
        colModel: [
            {
                name: 'edit',
                index: 'edit',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: false
            },
            {
                name: 'del',
                index: 'del',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: false
            },
            {
                name: 'idbandeja',
                index: 'idbandeja',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'iddocumento',
                index: 'iddocumento',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'idareaproviene',
                index: 'idareaproviene',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'idareadestino',
                index: 'idareadestino',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'idusuarioenvia',
                index: 'idusuarioenvia',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'idusuariodestino',
                index: 'idusuariodestino',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'bindrecepcion',
                index: 'bindrecepcion',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'idusuariorecepciona',
                index: 'idusuariorecepciona',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'fecharecepciona',
                index: 'fecharecepciona',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'fechalectura',
                index: 'fechalectura',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'fechaderivacion',
                index: 'fechaderivacion',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'fecharegistro',
                index: 'fecharegistro',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: false
            }],
        pager: '#pager',
        //onSelectRow: viewGeometry,
        viewrecords: true,
        shrinkToFit: false,
        //multiselect: true
    });
    jQuery("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false});
}

function cargarGrilla() {
    $.ajaxCall(urlApp + '/BandejaController/listarRegistrosBandejaBE.htm', {poBandejaBE: {IndOpSp: 1}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Bandeja = {
                idbandeja: $('#txtIdbandeja').val(),
                iddocumento: $('#txtIddocumento').val(),
                idareaproviene: $('#txtIdareaproviene').val(),
                idareadestino: $('#txtIdareadestino').val(),
                idusuarioenvia: $('#txtIdusuarioenvia').val(),
                idusuariodestino: $('#txtIdusuariodestino').val(),
                bindrecepcion: $('#txtBindrecepcion').val(),
                idusuariorecepciona: $('#txtIdusuariorecepciona').val(),
                fecharecepciona: $('#txtFecharecepciona').val(),
                fechalectura: $('#txtFechalectura').val(),
                fechaderivacion: $('#txtFechaderivacion').val(),
                fecharegistro: $('#txtFecharegistro').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/BandejaController/insertarBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }
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

function edit(id) {
    $('#container').data('idedit', id);
    var rowIds = $('#grid').jqGrid('getDataIDs');

    for (var i = 1; i <= rowIds.length; i++) {
        rowData = $('#grid').jqGrid('getRowData', i);
        if (rowData.idbandeja === id.toString()) {
            $('#txtIdbandeja').val(rowData.idbandeja);
            $('#txtIddocumento').val(rowData.iddocumento);
            $('#txtIdareaproviene').val(rowData.idareaproviene);
            $('#txtIdareadestino').val(rowData.idareadestino);
            $('#txtIdusuarioenvia').val(rowData.idusuarioenvia);
            $('#txtIdusuariodestino').val(rowData.idusuariodestino);
            $('#txtBindrecepcion').val(rowData.bindrecepcion);
            $('#txtIdusuariorecepciona').val(rowData.idusuariorecepciona);
            $('#txtFecharecepciona').val(rowData.fecharecepciona);
            $('#txtFechalectura').val(rowData.fechalectura);
            $('#txtFechaderivacion').val(rowData.fechaderivacion);
            $('#txtFecharegistro').val(rowData.fecharegistro);
            $('#txtEstado').val(rowData.estado);
            $("#btnNuevo").text('Actualizar');
            $.HabilitarForm('#form');
        } //if
    } //for
}

function actualizar() {

    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Bandeja = {
                IndOpSp: 1,
                idbandeja: $('#container').data('idedit'),
                iddocumento: $('#txtIddocumento').val(),
                idareaproviene: $('#txtIdareaproviene').val(),
                idareadestino: $('#txtIdareadestino').val(),
                idusuarioenvia: $('#txtIdusuarioenvia').val(),
                idusuariodestino: $('#txtIdusuariodestino').val(),
                bindrecepcion: $('#txtBindrecepcion').val(),
                idusuariorecepciona: $('#txtIdusuariorecepciona').val(),
                fecharecepciona: $('#txtFecharecepciona').val(),
                fechalectura: $('#txtFechalectura').val(),
                fechaderivacion: $('#txtFechaderivacion').val(),
                fecharegistro: $('#txtFecharegistro').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/BandejaController/actualizarBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }
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

function del(id) {
    var eliminar = function () {
        var Bandeja = {
            IndOpSp: 2,
            idbandeja: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/BandejaController/eliminarBandejaBE.htm', {poBandejaBE: Bandeja}, false, function (response) {
            if (response > 0) {
                bootbox.alert(Mensajes.operacionCorrecta);
                $("#btnNuevo").text('Nuevo');
                $.DesabilitarForm('#form');
                $.LimpiarForm('#form');
                cargarGrilla();
            }
        });
    };

    bootbox.confirm(Mensajes.deseaEliminar, function (result) {
        if (result == true) {
            eliminar();
        }
        else {

        }
    });


}
function loadCombos() {
    $.CargarCombo(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: {IndOpSp: 1}}, '#txtIddocumento');
    $.CargarCombo(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: {IndOpSp: 1}}, '#txtIdareaproviene');
    $.CargarCombo(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: {IndOpSp: 1}}, '#txtIdareadestino');
    $.CargarCombo(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: {IndOpSp: 1}}, '#txtIdusuarioenvia');
    $.CargarCombo(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: {IndOpSp: 1}}, '#txtIdusuariodestino');
    $.CargarCombo(urlApp + '/BandejaController/listObjectBandejaBE.htm', {poBandejaBE: {IndOpSp: 1}}, '#txtIdusuariorecepciona');
}
