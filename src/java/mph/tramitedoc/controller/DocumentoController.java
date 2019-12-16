package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.DocumentoBE;
import mph.tramitedoc.bl.DocumentoBL;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.ref.Reference;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import mph.tramitedoc.be.ArchivoBE;
import mph.tramitedoc.be.ArchivodocumentoBE;
import mph.tramitedoc.be.JQObjectBE;
import mph.tramitedoc.be.ReferenciaBE;
import mph.tramitedoc.bl.ArchivoBL;
import mph.tramitedoc.bl.ArchivodocumentoBL;
import mph.tramitedoc.bl.ReferenciaBL;
import mph.tramitedoc.util.NameUNIQUE;
import mph.tramitedoc.util.Parameter;
import mph.tramitedoc.util.UploadFTP;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
@RequestMapping("/DocumentoController")
@SessionAttributes({"oSession"})
public class DocumentoController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/insertarDocumentoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarDocumentoBE(@RequestBody Map<String, Object> param) {

        DocumentoBL oDocumentoBL = new DocumentoBL();
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);
        json = gson.toJson(oDocumentoBL.insertarDocumentoBE(oDocumentoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarDocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarDocumentoBE(@RequestBody Map<String, Object> param) {

        DocumentoBL oDocumentoBL = new DocumentoBL();
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);
        json = gson.toJson(oDocumentoBL.actualizarDocumentoBE(oDocumentoBE));
        return json;

    }

    @RequestMapping(value = "/actualizarRegistrosDocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarRegistrosDocumentoBE(@RequestBody Map<String, Object> param) {
        Type listType = new TypeToken<ArrayList<DocumentoBE>>() {
        }.getType();
        DocumentoBL oDocumentoBL = new DocumentoBL();
        ArrayList<DocumentoBE> listExpediente = gson.fromJson(gson.toJson(param.get("polistDocumentoBE")), listType);
        json = gson.toJson(oDocumentoBL.actualizarRegistrosDocumentoBE(listExpediente));
        return json;
    }

    @RequestMapping(value = "/eliminarDocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarDocumentoBE(@RequestBody Map<String, Object> param) {

        DocumentoBL oDocumentoBL = new DocumentoBL();
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);
        json = gson.toJson(oDocumentoBL.eliminarDocumentoBE(oDocumentoBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosDocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosDocumentoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        DocumentoBL oDocumentoBL = new DocumentoBL();
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);

        json = gson.toJson(oDocumentoBL.listarRegistrosDocumentoBE(oDocumentoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listarJQRegistrosDocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarJQRegistrosDocumentoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        DocumentoBL oDocumentoBL = new DocumentoBL();
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);
        JQObjectBE ojqobjectBE = oDocumentoBL.listarJQRegistroDocumentoBE(oDocumentoBE);
        json = gson.toJson(ojqobjectBE);
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");

        return s2;
    }

    @RequestMapping(value = "/listObjectDocumentoBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectDocumentoBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        DocumentoBL oDocumentoBL = new DocumentoBL();
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);

        json = gson.toJson(oDocumentoBL.listObjectDocumentoBE(oDocumentoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/derivarDocumentoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String derivarDocumentoBE(@RequestBody Map<String, Object> param, HttpServletRequest requests, HttpSession session) {

        DocumentoBL oDocumentoBL = new DocumentoBL();
        Type listType = (Type) new TypeToken<ArrayList<ArchivodocumentoBE>>() {
        }.getType();
        ArrayList<ArchivodocumentoBE> listaArchivo = gson.fromJson(gson.toJson(param.get("listVolumen")), listType);
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);
        int iddoc = oDocumentoBL.derivarDocumentoBE(oDocumentoBE);
        for (int i = 0; i < listaArchivo.size(); i++) {
            listaArchivo.get(i).setDocumento(iddoc);
        }
        session.setAttribute(Parameter.ss_id_doc_ins, iddoc);
        session.setAttribute(Parameter.ss_ins_listaArchivo, listaArchivo);
        // session.setAttribute("DocumentoingresoBE", oDocumentoingresoBE);
        json = gson.toJson(iddoc);
        return json;

    }

    @RequestMapping(value = "/crearDocumentoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String crearDocumentoBE(@RequestBody Map<String, Object> param, HttpServletRequest requests, HttpSession session) {

        DocumentoBL oDocumentoBL = new DocumentoBL();
        ReferenciaBL oReferenciaBL = new ReferenciaBL();
        Type listType = (Type) new TypeToken<ArrayList<ArchivodocumentoBE>>() {
        }.getType();
        ArrayList<ArchivodocumentoBE> listaArchivo = gson.fromJson(gson.toJson(param.get("listVolumen")), listType);
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);
        int iddoc = oDocumentoBL.insertarDocumentoBE(oDocumentoBE);

        ArrayList<ReferenciaBE> listareferencia = new ArrayList<ReferenciaBE>();
        for (int i = 0; i < oDocumentoBE.getListaidsdocumento().length; i++) {
            ReferenciaBE oReferenciaBE = new ReferenciaBE();
            oReferenciaBE.setIddocumento(iddoc);
            oReferenciaBE.setIddocumentoreferencia(oDocumentoBE.getListaidsdocumento()[i]);
            oReferenciaBE.setIdusuarioregistra(oDocumentoBE.getIdusuariocreacion());
            listareferencia.add(oReferenciaBE);
        }
        oReferenciaBL.insertarRegistrosReferenciaBE(listareferencia);

        if (iddoc == 0) {

        } else {
            for (int i = 0; i < listaArchivo.size(); i++) {
                listaArchivo.get(i).setDocumento(iddoc);
            }
            session.setAttribute(Parameter.ss_id_doc_ins, iddoc);
            session.setAttribute(Parameter.ss_ins_listaArchivo, listaArchivo);
        }

        // session.setAttribute("DocumentoingresoBE", oDocumentoingresoBE);
        json = gson.toJson(iddoc);
        return json;

    }

    @RequestMapping(value = "/insertarArchivoDocumento.htm", method = RequestMethod.POST)
    public @ResponseBody
    String insertarArchivoDocumento(MultipartHttpServletRequest request, HttpSession session) throws IOException {
        //creando una session para guardar los datos
        //session = requests.getSession(true);

        ArchivodocumentoBL oArchivodocumentoBL = new ArchivodocumentoBL();
        //ExpedienteBE oExpedienteBE = (ExpedienteBE) session.getAttribute("Expediente");
        ArrayList<ArchivodocumentoBE> listaArchivoDocumento = (ArrayList<ArchivodocumentoBE>) session.getAttribute(Parameter.ss_ins_listaArchivo);
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
                for (int i = 0; i < listaArchivoDocumento.size(); i++) {
                    System.out.println("volumen name:" + listaArchivoDocumento.get(i).getName());
                    System.out.println("volumen name:" + mpf.getName());
                    if (listaArchivoDocumento.get(i).getName().equals(mpf.getName())) {
                        listaArchivoDocumento.get(i).setUrl(_filename);
                    }
                }

            }
        }

        json = gson.toJson(oArchivodocumentoBL.insertarRegistrosArchivodocumentoBE(listaArchivoDocumento));
        /*limpiando las sessiones*/
        session.setAttribute(Parameter.ss_idenvio, 0);
        session.setAttribute(Parameter.ss_ins_listaArchivo, null);

        return json;

    }

    @RequestMapping(value = "/autocompletarDocumento.htm", method = RequestMethod.POST)
    public @ResponseBody
    String autocompletarDocumento(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        DocumentoBL oDocumentoBL = new DocumentoBL();
        String nvbusqueda = gson.fromJson(gson.toJson(param.get("pnvDenominacion")), String.class);
        DocumentoBE oDocumentoBE = new DocumentoBE();
        oDocumentoBE.setIndOpSp(4);
        oDocumentoBE.setCodigo(nvbusqueda);
        json = gson.toJson(oDocumentoBL.listarRegistrosDocumentoBE(oDocumentoBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/crearDocumentoResumindoBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String crearDocumentoResumindoBE(@RequestBody Map<String, Object> param, HttpServletRequest requests, HttpSession session) {

        DocumentoBL oDocumentoBL = new DocumentoBL();
        ReferenciaBL oReferenciaBL = new ReferenciaBL();
       
        DocumentoBE oDocumentoBE = gson.fromJson(gson.toJson(param.get("poDocumentoBE")), DocumentoBE.class);
        int iddoc = oDocumentoBL.insertarDocumentoBE(oDocumentoBE);

        ArrayList<ReferenciaBE> listareferencia = new ArrayList<ReferenciaBE>();
        for (int i = 0; i < oDocumentoBE.getListaidsdocumento().length; i++) {
            ReferenciaBE oReferenciaBE = new ReferenciaBE();
            oReferenciaBE.setIddocumento(iddoc);
            oReferenciaBE.setIddocumentoreferencia(oDocumentoBE.getListaidsdocumento()[i]);
            oReferenciaBE.setIdusuarioregistra(oDocumentoBE.getIdusuariocreacion());
            listareferencia.add(oReferenciaBE);
        }
        oReferenciaBL.insertarRegistrosReferenciaBE(listareferencia);

        if (iddoc == 0) {

        } else {

            for (int i = 0; i < oDocumentoBE.getLista_archivos().size(); i++) {
                oDocumentoBE.getLista_archivos().get(i).setDocumento(iddoc);
            }
            
            ArchivodocumentoBL oArchivodocumentoBL = new ArchivodocumentoBL();
            oArchivodocumentoBL.insertarRegistrosArchivodocumentoBE(oDocumentoBE.getLista_archivos());
        }
        session.setAttribute(Parameter.ss_fecha_manual, oDocumentoBE.getFecha_envio());
        json = gson.toJson(iddoc);
        return json;

    }

}
