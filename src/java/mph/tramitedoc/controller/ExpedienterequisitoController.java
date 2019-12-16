package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.ExpedienterequisitoBE;
import mph.tramitedoc.bl.ExpedienterequisitoBL;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@RequestMapping("/ExpedienterequisitoController")
@SessionAttributes({"oSession"})
public class ExpedienterequisitoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarExpedienterequisitoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarExpedienterequisitoBE(@RequestBody Map<String, Object> param) {

        ExpedienterequisitoBL oExpedienterequisitoBL = new ExpedienterequisitoBL();
        ExpedienterequisitoBE oExpedienterequisitoBE = gson.fromJson(gson.toJson(param.get("poExpedienterequisitoBE")), ExpedienterequisitoBE.class);
        json = gson.toJson(oExpedienterequisitoBL.insertarExpedienterequisitoBE(oExpedienterequisitoBE));
        return json;

    }

    @RequestMapping(value = "/insertarRegistrosExpedienterequisitoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarRegistrosExpedienterequisitoBE(@RequestBody Map<String, Object> param) {

        Type listType = new TypeToken<ArrayList<ExpedienterequisitoBE>>() {
        }.getType();
        ExpedienterequisitoBL oExpedienterequisitoBL = new ExpedienterequisitoBL();
        ArrayList<ExpedienterequisitoBE> olistExpedienterequisitoBE = gson.fromJson(gson.toJson(param.get("polistExpedienterequisitoBE")), listType);
        json = gson.toJson(oExpedienterequisitoBL.insertarRegistrosExpedienterequisitoBE(olistExpedienterequisitoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarExpedienterequisitoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarExpedienterequisitoBE(@RequestBody Map<String, Object> param) {

        ExpedienterequisitoBL oExpedienterequisitoBL = new ExpedienterequisitoBL();
        ExpedienterequisitoBE oExpedienterequisitoBE = gson.fromJson(gson.toJson(param.get("poExpedienterequisitoBE")), ExpedienterequisitoBE.class);
        json = gson.toJson(oExpedienterequisitoBL.actualizarExpedienterequisitoBE(oExpedienterequisitoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarRegistrosExpedienterequisitoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarRegistrosExpedienterequisitoBE(@RequestBody Map<String, Object> param) {
        
        Type listType = new TypeToken<ArrayList<ExpedienterequisitoBE>>() {
        }.getType();
        ExpedienterequisitoBL oExpedienterequisitoBL = new ExpedienterequisitoBL();
        ArrayList<ExpedienterequisitoBE> olistExpedienterequisitoBE = gson.fromJson(gson.toJson(param.get("polistExpedienterequisitoBE")), listType);
        int idexpediente = gson.fromJson(gson.toJson(param.get("idexpediente")), int.class);
        json = gson.toJson(oExpedienterequisitoBL.actualizarRegistrosExpedienterequisitoBE(olistExpedienterequisitoBE, idexpediente));
        return json;
        

    }

    @RequestMapping(value = "/eliminarExpedienterequisitoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarExpedienterequisitoBE(@RequestBody Map<String, Object> param) {

        ExpedienterequisitoBL oExpedienterequisitoBL = new ExpedienterequisitoBL();
        ExpedienterequisitoBE oExpedienterequisitoBE = gson.fromJson(gson.toJson(param.get("poExpedienterequisitoBE")), ExpedienterequisitoBE.class);
        json = gson.toJson(oExpedienterequisitoBL.eliminarExpedienterequisitoBE(oExpedienterequisitoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosExpedienterequisitoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosExpedienterequisitoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ExpedienterequisitoBL oExpedienterequisitoBL = new ExpedienterequisitoBL();
        ExpedienterequisitoBE oExpedienterequisitoBE = gson.fromJson(gson.toJson(param.get("poExpedienterequisitoBE")), ExpedienterequisitoBE.class);

        json = gson.toJson(oExpedienterequisitoBL.listarRegistrosExpedienterequisitoBE(oExpedienterequisitoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectExpedienterequisitoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectExpedienterequisitoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ExpedienterequisitoBL oExpedienterequisitoBL = new ExpedienterequisitoBL();
        ExpedienterequisitoBE oExpedienterequisitoBE = gson.fromJson(gson.toJson(param.get("poExpedienterequisitoBE")), ExpedienterequisitoBE.class);

        json = gson.toJson(oExpedienterequisitoBL.listObjectExpedienterequisitoBE(oExpedienterequisitoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
