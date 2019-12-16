package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class AreaBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idarea;
    private String denominacion;
    private int idusuariojefe;
    private boolean estado;
    private String abreviatura;
    private String codigo;
    private int idareasuperior;
    private String areasuperior;

    private int opcion, idtipodocumento, idusuario, codigodoc;

    public AreaBE() {
        this.IndOpSp = 0;
        this.idarea = 0;
        this.denominacion = "";
        this.estado = false;
        this.abreviatura = "";
        this.codigo = "";
        //this.idareasuperior = 0;
    }

    public AreaBE(int pIndOpSp, int pidarea, String pdenominacion, boolean pestado, String pabreviatura, String pcodigo, int pidareasuperior) {
        this.IndOpSp = pIndOpSp;
        this.idarea = pidarea;
        this.denominacion = pdenominacion;
        this.estado = pestado;
        this.abreviatura = pabreviatura;
        this.codigo = pcodigo;
        this.idareasuperior = pidareasuperior;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdarea() {
        return idarea;

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

    public void setIdarea(int idarea) {

        this.idarea = idarea;
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

    public int getIdusuariojefe() {
        return idusuariojefe;
    }

    public void setIdusuariojefe(int idusuariojefe) {
        this.idusuariojefe = idusuariojefe;
    }

    public String getAbreviatura() {
        return abreviatura;
    }

    public void setAbreviatura(String abreviatura) {
        this.abreviatura = abreviatura;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public int getIdareasuperior() {
        return idareasuperior;
    }

    public void setIdareasuperior(int idareasuperior) {
        this.idareasuperior = idareasuperior;
    }

    public String getAreasuperior() {
        return areasuperior;
    }

    public void setAreasuperior(String areasuperior) {
        this.areasuperior = areasuperior;
    }

    public int getOpcion() {
        return opcion;
    }

    public void setOpcion(int opcion) {
        this.opcion = opcion;
    }

    public int getIdtipodocumento() {
        return idtipodocumento;
    }

    public void setIdtipodocumento(int idtipodocumento) {
        this.idtipodocumento = idtipodocumento;
    }

    public int getIdusuario() {
        return idusuario;
    }

    public void setIdusuario(int idusuario) {
        this.idusuario = idusuario;
    }

    public int getCodigodoc() {
        return codigodoc;
    }

    public void setCodigodoc(int codigodoc) {
        this.codigodoc = codigodoc;
    }

}
