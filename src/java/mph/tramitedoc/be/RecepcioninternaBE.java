package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class RecepcioninternaBE {

    private int IndOpSp;
    private int idrecepcioninterna;
    private int idexpediente;
    private int idmensaje;
    private int idarea_destino;
    private int idarea_proviene;
    private int idusuariorecepciona;
    private int idusuarioenvia;
    private int idrecepcion_proviene;
    private boolean bindentregado;
    private Date fecharecepcion;
    private boolean bindderivado;
    private boolean bindprimero;
    private Date fechaderivacion;
    private String observacion;
    private boolean estado;

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdrecepcioninterna() {
        return idrecepcioninterna;

    }

    public int getIdexpediente() {
        return idexpediente;

    }

    public int getIdarea_destino() {
        return idarea_destino;

    }

    public int getIdarea_proviene() {
        return idarea_proviene;

    }

    public int getIdusuariorecepciona() {
        return idusuariorecepciona;

    }

    public int getIdusuarioenvia() {
        return idusuarioenvia;

    }

    public int getIdrecepcion_proviene() {
        return idrecepcion_proviene;

    }

    public boolean isBindentregado() {
        return bindentregado;

    }

    public Date getFecharecepcion() {
        return fecharecepcion;

    }

    public boolean isBindderivado() {
        return bindderivado;

    }

    public boolean isBindprimero() {
        return bindprimero;

    }

    public Date getFechaderivacion() {
        return fechaderivacion;

    }

    public String getObservacion() {
        return observacion;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdrecepcioninterna(int idrecepcioninterna) {

        this.idrecepcioninterna = idrecepcioninterna;
    }

    public void setIdexpediente(int idexpediente) {

        this.idexpediente = idexpediente;
    }

    public void setIdarea_destino(int idarea_destino) {

        this.idarea_destino = idarea_destino;
    }

    public void setIdarea_proviene(int idarea_proviene) {

        this.idarea_proviene = idarea_proviene;
    }

    public void setIdusuariorecepciona(int idusuariorecepciona) {

        this.idusuariorecepciona = idusuariorecepciona;
    }

    public void setIdusuarioenvia(int idusuarioenvia) {

        this.idusuarioenvia = idusuarioenvia;
    }

    public void setIdrecepcion_proviene(int idrecepcion_proviene) {

        this.idrecepcion_proviene = idrecepcion_proviene;
    }

    public void setBindentregado(boolean bindentregado) {

        this.bindentregado = bindentregado;
    }

    public void setFecharecepcion(Date fecharecepcion) {

        this.fecharecepcion = fecharecepcion;
    }

    public void setBindderivado(boolean bindderivado) {

        this.bindderivado = bindderivado;
    }

    public void setBindprimero(boolean bindprimero) {

        this.bindprimero = bindprimero;
    }

    public void setFechaderivacion(Date fechaderivacion) {

        this.fechaderivacion = fechaderivacion;
    }

    public void setObservacion(String observacion) {

        this.observacion = observacion;
    }

    public void setEstado(boolean estado) {

        this.estado = estado;
    }

    public int getIdmensaje() {
        return idmensaje;
    }

    public void setIdmensaje(int idmensaje) {
        this.idmensaje = idmensaje;
    }

}
