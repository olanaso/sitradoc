package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.ProcedimientoBE;
import mph.tramitedoc.bl.ProcedimientoBL;
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
@RequestMapping("/ProcedimientoController")
@SessionAttributes({"oSession"})
public class ProcedimientoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarProcedimientoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarProcedimientoBE(@RequestBody Map<String, Object> param) {

        ProcedimientoBL oProcedimientoBL = new ProcedimientoBL();
        ProcedimientoBE oProcedimientoBE = gson.fromJson(gson.toJson(param.get("poProcedimientoBE")), ProcedimientoBE.class);
        json = gson.toJson(oProcedimientoBL.insertarProcedimientoBE(oProcedimientoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarProcedimientoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarProcedimientoBE(@RequestBody Map<String, Object> param) {

        ProcedimientoBL oProcedimientoBL = new ProcedimientoBL();
        ProcedimientoBE oProcedimientoBE = gson.fromJson(gson.toJson(param.get("poProcedimientoBE")), ProcedimientoBE.class);
        json = gson.toJson(oProcedimientoBL.actualizarProcedimientoBE(oProcedimientoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarProcedimientoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarProcedimientoBE(@RequestBody Map<String, Object> param) {

        ProcedimientoBL oProcedimientoBL = new ProcedimientoBL();
        ProcedimientoBE oProcedimientoBE = gson.fromJson(gson.toJson(param.get("poProcedimientoBE")), ProcedimientoBE.class);
        json = gson.toJson(oProcedimientoBL.eliminarProcedimientoBE(oProcedimientoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosProcedimientoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosProcedimientoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ProcedimientoBL oProcedimientoBL = new ProcedimientoBL();
        ProcedimientoBE oProcedimientoBE = gson.fromJson(gson.toJson(param.get("poProcedimientoBE")), ProcedimientoBE.class);

        json = gson.toJson(oProcedimientoBL.listarRegistrosProcedimientoBE(oProcedimientoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectProcedimientoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectProcedimientoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ProcedimientoBL oProcedimientoBL = new ProcedimientoBL();
        ProcedimientoBE oProcedimientoBE = gson.fromJson(gson.toJson(param.get("poProcedimientoBE")), ProcedimientoBE.class);

        json = gson.toJson(oProcedimientoBL.listObjectProcedimientoBE(oProcedimientoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }
    
    @RequestMapping(value = "/autocompletarProcedimiento.htm", method = RequestMethod.POST)
    public @ResponseBody
    String autocompletarProcedimiento(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {

        ProcedimientoBL oProcedimientoBL = new ProcedimientoBL();
        ProcedimientoBE oProcedimientoBE = gson.fromJson(gson.toJson(param.get("pObject")), ProcedimientoBE.class);
        String denominacion = gson.fromJson(gson.toJson(param.get("pnvDenominacion")), String.class);
       
        oProcedimientoBE.setDenominacion(denominacion);
        //oProcedimientoBE.setIndOpSp(3);
        json = gson.toJson(oProcedimientoBL.listarRegistrosProcedimientoBE(oProcedimientoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;

    }


}
