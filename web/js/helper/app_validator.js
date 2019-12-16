/*! Development by ESEO */
function BuscaCadenaCaracter(t, a) {
    for (i = 0; i < t.length; i++)
        if (t.charAt(i) == a) return !0;
    return !1
}
$(document).ready(function() {
    $(":text").each(function() {
        var t = $(this).attr("UpperCases"),
            i = $(this).attr("LowerCases");
        (void 0 == t || void 0 == i) && (void 0 != t && ($(this).css("text-transform", "uppercase"), $(this).keyup(function() {
            "" === $(this).val() ? $(this).css("text-transform", "lowercase") : $(this).css("text-transform", "uppercase"), $(this).val($(this).val().toUpperCase())
        })), void 0 != i && ($(this).css("text-transform", "lowercase"), $(this).keyup(function() {
            $(this).val($(this).val().toLowerCase())
        })))
    }), $("textarea").each(function() {
        var t = $(this).attr("UpperCase"),
            i = $(this).attr("LowerCase");
        (void 0 == t || void 0 == i) && (void 0 != t && ($(this).css("text-transform", "uppercase"), $(this).keyup(function() {
            $(this).val($(this).val().toUpperCase())
        })), void 0 != i && ($(this).css("text-transform", "lowercase"), $(this).keyup(function() {
            $(this).val($(this).val().toLowerCase())
        })))
    }), $(":text").each(function() {
        var t = $(this).attr("SoloLetras"),
            i = $(this).attr("SoloNumeros"),
            a = $(this).attr("SoloDecimales"),
            s = $(this).attr("SoloRpmRpc");
        void 0 != t && $(this).keypress(function(t) {
            209 == t.which || 241 == t.which || 32 == t.which || t.which >= 65 && t.which <= 90 || t.which >= 97 && t.which <= 122 || t.preventDefault()
        }), void 0 != i && $(this).keypress(function(t) {
            8 != t.which && 9 != t.keyCode && 0 != t.keyCode && t.which < 48 || t.which > 57 && 118 != t.which && 86 != t.which && 99 != t.which && 67 != t.which ? (t.preventDefault(), $(this).val($(this).val().replace("v", "")), $(this).val($(this).val().replace("V", "")), $(this).val($(this).val().replace("c", "")), $(this).val($(this).val().replace("C", ""))) : ((BuscaCadenaCaracter($(this).val(), "V") || BuscaCadenaCaracter($(this).val(), "v")) && ($(this).val($(this).val().replace("v", "")), $(this).val($(this).val().replace("V", ""))), (BuscaCadenaCaracter($(this).val(), "C") || BuscaCadenaCaracter($(this).val(), "c")) && ($(this).val($(this).val().replace("c", "")), $(this).val($(this).val().replace("C", ""))))
        }), void 0 != s && $(this).keypress(function(t) {
            t.which && (8 != t.which && 35 != t.which && 42 != t.which && t.which < 48 || t.which > 57 && 118 != t.which && 86 != t.which && 99 != t.which && 67 != t.which) ? (t.preventDefault(), $(this).val($(this).val().replace("v", "")), $(this).val($(this).val().replace("V", "")), $(this).val($(this).val().replace("c", "")), $(this).val($(this).val().replace("C", ""))) : ((BuscaCadenaCaracter($(this).val(), "V") || BuscaCadenaCaracter($(this).val(), "v")) && ($(this).val($(this).val().replace("v", "")), $(this).val($(this).val().replace("V", ""))), (BuscaCadenaCaracter($(this).val(), "C") || BuscaCadenaCaracter($(this).val(), "c")) && ($(this).val($(this).val().replace("c", "")), $(this).val($(this).val().replace("C", ""))))
        }), void 0 != a && ($(this).keypress(function(t) {
            t.which && (8 != t.which && 46 != t.which && t.which < 48 || t.which > 57) && t.preventDefault()
        }), $(this).keyup(function() {
            var t = $(this).val();
            if (index = t.indexOf("."), index > 0) {
                var i = t.substring(index + 1, $(this).val().length),
                    s = i.length - a;
                s > 0 && $(this).val(t.substring(0, $(this).val().length - s))
            }
        }), $(this).change(function() {
            var t = $(this).val();
            if (index = t.indexOf("."), index > 0) {
                var i = t.substring(index + 1, $(this).val().length),
                    s = a - i.length;
                for (-1 == s && $(this).val($(this).val() + ".00"); s > 0;) $(this).val($(this).val() + "0"), s--
            } else -1 == index && $(this).val().length > 0 && $(this).val($(this).val() + ".00")
        }));
        var r = $(this).attr("date");
        void 0 != r && $(this).change(function() {
            if ("" != $(this).val()) {
                var t = isDate(this);
                t ? $(this).removeClass("error") : $(this).addClass("error")
            }
        })
    })
}), jQuery.Validar = function(t) {
    var i = !0;
    return $(t + " :text").each(function() {
        var t = $(this).attr("obligatorio");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 == a.length && ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1)
        }
        var s = $(this).attr("date");
        if (void 0 != s && $(this).is(":visible")) {
            var r = isDate(this);
            r || ($(this).addClass("error"), i = !1)
        }
    }), $(t + " textarea").each(function() {
        var t = $(this).attr("obligatorio");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 == a.length && ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1)
        }
    }), $(t + " select").each(function() {
        var t = $(this).attr("obligatorio");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $(this).val();
            (0 == a || "000" == a || "00000" == a || "000000000000000" == a) && ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1)
        }
    }), i
}, jQuery.ObligarData = function(t) {
    var i = !0;
    return $(t + " :text").each(function() {
        var t = $(this).attr("obligatorio");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 == a.length && ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1)
        }
    }), $(t + " textarea").each(function() {
        var t = $(this).attr("obligatorio");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 == a.length && ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1)
        }
    }), $(t + " select").each(function() {
        var t = $(this).attr("obligatorio");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $(this).val();
            if ("000000000000" == a) return;
            (0 == a || "000" == a || "00000" == a || "000000000000000" == a) && ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1)
        }
    }), $(t + " input").each(function() {
        var t = $(this).attr("obligatorio");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $(this).val();
            "" == a && ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1)
        }
    }), i
}, jQuery.VerificarData = function(t) {
    var i = !0;
    return $(t + " :text").each(function() {
        var t = $(this).attr("validarNumero");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 != a.length && (pat = /^\d*$/, pat.test(a) || ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1))
        }
        var s = $(this).attr("validarDecimal");
        if (void 0 != s && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 != a.length && (pat = /^\d*\.?\d+$/, pat.test(a) || ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1))
        }
        var t = $(this).attr("validarRpm");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 != a.length && (pat = /^[#|*]{1}\d+$/, pat.test(a) || ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1))
        }
        var r = $(this).attr("validarFecha");
        if (void 0 != r && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 != a.length && (validarFecha(a) || ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1))
        }
        var e = $(this).attr("date");
        if (void 0 != e && $(this).is(":visible") && 0 != $(this).val().length) {
            var h = isDate(this);
            h || ($(this).addClass("error"), i = !1)
        }
        var v = $(this).attr("validarTamanio");
        if (void 0 != v && $(this).is(":visible")) {
            var l = $.trim($(this).val()).length;
            0 != l && v > l && ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1)
        }
        var s = $(this).attr("validarHora");
        if (void 0 != s && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 != a.length && (pat = /^(0[1-9]|1\d|2[0-3]):([0-5]\d)$/, pat.test(a) || ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1))
        }
        var o = $(this).attr("validarCorreo");
        if (void 0 != o && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            0 != a.length && (pat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, pat.test(a) || ($(this).addClass("error"), $(this).change(function() {
                $(this).removeClass("error")
            }), i = !1))
        }
    }), i
}, jQuery.VerificarFechaMayor = function(t) {
    var i = !0;
    return $(t + " :text").each(function() {
        var t = $(this).attr("validarFechaMayor");
        if (void 0 != t && $(this).is(":visible")) {
            var a = $.trim($(this).val());
            if (0 != a.length) {
                var s = getFechaActual(),
                    r = a;
                fechaMayor(r, s) && ($(this).addClass("error"), $(this).change(function() {
                    $(this).removeClass("error")
                }), i = !1)
            }
        }
    }), i
}, jQuery.ValidarData = function(t) {
    var i = !1;
    if (i = $.ObligarData(t), !i) return -1;
    var a = !1;
    if (a = $.VerificarData(t), !a) return -2;
    return a = $.VerificarFechaMayor(t), a ? 0 : -3
}, jQuery.LimpiarForm = function(t) {
    $(t + " textarea").each(function() {
        $(this).val("")
    }), $(t + " select").each(function() {
        $(this).val(0)
    }), $(t + " input").each(function() {
        $(this).val(""), $(this).prop("checked", !1)
    })
}, jQuery.DesabilitarForm = function(t) {
    $(t + " textarea").each(function() {
        var t = $(this).attr("inafecto");
        void 0 != t || ($(this).attr("disabled", "disabled"), $(this).removeClass("error"))
    }), $(t + " select").each(function() {
        var t = $(this).attr("inafecto");
        void 0 != t || ($(this).attr("disabled", "disabled"), $(this).removeClass("error"))
    }), $(t + " input").each(function() {
        var t = $(this).attr("inafecto");
        void 0 != t || ($(this).attr("disabled", "disabled"), $(this).removeClass("error"))
    })
}, jQuery.HabilitarForm = function(t) {
    $(t + " textarea").each(function() {
        var t = $(this).attr("inafecto");
        void 0 != t || $(this).removeAttr("disabled")
    }), $(t + " select").each(function() {
        var t = $(this).attr("inafecto");
        void 0 != t || $(this).removeAttr("disabled")
    }), $(t + " input").each(function() {
        var t = $(this).attr("inafecto");
        void 0 != t || $(this).removeAttr("disabled")
    })
};