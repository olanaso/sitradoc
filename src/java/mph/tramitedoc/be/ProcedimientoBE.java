package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class ProcedimientoBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idprocedimiento;
    private int idarea;
    private String codigo;
    private String denominacion;
    private String area;
    private int plazodias;
    private int idcargoresolutor;
    private int idtipoprocedimiento;
    private String descripcion;
    private Double montototal;
    private boolean estado;
    private String cargoresolutor;
    private String tipoprocedimiento;

    public ProcedimientoBE() {
        this.IndOpSp = 0;
        this.idprocedimiento = 0;
        this.idarea = 0;
        this.codigo = "";
        this.denominacion = "";
        this.plazodias = 0;
        this.idcargoresolutor = 0;
        this.idtipoprocedimiento = 0;
        this.descripcion = "";
        this.montototal = 0.0;
        this.estado = false;
        this.cargoresolutor = "";
        this.tipoprocedimiento = "";
    }

    public ProcedimientoBE(int pIndOpSp, int pidprocedimiento, int pidarea, String pcodigo, String pdenominacion, 
            int pplazodias, int pidcargoresolutor, int pidtipoprocedimiento, String pdescripcion, Double pmontototal, 
            String pcargoresolutor, String ptipoprocedimiento, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idprocedimiento = pidprocedimiento;
        this.idarea = pidarea;
        this.codigo = pcodigo;
        this.denominacion = pdenominacion;
        this.plazodias = pplazodias;
        this.idcargoresolutor = pidcargoresolutor;
        this.idtipoprocedimiento = pidtipoprocedimiento;
        this.descripcion = pdescripcion;
        this.montototal = pmontototal;
        this.estado = pestado;
        this.cargoresolutor = pcargoresolutor;
        this.tipoprocedimiento = ptipoprocedimiento;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }
    
    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdprocedimiento() {
        return idprocedimiento;

    }

    public int getIdarea() {
        return idarea;

    }

    public String getCodigo() {
        return codigo;

    }

    public String getDenominacion() {
        return denominacion;

    }

    public int getPlazodias() {
        return plazodias;

    }

    public int getIdcargoresolutor() {
        return idcargoresolutor;

    }

    public String getDescripcion() {
        return descripcion;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdprocedimiento(int idprocedimiento) {

        this.idprocedimiento = idprocedimiento;
    }

    public void setIdarea(int idarea) {

        this.idarea = idarea;
    }

    public void setCodigo(String codigo) {

        this.codigo = codigo;
    }

    public void setDenominacion(String denominacion) {

        this.denominacion = denominacion;
    }

    public void setPlazodias(int plazodias) {

        this.plazodias = plazodias;
    }

    public void setIdcargoresolutor(int idcargoresolutor) {

        this.idcargoresolutor = idcargoresolutor;
    }

    public void setDescripcion(String descripcion) {

        this.descripcion = descripcion;
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

    public int getIdtipoprocedimiento() {
        return idtipoprocedimiento;
    }

    public void setIdtipoprocedimiento(int idtipoprocedimiento) {
        this.idtipoprocedimiento = idtipoprocedimiento;
    }

    public Double getMontototal() {
        return montototal;
    }

    public void setMontototal(Double montototal) {
        this.montototal = montototal;
    }

    public String getCargoresolutor() {
        return cargoresolutor;
    }

    public void setCargoresolutor(String cargoresolutor) {
        this.cargoresolutor = cargoresolutor;
    }

    public String getTipoprocedimiento() {
        return tipoprocedimiento;
    }

    public void setTipoprocedimiento(String tipoprocedimiento) {
        this.tipoprocedimiento = tipoprocedimiento;
    }
}
