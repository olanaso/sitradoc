package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.RolmoduloBE;
import mph.tramitedoc.bl.RolmoduloBL;
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
@RequestMapping("/RolmoduloController")
@SessionAttributes({"oSession"})
public class RolmoduloController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarRolmoduloBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarRolmoduloBE(@RequestBody Map<String, Object> param) {

        RolmoduloBL oRolmoduloBL = new RolmoduloBL();
        RolmoduloBE oRolmoduloBE = gson.fromJson(gson.toJson(param.get("poRolmoduloBE")), RolmoduloBE.class);
        json = gson.toJson(oRolmoduloBL.insertarRolmoduloBE(oRolmoduloBE));
        return json;

    }

    @RequestMapping(value = "/actualizarRolmoduloBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarRolmoduloBE(@RequestBody Map<String, Object> param) {

        RolmoduloBL oRolmoduloBL = new RolmoduloBL();
        RolmoduloBE oRolmoduloBE = gson.fromJson(gson.toJson(param.get("poRolmoduloBE")), RolmoduloBE.class);
        json = gson.toJson(oRolmoduloBL.actualizarRolmoduloBE(oRolmoduloBE));
        return json;

    }

    @RequestMapping(value = "/eliminarRolmoduloBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarRolmoduloBE(@RequestBody Map<String, Object> param) {

        RolmoduloBL oRolmoduloBL = new RolmoduloBL();
        RolmoduloBE oRolmoduloBE = gson.fromJson(gson.toJson(param.get("poRolmoduloBE")), RolmoduloBE.class);
        json = gson.toJson(oRolmoduloBL.eliminarRolmoduloBE(oRolmoduloBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosRolmoduloBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosRolmoduloBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        RolmoduloBL oRolmoduloBL = new RolmoduloBL();
        RolmoduloBE oRolmoduloBE = gson.fromJson(gson.toJson(param.get("poRolmoduloBE")), RolmoduloBE.class);
        
        json = gson.toJson(oRolmoduloBL.listarRegistrosRolmoduloBE(oRolmoduloBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectRolmoduloBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectRolmoduloBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        RolmoduloBL oRolmoduloBL = new RolmoduloBL();
        RolmoduloBE oRolmoduloBE = gson.fromJson(gson.toJson(param.get("poRolmoduloBE")), RolmoduloBE.class);

        json = gson.toJson(oRolmoduloBL.listObjectRolmoduloBE(oRolmoduloBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
