package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class UsuariorolBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idusuariorol;
    private int idusuario;
    private int idrol;
    private Date fechaasignacion;
    private boolean estado;

    //VARIABLES AGREGADOS
    private String denominacionrol;
    private String nombres;
    private String apellidos;
    private String telefono;

    public UsuariorolBE() {
        this.IndOpSp = 0;
        this.idusuariorol = 0;
        this.idusuario = 0;
        this.idrol = 0;
        this.fechaasignacion = new Date();
        this.estado = false;
        this.denominacionrol = "";
        this.nombres = "";
        this.apellidos = "";
        this.telefono = "";

    }

    public UsuariorolBE(int pIndOpSp, int pidusuariorol, int pidusuario, int pidrol, Date pfechaasignacion, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idusuariorol = pidusuariorol;
        this.idusuario = pidusuario;
        this.idrol = pidrol;
        this.fechaasignacion = pfechaasignacion;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdusuariorol() {
        return idusuariorol;

    }

    public int getIdusuario() {
        return idusuario;

    }

    public int getIdrol() {
        return idrol;

    }

    public Date getFechaasignacion() {
        return fechaasignacion;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdusuariorol(int idusuariorol) {

        this.idusuariorol = idusuariorol;
    }

    public void setIdusuario(int idusuario) {

        this.idusuario = idusuario;
    }

    public void setIdrol(int idrol) {

        this.idrol = idrol;
    }

    public void setFechaasignacion(Date fechaasignacion) {

        this.fechaasignacion = fechaasignacion;
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
     * @return the denominacionrol
     */
    public String getDenominacionrol() {
        return denominacionrol;
    }

    /**
     * @param denominacionrol the denominacionrol to set
     */
    public void setDenominacionrol(String denominacionrol) {
        this.denominacionrol = denominacionrol;
    }

    /**
     * @return the nombres
     */
    public String getNombres() {
        return nombres;
    }

    /**
     * @param nombres the nombres to set
     */
    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    /**
     * @return the apellidos
     */
    public String getApellidos() {
        return apellidos;
    }

    /**
     * @param apellidos the apellidos to set
     */
    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    /**
     * @return the telefono
     */
    public String getTelefono() {
        return telefono;
    }

    /**
     * @param telefono the telefono to set
     */
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }
}
