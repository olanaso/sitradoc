package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class EstadobandejaBE {

    private int IndOpSp;
    private int idestadobandeja;
    private int idusuario;
    private String icono;
    private String denominacion;
    private boolean estado;
    private int orden;
    private boolean bindfinal;

   

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdestadobandeja() {
        return idestadobandeja;

    }

    public int getIdusuario() {
        return idusuario;

    }

    public String getIcono() {
        return icono;

    }

    public String getDenominacion() {
        return denominacion;

    }

    public boolean isEstado() {
        return estado;

    }

    public int getOrden() {
        return orden;

    }

    public boolean isBindfinal() {
        return bindfinal;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdestadobandeja(int idestadobandeja) {

        this.idestadobandeja = idestadobandeja;
    }

    public void setIdusuario(int idusuario) {

        this.idusuario = idusuario;
    }

    public void setIcono(String icono) {

        this.icono = icono;
    }

    public void setDenominacion(String denominacion) {

        this.denominacion = denominacion;
    }

    public void setEstado(boolean estado) {

        this.estado = estado;
    }

    public void setOrden(int orden) {

        this.orden = orden;
    }

    public void setBindfinal(boolean bindfinal) {

        this.bindfinal = bindfinal;
    }

}
