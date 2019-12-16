

$(function () {
    initForm();
});



/*EVENTS
 * ------------------------
 */

$(function (){
    $("#btnReporte").click(function (e) {
        generarReporte();
    });
});

function loadCombos() {
}

/* FUNCTIONS
 * ------------------------
 */
function initForm() {
    loadCombos()
    $(".select2").select2();
    $('#txtHoraInicio').val('00:00');
    $('#txtHoraFin').val('23:59');
}



function loadCombos() {
    //  $.CargarCombo(urlApp + '/ExpedienteController/listObjectExpedienteBE.htm', {poExpedienteBE: {IndOpSp: 2}}, '#txtIdusuariocargo');
    $.FechaToday('#txtFechaInicio');
    $.FechaToday('#txtFechaFin');
    $('#txtHoraFin').mask("99:99", {placeholder: "hh:mm"});
    $('#txtHoraInicio').mask("99:99", {placeholder: "hh:mm"});
    $.CargarCombo(urlApp + '/CargoController/listObjectCargoBE.htm', {poCargoBE: {IndOpSp: 2}}, '#txtIdarea');

}

function generarReporte() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form2');
    switch (resulValidacion) {
        case 0:
            var OciBE = {
                fecha_inicio: $('#txtFechaInicio').val() + ' ' + $('#txtHoraInicio').val(),
                fecha_fin: $('#txtFechaFin').val() + ' ' + $('#txtHoraFin').val(),
                idarea: $('#txtIdarea').val(),
                usuario: Usuario.usuario,
                area: $('#txtIdarea option:selected').text()
            };

            $.ajaxReport(urlApp + '/FlujoController/generarReporteOCI.htm', {poOciBE: OciBE}, false, function (response) {
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


