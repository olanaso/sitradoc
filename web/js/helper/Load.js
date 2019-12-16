var arrayScript = new Array();
var htmlinsert;
function cargarJS(url) {
    var newscript = document.createElement('script');
    newscript.type = 'text/javascript';
    newscript.async = false;
    newscript.id = arrayScript.length + 1;
    newscript.src = url;
    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(newscript);
    arrayScript.push(arrayScript.length + 1);
}



/*Funcion que remueve las JS*/
function removeFilesLoad() {
    $.each(arrayScript, function (key, value) {
        $("#" + value).remove();
    });
    arrayScript = [];
}

/*Funcion que me permite cargar una pagina web*/
function cargarPaginaFunction(idDiv, href, fn) {
    $("#" + idDiv).children().remove();
    $("#" + idDiv).load(href, function () {
        fn();
        htmlinsert=$("#" + idDiv);
    });
}

/*Funcion que me permite cargar una pagina web*/
function cargarPagina(idDiv, href) {
    $("#" + idDiv).empty();
    $("#" + idDiv).load(href, function () {
        $('body').removeClass("loading");
    });
}

/*Funcion que me permite cargar una pagina web*/
function addHTML(idDiv, href) {
$("#" + idDiv).append($('<div>').load(href));
}

/*__________________________________EVENTOS DEL MENU___________________________________________________*/

/*______Cargando al Menu cliente__________*/

$("#recepcionExterna").click(function(evento) {
    $('#overlayViews').show(500);
    removeFilesLoad();
    //cargarPagina('ContainerModal', urlApp + '/html/Cliente/ViewModalCliente.html');
    var funtionCallJS = function() {
        cargarJS(urlApp + '/js/tramite/JSRecepcion.js');
    };
    cargarPaginaFunction('containerViews', urlApp + '/pages/views/viewRecepcionExterna.html', funtionCallJS);

});

$("#recepcionInterna").click(function(evento) {
    $('#overlayViews').show(500);
    removeFilesLoad();
    var funtionCallJS = function() {
        cargarJS(urlApp + '/js/tramite/JSRecepcionInterna.js');
    };
    cargarPaginaFunction('containerViews', urlApp + '/pages/views/viewRecepcionInterna.html', funtionCallJS);
});

$("#misdocumentos").click(function(evento) {
    $('#overlayViews').show(500);
    removeFilesLoad();
     var funtionCallJS = function() {
        cargarJS(urlApp + '/js/tramite/JSDocumento.js');
    };
    cargarPaginaFunction('containerViews', urlApp + '/pages/views/viewDocumento.html', funtionCallJS);
});

$("#tramiteExterno").click(function(evento) {
    $('#overlayViews').show(500);
    removeFilesLoad();
     var funtionCallJS = function() {
        cargarJS(urlApp + '/js/tramite/JSFlujo.js');
    };
    cargarPaginaFunction('containerViews', urlApp + '/pages/views/viewTramiteExterno.html', funtionCallJS);
});

