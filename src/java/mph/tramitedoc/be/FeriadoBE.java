package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class FeriadoBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idferiado;
    private int idanio;
    private Date fecha;
    private String motivo;
    private boolean estado;

    public FeriadoBE() {
        this.IndOpSp = 0;
        this.idferiado = 0;
        this.idanio = 0;
        this.fecha = new Date();
        this.motivo = "";
        this.estado = false;

    }

    public FeriadoBE(int pIndOpSp, int pidferiado, int pidanio, Date pfecha, String pmotivo, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idferiado = pidferiado;
        this.idanio = pidanio;
        this.fecha = pfecha;
        this.motivo = pmotivo;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdferiado() {
        return idferiado;

    }

    public int getIdanio() {
        return idanio;

    }

    public Date getFecha() {
        return fecha;

    }

    public String getMotivo() {
        return motivo;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdferiado(int idferiado) {

        this.idferiado = idferiado;
    }

    public void setIdanio(int idanio) {

        this.idanio = idanio;
    }

    public void setFecha(Date fecha) {

        this.fecha = fecha;
    }

    public void setMotivo(String motivo) {

        this.motivo = motivo;
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
