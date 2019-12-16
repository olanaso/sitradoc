package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.EstadoflujoBE;
import mph.tramitedoc.bl.EstadoflujoBL;
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
@RequestMapping("/EstadoflujoController")
@SessionAttributes({"oSession"})
public class EstadoflujoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarEstadoflujoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarEstadoflujoBE(@RequestBody Map<String, Object> param) {

        EstadoflujoBL oEstadoflujoBL = new EstadoflujoBL();
        EstadoflujoBE oEstadoflujoBE = gson.fromJson(gson.toJson(param.get("poEstadoflujoBE")), EstadoflujoBE.class);
        json = gson.toJson(oEstadoflujoBL.insertarEstadoflujoBE(oEstadoflujoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarEstadoflujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarEstadoflujoBE(@RequestBody Map<String, Object> param) {

        EstadoflujoBL oEstadoflujoBL = new EstadoflujoBL();
        EstadoflujoBE oEstadoflujoBE = gson.fromJson(gson.toJson(param.get("poEstadoflujoBE")), EstadoflujoBE.class);
        json = gson.toJson(oEstadoflujoBL.actualizarEstadoflujoBE(oEstadoflujoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarEstadoflujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarEstadoflujoBE(@RequestBody Map<String, Object> param) {

        EstadoflujoBL oEstadoflujoBL = new EstadoflujoBL();
        EstadoflujoBE oEstadoflujoBE = gson.fromJson(gson.toJson(param.get("poEstadoflujoBE")), EstadoflujoBE.class);
        json = gson.toJson(oEstadoflujoBL.eliminarEstadoflujoBE(oEstadoflujoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosEstadoflujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosEstadoflujoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        EstadoflujoBL oEstadoflujoBL = new EstadoflujoBL();
        EstadoflujoBE oEstadoflujoBE = gson.fromJson(gson.toJson(param.get("poEstadoflujoBE")), EstadoflujoBE.class);

        json = gson.toJson(oEstadoflujoBL.listarRegistrosEstadoflujoBE(oEstadoflujoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectEstadoflujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectEstadoflujoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        EstadoflujoBL oEstadoflujoBL = new EstadoflujoBL();
        EstadoflujoBE oEstadoflujoBE = gson.fromJson(gson.toJson(param.get("poEstadoflujoBE")), EstadoflujoBE.class);

        json = gson.toJson(oEstadoflujoBL.listObjectEstadoflujoBE(oEstadoflujoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
