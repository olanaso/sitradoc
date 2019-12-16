package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class ExpedienteBE extends BaseBE {

    private int IndOpSp;
    private String edit;
    private String del;
    private String derivar;
    private String sfecharegistro;
    private String sfecharecepciona;

    private int idexpediente;
    private int idusuariocargo;
    private int idprocedimiento;
    private int idarea;
    private int idarea_proviene;
    private int folios;
    private String nombredocumento;
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
    //ATRIBUTOS AGREGADOS
    private String areadenominacion;
    private String codprocedimiento;
    private String denoprocedimiento;

    private String area;
    private String procedimiento;
   

    private int idrecepcion;

    private String observacion;

    public int getIdarea_proviene() {
        return idarea_proviene;
    }

    public void setIdarea_proviene(int idarea_proviene) {
        this.idarea_proviene = idarea_proviene;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public int getIdrecepcion() {
        return idrecepcion;
    }

    public void setIdrecepcion(int idrecepcion) {
        this.idrecepcion = idrecepcion;
    }

    public String getSfecharegistro() {
        return sfecharegistro;
    }

    public void setSfecharegistro(String sfecharegistro) {
        this.sfecharegistro = sfecharegistro;
    }

    public String getDerivar() {
        return derivar;
    }

    public void setDerivar(String derivar) {
        this.derivar = derivar;
    }

    public ExpedienteBE() {
        this.IndOpSp = 0;
        this.idexpediente = 0;
        this.idusuariocargo = 0;
        this.idprocedimiento = 0;
        this.idarea = 0;
        this.codigo = 0;
        this.dni_ruc = "";
        this.nombre_razonsocial = "";
        this.apellidos = "";
        this.direccion = "";
        this.telefono = "";
        this.correo = "";
        this.asunto = "";
        this.estado = false;
        this.bindentregado = false;
        this.areadenominacion = "";
        this.codprocedimiento = "";
        this.denoprocedimiento = "";
        this.area = "";
        this.procedimiento = "";
        this.fecharegistro = new Date();
        this.fecharecepciona = new Date();
        this.idusuariorecepciona = 0;
    }

    public ExpedienteBE(int pIndOpSp, int pidexpediente, int pidusuariocargo, int pidprocedimiento, int pidarea, Integer pcodigo, String pdni_ruc, String pnombre_razonsocial, String papellidos, String pdireccion, String ptelefono, String pcorreo, String pasunto, boolean pestado, boolean pbindentregado, String pareadenominacion, String pcodprocedimiento, String pdenoprocedimiento, String parea, String pprocedimiento, Date pfecharegistro, Date pfecharecepciona, int pidusuariorecepciona) {
        this.IndOpSp = pIndOpSp;
        this.idexpediente = pidexpediente;
        this.idusuariocargo = pidusuariocargo;
        this.idprocedimiento = pidprocedimiento;
        this.idarea = pidarea;
        this.codigo = pcodigo;
        this.dni_ruc = pdni_ruc;
        this.nombre_razonsocial = pnombre_razonsocial;
        this.apellidos = papellidos;
        this.direccion = pdireccion;
        this.telefono = ptelefono;
        this.correo = pcorreo;
        this.asunto = pasunto;
        this.estado = pestado;
        this.bindentregado = pbindentregado;
        this.areadenominacion = pareadenominacion;
        this.codprocedimiento = pcodprocedimiento;
        this.denoprocedimiento = pdenoprocedimiento;
        this.area = parea;
        this.procedimiento = pprocedimiento;
        this.fecharegistro = pfecharegistro;
        this.fecharecepciona = pfecharecepciona;
        this.idusuariorecepciona = pidusuariorecepciona;
    }

    public String getObservado() {
        return observado;
    }

    public void setObservado(String observado) {
        this.observado = observado;
    }

    public boolean isBindobservado() {
        return bindobservado;
    }

    public void setBindobservado(boolean bindobservado) {
        this.bindobservado = bindobservado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdexpediente() {
        return idexpediente;

    }

    public int getIdusuariocargo() {
        return idusuariocargo;

    }

    public int getIdprocedimiento() {
        return idprocedimiento;

    }

    public int getIdarea() {
        return idarea;

    }

    public Integer getCodigo() {
        return codigo;

    }

    public String getDni_ruc() {
        return dni_ruc;

    }

    public String getNombre_razonsocial() {
        return nombre_razonsocial;

    }

    public String getApellidos() {
        return apellidos;

    }

    public String getDireccion() {
        return direccion;

    }

    public String getTelefono() {
        return telefono;

    }

    public String getCorreo() {
        return correo;

    }

    public String getAsunto() {
        return asunto;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdexpediente(int idexpediente) {

        this.idexpediente = idexpediente;
    }

    public void setIdusuariocargo(int idusuariocargo) {

        this.idusuariocargo = idusuariocargo;
    }

    public void setIdprocedimiento(int idprocedimiento) {

        this.idprocedimiento = idprocedimiento;
    }

    public void setIdarea(int idarea) {

        this.idarea = idarea;
    }

    public void setCodigo(Integer codigo) {

        this.codigo = codigo;
    }

    public void setDni_ruc(String dni_ruc) {

        this.dni_ruc = dni_ruc;
    }

    public void setNombre_razonsocial(String nombre_razonsocial) {

        this.nombre_razonsocial = nombre_razonsocial;
    }

    public void setApellidos(String apellidos) {

        this.apellidos = apellidos;
    }

    public void setDireccion(String direccion) {

        this.direccion = direccion;
    }

    public void setTelefono(String telefono) {

        this.telefono = telefono;
    }

    public void setCorreo(String correo) {

        this.correo = correo;
    }

    public void setAsunto(String asunto) {

        this.asunto = asunto;
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

    /**
     * @return the bindentregado
     */
    public boolean isBindentregado() {
        return bindentregado;
    }

    /**
     * @param bindentregado the bindentregado to set
     */
    public void setBindentregado(boolean bindentregado) {
        this.bindentregado = bindentregado;
    }

    /**
     * @return the areadenominacion
     */
    public String getAreadenominacion() {
        return areadenominacion;
    }

    /**
     * @param areadenominacion the areadenominacion to set
     */
    public void setAreadenominacion(String areadenominacion) {
        this.areadenominacion = areadenominacion;
    }

    /**
     * @return the codprocedimiento
     */
    public String getCodprocedimiento() {
        return codprocedimiento;
    }

    /**
     * @param codprocedimiento the codprocedimiento to set
     */
    public void setCodprocedimiento(String codprocedimiento) {
        this.codprocedimiento = codprocedimiento;
    }

    /**
     * @return the denoprocedimiento
     */
    public String getDenoprocedimiento() {
        return denoprocedimiento;
    }

    /**
     * @param denoprocedimiento the denoprocedimiento to set
     */
    public void setDenoprocedimiento(String denoprocedimiento) {
        this.denoprocedimiento = denoprocedimiento;
    }

    /**
     * @return the area
     */
    public String getArea() {
        return area;
    }

    /**
     * @param area the area to set
     */
    public void setArea(String area) {
        this.area = area;
    }

    /**
     * @return the procedimiento
     */
    public String getProcedimiento() {
        return procedimiento;
    }

    /**
     * @param procedimiento the procedimiento to set
     */
    public void setProcedimiento(String procedimiento) {
        this.procedimiento = procedimiento;
    }

    /**
     * @return the fecharegistro
     */
    public Date getFecharegistro() {
        return fecharegistro;
    }

    /**
     * @param fecharegistro the fecharegistro to set
     */
    public void setFecharegistro(Date fecharegistro) {
        this.fecharegistro = fecharegistro;
    }

    /**
     * @return the fecharecepciona
     */
    public Date getFecharecepciona() {
        return fecharecepciona;
    }

    /**
     * @param fecharecepciona the fecharecepciona to set
     */
    public void setFecharecepciona(Date fecharecepciona) {
        this.fecharecepciona = fecharecepciona;
    }

    /**
     * @return the idusuariorecepciona
     */
    public int getIdusuariorecepciona() {
        return idusuariorecepciona;
    }

    /**
     * @param idusuariorecepciona the idusuariorecepciona to set
     */
    public void setIdusuariorecepciona(int idusuariorecepciona) {
        this.idusuariorecepciona = idusuariorecepciona;
    }

    public int getFolios() {
        return folios;
    }

    public void setFolios(int folios) {
        this.folios = folios;
    }

    public String getNombredocumento() {
        return nombredocumento;
    }

    public void setNombredocumento(String nombredocumento) {
        this.nombredocumento = nombredocumento;
    }

    public String getSfecharecepciona() {
        return sfecharecepciona;
    }

    public void setSfecharecepciona(String sfecharecepciona) {
        this.sfecharecepciona = sfecharecepciona;
    }
}
