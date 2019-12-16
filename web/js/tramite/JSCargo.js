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
    //cargarGrilla();
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
        $("#txtIdarea").select2();
        $("#txtIdcargoparent").select2();
        //cargarGrilla();
    });
    
    $("#txtIdarea").change(function (e) {
        cargarGrilla($(this).val());
        loadCombosCargoParent($(this).val());
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
    //loadCombosCargoParent(0);
    $("#txtIdarea").select2();
    $("#txtIdcargoparent").select2();
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        ignoreCase: true,
        caption: "Lista Cargo",
        colNames: ["Edit", "Del", "idcargo", "Area", "Cargo", "Abreviatura", "Es jefe", "Nivel", "cargoparent", "estado", "idarea"],
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
                name: 'idcargo',
                index: 'idcargo',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'area',
                index: 'area',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'denominacion',
                index: 'denominacion',
                editable: false,
                width: 350,
                hidden: false
            },
            {
                name: 'abreviatura',
                index: 'abreviatura',
                editable: false,
                width: 90,
                hidden: false
            },
            {
                name: 'bindjefe',
                index: 'bindjefe',
                width: 110,
                align: 'center',
                formatter: 'checkbox',
                edittype: 'checkbox',
                editoptions: {value: 'Si:No', defaultValue: 'Yes'},
                stype: 'select',
                searchoptions: {sopt: ['eq', 'ne'], value: ':All;true:Si;false:No'}
            },
            {
                name: 'nivel',
                index: 'nivel',
                editable: false,
                align: 'center',
                width: 50,
                hidden: false
            }, {
                name: 'idcargoparent',
                index: 'idcargoparent',
                editable: false,
                align: 'center',
                width: 50,
                hidden: true
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'idarea',
                index: 'idarea',
                editable: false,
                width: 150,
                hidden: true
            }
        ],
        pager: '#pager',
        //onSelectRow: viewGeometry,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        //multiselect: true
    });
    $("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}

function cargarGrilla(idArea) {
    $.ajaxCall(urlApp + '/CargoController/listarRegistrosCargoBE.htm', {poCargoBE: {IndOpSp: 1, idarea: idArea}}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    if ($('#txtIdcargoparent').val() == '0' || $('#txtIdarea').val() == '0')
    {
        resulValidacion = -1;
    }
    switch (resulValidacion) {
        case 0:
            var Cargo = {
                idcargo: $('#txtIdcargo').val(),
                idcargoparent: $('#txtIdcargoparent').val(),
                bindjefe: $('#txtbindjefe').prop("checked"),
                denominacion: $('#txtDenominacion').val(),
                abreviatura: $('#txtAbreviatura').val(),
                estado: true,
                idarea: $('#txtIdarea').val(),
                nivel: $('#txtNivel').val()
            };
            $.ajaxCall(urlApp + '/CargoController/insertarCargoBE.htm', {poCargoBE: Cargo}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    $("#txtIdarea").select2();
                    $("#txtIdcargoparent").select2();
                    cargarGrilla();
                }
                if (response == -1) {
                    bootbox.alert(Mensajes.cargoDuplicado);
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
        if (rowData.idcargo === id.toString()) {
            console.log(rowData);
            //$('#txtIdcargo').val(rowData.idcargo);
            //$('#txtIdcargo').val(rowData.idcargo).change();
            //
            (rowData.bindjefe === 'Si') ? $('#txtbindjefe').prop("checked", true) : $('#txtbindjefe').prop("checked", false);
            $('#txtDenominacion').val(rowData.denominacion);
            $('#txtAbreviatura').val(rowData.abreviatura);
            $('#txtEstado').val(rowData.estado);
            $('#txtNivel').val(rowData.nivel);
            $("#txtIdarea").select2().select2('val', rowData.idarea);
            $("#txtIdcargoparent").select2().select2('val', rowData.idcargoparent);
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
            var Cargo = {
                idcargo: $('#container').data('idedit'),
                idcargoparent: $('#txtIdcargoparent').val(),
                bindjefe: $('#txtbindjefe').prop("checked"),
                denominacion: $('#txtDenominacion').val(),
                abreviatura: $('#txtAbreviatura').val(),
                estado: true,
                idarea: $('#txtIdarea').val(),
                nivel: $('#txtNivel').val()

            };
            $.ajaxCall(urlApp + '/CargoController/actualizarCargoBE.htm', {poCargoBE: Cargo}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    $("#txtIdarea").select2();
                    $("#txtIdcargoparent").select2();
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
        var Cargo = {
            IndOpSp: 2,
            idcargo: id //1=consulta por ids
        };
        $.ajaxCall(urlApp + '/CargoController/eliminarCargoBE.htm', {poCargoBE: Cargo}, false, function (response) {
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
    $.CargarCombo(urlApp + '/CargoController/listObjectCargoBE.htm', {poCargoBE: {IndOpSp: 2}}, '#txtIdarea');
}

function loadCombosCargoParent(idarea) {
    $.CargarCombo(urlApp + '/CargoController/listObjectCargoBE.htm', {poCargoBE: {IndOpSp: 3, idarea: idarea}}, '#txtIdcargoparent');
    $("#txtIdcargoparent").select2();
}
