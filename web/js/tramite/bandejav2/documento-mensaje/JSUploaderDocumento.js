/* 
 * Autor: Erick Escalante Olano
 */

(function () {

    var listaarchivos_msj_documento = new Array();
    window.listaarchivos_msj_documento = listaarchivos_msj_documento;
    /* Funcion Iniciadoras */
    $(function () {
        uplaoderMensajeDocumento();
    });


    function uplaoderMensajeDocumento() {

        document.getElementById("uploadFile").onchange = function (e) {
            debugger;
            var retorno = false;
            var reader = new FileReader();

            reader.onload = function (e) {
                // get loaded data and render thumbnail.
                // document.getElementById("image").src = e.target.result;
            };
            // read the image file as a data URL.
            reader.readAsDataURL(this.files[0]);
            if (this.files[0].size > 3145728) {
                retorno = true;
                $("#uploadFile").val('');
            }

            if (retorno) {
                bootbox.alert("El archivo sobreasa el limite permitido.");
            } else {
                var formData = new FormData();
                formData.append('file', this.files[0]);

                $("#files").append($("#fileUploadProgressTemplate").tmpl());
                $("#fileUploadError").addClass("hide");

                $.ajax({
                    url: urlApp + '/UploaderController/loadFiles/',
                    type: 'POST',
                    xhr: function () {

                        var xhr = $.ajaxSettings.xhr();
                        if (xhr.upload) {
                            xhr.upload.addEventListener('progress', function (evt) {
                                var percent = (evt.loaded / evt.total) * 100;
                                $("#files").find(".progress-bar").width(percent + "%");
                            }, false);
                        }
                        return xhr;
                    },
                    success: function (file) {
                        if (file.error) {
                            bootbox.alert(file.error);
                        }
                        else
                        {
                            $("#files").children().last().remove();
                            $("#files").append('<div id="alert_' + file.url.replace('.', '-') + '" class="alert alert-success alert-dismissible fade in" role="alert"> <button onclick="eliminarFileMensajeDocumento(\'' +file.link+ '\',\'' + file.url + '\')" type="button" class="close"  aria-label="Close"><span aria-hidden="true">×</span></button> ' + file.name + ' <i>(' + (Math.round(file.tamanio / 1048576 * 100) / 100) + ' Mb)</i> <a target="_blank" href="' + file.link + '">Ver</a></div>');
                            $('#container').data('fileurl', file.link);
                            $('#container').data('filename', file.name);
                            var file_document = {
                                nombre: file.name,
                                url: file.link
                            };
                            window.listaarchivos_msj_documento.push(file_document);
                        }
                    },
                    error: function () {
                        $("#fileUploadError").removeClass("hide").text("Ocurrio un error el subir el archivo");
                        $("#files").children().last().remove();
                        $("#uploadFile").closest("form").trigger("reset");
                    },
                    data: formData,
                    cache: false,
                    contentType: false,
                    processData: false
                }, 'json');
            }

        };
    }


    function eliminarFileMensajeDocumento(link,url) {
        bootbox.confirm("¿ Desea eliminar el Archivo ?", function (result) {
            if (result == true) {
                $.ajaxCall(urlApp + '/UploaderController/deleteFile', {poFileBE: {url: url}}, false, function (file) {
                    if (file.estado == true || file.estado == 'true') {//descomentar esto
                        $('#alert_' + url.replace('.', '-')).alert('close');
                        $('#container').data('fileurl', '');

                        debugger;
                        window.listaarchivos_msj_documento = window.listaarchivos_msj_documento.filter(function (el) {
                            return el.url !== link;
                        });
                        // window.listaarchivos_msj_documento = listaarchivos_msj_documento;
                        //eliminarElmentoArray(list_ArchivorepositorioBE, $('#container').data(url));
                    } else {
                        bootbox.alert("Ocurrio un error al eliminar este archivo");
                    }
                });
            }
        });
    }
    window.eliminarFileMensajeDocumento = eliminarFileMensajeDocumento;


})();