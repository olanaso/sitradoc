package mph.tramitedoc.be;

import java.util.ArrayList;
import java.util.Date;
//@autor Sergio Medina

public class DocumentoBE extends BaseBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private Integer iddocumento;
    private Integer idtipodocumento;
    private String codigo;
    private String asunto;
    private String mensaje;
    private Integer prioridad;
    private boolean bindrespuesta;
    private Integer diasrespuesta;
    private boolean bindllegadausuario;
    private Integer idareacioncreacion;
    private Integer idareadestino;
    private Integer idusuariocreacion;
    private Date fechacreacion;
    private Integer idexpediente;
    private Integer codigoexpediente;
    private boolean estado;

    /*datos para la bandeja de recepcion*/
    // private Integer idareadestino;

    /*para generar la bande ja de recepcion*/
    private Integer idrecepcioninterna;
    private String area_proviene, remitente, codigo_documento, fecha_envio, usuario;
    /*Consulta de año*/
    private Integer anio, idremitente, idarea;
    private String fecha_inicio, fecha_fin, fechaderivacion;

    private Integer idusuariorecepciona, idareaproviene;

    private String tipodocumento;
    private int[] listaidsdocumento;

    private Integer idmensaje;

    private ArrayList<ArchivodocumentoBE> lista_archivos = new ArrayList<>();

    public DocumentoBE() {
        this.IndOpSp = 0;
        this.iddocumento = 0;
        this.idtipodocumento = 0;
        this.asunto = "";
        this.mensaje = "";
        this.prioridad = 0;
        this.bindrespuesta = false;
        this.diasrespuesta = 0;
        this.bindllegadausuario = false;
        this.idareacioncreacion = 0;
        this.idusuariocreacion = 0;
        this.fechacreacion = new Date();
        this.idexpediente = 0;
        this.codigoexpediente = 0;
        this.estado = false;

    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public Integer getIddocumento() {
        return iddocumento;

    }

    public String getAsunto() {
        return asunto;

    }

    public String getMensaje() {
        return mensaje;

    }

    public Integer getPrioridad() {
        return prioridad;

    }

    public boolean isBindrespuesta() {
        return bindrespuesta;

    }

    public Integer getDiasrespuesta() {
        return diasrespuesta;

    }

    public boolean isBindllegadausuario() {
        return bindllegadausuario;

    }

    public Integer getIdareacioncreacion() {
        return idareacioncreacion;

    }

    public Integer getIdusuariocreacion() {
        return idusuariocreacion;

    }

    public Date getFechacreacion() {
        return fechacreacion;

    }

    public Integer getIdexpediente() {
        return idexpediente;

    }

    public Integer getCodigoexpediente() {
        return codigoexpediente;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIddocumento(Integer iddocumento) {

        this.iddocumento = iddocumento;
    }

    public void setAsunto(String asunto) {

        this.asunto = asunto;
    }

    public void setMensaje(String mensaje) {

        this.mensaje = mensaje;
    }

    public void setPrioridad(Integer prioridad) {

        this.prioridad = prioridad;
    }

    public void setBindrespuesta(boolean bindrespuesta) {

        this.bindrespuesta = bindrespuesta;
    }

    public void setDiasrespuesta(Integer diasrespuesta) {

        this.diasrespuesta = diasrespuesta;
    }

    public void setBindllegadausuario(boolean bindllegadausuario) {

        this.bindllegadausuario = bindllegadausuario;
    }

    public void setIdareacioncreacion(Integer idareacioncreacion) {

        this.idareacioncreacion = idareacioncreacion;
    }

    public void setIdusuariocreacion(Integer idusuariocreacion) {

        this.idusuariocreacion = idusuariocreacion;
    }

    public void setFechacreacion(Date fechacreacion) {

        this.fechacreacion = fechacreacion;
    }

    public void setIdexpediente(Integer idexpediente) {

        this.idexpediente = idexpediente;
    }

    public void setCodigoexpediente(Integer codigoexpediente) {

        this.codigoexpediente = codigoexpediente;
    }

    public void setEstado(boolean estado) {

        this.estado = estado;
    }

    public String getEdit() {
        return edit;
    }

    public void setEdit(String edit) {
        this.edit = edit;
    }

    public String getDel() {
        return del;
    }

    public void setDel(String del) {
        this.del = del;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public Integer getIdareadestino() {
        return idareadestino;
    }

    public void setIdareadestino(Integer idareadestino) {
        this.idareadestino = idareadestino;
    }

    public String getArea_proviene() {
        return area_proviene;
    }

    public void setArea_proviene(String area_proviene) {
        this.area_proviene = area_proviene;
    }

    public String getRemitente() {
        return remitente;
    }

    public void setRemitente(String remitente) {
        this.remitente = remitente;
    }

    public String getCodigo_documento() {
        return codigo_documento;
    }

    public void setCodigo_documento(String codigo_documento) {
        this.codigo_documento = codigo_documento;
    }

    public String getFecha_envio() {
        return fecha_envio;
    }

    public void setFecha_envio(String fecha_envio) {
        this.fecha_envio = fecha_envio;
    }

    public Integer getIdrecepcioninterna() {
        return idrecepcioninterna;
    }

    public void setIdrecepcioninterna(Integer idrecepcioninterna) {
        this.idrecepcioninterna = idrecepcioninterna;
    }

    public Integer getAnio() {
        return anio;
    }

    public void setAnio(Integer anio) {
        this.anio = anio;
    }

    public String getFecha_inicio() {
        return fecha_inicio;
    }

    public void setFecha_inicio(String fecha_inicio) {
        this.fecha_inicio = fecha_inicio;
    }

    public String getFecha_fin() {
        return fecha_fin;
    }

    public void setFecha_fin(String fecha_fin) {
        this.fecha_fin = fecha_fin;
    }

    public Integer getIdremitente() {
        return idremitente;
    }

    public void setIdremitente(Integer idremitente) {
        this.idremitente = idremitente;
    }

    public Integer getIdarea() {
        return idarea;
    }

    public void setIdarea(Integer idarea) {
        this.idarea = idarea;
    }

    public Integer getIdusuariorecepciona() {
        return idusuariorecepciona;
    }

    public void setIdusuariorecepciona(Integer idusuariorecepciona) {
        this.idusuariorecepciona = idusuariorecepciona;
    }

    public Integer getIdareaproviene() {
        return idareaproviene;
    }

    public void setIdareaproviene(Integer idareaproviene) {
        this.idareaproviene = idareaproviene;
    }

    public Integer getIdtipodocumento() {
        return idtipodocumento;
    }

    public void setIdtipodocumento(Integer idtipodocumento) {
        this.idtipodocumento = idtipodocumento;
    }

    public String getTipodocumento() {
        return tipodocumento;
    }

    public void setTipodocumento(String tipodocumento) {
        this.tipodocumento = tipodocumento;
    }

    public int[] getListaidsdocumento() {
        return listaidsdocumento;
    }

    public void setListaidsdocumento(int[] listaidsdocumento) {
        this.listaidsdocumento = listaidsdocumento;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public Integer getIdmensaje() {
        return idmensaje;
    }

    public void setIdmensaje(Integer idmensaje) {
        this.idmensaje = idmensaje;
    }

    public String getFechaderivacion() {
        return fechaderivacion;
    }

    public void setFechaderivacion(String fechaderivacion) {
        this.fechaderivacion = fechaderivacion;
    }

    public ArrayList<ArchivodocumentoBE> getLista_archivos() {
        return lista_archivos;
    }

    public void setLista_archivos(ArrayList<ArchivodocumentoBE> lista_archivos) {
        this.lista_archivos = lista_archivos;
    }

}
