/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.controller;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import mph.tramitedoc.be.FileBE;
import mph.tramitedoc.system.ParametrosSystem;
import mph.tramitedoc.util.NameUNIQUE;
import mph.tramitedoc.util.UploadFTP;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
@RequestMapping("/UploaderController")
@SessionAttributes({"oSession"})
public class UploaderController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/loadFiles", method = RequestMethod.POST)
    public @ResponseBody
    FileBE insertarArchivoMensaje(MultipartHttpServletRequest request, HttpSession session) throws IOException {
        //creando una session para guardar los datos
        //session = requests.getSession(true);
        FileBE oFileBE = new FileBE();
        if (ParametrosSystem.getUrl_access_ftp().equals("")) {
            oFileBE.setError("Configurar el FTP!!!");
        } else {

            String _filename = "";

            Iterator<String> itr = request.getFileNames();
            MultipartFile mpf = null;
            UploadFTP oUploadFTP = new UploadFTP();
            NameUNIQUE oNameUNIQUE = new NameUNIQUE();

            while (itr.hasNext()) {
                mpf = request.getFile(itr.next());
                if (!mpf.getOriginalFilename().equals("")) {
                    _filename = oNameUNIQUE.geneNameUNIQUE(mpf);
                    oFileBE.setUrl(_filename);
                    oFileBE.setName(mpf.getOriginalFilename());
                    oFileBE.setTamanio(String.valueOf(mpf.getSize()));
                    oFileBE.setSize(String.valueOf(mpf.getSize()));
                    oFileBE.setType(mpf.getContentType());
                    oFileBE.setLink(ParametrosSystem.getUrl_access_ftp() + "/" + _filename);
                    oUploadFTP.uploadFTP(mpf, _filename);
                }
            }

        }
        return oFileBE;

    }

    @RequestMapping(value = "/deleteFile", method = RequestMethod.POST)
    public @ResponseBody
    FileBE deleteFile(@RequestBody Map<String, Object> param) throws IOException {

        UploadFTP oUploadFTP = new UploadFTP();
        FileBE oFileBE = gson.fromJson(gson.toJson(param.get("poFileBE")), FileBE.class);
        oFileBE.setEstado(oUploadFTP.deleteFTP(oFileBE.getUrl()));
        return oFileBE;

    }

}
