





function cargardocumento() {

    var iddocumento = getUrlParameter("iddocumento");

    $.ajaxCall(urlApp + '/DocumentoController/listObjectDocumentoBE.htm', {poDocumentoBE: {IndOpSp: 2, iddocumento: iddocumento}}, false, function (response) {
        var a = response[0];
        $('#codigo_documento').text(a[0]);
        $('#asunto_documento').text(a[3]);
        $('#mensaje_documento').text(a[4]);
        $('#autor_documento').text(a[1]);
        $('#area_documento').text(a[2]);
        $('#fecha_documento').text(a[5]);

    });
    $.ajaxCall(urlApp + '/DocumentoController/listObjectDocumentoBE.htm', {poDocumentoBE: {IndOpSp: 3, iddocumento: iddocumento}}, false, function (response) {
        $.each(response, function (index, value) {
            $('#listareferencia').append('<a target="_blank" href="' + urlApp + '/pages/documento/ViewDoc.jsp?iddocumento=' + value[0] + '" > <div class="myButton" role="alert"> <h5 style="color:#FFF;">' + value[1] + '</h5> </div> </a>');
        });
    });
    $.ajaxCall(urlApp + '/DocumentoController/listObjectDocumentoBE.htm', {poDocumentoBE: {IndOpSp: 4, iddocumento: iddocumento}}, false, function (response) {
        var archivo = '';
        var extension = '';
        $.each(response, function (index, value) {
            archivo = value[1];
            extension = (archivo.substring(archivo.lastIndexOf("."))).toLowerCase();


            switch (extension) {
                case '.jpg':
                case '.png':
                case '.gif':
                case '.bmp':
                    $('#listaadjuntos').append('<a target="_blank" href="' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-image-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.xls':
                case '.xlsx':
                    $('#listaadjuntos').append('<a target="_blank" href="' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-excel-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.doc':
                case '.docx':
                    $('#listaadjuntos').append('<a target="_blank" href="' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-word-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.ppt':
                case '.pptx':
                    $('#listaadjuntos').append('<a target="_blank" href="' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-powerpoint-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.mp3':
                case '.wma':
                case '.wav':
                    $('#listaadjuntos').append('<a target="_blank" href="' + value[1] + '" > <div class="Buttonref" role="alert"> <i class="fa fa-file-audio-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;

                case '.avi':
                case '.mp4':
                case '.mpg':
                case '.wmv':
                case '.mov':
                    $('#listaadjuntos').append('<a target="_blank" href="' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file-video-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                case '.pdf':
                    $('#listaadjuntos').append('<a target="_blank" href="' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file-pdf-o fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
                default:
                    $('#listaadjuntos').append('<a target="_blank" href="' + value[1] + '"> <div class="Buttonref" role="alert"> <i class="fa fa-file fa-2x" aria-hidden="true"></i>   ' + value[0] + ' </div> </a>');
                    break;
            }









        });
    });
}

cargardocumento();
