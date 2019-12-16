package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.BandejaBE;
import mph.tramitedoc.bl.BandejaBL;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Map;
import mph.tramitedoc.be.JQObjectBE;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@RequestMapping("/BandejaController")
@SessionAttributes({"oSession"})
public class BandejaController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarBandejaBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarBandejaBE(@RequestBody Map<String, Object> param) {
        BandejaBL oBandejaBL = new BandejaBL();
        BandejaBE oBandejaBE = gson.fromJson(gson.toJson(param.get("poBandejaBE")), BandejaBE.class);
        json = gson.toJson(oBandejaBL.insertarBandejaBE(oBandejaBE));
        return json;
    }

    @RequestMapping(value = "/actualizarBandejaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarBandejaBE(@RequestBody Map<String, Object> param) {
        BandejaBL oBandejaBL = new BandejaBL();
        BandejaBE oBandejaBE = gson.fromJson(gson.toJson(param.get("poBandejaBE")), BandejaBE.class);
        json = gson.toJson(oBandejaBL.actualizarBandejaBE(oBandejaBE));
        return json;
    }

    @RequestMapping(value = "/eliminarBandejaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarBandejaBE(@RequestBody Map<String, Object> param) {
        BandejaBL oBandejaBL = new BandejaBL();
        BandejaBE oBandejaBE = gson.fromJson(gson.toJson(param.get("poBandejaBE")), BandejaBE.class);
        json = gson.toJson(oBandejaBL.eliminarBandejaBE(oBandejaBE));
        return json;
    }

    @RequestMapping(value = "/listarRegistrosBandejaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosBandejaBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        BandejaBL oBandejaBL = new BandejaBL();
        BandejaBE oBandejaBE = gson.fromJson(gson.toJson(param.get("poBandejaBE")), BandejaBE.class);

        json = gson.toJson(oBandejaBL.listarRegistrosBandejaBE(oBandejaBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listarJQRegistrosBandejaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarJQRegistrosBandejaBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {

        BandejaBL oBandejaBL = new BandejaBL();
        BandejaBE oBandejaBE = gson.fromJson(gson.toJson(param.get("poBandejaBE")), BandejaBE.class);
        JQObjectBE ojqobjectBE = oBandejaBL.listarJQRegistroDocumentoBE(oBandejaBE);
        json = gson.toJson(ojqobjectBE);
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectBandejaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectBandejaBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        BandejaBL oBandejaBL = new BandejaBL();
        BandejaBE oBandejaBE = gson.fromJson(gson.toJson(param.get("poBandejaBE")), BandejaBE.class);

        json = gson.toJson(oBandejaBL.listObjectBandejaBE(oBandejaBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
