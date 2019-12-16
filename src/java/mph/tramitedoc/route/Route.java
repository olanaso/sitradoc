/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.route;

//@Erick Escalante Olano
import java.io.UnsupportedEncodingException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

@Controller
public class Route {

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login() throws UnsupportedEncodingException {
        return "login";
    }

    @RequestMapping(value = "/administracion", method = RequestMethod.GET)
    public String actividad() throws UnsupportedEncodingException {
        return "tramite/ViewModulo";
    }

    @RequestMapping(value = "/bandeja", method = RequestMethod.GET)
    public String administracion() throws UnsupportedEncodingException {
        return "bandeja/ViewBandejaInterna";
    }

    @RequestMapping(value = "/bandejaTramite", method = RequestMethod.GET)
    public String administracionBandeja() throws UnsupportedEncodingException {
        return "bandeja/ViewBandejaV2";
    }

    @RequestMapping(value = "/bandeja3", method = RequestMethod.GET)
    public String administracionBandeja3() throws UnsupportedEncodingException {
        return "bandeja/ViewBandejaInternaPrueba2";
    }

    @RequestMapping(value = "/mesa-de-partes", method = RequestMethod.GET)
    public String mesapartes() throws UnsupportedEncodingException {
        return "tramite/ViewExpediente";
    }

    @RequestMapping(value = "/menu", method = RequestMethod.GET)
    public String menu() throws UnsupportedEncodingException {
        return "menu/menu";
    }

    @RequestMapping(value = "/TUPA-tramite/area", method = RequestMethod.GET)
    public String tupa_tramite() throws UnsupportedEncodingException {
        return "tramite/ViewArea";
    }

    @RequestMapping(value = "/TUPA-tramite/cargo", method = RequestMethod.GET)
    public String cargo() throws UnsupportedEncodingException {
        return "tramite/ViewCargo";
    }

    @RequestMapping(value = "/TUPA-tramite/procedimiento", method = RequestMethod.GET)
    public String procedimiento() throws UnsupportedEncodingException {
        return "tramite/ViewProcedimiento";
    }

    @RequestMapping(value = "/TUPA-tramite/requisitos", method = RequestMethod.GET)
    public String requisitos() throws UnsupportedEncodingException {
        return "tramite/ViewRequisitos";
    }

    @RequestMapping(value = "/TUPA-tramite/asignacion-cargo", method = RequestMethod.GET)
    public String asignacion_cargo() throws UnsupportedEncodingException {
        return "tramite/ViewUsuariocargo";
    }

    @RequestMapping(value = "/calendario/anio", method = RequestMethod.GET)
    public String anio() throws UnsupportedEncodingException {
        return "tramite/ViewAnio";
    }

    @RequestMapping(value = "/calendario/feriado", method = RequestMethod.GET)
    public String feriado() throws UnsupportedEncodingException {
        return "tramite/ViewFeriado";
    }

    @RequestMapping(value = "/seguridad/usuario", method = RequestMethod.GET)
    public String usuario() throws UnsupportedEncodingException {
        return "tramite/ViewUsuario";
    }

    @RequestMapping(value = "/seguridad/modulo", method = RequestMethod.GET)
    public String modulo() throws UnsupportedEncodingException {
        return "tramite/ViewModulo";
    }

    @RequestMapping(value = "/seguridad/rol", method = RequestMethod.GET)
    public String rol() throws UnsupportedEncodingException {
        return "tramite/ViewRol";
    }

    @RequestMapping(value = "/seguridad/asignacion-rol-modulo", method = RequestMethod.GET)
    public String asignacion_rol_modulo() throws UnsupportedEncodingException {
        return "tramite/ViewRolmodulo";
    }

    @RequestMapping(value = "/seguridad/asignacion-usuario-rol", method = RequestMethod.GET)
    public String asignacion_usuario_rol() throws UnsupportedEncodingException {
        return "tramite/ViewUsuariorol";
    }

    @RequestMapping(value = "/tramite-interno/tipo-documento", method = RequestMethod.GET)
    public String tipo_documento() throws UnsupportedEncodingException {
        return "tramite/ViewTipodocumento";
    }

    @RequestMapping(value = "/tramite-interno/tipo-procedimiento", method = RequestMethod.GET)
    public String tipo_procedimiento() throws UnsupportedEncodingException {
        return "tramite/ViewTipoProcedimiento";
    }

    @RequestMapping(value = "/reportes-estadisticas/reporte-oci", method = RequestMethod.GET)
    public String reporteOci() throws UnsupportedEncodingException {
        return "reporte/ViewReporteOci";
    }

    /*routes de banjdejas de tramite*/
    @RequestMapping(value = "/bandejav2", method = RequestMethod.GET)
    public String vistabandeja() throws UnsupportedEncodingException {
        return "bandejav2/ViewRecibidos";
    }

    @RequestMapping(value = "/tramite-interno/salida", method = RequestMethod.GET)
    public String vistabandejasalida() throws UnsupportedEncodingException {
        return "bandejav2/ViewSalida";
    }

    @RequestMapping(value = "/tramite-interno/resueltos", method = RequestMethod.GET)
    public String vistabandejaresueltos() throws UnsupportedEncodingException {
        return "bandejav2/ViewResueltos";
    }

    @RequestMapping(value = "/tramite-externo/recepcion-expedientes", method = RequestMethod.GET)
    public String recepcionexpedientes() throws UnsupportedEncodingException {
        return "bandejav2/tramexterno_recepcion_expedientes";
    }

    @RequestMapping(value = "/tramite-externo/resolucion-expedientes", method = RequestMethod.GET)
    public String resolucionexpedientes() throws UnsupportedEncodingException {
        return "bandejav2/tramexterno_resol_expediente";
    }

    @RequestMapping(value = "/tramite-interno/recepcion-documentos-internos", method = RequestMethod.GET)
    public String recepciondocumentosinternos() throws UnsupportedEncodingException {
        return "bandejav2/traminterno_recepcion_documentos";
    }

    @RequestMapping(value = "/bandeja/mis-documentos", method = RequestMethod.GET)
    public String misdocumentos() throws UnsupportedEncodingException {
        return "bandejav2/mis-documentos";
    }

    @RequestMapping(value = "/tramite-interno/mensaje", method = RequestMethod.GET)
    public String mensaje() throws UnsupportedEncodingException {
        return "bandejav2/tramite-interno-mensaje";
    }

    @RequestMapping(value = "/documento/ver", method = RequestMethod.GET)
    public String verdocumento() throws UnsupportedEncodingException {
        return "documento/ViewDoc";
    }

    @RequestMapping(value = "/seguridad/configuracion", method = RequestMethod.GET)
    public String configuracion() throws UnsupportedEncodingException {
        return "tramite/ViewConfiguraciones";
    }
    
     @RequestMapping(value = "/tramite-interno/configuracion-documento", method = RequestMethod.GET)
    public String configuracion_documento() throws UnsupportedEncodingException {
        return "bandejav2/ViewconfigDocumento";
    }
}
