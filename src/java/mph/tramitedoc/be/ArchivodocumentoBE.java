package mph.tramitedoc.be;

import java.util.ArrayList;
import java.util.Date;
//@autor Sergio Medina

public class ArchivodocumentoBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private Integer idarchivodocumento;
    private Integer documento;
    private String codigo;
    private String nombre;
    private String url;
    private boolean estado;
    private String name;
    private String ruta;

    public ArchivodocumentoBE() {
        this.IndOpSp = 0;
        this.idarchivodocumento = 0;
        this.documento = 0;
        this.codigo = "";
        this.nombre = "";
        this.url = "";
        this.estado = false;

    }

    public ArchivodocumentoBE(int pIndOpSp, Integer pidarchivodocumento, Integer pdocumento, String pcodigo, String pnombre, String purl, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idarchivodocumento = pidarchivodocumento;
        this.documento = pdocumento;
        this.codigo = pcodigo;
        this.nombre = pnombre;
        this.url = purl;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public Integer getIdarchivodocumento() {
        return idarchivodocumento;

    }

    public Integer getDocumento() {
        return documento;

    }

    public String getCodigo() {
        return codigo;

    }

    public String getNombre() {
        return nombre;

    }

    public String getUrl() {
        return url;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdarchivodocumento(Integer idarchivodocumento) {

        this.idarchivodocumento = idarchivodocumento;
    }

    public void setDocumento(Integer documento) {

        this.documento = documento;
    }

    public void setCodigo(String codigo) {

        this.codigo = codigo;
    }

    public void setNombre(String nombre) {

        this.nombre = nombre;
    }

    public void setUrl(String url) {

        this.url = url;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRuta() {
        return ruta;
    }

    public void setRuta(String ruta) {
        this.ruta = ruta;
    }

  

}
