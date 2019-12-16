package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.ExpedienteBE;
import mph.tramitedoc.bl.ExpedienteBL;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;

import java.io.UnsupportedEncodingException;

import java.lang.reflect.Type;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import java.util.Map;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mph.tramitedoc.be.JQObjectBE;
import mph.tramitedoc.util.ReportManager;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperReport;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@RequestMapping("/ExpedienteController")
@SessionAttributes({"oSession"})
public class ExpedienteController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarExpedienteBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarExpedienteBE(@RequestBody Map<String, Object> param) {

        ExpedienteBL oExpedienteBL = new ExpedienteBL();
        ExpedienteBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poExpedienteBE")), ExpedienteBE.class);
        json = gson.toJson(oExpedienteBL.insertarExpedienteBE(oExpedienteBE));
        return json;

    }

    @RequestMapping(value = "/actualizarExpedienteBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarExpedienteBE(@RequestBody Map<String, Object> param) {

        ExpedienteBL oExpedienteBL = new ExpedienteBL();
        ExpedienteBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poExpedienteBE")), ExpedienteBE.class);
        json = gson.toJson(oExpedienteBL.actualizarExpedienteBE(oExpedienteBE));
        return json;

    }

    @RequestMapping(value = "/derivarExpedienteBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String derivarExpedienteBE(@RequestBody Map<String, Object> param) {

        ExpedienteBL oExpedienteBL = new ExpedienteBL();
        ExpedienteBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poExpedienteBE")), ExpedienteBE.class);
        json = gson.toJson(oExpedienteBL.derivarExpedienteBE(oExpedienteBE));
        return json;

    }

    @RequestMapping(value = "/actualizarRegistrosExpedienteBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarRegistrosExpedienteBE(@RequestBody Map<String, Object> param) {

        Type listType = new TypeToken<ArrayList<ExpedienteBE>>() {
        }.getType();

        ExpedienteBL oExpedienteBL = new ExpedienteBL();

        ArrayList<ExpedienteBE> listExpediente = gson.fromJson(gson.toJson(param.get("polistExpedienteBE")), listType);
        json = gson.toJson(oExpedienteBL.actualizarRegistrosExpedienteBE(listExpediente));
        return json;

    }

    @RequestMapping(value = "/eliminarExpedienteBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarExpedienteBE(@RequestBody Map<String, Object> param) {

        ExpedienteBL oExpedienteBL = new ExpedienteBL();
        ExpedienteBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poExpedienteBE")), ExpedienteBE.class);
        json = gson.toJson(oExpedienteBL.eliminarExpedienteBE(oExpedienteBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosExpedienteBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosExpedienteBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ExpedienteBL oExpedienteBL = new ExpedienteBL();
        ExpedienteBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poExpedienteBE")), ExpedienteBE.class);

        ArrayList<ExpedienteBE> listExpediente = oExpedienteBL.listarRegistrosExpedienteBE(oExpedienteBE);
        json = gson.toJson(listExpediente);

 

        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");

        return s2;
    }

    @RequestMapping(value = "/listarJQRegistrosExpedienteBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarJQRegistrosExpedienteBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ExpedienteBL oExpedienteBL = new ExpedienteBL();
        ExpedienteBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poExpedienteBE")), ExpedienteBE.class);
        JQObjectBE ojqobjectBE = oExpedienteBL.listarJQRegistroExpedienteBE(oExpedienteBE);
        json = gson.toJson(ojqobjectBE);
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        
        return s2;
    }

    @RequestMapping(value = "/listObjectExpedienteBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectExpedienteBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        ExpedienteBL oExpedienteBL = new ExpedienteBL();
        ExpedienteBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poExpedienteBE")), ExpedienteBE.class);

        json = gson.toJson(oExpedienteBL.listObjectExpedienteBE(oExpedienteBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/generarReporte.htm", method = RequestMethod.POST)
    public @ResponseBody
    String generarReporte(@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, JRException, SQLException, IOException {

        try {
            ExpedienteBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poExpedienteBE")), ExpedienteBE.class);
            JasperReport jasperReport;
            //JasperPrint jasperPrint;
            ReportManager oReportManager = new ReportManager();
            ServletContext sc = request.getServletContext();
            String path = sc.getRealPath("/");

            jasperReport = JasperCompileManager.compileReport(path + "/reporte/reportesexpediente.jrxml");

            HashMap parametros = new HashMap();
            //    parametros.put("idcapacitacion", oCapacitacionBE.getIdcapacitacion());
            parametros.put("fecha_inicio", oExpedienteBE.getDni_ruc());
            parametros.put("fecha_fin", oExpedienteBE.getNombre_razonsocial());
            parametros.put("idusuario", oExpedienteBE.getIdusuariocargo());
            parametros.put("usuario", oExpedienteBE.getApellidos());

            //parametros.put("idventanilla", 0);
            //parametros.put("idusuario", 0);
            //parametros.put("fechainicio", "2010-01-01");
            //parametros.put("fechainicio", "2014-01-01");
            return oReportManager.generarReportepdf(jasperReport, parametros);

        } catch (Exception e) {
            return e.getMessage();
        }

    }

}
