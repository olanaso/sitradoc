$(function () {
    crearGrilla2();
    cargaGrillaAreaDestino();
});


function crearGrilla2() {
    jQuery("#grid").jqGrid({
        //data: mydata,
        datatype: "local",
        caption: "Configuracion de Documentos",
        colNames: ["idtipodocumento", "Tipo de Documento", "Nro Codigo Actual", "Nuevo Nro Codigo"],
        colModel: [
            {
                name: 'idtipodocumento',
                index: 'idtipodocumento',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'denominacion',
                index: 'denominacion',
                editable: false,
                width: 250,
                hidden: false
            },
            {
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 150,
                hidden: false
            }
            ,
            {
                name: 'ultimocodigo',
                index: 'ultimocodigo',
                editable: true,
                //edittype:'number',
                width: 150,
                hidden: false
            }
        ],
        rowNum: 10000,
        rowList: ['All'],
        pager: '#pager',
        sortname: 'amount',
        viewrecords: true,
        //autowidth: true,
        cellEdit: true,
        // caption: "Cell Edit Example",
        cellsubmit: 'clientArray',
        editurl: 'clientArray',
        //for dynamically adding Total
        afterSaveCell: editcell

    });
}

function cargaGrillaAreaDestino() {

    var Area = {
        IndOpSp: 4,
        idusuariojefe: Usuario.idusuario,
        idarea: Usuario.idarea
    };

    $.ajaxCall(urlApp + '/AreaController/getJSON.htm', {poAreaBE: Area}, false, function (response) {
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
    //PintarRowGrilla("grid", 'bindobservado', 'false', '#E21E27', '#FFFFFF')
}

function editcell(rowid, cellname, value, iRow, iCol) {

    var updateNroDOc = function () {
        var anterior = parseInt(jQuery("#grid").getRowData(rowid).codigo);
        var nuevo = parseInt(jQuery("#grid").getRowData(rowid).ultimocodigo);
        var idtipodocumento = jQuery("#grid").getRowData(rowid).idtipodocumento;
        //alert("anteiror "+anterior);
        //alert("nuevo "+nuevo);
        var Area = {
            //opcion,
            idtipodocumento: parseInt(idtipodocumento),
            idusuario: Usuario.idusuario,
            codigodoc: parseInt(nuevo),
            // idusuariojefe: Usuario.idusuario,
            idarea: Usuario.idarea
        };
        debugger;
        if (nuevo < anterior) {
            // alert('eliminar')
            Area.opcion = 2;
            $.ajaxCall(urlApp + '/SqlController/guardar-configuracion-documento', {poAreaBE: Area}, false, function (response) {
                //alert(response);
                cargaGrillaAreaDestino();
            });
        }
        if (nuevo > anterior) {
            Area.opcion = 1;
            //  alert('insertar')
            $.ajaxCall(urlApp + '/SqlController/guardar-configuracion-documento', {poAreaBE: Area}, false, function (response) {
                //alert(response);
                cargaGrillaAreaDestino();
            });
        }
        if (anterior === nuevo) {
            console.log('no hacer nada')
        }



    };

    bootbox.confirm("¿ Desea actualizar la Numeracion de el documento seleccionado ?", function (result) {
        if (result == true) {
            updateNroDOc();
        } else {

        }
    });


}