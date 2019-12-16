package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.FlujoBE;
import mph.tramitedoc.bl.FlujoBL;
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
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mph.tramitedoc.be.ArchivoBE;
import mph.tramitedoc.be.EnvioBE;
import mph.tramitedoc.be.ExpedienteBE;
import mph.tramitedoc.be.OciBE;
import mph.tramitedoc.bl.ArchivoBL;
import mph.tramitedoc.bl.EnvioBL;
import mph.tramitedoc.util.NameUNIQUE;
import mph.tramitedoc.util.Parameter;
import mph.tramitedoc.util.ReportManager;
import mph.tramitedoc.util.UploadFTP;
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
@RequestMapping("/FlujoController")
@SessionAttributes({"oSession"})
public class FlujoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarFlujoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarFlujoBE(@RequestBody Map<String, Object> param) {

        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);
        json = gson.toJson(oFlujoBL.insertarFlujoBE(oFlujoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarFlujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarFlujoBE(@RequestBody Map<String, Object> param) {

        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);
        json = gson.toJson(oFlujoBL.actualizarFlujoBE(oFlujoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarEstadoFlujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarEstadoFlujoBE(@RequestBody Map<String, Object> param) {

        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);
        json = gson.toJson(oFlujoBL.actualizarEstadoFlujoBE(oFlujoBE));
        return json;

    }

    @RequestMapping(value = "/registroderivarflujo.htm", method = RequestMethod.POST)
    public @ResponseBody
    String registroderivarflujo(@RequestBody Map<String, Object> param) {

        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);
        json = gson.toJson(oFlujoBL.registroderivarflujo(oFlujoBE));
        return json;

    }

    @RequestMapping(value = "/eliminarFlujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarFlujoBE(@RequestBody Map<String, Object> param) {

        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);
        json = gson.toJson(oFlujoBL.eliminarFlujoBE(oFlujoBE));
        return json;

    }

    @RequestMapping(value = "/lecturaFlujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String lecturaFlujoBE(@RequestBody Map<String, Object> param) {

        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);
        json = gson.toJson(oFlujoBL.lecturaFlujoBE(oFlujoBE));
        return json;
    }

    @RequestMapping(value = "/listarRegistrosFlujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosFlujoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);

        json = gson.toJson(oFlujoBL.listarRegistrosFlujoBE(oFlujoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listarJQRegistrosFlujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarJQRegistrosFlujoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);

        json = gson.toJson(oFlujoBL.listarJQRegistrosFlujoBE(oFlujoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectFlujoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectFlujoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        FlujoBL oFlujoBL = new FlujoBL();
        FlujoBE oFlujoBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), FlujoBE.class);

        json = gson.toJson(oFlujoBL.listObjectFlujoBE(oFlujoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/insertarEnvio.htm", method = RequestMethod.POST)
    public @ResponseBody
    String insertarEnvio(@RequestBody Map<String, Object> param, HttpServletRequest requests, HttpSession session) {
        //creando una session para guardar los datos
        session = requests.getSession(true);

        Type listType = (Type) new TypeToken<ArrayList<ArchivoBE>>() {
        }.getType();
        ArrayList<ArchivoBE> listaArchivo = gson.fromJson(gson.toJson(param.get("listVolumen")), listType);

        EnvioBL oEnvioBL = new EnvioBL();
        //VolumenBL oVolumenBL = new VolumenBL();
        EnvioBE oEnvioBE = gson.fromJson(gson.toJson(param.get("poFlujoBE")), EnvioBE.class);
        int idenvio = oEnvioBL.insertarEnvioBE(oEnvioBE);

        for (int i = 0; i < listaArchivo.size(); i++) {
            listaArchivo.get(i).setIdenvio(idenvio);
        }
        session.setAttribute(Parameter.ss_idenvio, idenvio);
        session.setAttribute(Parameter.ss_ins_listaArchivo, listaArchivo);
        // session.setAttribute("DocumentoingresoBE", oDocumentoingresoBE);
        json = gson.toJson(idenvio);
        return json;
    }

    /*Subiendo archivos flujo*/
//
//
    @RequestMapping(value = "/insertarArchivoFlujo.htm", method = RequestMethod.POST)
    public @ResponseBody
    String insertarArchivoFlujo(MultipartHttpServletRequest request, HttpSession session) throws IOException {
        //creando una session para guardar los datos
        //session = requests.getSession(true);

        ArchivoBL oArchivoBL = new ArchivoBL();
        //ExpedienteBE oExpedienteBE = (ExpedienteBE) session.getAttribute("Expediente");
        ArrayList<ArchivoBE> listaArchivo = (ArrayList<ArchivoBE>) session.getAttribute(Parameter.ss_ins_listaArchivo);
        //oVolumenBL.insertarRegistrosVolumenBE(listaVolumen);
        /*seccion para insertar files*/
        Iterator<String> itr = request.getFileNames();
        MultipartFile mpf = null;
        UploadFTP oUploadFTP = new UploadFTP();
        NameUNIQUE oNameUNIQUE = new NameUNIQUE();

        while (itr.hasNext()) {

            mpf = request.getFile(itr.next());
            if (!mpf.getOriginalFilename().equals("")) {
                String _filename = oNameUNIQUE.geneNameUNIQUE(mpf);
               // oUploadFTP.uploadFTP(Parameter.ftp_server, Parameter.ftp_port, Parameter.ftp_user, Parameter.ftp_password, mpf, _filename);
                for (int i = 0; i < listaArchivo.size(); i++) {
                    System.out.println("volumen name:" + listaArchivo.get(i).getName());
                    System.out.println("volumen name:" + mpf.getName());
                    if (listaArchivo.get(i).getName().equals(mpf.getName())) {
                        listaArchivo.get(i).setRuta(_filename);
                    }
                }

            }
        }

        json = gson.toJson(oArchivoBL.insertarRegistrosArchivoBE(listaArchivo));
        /*limpiando las sessiones*/
        session.setAttribute(Parameter.ss_idenvio, 0);
        session.setAttribute(Parameter.ss_ins_listaArchivo, null);

        return json;

    }

    @RequestMapping(value = "/insertarListaFlujo.htm", method = RequestMethod.POST)
    public @ResponseBody
    String insertarListaFlujo(@RequestBody Map<String, Object> param, HttpServletRequest requests, HttpSession session) {
        //creando una session para guardar los datos
        session = requests.getSession(true);
        Type listType = (Type) new TypeToken<ArrayList<FlujoBE>>() {
        }.getType();

        int idenvio = (int) session.getAttribute(Parameter.ss_idenvio);

        FlujoBL oFlujoBL = new FlujoBL();
        //VolumenBL oVolumenBL = new VolumenBL();

        ArrayList<FlujoBE> listaflujo = gson.fromJson(gson.toJson(param.get("listflujo")), listType);
        //DocumentoingresoBE oDocumentoingresoBE = gson.fromJson(gson.toJson(param.get("poDocumentoingresoBE")), DocumentoingresoBE.class);
        //session.setAttribute(Parameter.ss_ins_idexpediente, idflujo);
        for (int i = 0; i < listaflujo.size(); i++) {
            listaflujo.get(i).setIdenvio(idenvio);
        }
        int resp = oFlujoBL.derivarExpedienteFlujo(listaflujo);
        // session.setAttribute("DocumentoingresoBE", oDocumentoingresoBE);
        json = gson.toJson(resp);
        return json;
    }

    @RequestMapping(value = "/generarReporteOCI.htm", method = RequestMethod.POST)
    public @ResponseBody
    String generarReporteOCI(@RequestBody Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException, JRException, SQLException, IOException {

        try {
            OciBE ociBE = gson.fromJson(gson.toJson(param.get("poOciBE")), OciBE.class);
            JasperReport jasperReport;
            //JasperPrint jasperPrint;
            ReportManager oReportManager = new ReportManager();
            ServletContext sc = request.getServletContext();
            String path = sc.getRealPath("/");

            jasperReport = JasperCompileManager.compileReport(path + "/reporte/reporteOCI.jrxml");

            HashMap parametros = new HashMap();
            //    parametros.put("idcapacitacion", oCapacitacionBE.getIdcapacitacion());
            parametros.put("fecha_inicio", ociBE.getFecha_inicio());
            parametros.put("fecha_fin", ociBE.getFecha_fin());
            parametros.put("idarea", ociBE.getIdarea());
            parametros.put("usuario", ociBE.getUsuario());
            parametros.put("area", ociBE.getArea());

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
