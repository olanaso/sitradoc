package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class ExpedienterequisitoBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idexpedienterequisito;
    private int idrequisitos;
    private int idexpediente;
    private Date fecha;
    private boolean estado;

    public ExpedienterequisitoBE() {
        this.IndOpSp = 0;
        this.idexpedienterequisito = 0;
        this.idrequisitos = 0;
        this.idexpediente = 0;
        this.fecha = new Date();
        this.estado = false;

    }

    public ExpedienterequisitoBE(int pIndOpSp, int pinexpedienterequisito, int pidrequisitos, int pidexpediente, Date pfecha, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idexpedienterequisito = pinexpedienterequisito;
        this.idrequisitos = pidrequisitos;
        this.idexpediente = pidexpediente;
        this.fecha = pfecha;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdexpedienterequisito() {
        return idexpedienterequisito;

    }

    public int getIdrequisitos() {
        return idrequisitos;

    }

    public int getIdexpediente() {
        return idexpediente;

    }

    public Date getFecha() {
        return fecha;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdexpedienterequisito(int inexpedienterequisito) {

        this.idexpedienterequisito = inexpedienterequisito;
    }

    public void setIdrequisitos(int idrequisitos) {

        this.idrequisitos = idrequisitos;
    }

    public void setIdexpediente(int idexpediente) {

        this.idexpediente = idexpediente;
    }

    public void setFecha(Date fecha) {

        this.fecha = fecha;
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
