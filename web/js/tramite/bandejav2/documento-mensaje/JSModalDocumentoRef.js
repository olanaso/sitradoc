function addreferencia_regDocumento(iddocumento, codigo) {

        var addref = function () {

            if (arrayDocumentoReferencia_regDocumento.indexOf(iddocumento) >= 0) {
                bootbox.alert("Esta REFENCIA ya fue agregada");
            } else {
                $('#listreferencia_regDocumento').append('<div id="alert_' + iddocumento + '" class="alert alert-success alert-dismissible fade in" role="alert"> <button onclick="eliminarReferencia_regDocumento(' + iddocumento + ')" type="button" class="close"  aria-label="Close"><span aria-hidden="true">×</span></button> ' + codigo + ' </div>');
                arrayDocumentoReferencia_regDocumento.push(iddocumento);
            }



        };

        bootbox.confirm("¿ Desea agregar el Documento : <b>" + codigo + "</b> como REFERENCIA ?", function (result) {
            if (result == true) {
                addref();
            }
            else {

            }
        });



    }
    window.addreferencia_regDocumento = addreferencia_regDocumento;

    function agregarReferencias_regdocumento() {
        $('#ModalDocRef_regDocumento').modal('show');
    }
    window.agregarReferencias_regdocumento = agregarReferencias_regdocumento;

    function eliminarReferencia_regDocumento(iddocumento) {
        bootbox.confirm("¿ Desea eliminar la REFERENCIA ?", function (result) {
            if (result == true) {
                eliminarElmentoArray(arrayDocumentoReferencia_regDocumento, iddocumento);
                $('#alert_' + iddocumento).alert('close');
            }
            else {
            }
        });
    }
    window.eliminarReferencia_regDocumento = eliminarReferencia_regDocumento;

    function show_regDocumento(iddocumento) {
        var a = document.createElement('a');
        a.href = urlApp + '/pages/documento/ViewDoc.jsp?iddocumento=' + iddocumento;
        a.target = "_blank";
        document.body.appendChild(a);
        a.click();
    }

    window.show_regDocumento = show_regDocumento;
