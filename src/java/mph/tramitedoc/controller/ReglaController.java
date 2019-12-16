package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.ReglaBE;
import mph.tramitedoc.bl.ReglaBL;
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
@RequestMapping("/ReglaController")
@SessionAttributes({"oSession"})
public class ReglaController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarReglaBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarReglaBE(@RequestBody Map<String, Object> param) {

        ReglaBL oReglaBL = new ReglaBL();
        ReglaBE oReglaBE = gson.fromJson(gson.toJson(param.get("poReglaBE")), ReglaBE.class);
        json = gson.toJson(oReglaBL.insertarReglaBE(oReglaBE));
        return json;

    }

    @RequestMapping(value = "/actualizarReglaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarReglaBE(@RequestBody Map<String, Object> param) {

        ReglaBL oReglaBL = new ReglaBL();
        ReglaBE oReglaBE = gson.fromJson(gson.toJson(param.get("poReglaBE")), ReglaBE.class);
        json = gson.toJson(oReglaBL.actualizarReglaBE(oReglaBE));
        return json;

    }

    @RequestMapping(value = "/eliminarReglaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarReglaBE(@RequestBody Map<String, Object> param) {

        ReglaBL oReglaBL = new ReglaBL();
        ReglaBE oReglaBE = gson.fromJson(gson.toJson(param.get("poReglaBE")), ReglaBE.class);
        json = gson.toJson(oReglaBL.eliminarReglaBE(oReglaBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosReglaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosReglaBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ReglaBL oReglaBL = new ReglaBL();
        ReglaBE oReglaBE = gson.fromJson(gson.toJson(param.get("poReglaBE")), ReglaBE.class);

        json = gson.toJson(oReglaBL.listarRegistrosReglaBE(oReglaBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectReglaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectReglaBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ReglaBL oReglaBL = new ReglaBL();
        ReglaBE oReglaBE = gson.fromJson(gson.toJson(param.get("poReglaBE")), ReglaBE.class);

        json = gson.toJson(oReglaBL.listObjectReglaBE(oReglaBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
