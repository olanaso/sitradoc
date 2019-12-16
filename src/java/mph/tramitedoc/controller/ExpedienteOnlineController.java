package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.ExpedienteBE;
import mph.tramitedoc.bl.ExpedienteBL;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.File;
import java.io.IOException;

import java.io.UnsupportedEncodingException;

import java.lang.reflect.Type;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mph.tramitedoc.util.CaptchaGenerator;
import mph.tramitedoc.util.Parameter;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
@RequestMapping("/ExpedienteOnlineController")
@SessionAttributes({"oSession"})
public class ExpedienteOnlineController {

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

        json = gson.toJson(oExpedienteBL.listarRegistrosExpedienteBE(oExpedienteBE));
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

    
    @RequestMapping(value = "/getCaptcha.htm", method = RequestMethod.POST)
    public @ResponseBody
    String getCaptcha(HttpServletRequest request, HttpSession session) throws UnsupportedEncodingException {

        int num1 = (int) (Math.random() * 10);
        int num2 = (int) (Math.random() * 10);
        session = request.getSession(true);
        session.setAttribute(Parameter.ss_catpcha, (num1 + num2));
        CaptchaGenerator oCaptchaGenerator = new CaptchaGenerator();
        return oCaptchaGenerator.generateImage(num1 + "+" + num2);
    }
    
    
    private String saveDirectory = "E:/Upload/";
    /*
     (			#Start of the group #1
     [^\s]+			#  must contains one or more anything (except white space)
     (		#    start of the group #2
     \.		#	follow by a dot "."
     (?i)		#	ignore the case sensive checking for the following characters
     (		#	  start of the group #3
     jpg	#	    contains characters "jpg"
     |		#	    ..or
     png	#	    contains characters "png"
     |		#	    ..or
     gif	#	    contains characters "gif"
     |		#	    ..or
     bmp	#	    contains characters "bmp"
     )		#	  end of the group #3
     )		#     end of the group #2	
     $			#  end of the string
     )			#end of the group #1
     */
 
    

}
