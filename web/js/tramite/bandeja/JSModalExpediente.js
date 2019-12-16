$(function () {
    crearGrillaRerefenciaExpediente();



    /*================EVENTOS============================*/
    $('#txtbusqueda_expediente').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrilla_busquedaExpediente();
        }
    });

    $('#txtbusquedaanio_expediente').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrilla_busquedaExpediente();
        }
    });

    $('#txtbusquedacodigoexpediente_expediente').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrilla_busquedaExpediente();
        }
    });
});

function agregarExpediente_mensaje() {
    $('#ModalExpedienteRef').modal('show');

    $('#containerGrilla_expediente').bind('resize', function () {
        $("#grid_busqueda_expediente").setGridWidth($('#containerGrilla_expediente').width());
    }).trigger('resize');

}


function crearGrillaRerefenciaExpediente() {
    $("#grid_busqueda_expediente").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        ignoreCase: true,
        caption: "Lista Expediente",
        colNames: ["Agregar", "Eliminar", "idexpediente", "idprocedimiento", "idarea", "Codigo", "Area", "Cod.Procedimiento", "Procedimiento", "DNI/RUC", "Nombres/Razon Social"
                    , "Apellidos", "Direcci&oacute;n", "Telefonos", "Correo", "Asunto", "estado", "bindentregado", "Observado", "Fecha Registro", "Folios", "Nombre Documento"],
        colModel: [
            {
                name: 'edit',
                index: 'edit',
                editable: false,
                align: "center",
                width: 45,
                search: false,
                hidden: false
            },
            {
                name: 'del',
                index: 'del',
                editable: false,
                align: "center",
                width: 60,
                search: false,
                hidden: true
            },
            {
                name: 'idexpediente',
                index: 'idexpediente',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'idprocedimiento',
                index: 'idprocedimiento',
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
            },
            {
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 80,
                align: "center",
                hidden: false
            },
            {
                name: 'areadenominacion',
                index: 'areadenominacion',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'codprocedimiento',
                index: 'codprocedimiento',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'denoprocedimiento',
                index: 'denoprocedimiento',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'dni_ruc',
                index: 'dni_ruc',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'nombre_razonsocial',
                index: 'nombre_razonsocial',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'apellidos',
                index: 'apellidos',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'direccion',
                index: 'direccion',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'telefono',
                index: 'telefono',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'correo',
                index: 'correo',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'asunto',
                index: 'asunto',
                editable: false,
                width: 200,
                hidden: false
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'bindentregado',
                index: 'bindentregado',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'observado',
                index: 'observado',
                editable: false,
                width: 90,
                hidden: false,
                align: "center"
            }, {
                name: 'sfecharegistro',
                index: 'sfecharegistro',
                editable: false,
                width: 150,
                hidden: false,
                align: "center"
            }
            , {
                name: 'folios',
                index: 'folios',
                editable: false,
                width: 150,
                hidden: false,
                align: "center"
            }
            , {
                name: 'nombredocumento',
                index: 'nombredocumento',
                editable: false,
                width: 150,
                hidden: false,
                align: "center"
            }
        ],
        pager: '#pager_busqueda_expediente',
        //onSelectRow: viewGeometry,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        //multiselect: true
    });
    $("#grid_busqueda_expediente").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}


//var i=0;
function cargarGrilla_busquedaExpediente() {

    var Expediente = {
        IndOpSp: 6,
        //codigo: ($('#txtbusqueda').val() === '' || isNaN($('#txtbusqueda').val())) ? 0 : $('#txtbusqueda').val(),
        nombre_razonsocial: $('#txtbusqueda_expediente').val(),
        apellidos: $('#txtbusqueda_expediente').val(), dni_ruc: $('#txtbusqueda_expediente').val(),
        idarea: ($('#txtbusquedaanio_expediente').val().trim() === '' || isNaN($('#txtbusquedaanio_expediente').val())) ? 0 : $('#txtbusquedaanio_expediente').val().trim(),
        codigo: ($('#txtbusquedacodigoexpediente_expediente').val().trim() === '' || isNaN($('#txtbusquedacodigoexpediente_expediente').val())) ? 0 : $('#txtbusquedacodigoexpediente_expediente').val().trim(),
    };

    $.ajaxCall(urlApp + '/ExpedienteController/listarRegistrosExpedienteBE.htm', {poExpedienteBE: Expediente}, false, function (response) {
//       alert(i+1);
//       i=i+1;
        $('#grid_busqueda_expediente').jqGrid('clearGridData');
        jQuery("#grid_busqueda_expediente").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
    //PintarRowGrilla("grid", 'bindobservado', 'false', '#E21E27', '#FFFFFF')
}


var arrayExpedienteReferencia = new Array();
function addExpedienteReferencia(idexpediente, expediente) {
    var addref = function () {

        if (arrayExpedienteReferencia.length >= 1) {
            bootbox.alert("Solo puede agregar 01 Expediente como referencia.");
        } else {
            $('#listexpediente_mensaje').append('<div id="alertexp_' + idexpediente + '" class="alert alert-warning alert-dismissible fade in" role="alert"> <button onclick="eliminarReferenciaExpediente(' + idexpediente + ')" type="button" class="close"  aria-label="Close"><span aria-hidden="true">×</span></button> ' + expediente + ' </div>');
            arrayExpedienteReferencia.push(idexpediente);
        }
    };
    bootbox.confirm("¿ Desea agregar el Expediente : <b>" + expediente + "</b> como REFERENCIA ?", function (result) {
        if (result == true) {
            addref();
        } else {

        }
    });
}

//window.addExpedienteReferencia=addExpedienteReferencia;


function eliminarReferenciaExpediente(idexpediente) {

    bootbox.confirm("¿ Desea eliminar el Expediente ?", function (result) {
        if (result == true) {
            eliminarElmentoArray(arrayExpedienteReferencia, idexpediente);
            $('#alertexp_' + idexpediente).alert('close');
        } else {

        }
    });


}

var PRIORIDAD = 3;

function setPrioridad(prioridad) {
    PRIORIDAD = prioridad;
}