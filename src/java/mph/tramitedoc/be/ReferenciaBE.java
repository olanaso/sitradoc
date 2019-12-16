package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class ReferenciaBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private Integer idreferencia;
    private Integer iddocumento;
    private Integer iddocumentoreferencia;
    private Date fecharegistro;
    private Integer idusuarioregistra;
    private boolean estado;

    public ReferenciaBE() {
        this.IndOpSp = 0;
        this.idreferencia = 0;
        this.iddocumento = 0;
        this.iddocumentoreferencia = 0;
        this.fecharegistro = new Date();
        this.idusuarioregistra = 0;
        this.estado = false;

    }

    public ReferenciaBE(int pIndOpSp, Integer pidreferencia, Integer piddocumento, Integer piddocumentoreferencia, Date pfecharegistro, Integer pidusuarioregistra, boolean pestado) {
        this.IndOpSp = pIndOpSp;
        this.idreferencia = pidreferencia;
        this.iddocumento = piddocumento;
        this.iddocumentoreferencia = piddocumentoreferencia;
        this.fecharegistro = pfecharegistro;
        this.idusuarioregistra = pidusuarioregistra;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public Integer getIdreferencia() {
        return idreferencia;

    }

    public Integer getIddocumento() {
        return iddocumento;

    }

    public Integer getIddocumentoreferencia() {
        return iddocumentoreferencia;

    }

    public Date getFecharegistro() {
        return fecharegistro;

    }

    public Integer getIdusuarioregistra() {
        return idusuarioregistra;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdreferencia(Integer idreferencia) {

        this.idreferencia = idreferencia;
    }

    public void setIddocumento(Integer iddocumento) {

        this.iddocumento = iddocumento;
    }

    public void setIddocumentoreferencia(Integer iddocumentoreferencia) {

        this.iddocumentoreferencia = iddocumentoreferencia;
    }

    public void setFecharegistro(Date fecharegistro) {

        this.fecharegistro = fecharegistro;
    }

    public void setIdusuarioregistra(Integer idusuarioregistra) {

        this.idusuarioregistra = idusuarioregistra;
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
