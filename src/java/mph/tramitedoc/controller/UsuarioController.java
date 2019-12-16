package mph.tramitedoc.controller;

//@Erick Escalante Olano
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.Date;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import mph.tramitedoc.be.ParametrosSystemBE;
import mph.tramitedoc.be.UsuarioBE;
import mph.tramitedoc.bl.UsuarioBL;
import mph.tramitedoc.config.ConfigProperties;
import mph.tramitedoc.config.SaveConfiguration;
import mph.tramitedoc.da.TestConection;
import mph.tramitedoc.security.Cripto;
import mph.tramitedoc.system.ParametrosSystem;
import mph.tramitedoc.system.XMLConfiguration;
import mph.tramitedoc.util.Blowfish;
import mph.tramitedoc.util.Parameter;
import mph.tramitedoc.util.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
@RequestMapping("/UsuarioController")
@SessionAttributes({"oSession"})
public class UsuarioController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/init.htm", method = RequestMethod.POST)
    public @ResponseBody
    String init(@RequestBody Map<String, Object> param, HttpServletRequest request, HttpSession session) throws SQLException, Exception {
        ServletContext sc = request.getServletContext();
        String path = sc.getRealPath("/");

        ConfigProperties oConfigProperties = new ConfigProperties();
        int resultado = oConfigProperties.getProperties(path);
        oConfigProperties.getFTPProperties(path);

        if (resultado == 1) {
            TestConection otConection = new TestConection();
            try {
                if (otConection.testConection() == null) {
                    json = new Gson().toJson("false");
                } else {
                    json = new Gson().toJson("true");
                }
            } catch (SQLException ex) {
                Logger.getLogger(UsuarioController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } else {
            if (resultado == -2) {
                json = new Gson().toJson("null");
            } else {
                json = new Gson().toJson("false");
            }
        }

        return json;
    }

    @RequestMapping(value = "/testConeccion.htm", method = RequestMethod.POST)
    public @ResponseBody
    String testConeccion(@RequestBody Map<String, Object> param, HttpServletRequest request/*,@ModelAttribute("oSession") Session oSession,ModelMap model*/) throws SQLException {

        ParametrosSystemBE oSystemBE = gson.fromJson(gson.toJson(param.get("poParametrosSystem")), ParametrosSystemBE.class);
        TestConection otConection = new TestConection(oSystemBE.getUrlPostgres(), oSystemBE.getDriverPostgres(), oSystemBE.getUsuarioPostgres(), oSystemBE.getPasswordPostgres());
        if (otConection.testConection() == null) {
            json = new Gson().toJson("false");
        } else {

            json = new Gson().toJson("true");
        }

        return json;
    }

    @RequestMapping(value = "/guardarConfiguracion.htm", method = RequestMethod.POST)
    public @ResponseBody
    String guardarConfiguracion(@RequestBody Map<String, Object> param, HttpServletRequest request/*,@ModelAttribute("oSession") Session oSession,ModelMap model*/) {

        json = "";
        ServletContext sc = request.getServletContext();
        String path = sc.getRealPath("/");
        ParametrosSystemBE oSystemBE = gson.fromJson(gson.toJson(param.get("poParametrosSystem")), ParametrosSystemBE.class);
        SaveConfiguration oConfiguration = new SaveConfiguration();
        json = gson.toJson(oConfiguration.save(oSystemBE, path));
        return json;
    }

    @RequestMapping(value = "/initlogin.htm", method = RequestMethod.POST)
    public @ResponseBody
    String initlogin(@RequestBody Map<String, Object> param, HttpServletRequest request, HttpSession session) throws UnsupportedEncodingException {
        //System.out.println(session.getId());
        UsuarioBE oUsuarioBE = new UsuarioBE();
        System.out.println("session ID:" + session.getId());
        oUsuarioBE = (UsuarioBE) session.getAttribute(Parameter.ss_usuario_administrador);
        if (oUsuarioBE == null) {
            json = "null";
        } else {
            json = gson.toJson(oUsuarioBE);
        }
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/setDataUsuario.htm", method = RequestMethod.POST)
    public @ResponseBody
    String setDataUsuario(@RequestBody Map<String, Object> param, HttpServletRequest request, HttpSession session) throws UnsupportedEncodingException {
        //System.out.println(session.getId());
        UsuarioBE oUsuarioBE = new UsuarioBE();
        System.out.println("session ID:" + session.getId());
        oUsuarioBE = (UsuarioBE) session.getAttribute(Parameter.ss_usuario_administrador);
        UsuarioBE oUsuarioBE2 = gson.fromJson(gson.toJson(param.get("poUsuarioBE")), UsuarioBE.class);

        if (oUsuarioBE2.getIdcargo() == 0 || oUsuarioBE2.getCargo().equals(null)) {
            oUsuarioBE.setRoles(oUsuarioBE2.getRoles());
        } else {
            oUsuarioBE.setIdcargo(oUsuarioBE2.getIdcargo());
            oUsuarioBE.setCargo(oUsuarioBE2.getCargo());
            oUsuarioBE.setBindjefe(oUsuarioBE2.isBindjefe());
            oUsuarioBE.setIdarea(oUsuarioBE2.getIdarea());
            oUsuarioBE.setArea(oUsuarioBE2.getArea());
            oUsuarioBE.setRoles(oUsuarioBE2.getRoles());
        }

        oUsuarioBE.setListacargos(oUsuarioBE2.getListacargos());
        session.setAttribute(Parameter.ss_usuario_administrador, oUsuarioBE);
        return "1";
    }

    @RequestMapping(value = "/setDataUsuarioArea.htm", method = RequestMethod.POST)
    public @ResponseBody
    String setDataUsuarioArea(@RequestBody Map<String, Object> param, HttpServletRequest request, HttpSession session) throws UnsupportedEncodingException {
        //System.out.println(session.getId());
        UsuarioBE oUsuarioBE = new UsuarioBE();
        System.out.println("session ID:" + session.getId());
        oUsuarioBE = (UsuarioBE) session.getAttribute(Parameter.ss_usuario_administrador);
        UsuarioBE oUsuarioBE2 = gson.fromJson(gson.toJson(param.get("poUsuarioBE")), UsuarioBE.class);

        oUsuarioBE.setIdarea(oUsuarioBE2.getIdarea());
        oUsuarioBE.setArea(oUsuarioBE2.getArea());
        oUsuarioBE.setIdcargo(oUsuarioBE2.getIdcargo());
        oUsuarioBE.setCargo(oUsuarioBE2.getCargo());
        //oUsuarioBE.setRoles(oUsuarioBE2.getRoles());
        oUsuarioBE.setBindjefe(oUsuarioBE2.isBindjefe());
        oUsuarioBE.setBindcargoseleccionado(true);
        //oUsuarioBE.setListacargos(oUsuarioBE2.getListacargos());
        session.setAttribute(Parameter.ss_usuario_administrador, oUsuarioBE);
        return "1";
    }

    @RequestMapping(value = "/iniciarsession.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String iniciarsession(@RequestBody Map<String, Object> param, HttpServletRequest request, HttpSession session) {

        boolean create = true;
        session = request.getSession(create);
        Cripto oCripto = new Cripto();
        UsuarioBL oUsuarioBL = new UsuarioBL();
        UsuarioBE oUsuarioBE = gson.fromJson(gson.toJson(param.get("poUsuarioBE")), UsuarioBE.class);
        oUsuarioBE.setPassword(oCripto.Encriptar(oUsuarioBE.getPassword()));
        UsuarioBE oUsuarioBESession = oUsuarioBL.listarUsuarioBE(oUsuarioBE);

        if (oUsuarioBESession.getIdusuario() < 0 || ((oUsuarioBESession.getNombres() == null)
                && (oUsuarioBESession.getApellidos() == null)
                && (oUsuarioBESession.getPassword() == null))) {
            session.setAttribute(Parameter.ss_usuario_administrador, null);
            json = "null";
        } else {
            session.setAttribute(Parameter.ss_usuario_administrador, oUsuarioBESession);
            json = gson.toJson(oUsuarioBESession);
        }

        return json;

    }

    @RequestMapping(value = "/cerrarsession.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String cerrarsession(@RequestBody Map<String, Object> param, HttpServletRequest request, HttpSession session) {
        session.invalidate();
        return "null";
    }

    @RequestMapping(value = "/insertarUsuarioBE.htm", method = RequestMethod.POST, headers = "content-type=application/json")
    public @ResponseBody
    String insertarUsuarioBE(@RequestBody Map<String, Object> param) {

        Cripto oCripto = new Cripto();
        UsuarioBL oUsuarioBL = new UsuarioBL();
        UsuarioBE oUsuarioBE = gson.fromJson(gson.toJson(param.get("poUsuarioBE")), UsuarioBE.class);

        StringUtils oStringUtils = new StringUtils();
        Date ofecha = new Date();
        oUsuarioBE.setPassword(oCripto.Encriptar(oUsuarioBE.getPassword()));
        oUsuarioBE.setCreationdate(oStringUtils.dateToMillis(ofecha));
        json = gson.toJson(oUsuarioBL.insertarUsuarioBE(oUsuarioBE));
        return json;

    }

    @RequestMapping(value = "/actualizarUsuarioBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String actualizarUsuarioBE(@RequestBody Map<String, Object> param) {

        Cripto oCripto = new Cripto();
        UsuarioBL oUsuarioBL = new UsuarioBL();
        UsuarioBE oUsuarioBE = gson.fromJson(gson.toJson(param.get("poUsuarioBE")), UsuarioBE.class);
        //Blowfish oBlowfish = new Blowfish(Parameter.password_key);
        //oUsuarioBE.setPassword(oBlowfish.encrypt(oUsuarioBE.getPassword()));
        oUsuarioBE.setPassword(oCripto.Encriptar(oUsuarioBE.getPassword()));
        json = gson.toJson(oUsuarioBL.actualizarUsuarioBE(oUsuarioBE));
        return json;

    }

    @RequestMapping(value = "/eliminarUsuarioBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String eliminarUsuarioBE(@RequestBody Map<String, Object> param) {

        UsuarioBL oUsuarioBL = new UsuarioBL();
        UsuarioBE oUsuarioBE = gson.fromJson(gson.toJson(param.get("poUsuarioBE")), UsuarioBE.class);
        json = gson.toJson(oUsuarioBL.eliminarUsuarioBE(oUsuarioBE));
        return json;

    }

    @RequestMapping(value = "/listarRegistrosUsuarioBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listarRegistrosUsuarioBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        UsuarioBL oUsuarioBL = new UsuarioBL();
        UsuarioBE oUsuarioBE = gson.fromJson(gson.toJson(param.get("poUsuarioBE")), UsuarioBE.class);
        json = gson.toJson(oUsuarioBL.listarRegistrosUsuarioBE(oUsuarioBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/listObjectUsuarioBE.htm", method = RequestMethod.POST)
    public @ResponseBody
    String listObjectUsuarioBE(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        UsuarioBL oUsuarioBL = new UsuarioBL();
        UsuarioBE oUsuarioBE = gson.fromJson(gson.toJson(param.get("poUsuarioBE")), UsuarioBE.class);

        json = gson.toJson(oUsuarioBL.listObjectUsuarioBE(oUsuarioBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/autocompletarUsuarios.htm", method = RequestMethod.POST)
    public @ResponseBody
    String autocompletarUsuarios(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        UsuarioBL oUsuarioBL = new UsuarioBL();
        String nvbusqueda = gson.fromJson(gson.toJson(param.get("pnvDenominacion")), String.class);
        UsuarioBE oUsuarioBE = new UsuarioBE();
        oUsuarioBE.setIndOpSp(2);
        oUsuarioBE.setNombres(nvbusqueda);
        json = gson.toJson(oUsuarioBL.listarRegistrosUsuarioBE(oUsuarioBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

    @RequestMapping(value = "/autocompletarUsuariosWithArea.htm", method = RequestMethod.POST)
    public @ResponseBody
    String autocompletarUsuariosWithArea(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        UsuarioBL oUsuarioBL = new UsuarioBL();
        String nvbusqueda = gson.fromJson(gson.toJson(param.get("pnvDenominacion")), String.class);
        UsuarioBE oUsuarioBE = new UsuarioBE();
        oUsuarioBE.setIndOpSp(3);
        oUsuarioBE.setNombres(nvbusqueda);
        json = gson.toJson(oUsuarioBL.listarRegistrosUsuarioBE(oUsuarioBE));
        String s2 = new String(json.getBytes("UTF-8"), "ISO-8859-1");
        return s2;
    }

}
