package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class AreagrupoBE {

    private int IndOpSp;
    private int idareagrupo;
    private int denominacion;
    private int idusuariocreacion;
    private boolean estado;

    public AreagrupoBE() {
        this.IndOpSp = 0;
        this.idareagrupo = 0;
        this.denominacion = 0;
        this.idusuariocreacion = 0;
        this.estado = false;

    }

    public AreagrupoBE(int pIndOpSp, int pidareagrupo, int pdenominacion, int pidusuariocreacion, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idareagrupo = pidareagrupo;
        this.denominacion = pdenominacion;
        this.idusuariocreacion = pidusuariocreacion;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdareagrupo() {
        return idareagrupo;

    }

    public int getDenominacion() {
        return denominacion;

    }

    public int getIdusuariocreacion() {
        return idusuariocreacion;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdareagrupo(int idareagrupo) {

        this.idareagrupo = idareagrupo;
    }

    public void setDenominacion(int denominacion) {

        this.denominacion = denominacion;
    }

    public void setIdusuariocreacion(int idusuariocreacion) {

        this.idusuariocreacion = idusuariocreacion;
    }

    public void setEstado(boolean estado) {

        this.estado = estado;
    }

}
