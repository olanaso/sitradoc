package mph.tramitedoc.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.UnsupportedEncodingException;
import java.util.Map;
import mph.tramitedoc.be.TipoprocedimientoBE;
import mph.tramitedoc.bl.TipoprocedimientoBL;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

/**
 *
 * @author djackob
 */

@Controller
@RequestMapping("/TipoprocedimientoController")
@SessionAttributes({"oSession"})
public class TipoprocedimientoController {
    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarTipoprocedimientoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarTipoprocedimientoBE(@RequestBody Map<String, Object> param) {

        TipoprocedimientoBL oTipoprocedimientoBL = new TipoprocedimientoBL();
        TipoprocedimientoBE oTipoprocedimientoBE = gson.fromJson(gson.toJson(param.get("poTipoprocedimientoBE")), TipoprocedimientoBE.class);
        json = gson.toJson(oTipoprocedimientoBL.insertarTipoprocedimientoBE(oTipoprocedimientoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarTipoprocedimientoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarTipoprocedimientoBE(@RequestBody Map<String, Object> param) {

        TipoprocedimientoBL oTipoprocedimientoBL = new TipoprocedimientoBL();
        TipoprocedimientoBE oTipoprocedimientoBE = gson.fromJson(gson.toJson(param.get("poTipoprocedimientoBE")), TipoprocedimientoBE.class);
        json = gson.toJson(oTipoprocedimientoBL.actualizarTipoprocedimientoBE(oTipoprocedimientoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarTipoprocedimientoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarTipoprocedimientoBE(@RequestBody Map<String, Object> param) {

        TipoprocedimientoBL oTipoprocedimientoBL = new TipoprocedimientoBL();
        TipoprocedimientoBE oTipoprocedimientoBE = gson.fromJson(gson.toJson(param.get("poTipoprocedimientoBE")), TipoprocedimientoBE.class);
        json = gson.toJson(oTipoprocedimientoBL.eliminarTipoprocedimientoBE(oTipoprocedimientoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosTipoprocedimientoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosTipoprocedimientoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        TipoprocedimientoBL oTipoprocedimientoBL = new TipoprocedimientoBL();
        TipoprocedimientoBE oTipoprocedimientoBE = gson.fromJson(gson.toJson(param.get("poTipoprocedimientoBE")), TipoprocedimientoBE.class);

        json = gson.toJson(oTipoprocedimientoBL.listarRegistrosTipoprocedimientoBE(oTipoprocedimientoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectTipoprocedimientoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectTipoprocedimientoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        TipoprocedimientoBL oTipoprocedimientoBL = new TipoprocedimientoBL();
        TipoprocedimientoBE oTipoprocedimientoBE = gson.fromJson(gson.toJson(param.get("poTipoprocedimientoBE")), TipoprocedimientoBE.class);

        json = gson.toJson(oTipoprocedimientoBL.listObjectTipoprocedimientoBE(oTipoprocedimientoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }
}
