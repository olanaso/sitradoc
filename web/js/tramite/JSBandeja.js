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
     $('#textInicio').text('BANDEJA DOCUMENTARIA');
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
        ignoreCase:true,
        width: 500,
        
        colNames: ["Enviado Por",  "idarea", "Asunto", "Fecha"],
        colModel: [
            {
                name: 'edit',
                index: 'edit',
                editable: false,
                align: "center",
                width: 250,
                search: false,
                hidden: false
            },
           
            {
                name: 'idarea',
                index: 'idarea',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'denominacion',
                index: 'denominacion',
                editable: false,
                width: 550,
                hidden: false
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                search: false,
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
    $.ajaxCall(urlApp + '/AreaController/listarRegistrosAreaBE.htm', {poAreaBE: {IndOpSp: 1}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var Area = {
                idarea: $('#txtIdarea').val(),
                denominacion: $('#txtDenominacion').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/AreaController/insertarAreaBE.htm', {poAreaBE: Area}, false, function (response) {
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
        if (rowData.idarea === id.toString()) {
            $('#txtIdarea').val(rowData.idarea);
            $('#txtDenominacion').val(rowData.denominacion);
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
            var Area = {
                idarea: $('#container').data('idedit'),
                denominacion: $('#txtDenominacion').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/AreaController/actualizarAreaBE.htm', {poAreaBE: Area}, false, function (response) {
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
        var Area = {
            IndOpSp: 2,
            idarea: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/AreaController/eliminarAreaBE.htm', {poAreaBE: Area}, false, function (response) {
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
}
