function agregardestinos() {
    $('#Modalref_area_usuario').modal('show');
    cargaGrillaAreaDestino();
}

$(function () {
    crearGrillaAreaDestino();
    crearGrillaUsuarioDestino();

    $('#containerGrilla_gridareasdestino').bind('resize', function () {
        $("#gridareasdestino").setGridWidth($('#containerGrilla_gridareasdestino').width());
    }).trigger('resize');
    $('#containerGrilla_gridusuariodestino').bind('resize', function () {
        $("#gridusuariodestino").setGridWidth($('#containerGrilla_gridusuariodestino').width());
    }).trigger('resize');
});

/*Eventos */
$(function () {
    $('#btnagregarareasusuarios').click(function (e){
        enviarUsuariosAreas();
    })
});

function crearGrillaAreaDestino() {
    $("#gridareasdestino").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        ignoreCase: true,
        caption: "Lista Areas",
        colNames: ["idarea", "Abreviatura", "Area"],
        colModel: [
            {
                name: 'idarea',
                index: 'idarea',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'abreviatura',
                index: 'abreviatura',
                editable: false,
                width: 100,
                hidden: false
            },
            {
                name: 'denominacion',
                index: 'denominacion',
                editable: false,
                width: 250,
                hidden: false
            }
        ],
        pager: '#pagerareasdestino',
        //onSelectRow: viewGeometry,
        //rowList =['All'],
        rowNum: 10000,
        rowList: ["All"],
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        multiselect: true,
        onSelectRow: selectOneItemArea,
        onSelectAll: selectAllItemArea
    });
    $("#gridareasdestino").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}
function cargaGrillaAreaDestino() {

    var Area = {
        IndOpSp: 1,
    };

    $.ajaxCall(urlApp + '/AreaController/getJSON.htm', {poAreaBE: Area}, false, function (response) {
        $('#gridareasdestino').jqGrid('clearGridData');
        jQuery("#gridareasdestino").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
    });
    //PintarRowGrilla("grid", 'bindobservado', 'false', '#E21E27', '#FFFFFF')
}

var array_areas_seleccionadas = new Array();
function selectOneItemArea(rowId, status, e) {
    var row = jQuery("#gridareasdestino").getRowData(rowId);
    if (status) {
        array_areas_seleccionadas.push({
            idarea: row.idarea,
            area: row.denominacion
        });
    } else {
        removeAreasSelected(row.idarea);
    }
    showFilters();
}

function removeAreasSelected(idarea) {
    // return array_areas_seleccionadas.idarea!==idarea;
    array_areas_seleccionadas = jQuery.grep(array_areas_seleccionadas, function (elementOfArray, indexInArray) {
        return (elementOfArray.idarea != idarea);
    });
}

function removeAreasAll() {
    // return array_areas_seleccionadas.idarea!==idarea;
    array_areas_seleccionadas = [];
    showFilters();
}

function borrarFiltro(idarea) {
    removeAreasSelected(idarea);
    showFilters();
}

function showFilters() {
    $('#filtros').html('');
    var ids = []
    array_areas_seleccionadas.map(function (arrayItem) {
        $('#filtros').append('<label title="' + arrayItem.area + '" class="area"><i><a onclick="borrarFiltro(' + arrayItem.idarea + ')">X </a>' + arrayItem.area + ' </i> </label>');
        ids.push(arrayItem.idarea);
    });
    cargaGrillaUsuarioDestino(ids.toString());
}

function selectAllItemArea(ids, status) {
    if (status) {
        //alert(ids.join());
        //array_areas_seleccionadas = new Array();
        for (var i = 0; i < ids.length; i++) {
            var row = jQuery("#gridareasdestino").getRowData(ids[i]);
            array_areas_seleccionadas.push({
                idarea: row.idarea,
                area: row.denominacion
            });
        }


    }
    else {
        array_areas_seleccionadas = [];
    }

    showFilters();
}

function crearGrillaUsuarioDestino() {
    $("#gridusuariodestino").jqGrid({
        /*data: mydata,*/
        datatype: "local",
        height: 300,
        width: 500,
        ignoreCase: true,
        caption: "Lista Usuario",
        colNames: ["Area", "idusuario", "Nombre", "Usuario", "Cargo", "Is Jefe"],
        colModel: [
            {
                name: 'area',
                index: 'area',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'idusuario',
                index: 'idusuario',
                editable: false,
                width: 150,
                hidden: true
            },
            {
                name: 'nombre',
                index: 'nombre',
                editable: false,
                width: 150,
                hidden: false
            },
            {
                name: 'usuario',
                index: 'usuario',
                editable: false,
                width: 100,
                hidden: false
            }

            ,
            {
                name: 'cargo',
                index: 'cargo',
                editable: false,
                width: 150,
                hidden: false
            }
            ,
            {
                name: 'bindjefe',
                index: 'bindjefe',
                editable: false,
                width: 150,
                hidden: false
            }


        ],
        pager: '#paperusuariodestino',
        //onSelectRow: viewGeometry,
        rowNum: 10000,
        rowList: ["All"],
        viewrecords: true,
        rownumbers: true,
        shrinkToFit: false,
        multiselect: true,
       // beforeSelectRow: selectOneItemUsuario,
       // onSelectAll: selectAllItemUsuario,
        grouping: true,
        groupingView: {
            groupField: ['area'],
            groupColumnShow: [false]
        },
    });
    $("#gridusuariodestino").jqGrid('filterToolbar', {stringResult: true, searchOnEnter: false, defaultSearch: "cn"});
}
function cargaGrillaUsuarioDestino(ids) {

    if (ids.length == 0) {
        $('#gridusuariodestino').jqGrid('clearGridData');
    } else {
        var Area = {
            IndOpSp: 2
            , areasuperior: ids
        };

        $.ajaxCall(urlApp + '/AreaController/getJSON.htm', {poAreaBE: Area}, false, function (response) {
            $('#gridusuariodestino').jqGrid('clearGridData');
            jQuery("#gridusuariodestino").jqGrid('setGridParam', {data: response}).trigger('reloadGrid');
        });
    }

    SelectRowGrilla("gridusuariodestino", "bindjefe", true);
    //saveUsuarios();
    //PintarRowGrilla("grid", 'bindobservado', 'false', '#E21E27', '#FFFFFF')
}

var usuariosseleccionados = [];
function saveUsuarios() {
    usuariosseleccionados = [];
    var array_ids_users = jQuery("#gridusuariodestino").jqGrid('getGridParam', 'selarrrow');
    for (var i = 0; i < array_ids_users.length; i++) {
        var row = jQuery("#gridusuariodestino").getRowData(array_ids_users[i])
        usuariosseleccionados.push({
            idusuario: row.idusuario,
            usuario: row.usuario
        });
    }
}


function removeUsuariosDuplicate() {
    // return array_areas_seleccionadas.idarea!==idarea;
    var results = [];
    var idsSeen = {}, idSeenValue = {};
    for (var i = 0, len = usuariosseleccionados.length, id; i < len; ++i) {
        id = usuariosseleccionados[i].idusuario;
        if (idsSeen[id] !== idSeenValue) {
            results.push(usuariosseleccionados[i]);
            idsSeen[id] = idSeenValue;
        }
    }

    usuariosseleccionados = results;
}

function getidsareas(){
    var areas=[];
    for (var i = 0, len = array_areas_seleccionadas.length; i < len; ++i) {
       areas.push(array_areas_seleccionadas[i].idarea);
    }
    return areas;
}

function getidsusuarios(){
    var usuarios=[];
    for (var i = 0, len = usuariosseleccionados.length; i < len; ++i) {
       usuarios.push(usuariosseleccionados[i].idusuario);
    }
    return usuarios;
}

function enviarUsuariosAreas(){
    saveUsuarios();
    removeUsuariosDuplicate();
    return {
       usuarios: usuariosseleccionados,
       areas: array_areas_seleccionadas,
       listidsareas:getidsareas(),
       listidusuarios:getidsusuarios()
    };
}

