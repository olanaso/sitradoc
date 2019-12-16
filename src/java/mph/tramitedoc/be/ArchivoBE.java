package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class ArchivoBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private Integer idarchivo;
     private Integer idenvio;
    private Integer idflujo;
    private String denominacion;
    private String ruta;
    private boolean estado;
    private String name;

    public ArchivoBE() {
        this.IndOpSp = 0;
        this.idarchivo = 0;
        this.idflujo = 0;
        this.denominacion = "";
        this.ruta = "";
        this.estado = false;

    }

    public ArchivoBE(int pIndOpSp, Integer pidarchivo, Integer pidflujo, String pdenominacion, String pruta, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idarchivo = pidarchivo;
        this.idflujo = pidflujo;
        this.denominacion = pdenominacion;
        this.ruta = pruta;
        this.estado = pestado;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    

    public Integer getIdenvio() {
        return idenvio;
    }

    public void setIdenvio(Integer idenvio) {
        this.idenvio = idenvio;
    }
    

    public int getIndOpSp() {
        return IndOpSp;
    }

    public Integer getIdarchivo() {
        return idarchivo;

    }

    public Integer getIdflujo() {
        return idflujo;

    }

    public String getDenominacion() {
        return denominacion;

    }

    public String getRuta() {
        return ruta;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdarchivo(Integer idarchivo) {

        this.idarchivo = idarchivo;
    }

    public void setIdflujo(Integer idflujo) {

        this.idflujo = idflujo;
    }

    public void setDenominacion(String denominacion) {

        this.denominacion = denominacion;
    }

    public void setRuta(String ruta) {

        this.ruta = ruta;
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
