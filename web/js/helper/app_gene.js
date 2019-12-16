/*varibles globales de session*/
var Usuario;
/*varibles globales de session*/
function mostrarReporteRequerimiento(e, t, o, a, r) {
    window.open(e, null, "directories=no,channelmode =0,resizable=no,status=no,location=no,toolbar=no,menubar=no,fullscreen=no,scrollbars=yes, center:yes,dependent=no,width=" + t + ",left=" + a + ",height=" + o + ",top=" + r)
}
function obtenerIdsGrilla(e) {
    var t = new Array;
    return $(e + " tbody tr").each(function (e, o) {
        t.push(o.id)
    }), t
}
function actualizarIDGrid(e) {
    $(e + " tbody tr").each(function (e, t) {
        t.id = e
    })
}
function insetarIds(e, t) {
    $(e + " tbody tr").each(function (e, o) {
        o.id = t[e]
    })
}
function fGetNumUnico() {
    var e = new Date, t = e.getDay(), o = e.getMonth(), a = e.getFullYear(), r = e.getMinutes(), n = e.getHours(), i = e.getSeconds(), u = "" + a + o + t + n + r + i;
    return parseInt(u)
}
function limpiarForm(e) {
    $(e + " textarea").each(function () {
        $(this).val("")
    }), $(e + " select").each(function () {
        $(this).selectedIndex = 0
    }), $(e + " input").each(function () {
        var e = $(this).attr("inafecto");
        void 0 != e || ($(this).val(""), $(this).prop("checked", !1));
//        $(this).val(""), $(this).prop("checked", !1)
    })
}
function sleep(e) {
    for (var t = (new Date).getTime(), o = 0; 1e7 > o && !((new Date).getTime() - t > e); o++)
        ;
}
function actualizarIDGrid(e) {
    $("#" + e + " tbody tr").each(function (e, t) {
        t.id = e
    }), $("#" + e + " tbody tr td input").each(function (t, o) {
        o.id = "jqg_" + e + "_" + (t + 1)
    })
}
function PintarRowGrilla(e, t, o, a, r) {
    actualizarIDGrid(e), columns = $("#" + e).jqGrid("getGridParam", "colNames"), $("#" + e + " tr [aria-describedby=" + e + "_" + t + "]").each(function (t) {
        for (var n = columns.length; n > 0; )
            n--, $(this).text() == o && jQuery("#" + e).setCell(t + 1, n, "", {"background-color": a, color: r})
    })
}

function SelectRowGrilla(idgrilla, namecolumn, valorComparar) {
    var qfunciont =
            ' var idgrilla="' + idgrilla + '";' +
            ' var namecolumn="' + namecolumn + '";' +
            ' var valorComparar="' + valorComparar + '";' +
            '/* actualizarIDGrid(idgrilla);*/ ' +
            'columns = $("#" + idgrilla).jqGrid("getGridParam", "colNames"); ' +
            '$("#" + idgrilla + " tr [aria-describedby=" + idgrilla + "_" + namecolumn + "]").each(function (r) {' +
            ' var c = columns.length;' +
            ' while (c > 0) {' +
            '   c--;' +
            '  if ($(this).text() === valorComparar)' +
            '  jQuery("#" + idgrilla).jqGrid("setSelection",r + 1, true);' +
            '}' +
            '});'

    eval(qfunciont);
}

function eliminarElemArray(e, t) {
    var o = e.indexOf(t);
    return-1 !== o && e.splice(o, 1), e
}
function eliminarArraytoArray(e, t) {
    for (var o = t.length, a = 0; o > a; a++)
        e = eliminarElemArray(e, t[a]);
    return e
}
function redondeo(e) {
    return formato_numero(e, 0, ".", ",")
}
function formato_numero(e, t, o, a) {
    if (e = parseFloat(e), isNaN(e))
        return"";
    if (void 0 !== t && (e = e.toFixed(t)), e = e.toString().replace(".", void 0 !== o ? o : ","), a)
        for (var r = new RegExp("(-?[0-9]+)([0-9]{3})"); r.test(e); )
            e = e.replace(r, "$1" + a + "$2");
    return e
}
function ArraytoCvs(e, t) {
    var o = "data:text/csv;charset=utf-8,";
    e.forEach(function (e) {
        dataString = e.join(","), o += dataString + "\n"
    });
    var a = encodeURI(o), r = document.createElement("a");
    document.body.appendChild(r), r.href = a, r.download = t, r.click()
}
function cargarJS(e, t) {
    var o = document.createElement("script");
    o.type = "text/javascript", o.async = !1, o.id = t, o.src = e, (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild(o)
}
jQuery.ajaxSinParametros = function (e, t, o) {
    $.ajax({type: "POST", url: e, contentType: "application/json; charset=utf-8", dataType: "json", async: t, success: o, error: function (t) {
            jsErrLog.ErrorTrap(jQuery.parseJSON(t.responseText).Message, location.href, e, "")
        }})
}, jQuery.ajaxCall = function (e, t, o, a) {
    $.ajax({type: "POST", url: e, data: JSON.stringify(t), contentType: "application/json; charset=utf-8", dataType: "json", async: o, success: a, error: function (t, o, a) {
            console.log(t), console.log(o), console.log(a), bootbox.dialog({closeButton: !1, title: "<h1>ERROR!!! </h1> <br> Metodo:" + e + "<b><br> " + t.status + "  " + a + "</b>", message: t.responseText})
        }})
}, jQuery.ajaxLoad = function (e, t, o, a) {
    $.ajax({type: "POST", url: e, data: JSON.stringify(t), contentType: "application/json; charset=utf-8", dataType: "json", async: o, success: a, error: function (e) {
            bootbox.alert(":( Ocurrio un error en el Sistema...")
        }})
}, jQuery.ajaxReport = function (e, t, o, a) {
    $.ajax({type: "POST", url: e, data: JSON.stringify(t), contentType: "application/json; charset=utf-8", dataType: "text", async: o, success: a, error: function (t) {
            console.log(jQuery.parseJSON(t.responseText).Message, location.href, e, "")
        }})
}, jQuery.xml = function (e, t) {
    $.ajax({type: "GET", url: "../../Xml/" + e, dataType: "xml", success: t})
}, jQuery.ajaxObject = function (e, t, o, a, r) {
    $.ajax({type: "POST", url: e, data: "{'" + t + "':" + JSON.stringify(o) + "}", contentType: "application/json; charset=utf-8", dataType: "json", async: a, success: r, error: function (t) {
            jsErrLog.ErrorTrap(jQuery.parseJSON(t.responseText).Message, location.href, e, "")
        }})
}, jQuery.DropDownList = function (e, t, o) {
    $(o).html(""), $.ajaxCall(e, t, !1, function (e) {
        $.each(e, function (e, t) {
            $(o).append('<option value="' + t.Id + '" title="' + t.Valor + '">' + t.Valor + "</option>")
        })
    })
}, jQuery.DropDownListInt64 = function (e, t, o) {
    $(o).html(""), $.ajaxCall(e, t, !1, function (e) {
        $.each(e, function (e, t) {
            $(o).append('<option value="' + t.Id2 + '" title="' + t.Valor + '">' + t.Valor + "</option>")
        })
    })
}, jQuery.CargarComboSinIni = function (e, t, o) {
    $(o).html(""), $.ajaxCall(e, t, !1, function (e) {
        $.each(e, function (e, t) {
            $(o).append('<option value="' + t[0] + '" title="' + t[1] + '">' + t[1] + "</option>")
        })
    })
}, jQuery.CargarCombo = function (e, t, o) {
    $(o).html(""), $.ajaxCall(e, t, !1, function (e) {
        console.log(t[0] + "::::" + t[1]);
        $(o).append('<option value="0" title="TODOS">NINGUNO</option>'), $.each(e, function (e, t) {
            $(o).append('<option value="' + t[0] + '" title="' + t[1] + '">' + t[1] + "</option>")
        })
    })
}, jQuery.CargarComboData = function (e, o) {
    $(o).html(""), // $.ajaxCall(e, t, !1, function(e) {
//        console.log(t[0]+"::::"+t[1]);
            $(o).append('<option value="0" title="TODOS">NINGUNO</option>'), $.each(e, function (e, t) {
        $(o).append('<option value="' + t[0] + '" title="' + t[1] + '">' + t[1] + "</option>")
    })
    //})
}, jQuery.CargarComboDualList = function (e, t, o) {
    $(o).html(""), $.ajaxCall(e, t, !1, function (e) {
        $.each(e, function (e, t) {
            $(o).append('<option value="' + t[0] + '" title="' + t[1] + '">' + t[1] + "</option>")
        })
    })
}, jQuery.CargarComboFirtopt = function (e, t, o, a, r) {
    $(o).html(""), $.ajaxCall(e, t, !1, function (e) {
        $(o).append('<option value="' + a + '" title="' + r + '">' + r + "</option>"), $.each(e, function (e, t) {
            $(o).append('<option value="' + t[0] + '" title="' + t[1] + '">' + t[1] + "</option>")
        })
    })
}, jQuery.CargarMultipleCombo = function (e, t, o) {
    $(o).html(""), $.ajaxCall(e, t, !1, function (e) {
        $.each(e, function (e, t) {
            $(o).append('<option value="' + t[0] + '" title="' + t[1] + '">' + t[1] + "</option>")
        })
    })
}, jQuery.DropDownListCod = function (e, t, o) {
    $(o).html(""), $.ajaxCall(e, t, !1, function (e) {
        $.each(e, function (e, t) {
            $(o).append('<option value="' + t.Codigo + '" title="' + t.Valor + '">' + t.Valor + "</option>")
        })
    })
}, jQuery.SelectCombo = function (purl, pdata, pDropDownList, pFunctionEach) {
    $(pDropDownList).html(""), $.ajaxCall(purl, pdata, !1, function (response) {
        var data = "string" == typeof response.d ? eval("(" + response.d + ")") : response.d;
        $.each(data, pFunctionEach)
    })
}, jQuery.fn.Autocomplete = function (purl, pTextBoxControl, pWidth, pFunctionItem, pFunctionSelect) {
    $(pTextBoxControl).autocomplete({source: function (request, response) {
            var param = new Object;
            param.pnvDenominacion = request.term, $.ajaxCall(purl, param, !0, function (respon) {
                var data = "string" == typeof respon ? eval("(" + respon + ")") : respon;
                null != data && response($.map(data, pFunctionItem))
            })
        }, open: function () {
            $(this).autocomplete("widget").css({width: pWidth})
        }, select: pFunctionSelect})
}, jQuery.fn.AutocompleteWithPobject = function (e, t, o, a, r, n) {
    $(o).autocomplete({source: function (o, a) {
            var n = {pObject: t, pnvDenominacion: o.term};
            $.ajaxCall(e, n, !0, function (e) {
                var t = e;
                null != t && a($.map(t, r))
            })
        }, open: function () {
            $(this).autocomplete("widget").css({width: a})
        }, select: n})
}, jQuery.SearchByCodeWithAutoCompletePobjectApp = function (e, t, o, a, r) {
    $("#" + o).blur(function () {
        if ("" != $("#" + o).val()) {
            var n = new Object;
            n.param = $("#" + o).val(), n.param = $.AutoCompleteCode(n.param, a), $("#" + o).val(n.param);
            var i = t(), u = {pObject: i, pnvDenominacion: n.param};
            $.ajaxCall(e, u, !0, r)
        }
    })
}, jQuery.SearchByCodeWithAutoComplete = function (e, t, o, a) {
    $("#" + t).blur(function () {
        if ("" != $("#" + t).val()) {
            var r = new Object;
            r.param = $("#" + t).val(), r.param = $.AutoCompleteCode(r.param, o), $("#" + t).val(r.param), $.ajaxCall(e, r, !0, a)
        }
    })
}, jQuery.fn.GridBusqueda = function (e, t, o) {
    var a = $(e.NameGrid);
    a.jqGrid({datatype: function () {
            null != o && $.ajaxCall(o, {poSearchParam: t, pPaginaActual: a.getGridParam("page"), pTamanioPagina: a.getGridParam("rowNum")}, !1, function (e, t) {
                "success" == t && a[0].addJSONData(jQuery.parseJSON(e.d))
            })
        }, colModel: e.ColModel, jsonReader: {page: "CurrentPage", total: "PageCount", records: "RecordCount", repeatitems: !0, cell: "Row", root: "Items", id: "ID"}, pager: $(e.NamePager), loadtext: "Cargando datos...", recordtext: "{0} - {1} de {2} elementos", emptyrecords: "No hay resultados", pgtext: "Pág: {0} de {1}", rowNum: "500", rowList: [10, 20, 30], viewrecords: !0, multiselect: e.Multiselect, sortname: "Name", sortorder: "asc", width: e.Width, height: e.Height, caption: e.Caption, ondblClickRow: e.DoubleClick, onSelectRow: e.onSelectRow}).navGrid(e.NamePager, {edit: !1, add: !1, search: !1, del: !1}), jQuery.extend(jQuery.jgrid.edit, {ajaxEditOptions: {contentType: "application/json"}, recreateForm: !0, serializeEditData: function (e) {
            return JSON.stringify(e)
        }}), jQuery.extend(jQuery.jgrid.del, {ajaxDelOptions: {contentType: "application/json"}, serializeDelData: function (e) {
            return JSON.stringify(e)
        }})
}, jQuery.GridEditDelUrl = function (e, t, o, a) {
    var r = $(e.NameGrid);
    $.GridEditDelDatatype(e, function () {
        $.ajax(t, {pPaginaActual: r.getGridParam("page"), pTamanioPagina: r.getGridParam("rowNum")}, !1, function (e, t) {
            "success" == t && r[0].addJSONData(jQuery.parseJSON(e.d))
        })
    }, o, a)
}, jQuery.GridDatatype = function (e, t) {
    var o = $(e.NameGrid);
    o.jqGrid({datatype: function () {
            t()
        }, colModel: e.ColModel, jsonReader: {page: "CurrentPage", total: "PageCount", records: "RecordCount", repeatitems: !0, cell: "Row", root: "Items", id: "ID"}, pager: $(e.NamePager), loadtext: "Cargando datos...", recordtext: "{0} - {1} de {2} elementos", emptyrecords: "No hay resultados", pgtext: "Pág: {0} de {1}", rowNum: null == e.rowNum || void 0 == e.rowNum ? "11" : e.rowNum, rowList: [11, 22, 33], shrinkToFit: e.shrinkToFit, viewrecords: !0, multiselect: e.Multiselect, onSelectRow: e.OnSelectRow, sortname: "Name", sortorder: "asc", width: e.Width, height: e.Height, caption: e.Caption, ondblClickRow: e.DoubleClick, subGrid: e.subGrid, subGridRowExpanded: e.subGridRowExpanded, subGridRowColapsed: e.subGridRowColapsed}).navGrid(e.NamePager, {edit: !1, add: !1, search: !1, del: !1})
}, jQuery.GridDatatypeDemon = function (e, t) {
    var o = $(e.NameGrid);
    o.jqGrid({datatype: function () {
            t()
        }, colModel: e.ColModel, jsonReader: {page: "CurrentPage", total: "PageCount", records: "RecordCount", repeatitems: !0, cell: "Row", root: "Items", id: "ID"}, loadtext: "Cargando datos...", emptyrecords: "No hay resultados", shrinkToFit: e.shrinkToFit, viewrecords: !0, multiselect: e.Multiselect, onSelectRow: e.OnSelectRow, sortname: "Name", sortorder: "asc", width: e.Width, height: e.Height, caption: e.Caption, ondblClickRow: e.DoubleClick, subGrid: e.subGrid, subGridRowExpanded: e.subGridRowExpanded, subGridRowColapsed: e.subGridRowColapsed, grouping: e.Grouping, groupingView: {groupField: [e.NameGroup], groupColumnShow: [!1], groupText: ["<b>{0}</b>"], groupCollapse: !0, groupOrder: ["asc"], groupDataSorted: !1}, editurl: "server.php", afterInsertRow: e.afterInsertRow}).navGrid(e.NamePager, {edit: !1, add: !1, search: !1, del: !1})
}, jQuery.GridDatatypeWithSearch = function (e, t) {
    var o = $(e.NameGrid);
    o.jqGrid({datatype: function () {
            t()
        }, colModel: e.ColModel, jsonReader: {page: "CurrentPage", total: "PageCount", records: "RecordCount", repeatitems: !0, cell: "Row", root: "Items", id: "ID"}, pager: $(e.NamePager), loadtext: "Cargando datos...", recordtext: "{0} - {1} de {2} elementos", emptyrecords: "No hay resultados", pgtext: "Pág: {0} de {1}", rowNum: null == e.rowNum || void 0 == e.rowNum ? "11" : e.rowNum, rowList: [11, 22, 33], shrinkToFit: e.shrinkToFit, viewrecords: !0, multiselect: e.Multiselect, onSelectRow: e.OnSelectRow, sortname: "Name", sortorder: "asc", width: e.Width, height: e.Height, caption: e.Caption, ondblClickRow: e.DoubleClick, grouping: e.Grouping, groupingView: {groupField: [e.NameGroup], groupColumnShow: [!1], groupText: ["<b>{0}</b>"], groupCollapse: !0, groupOrder: ["asc"], groupDataSorted: !1}, editurl: "server.php", afterInsertRow: e.afterInsertRow}).navGrid(e.NamePager, {edit: !1, add: !1, search: !0, del: !1}, {}, {}, {}, {caption: "Buscar Contribuyente", Find: "Buscar", Reset: "Limpiar", odata: ["Igual a "], sopt: ["eq"], closeAfterSearch: !0, search: !1, onSearch: e.OnSearch}, {closeOnEscape: !0})
}, jQuery.GridDatatypeZeroC = function (e, t) {
    var o = $(e.NameGrid);
    o.jqGrid({datatype: function () {
            t()
        }, colModel: e.ColModel, jsonReader: {page: "CurrentPage", total: "PageCount", records: "RecordCount", repeatitems: !0, cell: "Row", root: "Items", id: "ID"}, pager: $(e.NamePager), loadtext: "Cargando datos...", recordtext: "{0} - {1} de {2} elementos", emptyrecords: "No hay resultados", pgtext: "Pág: {0} de {1}", rowNum: null == e.rowNum || void 0 == e.rowNum ? "22" : e.rowNum, rowList: e.RowList, viewrecords: !0, multiselect: e.Multiselect, onSelectRow: e.OnSelectRow, sortname: "Name", sortorder: "asc", width: e.Width, height: e.Height, caption: e.Caption, ondblClickRow: e.DoubleClick, grouping: e.Grouping, groupingView: {groupField: [e.NameGroup], groupColumnShow: [!1], groupText: ["<b>{0}</b>"], groupCollapse: e.GroupCollapse, groupOrder: ["asc"], groupDataSorted: !1}, editurl: "server.php", afterInsertRow: e.afterInsertRow}).navGrid(e.NamePager, {edit: !1, add: !1, search: !1, del: !1})
}, jQuery.GridEditDelDatatype = function (e, t, o, a) {
    var r = $(e.NameGrid), n = "";
    e.ColModel.unshift({name: "del", index: "del", width: 40, sortable: !1, label: " "}), e.ColModel.unshift({name: "edit", index: "edit", width: 40, sortable: !1, label: " "}), r.jqGrid({datatype: function () {
            t();
            var o = e.NameGrid.replace("#", "");
            $("#" + o + " tr [aria-describedby='" + o + "_edit']").css({"background-image": 'url("../../Images/imgJqGrid/Editar.png")', "background-repeat": "no-repeat", cursor: "pointer"}), $("#" + o + " tr [aria-describedby='" + o + "_del']").css({"background-image": 'url("../../Images/imgJqGrid/Eliminar.png")', "background-repeat": "no-repeat", cursor: "pointer"}), $("#" + o + " tr [aria-describedby='" + o + "_edit']").click(function () {
                n = "edit"
            }), $("#" + o + " tr [aria-describedby='" + o + "_del']").click(function () {
                n = "del"
            })
        }, colModel: e.ColModel, jsonReader: {page: "CurrentPage", total: "PageCount", records: "RecordCount", repeatitems: !0, cell: "Row", root: "Items", id: "ID"}, pager: $(e.NamePager), loadtext: "Cargando datos...", recordtext: "{0} - {1} de {2} elementos", emptyrecords: "No hay resultados", pgtext: "Pág: {0} de {1}", rowNum: null == e.rowNum || void 0 == e.rowNum ? "10" : e.rowNum, rowList: [10, 20, 30], viewrecords: !0, multiselect: e.Multiselect, sortname: "Name", sortorder: "asc", width: e.Width, height: e.Height, caption: e.Caption, ondblClickRow: e.DoubleClick, onSelectRow: function (e) {
            "edit" == n ? o(e) : "del" == n && a(e), n = ""
        }, grouping: e.grouping, groupingView: {groupField: [e.NameGroup], groupColumnShow: [!1], groupText: ["<b>{0}</b>"], groupCollapse: !1, groupOrder: ["asc"], groupDataSorted: !1}}).navGrid(e.NamePager, {edit: !1, add: !1, search: !1, del: !1})
}, jQuery.GridEditDatatype = function (e, t, o) {
    var a = $(e.NameGrid), r = "";
    e.ColModel.unshift({name: "edit", index: "edit", width: 25, sortable: !1, label: " "}), a.jqGrid({datatype: function () {
            t();
            var o = e.NameGrid.replace("#", "");
            $("#" + o + " tr [aria-describedby='" + o + "_edit']").css({"background-image": 'url("../../Images/imgJqGrid/Consultar.png")', "background-repeat": "no-repeat", cursor: "pointer"}), $("#" + o + " tr [aria-describedby='" + o + "_edit']").click(function () {
                r = "edit"
            })
        }, colModel: e.ColModel, jsonReader: {page: "CurrentPage", total: "PageCount", records: "RecordCount", repeatitems: !0, cell: "Row", root: "Items", id: "ID"}, pager: $(e.NamePager), loadtext: "Cargando datos...", recordtext: "{0} - {1} de {2} elementos", emptyrecords: "No hay resultados", pgtext: "Pág: {0} de {1}", rowNum: "10", rowList: [10, 20, 30], viewrecords: !0, multiselect: e.Multiselect, sortname: "Name", sortorder: "asc", width: e.Width, height: e.Height, caption: e.Caption, ondblClickRow: e.DoubleClick, onSelectRow: function (e) {
            "edit" == r && o(e), r = ""
        }, grouping: e.grouping, groupingView: {groupField: [e.NameGroup], groupColumnShow: [!1], groupText: ["<b>{0}</b>"], groupCollapse: !1, groupOrder: ["asc"], groupDataSorted: !1}}).navGrid(e.NamePager, {edit: !1, add: !1, search: !1, del: !1})
}, jQuery.Calendario = function (e) {
    $(e).datepicker({changeMonth: !0, changeYear: !0, autoSize: !1, inline: !0, showButtonPanel: !0, dateFormat: "dd/mm/yy", dayNames: ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sabado"], dayNamesMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa"], dayNamesShort: ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab"], monthNames: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"], monthNamesShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Set", "Oct", "Nov", "Dic"], closeText: "Salir", currentText: "Hoy", nextText: "Siguiente", prevText: "Anterior"}), $(e).datepicker($.datepicker.regional.es)
}, jQuery.Hora = function (e) {
     $(e).ptTimeSelect({
            hoursLabel:     'Horas',
            minutesLabel:   'Minutos',
            setButtonLabel: 'Establecer',
    });
}, jQuery.Tab = function (e) {
    $(e).tabs({collapsible: !0})
}, jQuery.LimpiarFormulario = function (e) {
    var t = $("#" + e);
    $(":input", t).each(function () {
        var e = this.type, t = this.tagName.toLowerCase();
        "text" == e || "password" == e || "textarea" == t ? this.value = "" : "checkbox" == e || "radio" == e ? this.checked = !1 : "select" == t && (this.selectedIndex = -1)
    })
}, jQuery.InhabilitarFormulario = function (e) {
    var t = "#" + e;
    $(t + " :input").each(function () {
        var e = this.type, t = this.tagName.toLowerCase();
        "text" == e || "password" == e || "textarea" == t ? this.disabled = !0 : "checkbox" == e || "radio" == e ? this.disabled = !0 : "select" == t && (this.disabled = !0)
    })
}, jQuery.HabilitarFormulario = function (e) {
    var t = "#" + e;
    $(t + " :input").each(function () {
        var e = this.type, t = this.tagName.toLowerCase();
        "text" == e || "password" == e || "textarea" == t ? this.disabled = !1 : "checkbox" == e || "radio" == e ? this.disabled = !1 : "select" == t && (this.disabled = !1)
    })
}, jQuery.Preloading = function () {
    $("#div_precarga").ajaxStart(function () {
        $(this).show()
    }).ajaxStop(function () {
        $(this).hide()
    })
}, jQuery.GetBoolean = function (e) {
    return"true" == String(e)
}, jQuery.LlenarGrilla = function (e, t) {
    $.GetBoolean(t.bEsCorrecto) ? $(e)[0].addJSONData(jQuery.parseJSON(t.nvResultadoGrilla)) : ($(e)[0].addJSONData(jQuery.parseJSON('{"PageCount":0,"CurrentPage":1,"RecordCount":0,"Items":null}')), $.MessageAlert(MENSAJEOPERACION.ERROR_CARGAR_DATA.msje))
}, jQuery.Upload = function (e, t, o, a, r) {
    return $(t).ajaxStart(function () {
        $(this).show()
    }).ajaxComplete(function () {
        $(this).hide()
    }), $.ajaxFileUpload({url: o, secureuri: !1, fileElementId: e, dataType: "json", data: a, success: r, error: function (e, t, o) {
            alert(o)
        }}), !1
}, jQuery.time = function (e) {
    $(e).timepickr()
}, jQuery.FechaToday = function (e) {
    var t = new Date, o = t.getDate(), a = t.getMonth() + 1, r = t.getFullYear();
    10 > o && (o = "0" + o), 10 > a && (a = "0" + a);
    var t = r + "-" + a + "-" + o;
    $(e).mask("9999-99-99", {placeholder: "aaaa/mm/dd"}), $(e).val(t)
}, jQuery.alertConfirm = function (e, t, o) {
    confirm(e) ? t() : o()
}, jQuery.LlenarCerosIzquierda = function (e, t) {
    for (e = e.toString(); e.length < t; )
        e = "0" + e;
    return e
}, jQuery.getAlloptionsSelect = function (e) {
    var t = [];
    return $(e + " option").each(function () {
        t.push($(this).val())
    }), t
}, jQuery.ValidarHora = function (e) {
    $(e).removeClass("error");
    var t = $(e).val().replace(/^([0-9])([0-9]):([0-9])_$/, "0$1:$2$3");
    return t.match(/([0-1][0-9]|2[0-3]):[0-5][0-9]/) ? ($(e).val(t), !0) : ($(e).val(""), void $(e).addClass("error"))
}, jQuery.extend({getURLParam: function (e) {
        var t = "", o = window.location.href, a = !1, r = e + "=", n = r.length;
        if (o.indexOf("?") > -1)
            for (var i = o.substr(o.indexOf("?") + 1), u = i.split("&"), l = 0; l < u.length; l++)
                if (u[l].substr(0, n) == r) {
                    var c = u[l].split("=");
                    t = c[1], a = !0;
                    break
                }
        return 0 == a ? null : t
    }}), $(document).ajaxSend(function () {
    $("#mydiv").show()
}), $(document).ajaxComplete(function () {
    $("#mydiv").hide()
}), jQuery.HoraMask = function (e) {
    jQuery(function (t) {
        t(e).mask("99:99", {placeholder: "hh:mm"})
    })
}, jQuery.ajaxUpload = function (e, t, o) {
    var a = new FormData(document.getElementById(t));
    $.ajax({url: e, data: a, dataType: "text", processData: !1, contentType: !1, cache: !1, type: "POST", success: o, error: function (e) {
            $("body").removeClass("loading"), bootbox.alert(Mensajes.operacionErronea)
        }})
}, jQuery.fn.AutocompleteMultiple = function (purl, pTextBoxControl, pWidth, pFunctionItem, pFunctionSelect) {
    $(pTextBoxControl).tokenfield({autocomplete: {source: function (request, response) {
                var param = new Object;
                param.pnvDenominacion = request.term, $.ajaxCall(purl, param, !0, function (respon) {
                    var data = "string" == typeof respon ? eval("(" + respon + ")") : respon;
                    null != data && response($.map(data, pFunctionItem))
                })
            }, open: function (e, t) {
                $(this).autocomplete("widget").css({width: null === pWidth ? $(pTextBoxControl).width() : pWidth})
            }, select: pFunctionSelect}, showAutocompleteOnFocus: !0})
};

/*para capturar el parametro*/
var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};