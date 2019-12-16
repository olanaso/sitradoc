package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.RequisitosBE;
import mph.tramitedoc.bl.RequisitosBL;
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
@RequestMapping("/RequisitosController")
@SessionAttributes({"oSession"})
public class RequisitosController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarRequisitosBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarRequisitosBE(@RequestBody Map<String, Object> param) {

        RequisitosBL oRequisitosBL = new RequisitosBL();
        RequisitosBE oRequisitosBE = gson.fromJson(gson.toJson(param.get("poRequisitosBE")), RequisitosBE.class);
        json = gson.toJson(oRequisitosBL.insertarRequisitosBE(oRequisitosBE));
        return json;

    }

    @RequestMapping(value = "/actualizarRequisitosBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarRequisitosBE(@RequestBody Map<String, Object> param) {

        RequisitosBL oRequisitosBL = new RequisitosBL();
        RequisitosBE oRequisitosBE = gson.fromJson(gson.toJson(param.get("poRequisitosBE")), RequisitosBE.class);
        json = gson.toJson(oRequisitosBL.actualizarRequisitosBE(oRequisitosBE));
        return json;

    }

    @RequestMapping(value = "/eliminarRequisitosBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarRequisitosBE(@RequestBody Map<String, Object> param) {

        RequisitosBL oRequisitosBL = new RequisitosBL();
        RequisitosBE oRequisitosBE = gson.fromJson(gson.toJson(param.get("poRequisitosBE")), RequisitosBE.class);
        json = gson.toJson(oRequisitosBL.eliminarRequisitosBE(oRequisitosBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosRequisitosBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosRequisitosBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        RequisitosBL oRequisitosBL = new RequisitosBL();
        RequisitosBE oRequisitosBE = gson.fromJson(gson.toJson(param.get("poRequisitosBE")), RequisitosBE.class);

        json = gson.toJson(oRequisitosBL.listarRegistrosRequisitosBE(oRequisitosBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectRequisitosBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectRequisitosBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        RequisitosBL oRequisitosBL = new RequisitosBL();
        RequisitosBE oRequisitosBE = gson.fromJson(gson.toJson(param.get("poRequisitosBE")), RequisitosBE.class);

        json = gson.toJson(oRequisitosBL.listObjectRequisitosBE(oRequisitosBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
