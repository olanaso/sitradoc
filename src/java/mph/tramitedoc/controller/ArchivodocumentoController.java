package mph.tramitedoc.controller;


//@Erick Escalante Olano


import mph.tramitedoc.be.ArchivodocumentoBE;
import mph.tramitedoc.bl.ArchivodocumentoBL;
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
@RequestMapping("/ArchivodocumentoController")
@SessionAttributes({"oSession"})
public class ArchivodocumentoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarArchivodocumentoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarArchivodocumentoBE(@RequestBody Map<String, Object> param) {

        ArchivodocumentoBL oArchivodocumentoBL = new ArchivodocumentoBL();
        ArchivodocumentoBE oArchivodocumentoBE = gson.fromJson(gson.toJson(param.get("poArchivodocumentoBE")), ArchivodocumentoBE.class);
        json = gson.toJson(oArchivodocumentoBL.insertarArchivodocumentoBE(oArchivodocumentoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarArchivodocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarArchivodocumentoBE(@RequestBody Map<String, Object> param) {

        ArchivodocumentoBL oArchivodocumentoBL = new ArchivodocumentoBL();
        ArchivodocumentoBE oArchivodocumentoBE = gson.fromJson(gson.toJson(param.get("poArchivodocumentoBE")), ArchivodocumentoBE.class);
        json = gson.toJson(oArchivodocumentoBL.actualizarArchivodocumentoBE(oArchivodocumentoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarArchivodocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarArchivodocumentoBE(@RequestBody Map<String, Object> param) {

        ArchivodocumentoBL oArchivodocumentoBL = new ArchivodocumentoBL();
        ArchivodocumentoBE oArchivodocumentoBE = gson.fromJson(gson.toJson(param.get("poArchivodocumentoBE")), ArchivodocumentoBE.class);
        json = gson.toJson(oArchivodocumentoBL.eliminarArchivodocumentoBE(oArchivodocumentoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosArchivodocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosArchivodocumentoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ArchivodocumentoBL oArchivodocumentoBL = new ArchivodocumentoBL();
        ArchivodocumentoBE oArchivodocumentoBE = gson.fromJson(gson.toJson(param.get("poArchivodocumentoBE")), ArchivodocumentoBE.class);

        json = gson.toJson(oArchivodocumentoBL.listarRegistrosArchivodocumentoBE(oArchivodocumentoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectArchivodocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectArchivodocumentoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ArchivodocumentoBL oArchivodocumentoBL = new ArchivodocumentoBL();
        ArchivodocumentoBE oArchivodocumentoBE = gson.fromJson(gson.toJson(param.get("poArchivodocumentoBE")), ArchivodocumentoBE.class);

        json = gson.toJson(oArchivodocumentoBL.listObjectArchivodocumentoBE(oArchivodocumentoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
