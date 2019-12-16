package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.ModuloBE;
import mph.tramitedoc.bl.ModuloBL;
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
@RequestMapping("/ModuloController")
@SessionAttributes({"oSession"})
public class ModuloController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarModuloBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarModuloBE(@RequestBody Map<String, Object> param) {

        ModuloBL oModuloBL = new ModuloBL();
        ModuloBE oModuloBE = gson.fromJson(gson.toJson(param.get("poModuloBE")), ModuloBE.class);
        json = gson.toJson(oModuloBL.insertarModuloBE(oModuloBE));
        return json;

    }

    @RequestMapping(value = "/actualizarModuloBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarModuloBE(@RequestBody Map<String, Object> param) {

        ModuloBL oModuloBL = new ModuloBL();
        ModuloBE oModuloBE = gson.fromJson(gson.toJson(param.get("poModuloBE")), ModuloBE.class);
        json = gson.toJson(oModuloBL.actualizarModuloBE(oModuloBE));
        return json;

    }

    @RequestMapping(value = "/eliminarModuloBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarModuloBE(@RequestBody Map<String, Object> param) {

        ModuloBL oModuloBL = new ModuloBL();
        ModuloBE oModuloBE = gson.fromJson(gson.toJson(param.get("poModuloBE")), ModuloBE.class);
        json = gson.toJson(oModuloBL.eliminarModuloBE(oModuloBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosModuloBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosModuloBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ModuloBL oModuloBL = new ModuloBL();
        ModuloBE oModuloBE = gson.fromJson(gson.toJson(param.get("poModuloBE")), ModuloBE.class);

        json = gson.toJson(oModuloBL.listarRegistrosModuloBE(oModuloBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectModuloBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectModuloBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ModuloBL oModuloBL = new ModuloBL();
        ModuloBE oModuloBE = gson.fromJson(gson.toJson(param.get("poModuloBE")), ModuloBE.class);

        json = gson.toJson(oModuloBL.listObjectModuloBE(oModuloBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
