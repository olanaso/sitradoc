package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class TipodocumentoBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private Integer idtipodocumento;
    private Integer idregla;
    private String denominacion;
    private String descripcion;
    private boolean estado;
    private boolean subida;
    private boolean igual;
    private boolean bajada;
    //private boolean jefe;

    public TipodocumentoBE() {
        this.IndOpSp = 0;
        this.idtipodocumento = 0;
        this.idregla = 0;
        this.denominacion = "";
        this.descripcion = "";
        this.estado = false;
        this.subida = false;
        this.igual = false;
        this.bajada = false;
        //this.jefe = false;

    }

    public TipodocumentoBE(int pIndOpSp, Integer pidtipodocumento, Integer pidregla, String pdenominacion, String pdescripcion,
            boolean pestado, boolean psubida, boolean pigual, boolean pbajada/*, boolean pjefe*/) {
        this.IndOpSp = pIndOpSp;
        this.idtipodocumento = pidtipodocumento;
        this.idregla = pidregla;
        this.denominacion = pdenominacion;
        this.descripcion = pdescripcion;
        this.estado = pestado;
        this.subida = psubida;
        this.igual = pigual;
        this.bajada = pbajada;
        //this.jefe = pjefe;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public Integer getIdtipodocumento() {
        return idtipodocumento;

    }

    public Integer getIdregla() {
        return idregla;

    }

    public String getDenominacion() {
        return denominacion;

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

    public void setIdtipodocumento(Integer idtipodocumento) {

        this.idtipodocumento = idtipodocumento;
    }

    public void setIdregla(Integer idregla) {

        this.idregla = idregla;
    }

    public void setDenominacion(String denominacion) {

        this.denominacion = denominacion;
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

    public boolean isSubida() {
        return subida;
    }

    public void setSubida(boolean subida) {
        this.subida = subida;
    }

    public boolean isIgual() {
        return igual;
    }

    public void setIgual(boolean igual) {
        this.igual = igual;
    }

    public boolean isBajada() {
        return bajada;
    }

    public void setBajada(boolean bajada) {
        this.bajada = bajada;
    }

//    public boolean isJefe() {
//        return jefe;
//    }
//
//    public void setJefe(boolean jefe) {
//        this.jefe = jefe;
//    }
}
