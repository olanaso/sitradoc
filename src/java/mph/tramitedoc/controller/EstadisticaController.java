/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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

import java.util.ArrayList;

import java.util.HashMap;

import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mph.tramitedoc.be.EstadoflujoBE;
import mph.tramitedoc.bl.EstadoflujoBL;
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

@Controller
@RequestMapping("/EstadisticaController")
@SessionAttributes({"oSession"})
public class EstadisticaController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/listObjectEstadisticaBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectExpedienteBE(HttpServletRequest request, HttpSession session, @RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        int suma_catpcha = (int) session.getAttribute(Parameter.ss_catpcha);
        EstadoflujoBL oExpedienteBL = new EstadoflujoBL();
        EstadoflujoBE oExpedienteBE = gson.fromJson(gson.toJson(param.get("poEstadoflujoBE")), EstadoflujoBE.class);

        json = gson.toJson(oExpedienteBL.listObjectEstadoflujoBE(oExpedienteBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
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

}
