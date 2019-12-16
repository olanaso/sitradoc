package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class RolmoduloBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idrolmodulo;
    private int idrol;
    private int idmodulo;
    private Date fechaasignacion;
    private boolean estado;

    //VARIABLES AGREGADOS
    private String denominacionrol;
    private String denominacionmodulo;
    private String paginainiciomodulo;

    public RolmoduloBE() {
        this.IndOpSp = 0;
        this.idrolmodulo = 0;
        this.idrol = 0;
        this.idmodulo = 0;
        this.fechaasignacion = new Date();
        this.estado = false;
        this.denominacionrol = "";
        this.denominacionmodulo = "";
        this.paginainiciomodulo = "";

    }

    public RolmoduloBE(int pIndOpSp, int pidrolmodulo, int pidrol, int pidmodulo, Date pfechaasignacion, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idrolmodulo = pidrolmodulo;
        this.idrol = pidrol;
        this.idmodulo = pidmodulo;
        this.fechaasignacion = pfechaasignacion;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdrolmodulo() {
        return idrolmodulo;

    }

    public int getIdrol() {
        return idrol;

    }

    public int getIdmodulo() {
        return idmodulo;

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

    public void setIdrolmodulo(int idrolmodulo) {

        this.idrolmodulo = idrolmodulo;
    }

    public void setIdrol(int idrol) {

        this.idrol = idrol;
    }

    public void setIdmodulo(int idmodulo) {

        this.idmodulo = idmodulo;
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
     * @return the denominacionmodulo
     */
    public String getDenominacionmodulo() {
        return denominacionmodulo;
    }

    /**
     * @param denominacionmodulo the denominacionmodulo to set
     */
    public void setDenominacionmodulo(String denominacionmodulo) {
        this.denominacionmodulo = denominacionmodulo;
    }

    /**
     * @return the paginainiciomodulo
     */
    public String getPaginainiciomodulo() {
        return paginainiciomodulo;
    }

    /**
     * @param paginainiciomodulo the paginainiciomodulo to set
     */
    public void setPaginainiciomodulo(String paginainiciomodulo) {
        this.paginainiciomodulo = paginainiciomodulo;
    }

}
