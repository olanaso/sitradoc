package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.UsuariorolBE;
import mph.tramitedoc.bl.UsuariorolBL;
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
@RequestMapping("/UsuariorolController")
@SessionAttributes({"oSession"})
public class UsuariorolController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarUsuariorolBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarUsuariorolBE(@RequestBody Map<String, Object> param) {

        UsuariorolBL oUsuariorolBL = new UsuariorolBL();
        UsuariorolBE oUsuariorolBE = gson.fromJson(gson.toJson(param.get("poUsuariorolBE")), UsuariorolBE.class);
        json = gson.toJson(oUsuariorolBL.insertarUsuariorolBE(oUsuariorolBE));
        return json;

    }

    @RequestMapping(value = "/actualizarUsuariorolBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarUsuariorolBE(@RequestBody Map<String, Object> param) {

        UsuariorolBL oUsuariorolBL = new UsuariorolBL();
        UsuariorolBE oUsuariorolBE = gson.fromJson(gson.toJson(param.get("poUsuariorolBE")), UsuariorolBE.class);
        json = gson.toJson(oUsuariorolBL.actualizarUsuariorolBE(oUsuariorolBE));
        return json;

    }

    @RequestMapping(value = "/eliminarUsuariorolBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarUsuariorolBE(@RequestBody Map<String, Object> param) {

        UsuariorolBL oUsuariorolBL = new UsuariorolBL();
        UsuariorolBE oUsuariorolBE = gson.fromJson(gson.toJson(param.get("poUsuariorolBE")), UsuariorolBE.class);
        json = gson.toJson(oUsuariorolBL.eliminarUsuariorolBE(oUsuariorolBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosUsuariorolBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosUsuariorolBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        UsuariorolBL oUsuariorolBL = new UsuariorolBL();
        UsuariorolBE oUsuariorolBE = gson.fromJson(gson.toJson(param.get("poUsuariorolBE")), UsuariorolBE.class);

        json = gson.toJson(oUsuariorolBL.listarRegistrosUsuariorolBE(oUsuariorolBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectUsuariorolBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectUsuariorolBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        UsuariorolBL oUsuariorolBL = new UsuariorolBL();
        UsuariorolBE oUsuariorolBE = gson.fromJson(gson.toJson(param.get("poUsuariorolBE")), UsuariorolBE.class);

        json = gson.toJson(oUsuariorolBL.listObjectUsuariorolBE(oUsuariorolBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
