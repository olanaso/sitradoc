package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class CargoBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private Integer idcargo;
    private Integer idarea;
    private String denominacion;
    private boolean estado;
    private boolean bindjefe;
    private Integer idcargoparent;
    private Integer nivel;
    private String area;
    private String abreviatura;

    public CargoBE() {
        this.IndOpSp = 0;
        this.idcargo = 0;
        this.idarea = 0;
        this.denominacion = "";
        this.estado = false;
        this.bindjefe = false;
        this.idcargoparent = 0;
        this.nivel = 0;
        this.abreviatura = "";
    }

    public CargoBE(int pIndOpSp, Integer pidcargo, Integer pidarea, String pdenominacion, boolean pestado, boolean pbindjefe, Integer pidcargoparent, Integer pnivel, String pabreviatura) {
        this.IndOpSp = pIndOpSp;
        this.idcargo = pidcargo;
        this.idarea = pidarea;
        this.denominacion = pdenominacion;
        this.estado = pestado;
        this.bindjefe = pbindjefe;
        this.idcargoparent = pidcargoparent;
        this.nivel = pnivel;
        this.abreviatura = pabreviatura;
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

    public Integer getIdcargo() {
        return idcargo;

    }

    public Integer getIdarea() {
        return idarea;

    }

    public String getDenominacion() {
        return denominacion;

    }

    public boolean isEstado() {
        return estado;

    }

    public boolean isBindjefe() {
        return bindjefe;

    }

    public Integer getIdcargoparent() {
        return idcargoparent;

    }

    public Integer getNivel() {
        return nivel;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdcargo(Integer idcargo) {

        this.idcargo = idcargo;
    }

    public void setIdarea(Integer idarea) {

        this.idarea = idarea;
    }

    public void setDenominacion(String denominacion) {

        this.denominacion = denominacion;
    }

    public void setEstado(boolean estado) {

        this.estado = estado;
    }

    public void setBindjefe(boolean bindjefe) {

        this.bindjefe = bindjefe;
    }

    public void setIdcargoparent(Integer idcargoparent) {

        this.idcargoparent = idcargoparent;
    }

    public void setNivel(Integer nivel) {

        this.nivel = nivel;
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

    public String getAbreviatura() {
        return abreviatura;
    }

    public void setAbreviatura(String abreviatura) {
        this.abreviatura = abreviatura;
    }
}
