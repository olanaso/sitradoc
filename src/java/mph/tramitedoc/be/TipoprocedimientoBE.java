package mph.tramitedoc.be;

public class TipoprocedimientoBE {
    
    private int IndOpSp;
    private String edit;
    private String del;
    
    private Integer idtipoprocedimiento;
    private String denominacion;
    private String descripcion;
    private int orden;
    private boolean bindactual;
    private boolean estado;
    
    public TipoprocedimientoBE(){
        this.IndOpSp = 0;
        this.idtipoprocedimiento = 0;
        this.denominacion = "";
        this.descripcion = "";
        this.orden = 0;
        this.estado = false;
        this.bindactual = false;
    }
    
    public TipoprocedimientoBE(int pIndOpSp, Integer pidtipoprocedimiento, String pdenominacion, String pdescripcion, int porden, boolean pbindactual, boolean pestado){
        this.IndOpSp = pIndOpSp;
        this.idtipoprocedimiento = pidtipoprocedimiento;
        this.denominacion = pdenominacion;
        this.descripcion = pdescripcion;
        this.orden = porden;
        this.estado = pestado;
        this.bindactual = pbindactual;
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

    public Integer getIdtipoprocedimiento() {
        return idtipoprocedimiento;
    }

    public void setIdtipoprocedimiento(Integer idtipoprocedimiento) {
        this.idtipoprocedimiento = idtipoprocedimiento;
    }

    public String getDenominacion() {
        return denominacion;
    }

    public void setDenominacion(String denominacion) {
        this.denominacion = denominacion;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getOrden() {
        return orden;
    }

    public void setOrden(int orden) {
        this.orden = orden;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public boolean isBindactual() {
        return bindactual;
    }

    public void setBindactual(boolean bindactual) {
        this.bindactual = bindactual;
    }
}
