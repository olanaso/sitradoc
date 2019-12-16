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
        cargarGrilla();
    });
      $("#txtIdanio").change(function (e) {
        cargarGrilla($(this).val());
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
        ignoreCase:true,
        caption: "Lista Feriado",
        colNames: ["Edit", "Del", "idferiado", "idanio", "Fecha", "Motivo", "estado"],
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
                name: 'idferiado',
                index: 'idferiado',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'idanio',
                index: 'idanio',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'fecha',
                index: 'fecha',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'motivo',
                index: 'motivo',
                editable: false,
                width: 350,
                hidden: false
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: true
            }],
        pager: '#pager',
        //onSelectRow: viewGeometry,
        viewrecords: true,
        shrinkToFit: false,
        //multiselect: true
    });
    jQuery("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false});
}

function cargarGrilla(idAnio) {
    $.ajaxCall(urlApp + '/FeriadoController/listarRegistrosFeriadoBE.htm', {poFeriadoBE: {IndOpSp: 1,idanio:idAnio}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Feriado = {
                idferiado: $('#txtIdferiado').val(),
                idanio: $('#txtIdanio').val(),
                fecha: $('#txtFecha').val(),
                motivo: $('#txtMotivo').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/FeriadoController/insertarFeriadoBE.htm', {poFeriadoBE: Feriado}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    cargarGrilla();

                }
                if(response==-1){
                   bootbox.alert(Mensajes.feriadoDuplicado); 
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
        if (rowData.idferiado === id.toString()) {
            $('#txtIdferiado').val(rowData.idferiado);
            $('#txtIdanio').val(rowData.idanio);
            $('#txtFecha').val(rowData.fecha);
            $('#txtMotivo').val(rowData.motivo);
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
            var Feriado = {
                idferiado: $('#container').data('idedit'),
                idanio: $('#txtIdanio').val(),
                fecha: $('#txtFecha').val(),
                motivo: $('#txtMotivo').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/FeriadoController/actualizarFeriadoBE.htm', {poFeriadoBE: Feriado}, false, function (response) {
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
        var Feriado = {
            IndOpSp: 2,
            idferiado: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/FeriadoController/eliminarFeriadoBE.htm', {poFeriadoBE: Feriado}, false, function (response) {
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
    $.CargarCombo(urlApp + '/FeriadoController/listObjectFeriadoBE.htm', {poFeriadoBE: {IndOpSp: 2}}, '#txtIdanio');
    
}
