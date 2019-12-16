package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.TipodocumentoBE;
import mph.tramitedoc.bl.TipodocumentoBL;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;


@Controller
@RequestMapping("/TipodocumentoController")
@SessionAttributes({"oSession"})
public class TipodocumentoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarTipodocumentoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarTipodocumentoBE(@RequestBody Map<String, Object> param) {

        TipodocumentoBL oTipodocumentoBL = new TipodocumentoBL();
        TipodocumentoBE oTipodocumentoBE = gson.fromJson(gson.toJson(param.get("poTipodocumentoBE")), TipodocumentoBE.class);
        json = gson.toJson(oTipodocumentoBL.insertarTipodocumentoBE(oTipodocumentoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarTipodocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarTipodocumentoBE(@RequestBody Map<String, Object> param) {

        TipodocumentoBL oTipodocumentoBL = new TipodocumentoBL();
        TipodocumentoBE oTipodocumentoBE = gson.fromJson(gson.toJson(param.get("poTipodocumentoBE")), TipodocumentoBE.class);
        json = gson.toJson(oTipodocumentoBL.actualizarTipodocumentoBE(oTipodocumentoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarTipodocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarTipodocumentoBE(@RequestBody Map<String, Object> param) {

        TipodocumentoBL oTipodocumentoBL = new TipodocumentoBL();
        TipodocumentoBE oTipodocumentoBE = gson.fromJson(gson.toJson(param.get("poTipodocumentoBE")), TipodocumentoBE.class);
        json = gson.toJson(oTipodocumentoBL.eliminarTipodocumentoBE(oTipodocumentoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosTipodocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosTipodocumentoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        TipodocumentoBL oTipodocumentoBL = new TipodocumentoBL();
        TipodocumentoBE oTipodocumentoBE = gson.fromJson(gson.toJson(param.get("poTipodocumentoBE")), TipodocumentoBE.class);

        json = gson.toJson(oTipodocumentoBL.listarRegistrosTipodocumentoBE(oTipodocumentoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectTipodocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectTipodocumentoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        TipodocumentoBL oTipodocumentoBL = new TipodocumentoBL();
        TipodocumentoBE oTipodocumentoBE = gson.fromJson(gson.toJson(param.get("poTipodocumentoBE")), TipodocumentoBE.class);

        json = gson.toJson(oTipodocumentoBL.listObjectTipodocumentoBE(oTipodocumentoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
