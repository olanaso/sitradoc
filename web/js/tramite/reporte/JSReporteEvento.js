$(function () {
    initForm();
});



/*EVENTS
 * ------------------------
 */
$(function () {
    $("#btnReporte").click(function (e) {
        generarReporte();
    });
});


/* FUNCTIONS
 * ------------------------
 */
function initForm() {
    $.FechaToday('#txtFechaInicio');
    $.FechaToday('#txtFechaFin');
}


function generarReporte() {
    var resulValidacion = 0;
    resulValidacion = $.ValidarData('#form2');
    switch (resulValidacion) {
        case 0:
            var OciBE = {
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


