package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.ReferenciaBE;
import mph.tramitedoc.bl.ReferenciaBL;
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
@RequestMapping("/ReferenciaController")
@SessionAttributes({"oSession"})
public class ReferenciaController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarReferenciaBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarReferenciaBE(@RequestBody Map<String, Object> param) {

        ReferenciaBL oReferenciaBL = new ReferenciaBL();
        ReferenciaBE oReferenciaBE = gson.fromJson(gson.toJson(param.get("poReferenciaBE")), ReferenciaBE.class);
        json = gson.toJson(oReferenciaBL.insertarReferenciaBE(oReferenciaBE));
        return json;

    }

    @RequestMapping(value = "/actualizarReferenciaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarReferenciaBE(@RequestBody Map<String, Object> param) {

        ReferenciaBL oReferenciaBL = new ReferenciaBL();
        ReferenciaBE oReferenciaBE = gson.fromJson(gson.toJson(param.get("poReferenciaBE")), ReferenciaBE.class);
        json = gson.toJson(oReferenciaBL.actualizarReferenciaBE(oReferenciaBE));
        return json;

    }

    @RequestMapping(value = "/eliminarReferenciaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarReferenciaBE(@RequestBody Map<String, Object> param) {

        ReferenciaBL oReferenciaBL = new ReferenciaBL();
        ReferenciaBE oReferenciaBE = gson.fromJson(gson.toJson(param.get("poReferenciaBE")), ReferenciaBE.class);
        json = gson.toJson(oReferenciaBL.eliminarReferenciaBE(oReferenciaBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosReferenciaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosReferenciaBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ReferenciaBL oReferenciaBL = new ReferenciaBL();
        ReferenciaBE oReferenciaBE = gson.fromJson(gson.toJson(param.get("poReferenciaBE")), ReferenciaBE.class);

        json = gson.toJson(oReferenciaBL.listarRegistrosReferenciaBE(oReferenciaBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectReferenciaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectReferenciaBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ReferenciaBL oReferenciaBL = new ReferenciaBL();
        ReferenciaBE oReferenciaBE = gson.fromJson(gson.toJson(param.get("poReferenciaBE")), ReferenciaBE.class);

        json = gson.toJson(oReferenciaBL.listObjectReferenciaBE(oReferenciaBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
