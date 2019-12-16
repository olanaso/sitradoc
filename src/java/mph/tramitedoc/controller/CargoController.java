package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.CargoBE;
import mph.tramitedoc.bl.CargoBL;
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
@RequestMapping("/CargoController")
@SessionAttributes({"oSession"})
public class CargoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarCargoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarCargoBE(@RequestBody Map<String, Object> param) {

        CargoBL oCargoBL = new CargoBL();
        CargoBE oCargoBE = gson.fromJson(gson.toJson(param.get("poCargoBE")), CargoBE.class);
        json = gson.toJson(oCargoBL.insertarCargoBE(oCargoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarCargoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarCargoBE(@RequestBody Map<String, Object> param) {

        CargoBL oCargoBL = new CargoBL();
        CargoBE oCargoBE = gson.fromJson(gson.toJson(param.get("poCargoBE")), CargoBE.class);
        json = gson.toJson(oCargoBL.actualizarCargoBE(oCargoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarCargoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarCargoBE(@RequestBody Map<String, Object> param) {

        CargoBL oCargoBL = new CargoBL();
        CargoBE oCargoBE = gson.fromJson(gson.toJson(param.get("poCargoBE")), CargoBE.class);
        json = gson.toJson(oCargoBL.eliminarCargoBE(oCargoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosCargoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosCargoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        CargoBL oCargoBL = new CargoBL();
        CargoBE oCargoBE = gson.fromJson(gson.toJson(param.get("poCargoBE")), CargoBE.class);

        json = gson.toJson(oCargoBL.listarRegistrosCargoBE(oCargoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectCargoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectCargoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        CargoBL oCargoBL = new CargoBL();
        CargoBE oCargoBE = gson.fromJson(gson.toJson(param.get("poCargoBE")), CargoBE.class);

        json = gson.toJson(oCargoBL.listObjectCargoBE(oCargoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
