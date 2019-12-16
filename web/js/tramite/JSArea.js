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
        $("#txtIdarea").select2();
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
    $("#txtIdarea").select2();
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        ignoreCase:true,
        celledit: true, 	 
        cellsubmit: "local",
        width: 500,
        multiselect:false,
        caption: "Lista Area",
        colNames: ["Edit", "Del", "idarea", "Abreviatura", "Codigo", "Denominacion", "idareasuperior", "AreaSuperior", "estado"],
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
                name: 'idarea',
                index: 'idarea',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'abreviatura',
                index: 'abreviatura',
                editable: false,
                width: 100,
                hidden: false
            },
            {
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 100,
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
                name: 'idareasuperior',
                index: 'idareasuperior',
                editable: false,
                width: 250,
                hidden: true
            },
            {
                name: 'areasuperior',
                index: 'areasuperior',
                editable: false,
                width: 250,
                hidden: false
            },
            {
                name: 'estado',
                index: 'estado',
                editable: false,
                edittype:"checkbox",
                width: 150,
                hidden: true
            }],
        pager: '#pager',
        onSelectRow: editRow,
         viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        //multiselect: true
    });
  
    $("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
    
     var lastSelection;

            function editRow(id) {
                if (id && id !== lastSelection) {
                    var grid = $("#grid");
                    grid.jqGrid('restoreRow',lastSelection);
                    grid.jqGrid('editRow',id, {keys: true} );
                    lastSelection = id;
                }
            }
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
                denominacion: $('#txtDenominacion').val(),
                abreviatura: $('#txtAbreviatura').val(),
                idareasuperior: $('#txtIdarea').val(),
                codigo: $('#txtCodigo').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/AreaController/insertarAreaBE.htm', {poAreaBE: Area}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    $("#txtIdarea").select2();
                    cargarGrilla();
                }
                if(response==-1){
                   bootbox.alert(Mensajes.areaDuplicado); 
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
            $('#txtIdarea').select2().select2('val', rowData.idareasuperior);
            $('#txtDenominacion').val(rowData.denominacion);
            $('#txtAbreviatura').val(rowData.abreviatura);
            $('#txtCodigo').val(rowData.codigo);
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
                abreviatura: $('#txtAbreviatura').val(),
                idareasuperior: $('#txtIdarea').val(),
                codigo: $('#txtCodigo').val(),
                estado: true
            };
            $.ajaxCall(urlApp + '/AreaController/actualizarAreaBE.htm', {poAreaBE: Area}, false, function (response) {
                if (response > 0) {
                    bootbox.alert(Mensajes.operacionCorrecta);
                    $("#btnNuevo").text('Nuevo');
                    $.DesabilitarForm('#form');
                    $.LimpiarForm('#form');
                    $("#txtIdarea").select2();
                    cargarGrilla();
                }
                 if(response==-1){
                   bootbox.alert(Mensajes.areaDuplicado); 
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
    $.CargarCombo(urlApp + '/AreaController/listObjectAreaBE.htm', {poAreaBE: {IndOpSp: 1}}, '#txtIdarea');
}
