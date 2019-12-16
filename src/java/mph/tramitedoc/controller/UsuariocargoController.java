package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.UsuariocargoBE;
import mph.tramitedoc.bl.UsuariocargoBL;
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
@RequestMapping("/UsuariocargoController")
@SessionAttributes({"oSession"})
public class UsuariocargoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarUsuariocargoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarUsuariocargoBE(@RequestBody Map<String, Object> param) {

        UsuariocargoBL oUsuariocargoBL = new UsuariocargoBL();
        UsuariocargoBE oUsuariocargoBE = gson.fromJson(gson.toJson(param.get("poUsuariocargoBE")), UsuariocargoBE.class);
        json = gson.toJson(oUsuariocargoBL.insertarUsuariocargoBE(oUsuariocargoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarUsuariocargoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarUsuariocargoBE(@RequestBody Map<String, Object> param) {

        UsuariocargoBL oUsuariocargoBL = new UsuariocargoBL();
        UsuariocargoBE oUsuariocargoBE = gson.fromJson(gson.toJson(param.get("poUsuariocargoBE")), UsuariocargoBE.class);
        json = gson.toJson(oUsuariocargoBL.actualizarUsuariocargoBE(oUsuariocargoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarUsuariocargoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarUsuariocargoBE(@RequestBody Map<String, Object> param) {

        UsuariocargoBL oUsuariocargoBL = new UsuariocargoBL();
        UsuariocargoBE oUsuariocargoBE = gson.fromJson(gson.toJson(param.get("poUsuariocargoBE")), UsuariocargoBE.class);
        json = gson.toJson(oUsuariocargoBL.eliminarUsuariocargoBE(oUsuariocargoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosUsuariocargoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosUsuariocargoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        UsuariocargoBL oUsuariocargoBL = new UsuariocargoBL();
        UsuariocargoBE oUsuariocargoBE = gson.fromJson(gson.toJson(param.get("poUsuariocargoBE")), UsuariocargoBE.class);

        json = gson.toJson(oUsuariocargoBL.listarRegistrosUsuariocargoBE(oUsuariocargoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectUsuariocargoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectUsuariocargoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        UsuariocargoBL oUsuariocargoBL = new UsuariocargoBL();
        UsuariocargoBE oUsuariocargoBE = gson.fromJson(gson.toJson(param.get("poUsuariocargoBE")), UsuariocargoBE.class);

        json = gson.toJson(oUsuariocargoBL.listObjectUsuariocargoBE(oUsuariocargoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
