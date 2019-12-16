package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class FlujoBE extends BaseBE {

    private int IndOpSp;
    private String edit;
    private String del;
    private String responder;
    private String visualizar;

    private int idflujo;
    private int idflujoparent;
    private int idexpediente;
    private int idestadoflujo;
    private int idusuario;
    private int idenvio;
    private int idusuarioenvia;
    private int idusuariorecepciona;
    private Date fechaenvio;
    private Date fechalectura;
    private String asunto;
    private String descripcion;
    private String observacion;
    private String nombres;
    private String remitente;
    private String sfechaenvio;
    private String sfecharegistro;
    private boolean binderror;
    private boolean bindleido;
    private boolean bindparent;
    private boolean bindatendido;
    private boolean estado;
    private String derivar;
    private String resolver;
    private String diasrestantes;
    private String fechaingreso;
    private String fecharecepcion;
    private String isleido;
    private int idrespuesta;
    private String titulorespuesta;
    private String cuerporespuesta;
    private int idarea;
    private String gentraminterno;

    /*Agregados*/
    private int anio;
    private Integer codigo;
    private String nombre_razonsocial;
    private int idtipodocumento;
    private int idcargo;
    private boolean firma;
    
     private String semaforo;

    public String getGentraminterno() {
        return gentraminterno;
    }

    public void setGentraminterno(String gentraminterno) {
        this.gentraminterno = gentraminterno;
    }

    public String getVisualizar() {
        return visualizar;
    }

    public void setVisualizar(String visualizar) {
        this.visualizar = visualizar;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
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

    public String getResponder() {
        return responder;
    }

    public void setResponder(String responder) {
        this.responder = responder;
    }

    public int getIdflujo() {
        return idflujo;
    }

    public void setIdflujo(int idflujo) {
        this.idflujo = idflujo;
    }

    public int getIdflujoparent() {
        return idflujoparent;
    }

    public void setIdflujoparent(int idflujoparent) {
        this.idflujoparent = idflujoparent;
    }

    public int getIdexpediente() {
        return idexpediente;
    }

    public void setIdexpediente(int idexpediente) {
        this.idexpediente = idexpediente;
    }

    public int getIdestadoflujo() {
        return idestadoflujo;
    }

    public void setIdestadoflujo(int idestadoflujo) {
        this.idestadoflujo = idestadoflujo;
    }

    public int getIdusuario() {
        return idusuario;
    }

    public void setIdusuario(int idusuario) {
        this.idusuario = idusuario;
    }

    public int getIdenvio() {
        return idenvio;
    }

    public void setIdenvio(int idenvio) {
        this.idenvio = idenvio;
    }

    public int getIdusuarioenvia() {
        return idusuarioenvia;
    }

    public void setIdusuarioenvia(int idusuarioenvia) {
        this.idusuarioenvia = idusuarioenvia;
    }

    public int getIdusuariorecepciona() {
        return idusuariorecepciona;
    }

    public void setIdusuariorecepciona(int idusuariorecepciona) {
        this.idusuariorecepciona = idusuariorecepciona;
    }

    public Date getFechaenvio() {
        return fechaenvio;
    }

    public void setFechaenvio(Date fechaenvio) {
        this.fechaenvio = fechaenvio;
    }

    public Date getFechalectura() {
        return fechalectura;
    }

    public void setFechalectura(Date fechalectura) {
        this.fechalectura = fechalectura;
    }

    public String getAsunto() {
        return asunto;
    }

    public void setAsunto(String asunto) {
        this.asunto = asunto;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getRemitente() {
        return remitente;
    }

    public void setRemitente(String remitente) {
        this.remitente = remitente;
    }

    public String getSfechaenvio() {
        return sfechaenvio;
    }

    public void setSfechaenvio(String sfechaenvio) {
        this.sfechaenvio = sfechaenvio;
    }

    public boolean isBinderror() {
        return binderror;
    }

    public void setBinderror(boolean binderror) {
        this.binderror = binderror;
    }

    public boolean isBindleido() {
        return bindleido;
    }

    public void setBindleido(boolean bindleido) {
        this.bindleido = bindleido;
    }

    public boolean isBindparent() {
        return bindparent;
    }

    public void setBindparent(boolean bindparent) {
        this.bindparent = bindparent;
    }

    public boolean isBindatendido() {
        return bindatendido;
    }

    public void setBindatendido(boolean bindatendido) {
        this.bindatendido = bindatendido;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public String getDerivar() {
        return derivar;
    }

    public void setDerivar(String derivar) {
        this.derivar = derivar;
    }

    public String getResolver() {
        return resolver;
    }

    public void setResolver(String resolver) {
        this.resolver = resolver;
    }

    public String getDiasrestantes() {
        return diasrestantes;
    }

    public void setDiasrestantes(String diasrestantes) {
        this.diasrestantes = diasrestantes;
    }

    public String getFechaingreso() {
        return fechaingreso;
    }

    public void setFechaingreso(String fechaingreso) {
        this.fechaingreso = fechaingreso;
    }

    public String getFecharecepcion() {
        return fecharecepcion;
    }

    public void setFecharecepcion(String fecharecepcion) {
        this.fecharecepcion = fecharecepcion;
    }

    public String getIsleido() {
        return isleido;
    }

    public void setIsleido(String isleido) {
        this.isleido = isleido;
    }

    public int getIdrespuesta() {
        return idrespuesta;
    }

    public void setIdrespuesta(int idrespuesta) {
        this.idrespuesta = idrespuesta;
    }

    public String getTitulorespuesta() {
        return titulorespuesta;
    }

    public void setTitulorespuesta(String titulorespuesta) {
        this.titulorespuesta = titulorespuesta;
    }

    public String getCuerporespuesta() {
        return cuerporespuesta;
    }

    public void setCuerporespuesta(String cuerporespuesta) {
        this.cuerporespuesta = cuerporespuesta;
    }

    public int getIdarea() {
        return idarea;
    }

    public void setIdarea(int idarea) {
        this.idarea = idarea;
    }

    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public String getNombre_razonsocial() {
        return nombre_razonsocial;
    }

    public void setNombre_razonsocial(String Nombre_razonsocial) {
        this.nombre_razonsocial = Nombre_razonsocial;
    }

    public int getIdtipodocumento() {
        return idtipodocumento;
    }

    public void setIdtipodocumento(int idtipodocumento) {
        this.idtipodocumento = idtipodocumento;
    }

    public int getIdcargo() {
        return idcargo;
    }

    public void setIdcargo(int idcargo) {
        this.idcargo = idcargo;
    }

    public boolean isFirma() {
        return firma;
    }

    public void setFirma(boolean firma) {
        this.firma = firma;
    }

    public String getSfecharegistro() {
        return sfecharegistro;
    }

    public void setSfecharegistro(String sfecharegistro) {
        this.sfecharegistro = sfecharegistro;
    }

    public String getSemaforo() {
        return semaforo;
    }

    public void setSemaforo(String semaforo) {
        this.semaforo = semaforo;
    }
    
    
    
    

}
