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
var cantidadrequisitosentregar = 0;

$(function () {
    initForm();
    crearGrilla();
    //cargarGrilla();
    autocompletarProcedimientos();
    $('#containerGrilla').bind('resize', function () {
        $("#grid").setGridWidth($('#containerGrilla').width());
    }).trigger('resize');
    $('#textInicio').text('MESA DE PARTES');
    dualList();
    $('#txtIdarea').attr("disabled", "disabled");
    
        $('.modal').on('show.bs.modal', function (e) {

        $('body').children().addClass('blurcontent')
        $('.modal').removeClass('blurcontent');

    })

    $('.modal').on('hide.bs.modal', function (e) {
        $('body').children().removeClass('blurcontent')
        
    })
});

/*dual list*/
function dualList() {

    $('.pasar').click(function () {
        return !$('#origen option:selected').remove().appendTo('#destino');
    });
    $('.quitar').click(function () {
        return !$('#destino option:selected').remove().appendTo('#origen');
    });
    $('.pasartodos').click(function () {
        $('#origen option').each(function () {
            $(this).remove().appendTo('#destino');
        });
    });
    $('.quitartodos').click(function () {
        $('#destino option').each(function () {
            $(this).remove().appendTo('#origen');
        });
    });

    $('.submit').click(function () {
        $('#destino option').prop('selected', 'selected');
    });

    $('#txtbusqueda').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrilla();
            //alert(1)
        }


    });

    $('#txtbusquedaanio').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrilla();
        }
    });

    $('#txtbusquedacodigoexpediente').on('keypress', function (e) {
        if (e.keyCode === 13) {
            cargarGrilla();
        }
    });

//    $('#txtbusqueda').on('keyup', function (e) {
//        if ($(this).val() === '') {
//            cargarGrilla();
//        }
//    });

    /*$('#txtbusqueda').on('focusout', function (e) {
     if ($(this).val() === '') {
     cargarGrilla();
     } else {
     
     }
     });*/



    $(".selectAll").on('focus', function () {
        $(this).select();
    });
}



function clearinginput() {

    // /////
    // CLEARABLE INPUT
    function tog(v) {
        return v ? 'addClass' : 'removeClass';
    }

    $(document).on('input', '.clearable', function () {
        $(this)[tog(this.value)]('x');
    }).on('mousemove', '.x', function (e) {
        $(this)[tog(this.offsetWidth - 18 < e.clientX - this.getBoundingClientRect().left)]('onX');
    }).on('touchstart click', '.onX', function (ev) {
        ev.preventDefault();
        $(this).removeClass('x onX').val('').change();
        $("#destino").html("");
        $("#origen").html("");
        $('#txtIdarea').val('');
    });


}

/*EVENTS
 * ------------------------
 */
$(function () {

    $("#btnNuevo").click(function (e) {

        if ($("#btnNuevo").text() === 'Nuevo') {
            $.HabilitarForm('#form');
            $("#btnNuevo").text('Guardar');
            $('#txtObservacion').val('NUEVO REGISTRO');
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
        $("#destino").html("");
        $("#origen").html("");
        $("#btnNuevo").text('Nuevo');
    });

//    $("#txtIdarea").change(function (e) {
//        cargarComboArea($("#txtIdarea").val());
//    });

//    $("#txtIdprocedimiento").change(function (e) {
//        cargarComboRequisitos($("#txtIdprocedimiento").val());
//    });

    $("#txtDni_ruc").focusout(function (e) {
        seleccionarDNI($("#txtDni_ruc").val());
    });

    $("#btnReporte").click(function (e) {
        generarReporte();
    });

    $("#txtIdprocedimiento").keyup(function (e) {
        if ($("#txtIdprocedimiento").val() === '') {
            // $('#txtIdprocedimiento').css('background', '#FFF');
            $('#txtIdarea').val('');
            $('#container').data('idprocedimiento', null);
            $('#container').data('idarea', null);
        }
    });

    $('#formTipoDocumento input').on('change', function () {

        if ($('input[name="TipoDocumento"]:checked', '#formTipoDocumento').attr('valor') === 'DNI') {
            $('#txtDni_ruc').attr('maxlength', 8);
             $('#txtDni_ruc').mask("99999999", {placeholder: "________"});
            
        }
        if ($('input[name="TipoDocumento"]:checked', '#formTipoDocumento').attr('valor') === 'RUC') {
            $('#txtDni_ruc').attr('maxlength', 11);
            $('#txtDni_ruc').mask("99999999999", {placeholder: "___________"});
        }
        $('#txtDni_ruc').val('');
    });


});


/* FUNCTIONS
 * ------------------------
 */
function initForm() {

    $.DesabilitarForm('#form');
    $.LimpiarForm('#form');
    $("#btnNuevo").text('Nuevo');
    autocompletarProcedimientos();
    //loadCombos();
    $.FechaToday('#txtFechaInicio');
    $.FechaToday('#txtFechaFin');
    $('#txtHoraFin').mask("99:99", {placeholder: "hh:mm"});
    $('#txtHoraInicio').mask("99:99", {placeholder: "hh:mm"});
    $('#txtDni_ruc').mask("99999999", {placeholder: "________"});
    $(".select2").select2();
    clearinginput();
    $('#rbnDNI').click();
    $('#txtObservacion').val('NUEVO REGISTRO');
}

function crearGrilla() {
    $("#grid").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        ignoreCase: true,
        caption: "Lista Expediente",
        colNames: ["Editar", "Eliminar", "idexpediente", "idprocedimiento", "idarea", "Codigo", "Area", "Cod.Procedimiento", "Procedimiento", "DNI/RUC", "Nombres/Razon Social"
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
        pager: '#pager',
        //onSelectRow: viewGeometry,
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        onPaging: function (pgButton) {
            // if user has entered page number
            if (pgButton == "user") {
                // find out the requested and last page
                var requestedPage = $("#grid").getGridParam("page");
                var lastPage = $("#grid").getGridParam("lastpage");
                alert("requestedPage: " + requestedPage + ", lastPage: " + lastPage);
                // if the requested page is higher than the last page value 
                if (requestedPage > lastPage) {
                    alert("Setting to " + lastPage);
                    // set the requested page to the last page value - then reload
                    $("#grid").setGridParam({page: lastPage}).trigger("reloadGrid");
                }
            }
        }
        //multiselect: true
    });
    $("#grid").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}

/* Funcion autocompletar procedimiento */
function autocompletarProcedimientos() {
    $("#txtIdprocedimiento").AutocompleteWithPobject(urlApp + "/ProcedimientoController/autocompletarProcedimiento.htm", {IndOpSp: 4}, "#txtIdprocedimiento", 600,
            function (item) {
                //console.log(item);
                return {
                    label: item.denominacion,
                    area: item.area,
                    idprocedimiento: item.idprocedimiento,
                    idarea: item.idarea
                }
            },
            function (event, ui) {
                $('#txtIdarea').val(ui.item.area);
                cargarComboRequisitos(ui.item.idprocedimiento);
                $('#container').data('idprocedimiento', ui.item.idprocedimiento);
                $('#container').data('idarea', ui.item.idarea);

                //  $('#txtIdprocedimiento').css('background', '#C7F0AA');


            });
}

//var i=0;
function cargarGrilla() {

    var Expediente = {
        IndOpSp: 1,
        //codigo: ($('#txtbusqueda').val() === '' || isNaN($('#txtbusqueda').val())) ? 0 : $('#txtbusqueda').val(),
        nombre_razonsocial: $('#txtbusqueda').val(),
        apellidos: $('#txtbusqueda').val(), dni_ruc: $('#txtbusqueda').val(),
        idarea: ($('#txtbusquedaanio').val().trim() === '' || isNaN($('#txtbusquedaanio').val())) ? 0 : $('#txtbusquedaanio').val().trim(),
        codigo: ($('#txtbusquedacodigoexpediente').val().trim() === '' || isNaN($('#txtbusquedacodigoexpediente').val())) ? 0 : $('#txtbusquedacodigoexpediente').val().trim(),
    };

    $.ajaxCall(urlApp + '/ExpedienteController/listarRegistrosExpedienteBE.htm', {poExpedienteBE: Expediente}, false, function (response) {
//       alert(i+1);
//       i=i+1;
        $('#grid').jqGrid('clearGridData');
        jQuery("#grid").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
    //PintarRowGrilla("grid", 'bindobservado', 'false', '#E21E27', '#FFFFFF')
}


function save() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:
            var guardarExpediente = function (Expediente) {
                $.ajaxCall(urlApp + '/ExpedienteController/insertarExpedienteBE.htm', {poExpedienteBE: Expediente}, false, function (response) {
                    if (response > 0) {
                        var listExpedienterequisitoBE = new Array();
                        $($.getAlloptionsSelect('#destino')).each(function (index, value) {
                            listExpedienterequisitoBE.push(
                                    {
                                        idrequisitos: value,
                                        idexpediente: response,
                                        estado: true
                                    });
                        });
                        $.ajaxCall(urlApp + '/ExpedienterequisitoController/insertarRegistrosExpedienterequisitoBE.htm', {polistExpedienterequisitoBE: listExpedienterequisitoBE}, false, function (respuesta) {
                            bootbox.alert("<H2>CODIGO EXPEDIENTE :</H2><H1>" + response + "</H1>");
                            $("#btnNuevo").text('Nuevo');
                            $("#destino").html("");
                            $("#origen").html("");
                            $.DesabilitarForm('#form');
                            $.LimpiarForm('#form');
                            cargarGrilla();
                        });
                    }

                });
            };

            if (cantidadrequisitosentregar === $.getAlloptionsSelect('#destino').length) {
                //REGISTRAR COMO EXPEDIENTE SIN OBSERVADO
                var Expediente = {
                    idexpediente: $('#txtIdexpediente').val(),
                    idusuariocargo: Usuario.idusuario,
                    idprocedimiento: $('#container').data('idprocedimiento'),
                    idarea: $('#container').data('idarea'),
                    codigo: $('#txtCodigo').val(),
                    dni_ruc: $('#txtDni_ruc').val(),
                    nombre_razonsocial: $('#txtNombre_razonsocial').val(),
                    apellidos: $('#txtApellidos').val(),
                    direccion: $('#txtDireccion').val(),
                    telefono: $('#txtTelefono').val(),
                    correo: $('#txtCorreo').val(),
                    asunto: $('#txtAsunto').val(),
                    estado: true,
                    bindentregado: false,
                    bindobservado: false,
                    folios: parseInt($('#txtfolios').val()),
                    nombredocumento: $('#txtdocumento').val(),
                    idarea_proviene: Usuario.idarea,
                    observacion: $('#txtObservacion').val()

                };
                guardarExpediente(Expediente);

            } else {
                bootbox.confirm("Faltan adjuntar REQUISITOS el expediente sera OBSERVADO.", function (result) {
                    if (result == true) {
                        //REGISTRAR COMO EXPEDIENTE OBSERVADO
                        var Expediente = {
                            idexpediente: $('#txtIdexpediente').val(),
                            idusuariocargo: Usuario.idusuario,
                            idprocedimiento: $('#container').data('idprocedimiento'),
                            idarea: $('#container').data('idarea'),
                            codigo: $('#txtCodigo').val(),
                            dni_ruc: $('#txtDni_ruc').val(),
                            nombre_razonsocial: $('#txtNombre_razonsocial').val(),
                            apellidos: $('#txtApellidos').val(),
                            direccion: $('#txtDireccion').val(),
                            telefono: $('#txtTelefono').val(),
                            correo: $('#txtCorreo').val(),
                            asunto: $('#txtAsunto').val(),
                            estado: true,
                            bindentregado: false,
                            bindobservado: true,
                            folios: parseInt($('#txtfolios').val()),
                            nombredocumento: $('#txtdocumento').val(),
                            idarea_proviene: Usuario.idarea,
                            observacion: $('#txtObservacion').val()
                        };
                        guardarExpediente(Expediente);
                    }
                    else {
                        alert('cancelo')
                        return;
                    }
                });

            }


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
    var idprocedimiento = 0;
    for (var i = 1; i <= rowIds.length; i++) {
        rowData = $('#grid').jqGrid('getRowData', i);
        if (rowData.idexpediente === id.toString()) {
            $('#txtIdexpediente').val(rowData.idexpediente);
            $('#txtIdusuariocargo').val(rowData.idusuariocargo);

            $('#txtIdprocedimiento').val(rowData.denoprocedimiento);
            $('#txtIdarea').val(rowData.areadenominacion);

            $('#container').data('idprocedimiento', rowData.idprocedimiento);
            $('#container').data('idarea', rowData.idarea);

            idprocedimiento = rowData.idprocedimiento;
            //alert(rowData.idprocedimiento);
            console.log('idarea: ' + rowData.idarea);

            $('#txtCodigo').val(rowData.codigo);
            $('#txtDni_ruc').val(rowData.dni_ruc);
            $('#txtNombre_razonsocial').val(rowData.nombre_razonsocial);
            $('#txtApellidos').val(rowData.apellidos);
            $('#txtDireccion').val(rowData.direccion);
            $('#txtTelefono').val(rowData.telefono);
            $('#txtCorreo').val(rowData.correo);
            $('#txtAsunto').val(rowData.asunto);
            $('#txtEstado').val(rowData.estado);
            $('#txtfolios').val(rowData.folios);
            $('#txtdocumento').val(rowData.nombredocumento);
            $('#txtObservacion').val('');
            $("#btnNuevo").text('Actualizar');

            $.HabilitarForm('#form');
        } //if
    } //for
    //$("#txtIdarea").prop("disabled", true);
    //$("#txtIdprocedimiento").prop("disabled", true);
    $.CargarComboSinIni(urlApp + '/ExpedienteController/listObjectExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 6, idexpediente: id}}, '#destino');
    //alert(rowData.idprocedimiento);
    $.CargarComboSinIni(urlApp + '/ExpedienteController/listObjectExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 7, idprocedimiento: idprocedimiento, idexpediente: id}}, '#origen');
    cantidadrequisitosentregar = $.getAlloptionsSelect('#destino').length + $.getAlloptionsSelect('#origen').length;

}

/*funciona para actualizar el expediente*/
function actualizar() {

    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form');
    switch (resulValidacion) {
        case 0:

            var actualizarExpediente = function (Expediente) {
                //alert(Expediente);
                $.ajaxCall(urlApp + '/ExpedienteController/actualizarExpedienteBE.htm', {poExpedienteBE: Expediente}, false, function (response) {
                    if (response > 0) {

                        var listExpedienterequisitoBE = new Array();
                        $($.getAlloptionsSelect('#destino')).each(function (index, value) {
                            listExpedienterequisitoBE.push(
                                    {
                                        idrequisitos: value,
                                        idexpediente: response,
                                        estado: true
                                    });
                        });

                        $.ajaxCall(urlApp + '/ExpedienterequisitoController/actualizarRegistrosExpedienterequisitoBE.htm', {polistExpedienterequisitoBE: listExpedienterequisitoBE, idexpediente: response}, false, function (respuesta) {

                            bootbox.alert("<H2>CODIGO EXPEDIENTE ACTUALIZADO:</H2><H1>" + response + "</H1>");
                            $("#btnNuevo").text('Nuevo');
                            $("#destino").html("");
                            $("#origen").html("");
                            $.DesabilitarForm('#form');
                            $.LimpiarForm('#form');
                            cargarGrilla();

                        });
                    }

                });
            };
            console.log('catindad entregar:' + cantidadrequisitosentregar);
            console.log('destino:' + $.getAlloptionsSelect('#destino').length);
            if (cantidadrequisitosentregar === $.getAlloptionsSelect('#destino').length) {
                //REGISTRAR COMO EXPEDIENTE SIN OBSERVADO
                var Expediente = {
                    idexpediente: $('#container').data('idedit'),
                    idusuariocargo: Usuario.idusuario,
                    idprocedimiento: $('#container').data('idprocedimiento'),
                    idarea: $('#container').data('idarea'),
                    //codigo: $('#txtCodigo').val(),
                    dni_ruc: $('#txtDni_ruc').val(),
                    nombre_razonsocial: $('#txtNombre_razonsocial').val(),
                    apellidos: $('#txtApellidos').val(),
                    direccion: $('#txtDireccion').val(),
                    telefono: $('#txtTelefono').val(),
                    correo: $('#txtCorreo').val(),
                    asunto: $('#txtAsunto').val(),
                    //estado: true,
                    //bindentregado: false,
                    bindobservado: false,
                    folios: parseInt($('#txtfolios').val()),
                    nombredocumento: $('#txtdocumento').val(),
                    observacion: $('#txtObservacion').val()

                };
                //actualizarExpediente(Expediente);

                bootbox.confirm("Usted esta actualizando Expediente: "+$('#txtCodigo').val()+" este registro &iquest;Desea Actualizarlo?", function (result) {
                    if (result === true) {
                        actualizarExpediente(Expediente);
                    }
                    else {

                    }
                });
            } else {
                bootbox.confirm("Faltan adjuntar REQUISITOS el expediente sera OBSERVADO.", function (result) {
                    if (result == true) {
                        //REGISTRAR COMO EXPEDIENTE OBSERVADO
                        var Expediente = {
                            idexpediente: $('#container').data('idedit'),
                            idusuariocargo: Usuario.idusuario,
                            dni_ruc: $('#txtDni_ruc').val(),
                            idprocedimiento: $('#container').data('idprocedimiento'),
                            idarea: $('#container').data('idarea'),
                            nombre_razonsocial: $('#txtNombre_razonsocial').val(),
                            apellidos: $('#txtApellidos').val(),
                            direccion: $('#txtDireccion').val(),
                            telefono: $('#txtTelefono').val(),
                            correo: $('#txtCorreo').val(),
                            asunto: $('#txtAsunto').val(),
                            //estado: true,
                            //bindentregado: false,
                            bindobservado: true,
                            folios: parseInt($('#txtfolios').val()),
                            nombredocumento: $('#txtdocumento').val(),
                            observacion: $('#txtObservacion').val()
                        };

                        bootbox.confirm("Usted esta actualizando este registro &iquest;Desea Actualizarlo?", function (result) {

                            if (result === true) {
                                actualizarExpediente(Expediente);
                            }
                            else {

                            }
                        });

                    }
                    else {
                        //alert('cancelo');
                        return;
                    }
                });

            }


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
        var Expediente = {
            IndOpSp: 2,
            idexpediente: id, //1=consulta por ids
            idusuariocargo: Usuario.idusuario,
        };
        $.ajaxCall(urlApp + '/ExpedienteController/eliminarExpedienteBE.htm', {poExpedienteBE: Expediente}, false, function (response) {
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
    //  $.CargarCombo(urlApp + '/ExpedienteController/listObjectExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 2}}, '#txtIdusuariocargo');
    $.FechaToday('#txtFechaInicio');
    $.FechaToday('#txtFechaFin');
    $('#txtHoraFin').mask("99:99", {placeholder: "hh:mm"});
    $('#txtHoraInicio').mask("99:99", {placeholder: "hh:mm"});
    $.CargarCombo(urlApp + '/ExpedienteController/listObjectExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 3}}, '#txtIdarea');

}

function cargarComboArea(idArea) {
    $.CargarCombo(urlApp + '/ExpedienteController/listObjectExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 4, idarea: idArea}}, '#txtIdprocedimiento');
}


function cargarComboRequisitos(idProcedimiento) {
    $("#destino").html("");
    $.CargarComboSinIni(urlApp + '/ExpedienteController/listObjectExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 5, idprocedimiento: idProcedimiento}}, '#origen');
    cantidadrequisitosentregar = $.getAlloptionsSelect('#origen').length;
}


function seleccionarDNI(dni_ruc) {
    $.ajaxCall(urlApp + '/ExpedienteController/listarRegistrosExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 3, dni_ruc: dni_ruc}}, false, function (response) {

        if (response.length === 0) {
            $("#txtNombre_razonsocial").val('');
            $("#txtApellidos").val('');
            $("#txtDireccion").val('');
            $("#txtTelefono").val('');
            $("#txtCorreo").val('');
        }
        else {
            $("#txtNombre_razonsocial").val(response[0].nombre_razonsocial);
            $("#txtApellidos").val(response[0].apellidos);
            $("#txtDireccion").val(response[0].direccion);
            $("#txtTelefono").val(response[0].telefono);
            $("#txtCorreo").val(response[0].correo);
        }


    });
}



function generarReporte() {

    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form2');
    switch (resulValidacion) {
        case 0:
            var ExpedienteBE = {
                dni_ruc: $('#txtFechaInicio').val() + ' ' + $('#txtHoraInicio').val(),
                nombre_razonsocial: $('#txtFechaFin').val() + ' ' + $('#txtHoraFin').val(),
                apellidos: Usuario.usuario,
                idusuariocargo: ($('#chksolousuario').prop("checked")) ? Usuario.idusuario : 0
            };

            $.ajaxReport(urlApp + '/ExpedienteController/generarReporte.htm', {poExpedienteBE: ExpedienteBE}, false, function (response) {
                $('#reportview').attr('src', response);
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
