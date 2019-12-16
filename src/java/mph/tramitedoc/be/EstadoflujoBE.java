package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class EstadoflujoBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idestadoflujo;
    private String denominacion;
    private boolean estado;

    public EstadoflujoBE() {
        
        this.IndOpSp = 0;
        this.idestadoflujo = 0;
        this.denominacion = "";
        this.estado = false;

    }

    public EstadoflujoBE(int pIndOpSp, int pidestadoflujo, String pdenominacion, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idestadoflujo = pidestadoflujo;
        this.denominacion = pdenominacion;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdestadoflujo() {
        return idestadoflujo;

    }

    public String getDenominacion() {
        return denominacion;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdestadoflujo(int idestadoflujo) {

        this.idestadoflujo = idestadoflujo;
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
}
