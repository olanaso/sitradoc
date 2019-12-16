/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package mph.tramitedoc.controller;

//@Erick Escalante Olano
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import mph.tramitedoc.be.ParametrosSystemBE;
import mph.tramitedoc.config.ConfigProperties;
import mph.tramitedoc.config.SaveConfiguration;
import mph.tramitedoc.da.TestConection;
import mph.tramitedoc.security.Cripto;
import mph.tramitedoc.system.ParametrosSystem;
import mph.tramitedoc.system.XMLConfiguration;
import mph.tramitedoc.util.Parameter;
import mph.tramitedoc.util.UploadFTP;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.Date;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import net.sf.jasperreports.engine.JasperCompileManager;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@RequestMapping("/FTPController")
@SessionAttributes({"oSession"})
public class FTPController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/testConeccionFTP.htm", method = RequestMethod.POST)
    public @ResponseBody
    String testConeccionFTP(@RequestBody Map<String, Object> param, HttpServletRequest request/*,@ModelAttribute("oSession") Session oSession,ModelMap model*/) throws SQLException, IOException {
        UploadFTP oFTP = new UploadFTP();
        ParametrosSystemBE oSystemBE = gson.fromJson(gson.toJson(param.get("poParametrosSystem")), ParametrosSystemBE.class);
        json = gson.toJson(oFTP.testuploadFTP(oSystemBE.getFtp_ip_address(), oSystemBE.getFtp_port(), oSystemBE.getFtp_user(), oSystemBE.getFtp_password()));
        return json;
    }

    @RequestMapping(value = "/guardarConfiguracionFTP.htm", method = RequestMethod.POST)
    public @ResponseBody
    String guardarConfiguracionFTP(@RequestBody Map<String, Object> param, HttpServletRequest request/*,@ModelAttribute("oSession") Session oSession,ModelMap model*/) {
        json = "";
        ServletContext sc = request.getServletContext();
        String path = sc.getRealPath("/");
        ParametrosSystemBE oSystemBE = gson.fromJson(gson.toJson(param.get("poParametrosSystem")), ParametrosSystemBE.class);
        SaveConfiguration oConfiguration = new SaveConfiguration();
        json = gson.toJson(oConfiguration.saveFTP(oSystemBE, path));
        return json;
    }

}