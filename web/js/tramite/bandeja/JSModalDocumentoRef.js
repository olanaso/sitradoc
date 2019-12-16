


/*Inicializador*/
$(function () {
    $('#container').data('idusuario_busqueda', Usuario.idusuario);
    crearGrillaDocumentoBusqueda();
    cargarCombosBusquedaDocumentoReferencia();

    $.FechaToday('#b_fecha_inicio_documento');
    $.FechaToday('#b_fecha_fin_documento');
    /*======EVENTOS========*/
    $("#btnlimpiarbusqdetallada_documento").click(function (e) {
        limpiarbusquedadetallada();
        e.preventDefault();
    });

    $("#btnbusqdetallada_documento").click(function (e) {
        cargarGrillaDocumentoBusqueda();
        e.preventDefault();
    });
});


/*Manejo de los documentos referencia*/
function cargarCombosBusquedaDocumentoReferencia() {

    $.CargarCombo(urlApp + '/UsuariocargoController/listObjectUsuariocargoBE.htm', {poUsuariocargoBE: {IndOpSp: 1}}, '#txtIdusuario_creaciondocumento_documento');
    $.CargarCombo(urlApp + '/FlujoController/listObjectFlujoBE.htm', {poFlujoBE: {IndOpSp: 6}}, '#drptipodocbusqueda_documento');
    $.CargarCombo(urlApp + '/AreaController/listObjectAreaBE.htm', {poAreaBE: {IndOpSp: 2}}, '#drpareabusqueda_documento');
    //$(".select2").select2();
    $("#txtIdusuario_creaciondocumento_documento").change(function () {
        $('#container').data('idusuario_busqueda', $(this).val());
    });
}


function agregarReferencias_mensaje() {
    $('#ModalDocRef_documento').modal('show');
    cargarGrillaDocumentoBusqueda();
}

/*Funcion que crea la grilla*/
function crearGrillaDocumentoBusqueda() {
    $("#gridDocumentoBusqueda_documento").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 200,
        width: 860,
        caption: "Busqueda de documento",
        colNames: ["+", "Ver", "iddocumento", "Tipo Documento", "C&oacute;digo Documento", "Autor", "Denominaci&oacute;n", "Descripci&oacute;n", "prioridad", "bindrespuesta", "diasrespuesta", "bindllegadausuario", "idareacioncreacion", "idusuariocreacion", "Fecha de Creaci&oacute;n", "idexpediente", "C&oacute;digo Expediente", "estado"],
        colModel: [{
                name: 'edit',
                index: 'edit',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: false
            }, {
                name: 'del',
                index: 'del',
                editable: false,
                align: "center",
                width: 40,
                search: false,
                hidden: false
            }, {
                name: 'iddocumento',
                index: 'iddocumento',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'tipodocumento',
                index: 'tipodocumento',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'codigo',
                index: 'codigo',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'usuario',
                index: 'usuario',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'asunto',
                index: 'asunto',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'mensaje',
                index: 'mensaje',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'prioridad',
                index: 'prioridad',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'bindrespuesta',
                index: 'bindrespuesta',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'diasrespuesta',
                index: 'diasrespuesta',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'bindllegadausuario',
                index: 'bindllegadausuario',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'idareacioncreacion',
                index: 'idareacioncreacion',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'idusuariocreacion',
                index: 'idusuariocreacion',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'fecha_envio',
                index: 'fecha_envio',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'idexpediente',
                index: 'idexpediente',
                editable: false,
                width: 150,
                hidden: true
            }, {
                name: 'codigoexpediente',
                index: 'codigoexpediente',
                editable: false,
                width: 150,
                hidden: false
            }, {
                name: 'estado',
                index: 'estado',
                editable: false,
                width: 150,
                hidden: true
            }],
        pager: '#pagerDocumentoBusqueda_documento',
        //onSelectRow: viewGeometry,
        viewrecords: true,
        shrinkToFit: false,
        //multiselect: true
    });
    jQuery("#gridDocumentoBusqueda_documento").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false});
}

/*Funcion que me permite la carga de la grilla de documentos*/
function cargarGrillaDocumentoBusqueda() {
    var DocumentoBE = {
        IndOpSp:7,
        idtipodocumento: $('#drptipodocbusqueda_documento').val(),
        idareacioncreacion: $('#drpareabusqueda_documento').val(),
        idusuariocreacion: $('#container').data('idusuario_busqueda'),
        fecha_inicio: $('#b_fecha_inicio_documento').val(),
        fecha_fin: $('#b_fecha_fin_documento').val(),
        asunto: $('#txtbusquedadetallada_documento').val()
    };
    $.ajaxCall(urlApp + '/DocumentoController/listarRegistrosDocumentoBE.htm', {poDocumentoBE: DocumentoBE}, false, function (response) {
        $('#gridDocumentoBusqueda_documento').jqGrid('clearGridData');
        jQuery("#gridDocumentoBusqueda_documento").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
}

/*FUncion para limpar la busqueda del dumento de referencia al mesaje */
function limpiarbusquedadetallada() {
    $('#drptipodocbusqueda_documento').val(0);
    $('#drpareabusqueda_documento').val(0);
    $('#txt_usuario_busqueda_documento').val('');
    $('#txtbusquedadetallada_documento').val('');
    $('#txtIdusuario_creaciondocumento_documento').val(0);
    $('#container').data('idusuario_busqueda', 0);
}


/*Funcion que permite agregar referencia de un documento */
var arrayDocumentoReferencia_documento = new Array();
function addreferencia_documento(iddocumento, codigo) {
    var addref = function () {
        if (arrayDocumentoReferencia_documento.indexOf(iddocumento) >= 0) {
            bootbox.alert("Esta REFENCIA ya fue agregada");
        } else {
            $('#listreferencia_mensaje').append('<div id="alert_' + iddocumento + '" class="alert alert-success alert-dismissible fade in" role="alert"> <button onclick="eliminarReferencia_documento(' + iddocumento + ')" type="button" class="close"  aria-label="Close"><span aria-hidden="true">×</span></button> ' + codigo + ' </div>');
            arrayDocumentoReferencia_documento.push(iddocumento);
        }
    };
    bootbox.confirm("¿ Desea agregar el Documento : <b>" + codigo + "</b> como REFERENCIA ?", function (result) {
        if (result == true) {
            addref();
        } else {

        }
    });
}

function eliminarReferencia_documento(iddocumento) {
    bootbox.confirm("¿ Desea eliminar la REFERENCIA ?", function (result) {
        if (result == true) {
            eliminarElmentoArray(arrayDocumentoReferencia_documento, iddocumento);
            $('#alert_' + iddocumento).alert('close');
        } else {
        }
    });
}
