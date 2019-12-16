package mph.tramitedoc.be;

import java.util.ArrayList;
import java.util.Date;
//@autor Sergio Medina

public class MensajeBE {

    private int IndOpSp;
    private int idmensaje;
    private String asunto;
    private String mensaje;
    private int prioridad;
    private boolean bindrespuesta, bindrecepcion;
    private int diasrespuesta;
    private int idareacioncreacion;
    private int idusuariocreacion;
    private Date fechacreacion;
    private boolean estado;
    private Integer[] idareas, iddocumentos;
    private ArrayList<UsuarioBE> listausuarios;
    private ArrayList<ArchivomensajeBE> archivosmensaje;
    private Integer idexpediente;
    private String fecha_manual;
    
    public MensajeBE(){
        this.IndOpSp = 0;
        this.idmensaje = 0;
        this.asunto = "";
        this.mensaje = "";
        this.prioridad = 0;
        this.bindrespuesta = false;
        this.bindrecepcion = true;
        this.diasrespuesta = 0;
        this.idareacioncreacion = 0;
        this.idusuariocreacion = 0;
        this.fechacreacion = new Date();
        this.estado = false;
        this.idexpediente = 0;
    }

    public boolean isBindrecepcion() {
        return bindrecepcion;
    }

    public void setBindrecepcion(boolean bindrecepcion) {
        this.bindrecepcion = bindrecepcion;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdmensaje() {
        return idmensaje;

    }

    public String getAsunto() {
        return asunto;

    }

    public int getPrioridad() {
        return prioridad;

    }

    public boolean isBindrespuesta() {
        return bindrespuesta;

    }

    public int getDiasrespuesta() {
        return diasrespuesta;

    }

    public int getIdareacioncreacion() {
        return idareacioncreacion;

    }

    public int getIdusuariocreacion() {
        return idusuariocreacion;

    }

    public Date getFechacreacion() {
        return fechacreacion;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdmensaje(int idmensaje) {

        this.idmensaje = idmensaje;
    }

    public void setAsunto(String asunto) {

        this.asunto = asunto;
    }

    public void setMensaje(String mensaje) {

        this.mensaje = mensaje;
    }

    public void setPrioridad(int prioridad) {

        this.prioridad = prioridad;
    }

    public void setBindrespuesta(boolean bindrespuesta) {

        this.bindrespuesta = bindrespuesta;
    }

    public void setDiasrespuesta(int diasrespuesta) {

        this.diasrespuesta = diasrespuesta;
    }

    public void setIdareacioncreacion(int idareacioncreacion) {

        this.idareacioncreacion = idareacioncreacion;
    }

    public void setIdusuariocreacion(int idusuariocreacion) {

        this.idusuariocreacion = idusuariocreacion;
    }

    public void setFechacreacion(Date fechacreacion) {

        this.fechacreacion = fechacreacion;
    }

    public void setEstado(boolean estado) {

        this.estado = estado;
    }

    public Integer[] getIdareas() {
        return idareas;
    }

    public void setIdareas(Integer[] idareas) {
        this.idareas = idareas;
    }

    public ArrayList<UsuarioBE> getListausuarios() {
        return listausuarios;
    }

    public void setListausuarios(ArrayList<UsuarioBE> listausuarios) {
        this.listausuarios = listausuarios;
    }

    public Integer[] getIddocumentos() {
        return iddocumentos;
    }

    public void setIddocumentos(Integer[] iddocumentos) {
        this.iddocumentos = iddocumentos;
    }

    public ArrayList<ArchivomensajeBE> getArchivosmensaje() {
        return archivosmensaje;
    }

    public void setArchivosmensaje(ArrayList<ArchivomensajeBE> archivosmensaje) {
        this.archivosmensaje = archivosmensaje;
    }

    public String getMensaje() {
        return mensaje;
    }

    public Integer getIdexpediente() {
        return idexpediente;
    }

    public void setIdexpediente(Integer idexpediente) {
        this.idexpediente = idexpediente;
    }

    public String getFecha_manual() {
        return fecha_manual;
    }

    public void setFecha_manual(String fecha_manual) {
        this.fecha_manual = fecha_manual;
    }
}
