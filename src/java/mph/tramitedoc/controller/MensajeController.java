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
import mph.tramitedoc.be.ArchivomensajeBE;
import mph.tramitedoc.be.BandejaBE;
import mph.tramitedoc.be.DocumentomensajeBE;
import mph.tramitedoc.be.EventoBE;
import mph.tramitedoc.be.JQObjectBE;
import mph.tramitedoc.be.MensajeBE;
import mph.tramitedoc.be.RecepcioninternaBE;
import mph.tramitedoc.be.ReferenciaBE;
import mph.tramitedoc.bl.ArchivoBL;
import mph.tramitedoc.bl.ArchivodocumentoBL;
import mph.tramitedoc.bl.ArchivomensajeBL;
import mph.tramitedoc.bl.BandejaBL;
import mph.tramitedoc.bl.DocumentomensajeBL;
import mph.tramitedoc.bl.EventoBL;
import mph.tramitedoc.bl.MensajeBL;
import mph.tramitedoc.bl.RecepcioninternaBL;
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
@RequestMapping("/MensajeController")
@SessionAttributes({"oSession"})
public class MensajeController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/crearMensajeBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String crearMensajeBE(@RequestBody Map<String, Object> param, HttpServletRequest requests, HttpSession session) {

        String fecha_manual=(String)  session.getAttribute(Parameter.ss_fecha_manual);
        MensajeBL oMensajeBL = new MensajeBL();

        MensajeBE oMensajeBE = gson.fromJson(gson.toJson(param.get("poMensajeBE")), MensajeBE.class);
        oMensajeBE.setFecha_manual(fecha_manual);
        int idmensaje = oMensajeBL.crearMensajeBE(oMensajeBE);

        if (idmensaje > 0) {
            /*Derivando a las bandejas areas y asu recepcion*/
            if (oMensajeBE.isBindrecepcion() != false) {
                RecepcioninternaBL oRecepcioninternaBL = new RecepcioninternaBL();
                ArrayList<RecepcioninternaBE> recepcionjInterna = new ArrayList<RecepcioninternaBE>();
                for (int i = 0; i < oMensajeBE.getIdareas().length; i++) {
                    RecepcioninternaBE oRecepcioninternaBE = new RecepcioninternaBE();
                    oRecepcioninternaBE.setBindderivado(false);
                    oRecepcioninternaBE.setBindentregado(false);
                    oRecepcioninternaBE.setBindprimero(true);
                    oRecepcioninternaBE.setEstado(true);
                    oRecepcioninternaBE.setFechaderivacion(null);
                    oRecepcioninternaBE.setFecharecepcion(null);//
                    oRecepcioninternaBE.setIdarea_destino(oMensajeBE.getIdareas()[i]);
                    oRecepcioninternaBE.setIdarea_proviene(oMensajeBE.getIdareacioncreacion());
                    oRecepcioninternaBE.setIdmensaje(idmensaje);
                    oRecepcioninternaBE.setIdrecepcion_proviene(0);
                    oRecepcioninternaBE.setIdusuarioenvia(oMensajeBE.getIdusuariocreacion());
                    oRecepcioninternaBE.setIdusuariorecepciona(0);
                    oRecepcioninternaBE.setObservacion("DERIVADO DESDE CRECION DE MENSAJE");
                    recepcionjInterna.add(oRecepcioninternaBE);
                }
                oRecepcioninternaBL.insertarRegistrosRecepcioninternaBE(recepcionjInterna);
            }


            /*Derivando a las abandejas de los usuario*/
            String areasdestino = "";
            String usuariosdestino = "";
            BandejaBL oBandejaBL = new BandejaBL();
            ArrayList<BandejaBE> listaBandejaBE = new ArrayList<BandejaBE>();
            for (int i = 0; i < oMensajeBE.getListausuarios().size(); i++) {
                BandejaBE oBandejaBE = new BandejaBE();
                oBandejaBE.setIdmensaje(idmensaje);
                oBandejaBE.setIdareaproviene(oMensajeBE.getIdareacioncreacion());
                oBandejaBE.setIdareadestino(oMensajeBE.getListausuarios().get(i).getIdarea());
                oBandejaBE.setIdusuariodestino(oMensajeBE.getListausuarios().get(i).getIdusuario());
                oBandejaBE.setIdusuarioenvia(oMensajeBE.getIdusuariocreacion());
                oBandejaBE.setIddocumento(oMensajeBE.getIdexpediente());
                oBandejaBE.setBindrecepcion(false);
                oBandejaBE.setIdusuariorecepciona(0);
                oBandejaBE.setFecha_manual(fecha_manual);
              //  System.out.println(""+oMensajeBE.getIddocumentos()[0]);
                oBandejaBE.setDocumento("");
              //  System.out.println("ids documentos:"+oMensajeBE.getIddocumentos()[0].toString());
                //oBandejaBE.setFecharegistro(new Date());

                listaBandejaBE.add(oBandejaBE);
                areasdestino = oMensajeBE.getListausuarios().get(i).getIdarea() + "," + areasdestino;
                usuariosdestino = oMensajeBE.getListausuarios().get(i).getIdusuario() + "," + usuariosdestino;
                if ((i + 1) == oMensajeBE.getListausuarios().size()) {
                    areasdestino = areasdestino.substring(0, areasdestino.length() - 1);
                    usuariosdestino = usuariosdestino.substring(0, usuariosdestino.length() - 1);
                }
            }
            oBandejaBL.insertarRegistrosBandejaBE(listaBandejaBE);

            DocumentomensajeBL oDocumentomensajeBL = new DocumentomensajeBL();
            ArrayList<DocumentomensajeBE> listaDocumentomensajeBE = new ArrayList<DocumentomensajeBE>();
            for (int i = 0; i < oMensajeBE.getIddocumentos().length; i++) {
                DocumentomensajeBE oDocumentomensajeBE = new DocumentomensajeBE();

                oDocumentomensajeBE.setEstado(true);
                oDocumentomensajeBE.setIddocumento(oMensajeBE.getIddocumentos()[i]);
                oDocumentomensajeBE.setIdmensaje(idmensaje);
                oDocumentomensajeBE.setIdusuariocreacion(oMensajeBE.getIdusuariocreacion());

                listaDocumentomensajeBE.add(oDocumentomensajeBE);
            }
            oDocumentomensajeBL.insertarRegistrosDocumentomensajeBE(listaDocumentomensajeBE);

            /*Actualizando Evento*/
            EventoBE oEventoBE = new EventoBE();
            EventoBL oEventoBL = new EventoBL();
            oEventoBE.setIdexpediente(oMensajeBE.getIdexpediente());
            oEventoBE.setAreadestino(areasdestino);
            oEventoBE.setUsuariodestino(usuariosdestino);
            oEventoBL.actualizarEventoBE(oEventoBE);

            for (int i = 0; i < oMensajeBE.getArchivosmensaje().size(); i++) {
                oMensajeBE.getArchivosmensaje().get(i).setIdmensaje(idmensaje);
            }

            session.setAttribute(Parameter.ss_ins_listaArchivo_mensaje, oMensajeBE.getArchivosmensaje());
            json = gson.toJson(idmensaje);
        } else {
            json = gson.toJson(-1);
        }
        return json;

    }

    @RequestMapping(value = "/insertarArchivoMensaje.htm", method = RequestMethod.POST)
    public @ResponseBody
    String insertarArchivoMensaje(MultipartHttpServletRequest request, HttpSession session) throws IOException {
        //creando una session para guardar los datos
        //session = requests.getSession(true);

        ArchivomensajeBL oArchivomensajeBL = new ArchivomensajeBL();
        //ExpedienteBE oExpedienteBE = (ExpedienteBE) session.getAttribute("Expediente");
        ArrayList<ArchivomensajeBE> listaArchivoMensaje = (ArrayList<ArchivomensajeBE>) session.getAttribute(Parameter.ss_ins_listaArchivo_mensaje);
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
          //      oUploadFTP.uploadFTP(Parameter.ftp_server, Parameter.ftp_port, Parameter.ftp_user, Parameter.ftp_password, mpf, _filename);
                for (int i = 0; i < listaArchivoMensaje.size(); i++) {
                    System.out.println("volumen name:" + listaArchivoMensaje.get(i).getName());
                    System.out.println("volumen name:" + mpf.getName());
                    if (listaArchivoMensaje.get(i).getName().equals(mpf.getName())) {
                        listaArchivoMensaje.get(i).setUrl(_filename);
                    }
                }

            }
        }
        json = gson.toJson(oArchivomensajeBL.insertarRegistrosArchivomensajeBE(listaArchivoMensaje));
        /*limpiando las sessiones*/
        session.setAttribute(Parameter.ss_idenvio, 0);
        session.setAttribute(Parameter.ss_ins_listaArchivo, null);
        return json;

    }

}
