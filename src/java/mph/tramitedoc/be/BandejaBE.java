package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class BandejaBE extends BaseBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private Integer idbandeja;
    private Integer iddocumento;
    private Integer idmensaje;
    private Integer idareaproviene;
    private Integer idareadestino;
    private Integer idusuarioenvia;
    private Integer idusuariodestino;
    private boolean bindrecepcion;
    private Integer idusuariorecepciona;
    private Date fecharecepciona;
    private Date fechalectura;
    private Date fechaderivacion;
    private Date fecharegistro;
    private boolean estado;
    private boolean bindatendido;
    private boolean bindfinalizado;

    private String usuarioenvia, asunto, mensaje, fechaenvio, adjunto, recepcion;

    private String b_idsarea, b_idsusuarioenvia, b_asunto, b_mensaje, b_indsrecepcion, b_indsrespuesta, b_indsprioridad, b_vencidosactivos, b_fechainicio, b_fechafin, limite, offsete;
    private String documento, fecha_manual;

    public BandejaBE() {
        this.b_idsarea = "";
        this.b_idsusuarioenvia = "";
        this.b_asunto = "";
        this.b_mensaje = "";
        this.b_indsrecepcion = "";
        this.b_indsrespuesta = "";
        this.b_indsprioridad = "";
        this.b_vencidosactivos = "";
        this.b_fechainicio = "";
        this.b_fechafin = "";
        this.limite = "";
        this.offsete = "";
    }

    public String getRecepcion() {
        return recepcion;
    }

    public void setRecepcion(String recepcion) {
        this.recepcion = recepcion;
    }

    public String getUsuarioenvia() {
        return usuarioenvia;
    }

    public void setUsuarioenvia(String usuarioenvia) {
        this.usuarioenvia = usuarioenvia;
    }

    public String getAsunto() {
        return asunto;
    }

    public void setAsunto(String asunto) {
        this.asunto = asunto;
    }

    public String getMensaje() {
        return mensaje;
    }

    public void setMensaje(String mensaje) {
        this.mensaje = mensaje;
    }

    public String getFechaenvio() {
        return fechaenvio;
    }

    public void setFechaenvio(String fechaenvio) {
        this.fechaenvio = fechaenvio;
    }

    public String getAdjunto() {
        return adjunto;
    }

    public void setAdjunto(String adjunto) {
        this.adjunto = adjunto;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public Integer getIdbandeja() {
        return idbandeja;

    }

    public Integer getIddocumento() {
        return iddocumento;

    }

    public Integer getIdareaproviene() {
        return idareaproviene;

    }

    public Integer getIdareadestino() {
        return idareadestino;

    }

    public Integer getIdusuarioenvia() {
        return idusuarioenvia;

    }

    public Integer getIdusuariodestino() {
        return idusuariodestino;

    }

    public boolean isBindrecepcion() {
        return bindrecepcion;

    }

    public Integer getIdusuariorecepciona() {
        return idusuariorecepciona;

    }

    public Date getFecharecepciona() {
        return fecharecepciona;

    }

    public Date getFechalectura() {
        return fechalectura;

    }

    public Date getFechaderivacion() {
        return fechaderivacion;

    }

    public Date getFecharegistro() {
        return fecharegistro;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdbandeja(Integer idbandeja) {

        this.idbandeja = idbandeja;
    }

    public void setIddocumento(Integer iddocumento) {

        this.iddocumento = iddocumento;
    }

    public void setIdareaproviene(Integer idareaproviene) {

        this.idareaproviene = idareaproviene;
    }

    public void setIdareadestino(Integer idareadestino) {

        this.idareadestino = idareadestino;
    }

    public void setIdusuarioenvia(Integer idusuarioenvia) {

        this.idusuarioenvia = idusuarioenvia;
    }

    public void setIdusuariodestino(Integer idusuariodestino) {

        this.idusuariodestino = idusuariodestino;
    }

    public void setBindrecepcion(boolean bindrecepcion) {

        this.bindrecepcion = bindrecepcion;
    }

    public void setIdusuariorecepciona(Integer idusuariorecepciona) {

        this.idusuariorecepciona = idusuariorecepciona;
    }

    public void setFecharecepciona(Date fecharecepciona) {

        this.fecharecepciona = fecharecepciona;
    }

    public void setFechalectura(Date fechalectura) {

        this.fechalectura = fechalectura;
    }

    public void setFechaderivacion(Date fechaderivacion) {

        this.fechaderivacion = fechaderivacion;
    }

    public void setFecharegistro(Date fecharegistro) {

        this.fecharegistro = fecharegistro;
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

    public Integer getIdmensaje() {
        return idmensaje;
    }

    public void setIdmensaje(Integer idmensaje) {
        this.idmensaje = idmensaje;
    }
    /*atributos para la busqueda avanzada*/

    public String getB_idsarea() {
        return b_idsarea;
    }

    public void setB_idsarea(String b_idsarea) {
        this.b_idsarea = b_idsarea;
    }

    public String getB_idsusuarioenvia() {
        return b_idsusuarioenvia;
    }

    public void setB_idsusuarioenvia(String b_idsusuarioenvia) {
        this.b_idsusuarioenvia = b_idsusuarioenvia;
    }

    public String getB_asunto() {
        return b_asunto;
    }

    public void setB_asunto(String b_asunto) {
        this.b_asunto = b_asunto;
    }

    public String getB_mensaje() {
        return b_mensaje;
    }

    public void setB_mensaje(String b_mensaje) {
        this.b_mensaje = b_mensaje;
    }

    public String getB_indsrecepcion() {
        return b_indsrecepcion;
    }

    public void setB_indsrecepcion(String b_indsrecepcion) {
        this.b_indsrecepcion = b_indsrecepcion;
    }

    public String getB_indsrespuesta() {
        return b_indsrespuesta;
    }

    public void setB_indsrespuesta(String b_indsrespuesta) {
        this.b_indsrespuesta = b_indsrespuesta;
    }

    public String getB_indsprioridad() {
        return b_indsprioridad;
    }

    public void setB_indsprioridad(String b_indsprioridad) {
        this.b_indsprioridad = b_indsprioridad;
    }

    public String getB_vencidosactivos() {
        return b_vencidosactivos;
    }

    public void setB_vencidosactivos(String b_vencidosactivos) {
        this.b_vencidosactivos = b_vencidosactivos;
    }

    public String getB_fechainicio() {
        return b_fechainicio;
    }

    public void setB_fechainicio(String b_fechainicio) {
        this.b_fechainicio = b_fechainicio;
    }

    public String getB_fechafin() {
        return b_fechafin;
    }

    public void setB_fechafin(String b_fechafin) {
        this.b_fechafin = b_fechafin;
    }

    public String getLimite() {
        return limite;
    }

    public void setLimite(String limite) {
        this.limite = limite;
    }

    public String getOffsete() {
        return offsete;
    }

    public void setOffsete(String offsete) {
        this.offsete = offsete;
    }

    public boolean isBindatendido() {
        return bindatendido;
    }

    public void setBindatendido(boolean bindatendido) {
        this.bindatendido = bindatendido;
    }

    public boolean isBindfinalizado() {
        return bindfinalizado;
    }

    public void setBindfinalizado(boolean bindfinalizado) {
        this.bindfinalizado = bindfinalizado;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getFecha_manual() {
        return fecha_manual;
    }

    public void setFecha_manual(String fecha_manual) {
        this.fecha_manual = fecha_manual;
    }
    

}
