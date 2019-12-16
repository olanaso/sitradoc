package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.FeriadoBE;
import mph.tramitedoc.bl.FeriadoBL;
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
@RequestMapping("/FeriadoController")
@SessionAttributes({"oSession"})
public class FeriadoController {

    Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyyy").create();
    String json = "";

    @RequestMapping(value = "/insertarFeriadoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarFeriadoBE(@RequestBody Map<String, Object> param) {

        FeriadoBL oFeriadoBL = new FeriadoBL();
        FeriadoBE oFeriadoBE = gson.fromJson(gson.toJson(param.get("poFeriadoBE")), FeriadoBE.class);
        json = gson.toJson(oFeriadoBL.insertarFeriadoBE(oFeriadoBE));
        return json;

    }    

    @RequestMapping(value = "/actualizarFeriadoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarFeriadoBE(@RequestBody Map<String, Object> param) {

        FeriadoBL oFeriadoBL = new FeriadoBL();
        FeriadoBE oFeriadoBE = gson.fromJson(gson.toJson(param.get("poFeriadoBE")), FeriadoBE.class);
        json = gson.toJson(oFeriadoBL.actualizarFeriadoBE(oFeriadoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarFeriadoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarFeriadoBE(@RequestBody Map<String, Object> param) {

        FeriadoBL oFeriadoBL = new FeriadoBL();
        FeriadoBE oFeriadoBE = gson.fromJson(gson.toJson(param.get("poFeriadoBE")), FeriadoBE.class);
        json = gson.toJson(oFeriadoBL.eliminarFeriadoBE(oFeriadoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosFeriadoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosFeriadoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        FeriadoBL oFeriadoBL = new FeriadoBL();
        FeriadoBE oFeriadoBE = gson.fromJson(gson.toJson(param.get("poFeriadoBE")), FeriadoBE.class);

        json = gson.toJson(oFeriadoBL.listarRegistrosFeriadoBE(oFeriadoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectFeriadoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectFeriadoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        FeriadoBL oFeriadoBL = new FeriadoBL();
        FeriadoBE oFeriadoBE = gson.fromJson(gson.toJson(param.get("poFeriadoBE")), FeriadoBE.class);

        json = gson.toJson(oFeriadoBL.listObjectFeriadoBE(oFeriadoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
