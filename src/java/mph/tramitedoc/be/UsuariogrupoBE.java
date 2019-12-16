package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class UsuariogrupoBE {

    private int IndOpSp;
    private int idusuariogrupo;
    private int denominacion;
    private int idusuariocreacion;
    private boolean estado;

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdusuariogrupo() {
        return idusuariogrupo;

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

    public void setIdusuariogrupo(int idusuariogrupo) {

        this.idusuariogrupo = idusuariogrupo;
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
