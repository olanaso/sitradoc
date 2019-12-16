package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.AnioBE;
import mph.tramitedoc.bl.AnioBL;
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
@RequestMapping("/AnioController")
@SessionAttributes({"oSession"})
public class AnioController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarAnioBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarAnioBE(@RequestBody Map<String, Object> param) {

        AnioBL oAnioBL = new AnioBL();
        AnioBE oAnioBE = gson.fromJson(gson.toJson(param.get("poAnioBE")), AnioBE.class);
        json = gson.toJson(oAnioBL.insertarAnioBE(oAnioBE));
        return json;

    }

    @RequestMapping(value = "/actualizarAnioBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarAnioBE(@RequestBody Map<String, Object> param) {

        AnioBL oAnioBL = new AnioBL();
        AnioBE oAnioBE = gson.fromJson(gson.toJson(param.get("poAnioBE")), AnioBE.class);
        json = gson.toJson(oAnioBL.actualizarAnioBE(oAnioBE));
        return json;

    }

    @RequestMapping(value = "/eliminarAnioBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarAnioBE(@RequestBody Map<String, Object> param) {

        AnioBL oAnioBL = new AnioBL();
        AnioBE oAnioBE = gson.fromJson(gson.toJson(param.get("poAnioBE")), AnioBE.class);
        json = gson.toJson(oAnioBL.eliminarAnioBE(oAnioBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosAnioBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosAnioBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        AnioBL oAnioBL = new AnioBL();
        AnioBE oAnioBE = gson.fromJson(gson.toJson(param.get("poAnioBE")), AnioBE.class);

        json = gson.toJson(oAnioBL.listarRegistrosAnioBE(oAnioBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectAnioBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectAnioBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        AnioBL oAnioBL = new AnioBL();
        AnioBE oAnioBE = gson.fromJson(gson.toJson(param.get("poAnioBE")), AnioBE.class);

        json = gson.toJson(oAnioBL.listObjectAnioBE(oAnioBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
