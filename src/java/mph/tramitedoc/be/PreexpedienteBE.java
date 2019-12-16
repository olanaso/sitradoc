package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class PreexpedienteBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idpreexpediente;
    private int idusuariocargo;
    private int idprocedimiento;
    private int idarea;
    private Integer codigo;
    private String dni_ruc;
    private String nombre_razonsocial;
    private String apellidos;
    private String direccion;
    private String telefono;
    private String correo;
    private String asunto;
    private Date fecharegistro;
    private Date fecharecepciona;
    private int idusuariorecepciona;
    private boolean estado;
    private boolean bindentregado;
    private boolean bindobservado;
    private String observado;

    private String ipenvio,
            lat,
            lon,
            urlcomprobante,
            codigocomprobante;
    private boolean bindaprobado;

    //ATRIBUTOS AGREGADOS
    private String areadenominacion;
    private String codprocedimiento;
    private String denoprocedimiento;
    private String area;
    private String procedimiento;

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

    public int getIdpreexpediente() {
        return idpreexpediente;
    }

    public void setIdpreexpediente(int idpreexpediente) {
        this.idpreexpediente = idpreexpediente;
    }

    public int getIdusuariocargo() {
        return idusuariocargo;
    }

    public void setIdusuariocargo(int idusuariocargo) {
        this.idusuariocargo = idusuariocargo;
    }

    public int getIdprocedimiento() {
        return idprocedimiento;
    }

    public void setIdprocedimiento(int idprocedimiento) {
        this.idprocedimiento = idprocedimiento;
    }

    public int getIdarea() {
        return idarea;
    }

    public void setIdarea(int idarea) {
        this.idarea = idarea;
    }

    public Integer getCodigo() {
        return codigo;
    }

    public void setCodigo(Integer codigo) {
        this.codigo = codigo;
    }

    public String getDni_ruc() {
        return dni_ruc;
    }

    public void setDni_ruc(String dni_ruc) {
        this.dni_ruc = dni_ruc;
    }

    public String getNombre_razonsocial() {
        return nombre_razonsocial;
    }

    public void setNombre_razonsocial(String nombre_razonsocial) {
        this.nombre_razonsocial = nombre_razonsocial;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getAsunto() {
        return asunto;
    }

    public void setAsunto(String asunto) {
        this.asunto = asunto;
    }

    public Date getFecharegistro() {
        return fecharegistro;
    }

    public void setFecharegistro(Date fecharegistro) {
        this.fecharegistro = fecharegistro;
    }

    public Date getFecharecepciona() {
        return fecharecepciona;
    }

    public void setFecharecepciona(Date fecharecepciona) {
        this.fecharecepciona = fecharecepciona;
    }

    public int getIdusuariorecepciona() {
        return idusuariorecepciona;
    }

    public void setIdusuariorecepciona(int idusuariorecepciona) {
        this.idusuariorecepciona = idusuariorecepciona;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public boolean isBindentregado() {
        return bindentregado;
    }

    public void setBindentregado(boolean bindentregado) {
        this.bindentregado = bindentregado;
    }

    public boolean isBindobservado() {
        return bindobservado;
    }

    public void setBindobservado(boolean bindobservado) {
        this.bindobservado = bindobservado;
    }

    public String getObservado() {
        return observado;
    }

    public void setObservado(String observado) {
        this.observado = observado;
    }

    public String getIpenvio() {
        return ipenvio;
    }

    public void setIpenvio(String ipenvio) {
        this.ipenvio = ipenvio;
    }

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getLon() {
        return lon;
    }

    public void setLon(String lon) {
        this.lon = lon;
    }

    public String getUrlcomprobante() {
        return urlcomprobante;
    }

    public void setUrlcomprobante(String urlcomprobante) {
        this.urlcomprobante = urlcomprobante;
    }

    public String getCodigocomprobante() {
        return codigocomprobante;
    }

    public void setCodigocomprobante(String codigocomprobante) {
        this.codigocomprobante = codigocomprobante;
    }

    public boolean isBindaprobado() {
        return bindaprobado;
    }

    public void setBindaprobado(boolean bindaprobado) {
        this.bindaprobado = bindaprobado;
    }

    public String getAreadenominacion() {
        return areadenominacion;
    }

    public void setAreadenominacion(String areadenominacion) {
        this.areadenominacion = areadenominacion;
    }

    public String getCodprocedimiento() {
        return codprocedimiento;
    }

    public void setCodprocedimiento(String codprocedimiento) {
        this.codprocedimiento = codprocedimiento;
    }

    public String getDenoprocedimiento() {
        return denoprocedimiento;
    }

    public void setDenoprocedimiento(String denoprocedimiento) {
        this.denoprocedimiento = denoprocedimiento;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getProcedimiento() {
        return procedimiento;
    }

    public void setProcedimiento(String procedimiento) {
        this.procedimiento = procedimiento;
    }

}
