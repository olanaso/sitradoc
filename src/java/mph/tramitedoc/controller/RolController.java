package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.RolBE;
import mph.tramitedoc.bl.RolBL;
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
@RequestMapping("/RolController")
@SessionAttributes({"oSession"})
public class RolController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarRolBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarRolBE(@RequestBody Map<String, Object> param) {

        RolBL oRolBL = new RolBL();
        RolBE oRolBE = gson.fromJson(gson.toJson(param.get("poRolBE")), RolBE.class);
        json = gson.toJson(oRolBL.insertarRolBE(oRolBE));
        return json;

    }

    @RequestMapping(value = "/actualizarRolBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarRolBE(@RequestBody Map<String, Object> param) {

        RolBL oRolBL = new RolBL();
        RolBE oRolBE = gson.fromJson(gson.toJson(param.get("poRolBE")), RolBE.class);
        json = gson.toJson(oRolBL.actualizarRolBE(oRolBE));
        return json;

    }

    @RequestMapping(value = "/eliminarRolBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarRolBE(@RequestBody Map<String, Object> param) {

        RolBL oRolBL = new RolBL();
        RolBE oRolBE = gson.fromJson(gson.toJson(param.get("poRolBE")), RolBE.class);
        json = gson.toJson(oRolBL.eliminarRolBE(oRolBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosRolBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosRolBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        RolBL oRolBL = new RolBL();
        RolBE oRolBE = gson.fromJson(gson.toJson(param.get("poRolBE")), RolBE.class);

        json = gson.toJson(oRolBL.listarRegistrosRolBE(oRolBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectRolBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectRolBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        RolBL oRolBL = new RolBL();
        RolBE oRolBE = gson.fromJson(gson.toJson(param.get("poRolBE")), RolBE.class);

        json = gson.toJson(oRolBL.listObjectRolBE(oRolBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
