package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class RequisitosBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idrequisitos;
    private int idprocedimiento;
    private String denominacion;
    private boolean estado;
    
    //Variables Agregados
    private String procdenominacion;

    public RequisitosBE() {
        this.IndOpSp = 0;
        this.idrequisitos = 0;
        this.idprocedimiento = 0;
        this.denominacion = "";
        this.estado = false;

    }

    public RequisitosBE(int pIndOpSp, int pidrequisitos, int pidprocedimiento, String pdenominacion, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idrequisitos = pidrequisitos;
        this.idprocedimiento = pidprocedimiento;
        this.denominacion = pdenominacion;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdrequisitos() {
        return idrequisitos;

    }

    public int getIdprocedimiento() {
        return idprocedimiento;

    }

    public String getDenominacion() {
        return denominacion;

    }

    public boolean isEstado() {
        return estado;

    }
    
    public String getProcdenominacion() {
        return procdenominacion;
    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdrequisitos(int idrequisitos) {

        this.idrequisitos = idrequisitos;
    }

    public void setIdprocedimiento(int idprocedimiento) {

        this.idprocedimiento = idprocedimiento;
    }

    public void setDenominacion(String denominacion) {

        this.denominacion = denominacion;
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

    public void setProcdenominacion(String procdenominacion) {
        this.procdenominacion = procdenominacion;
    }
}
