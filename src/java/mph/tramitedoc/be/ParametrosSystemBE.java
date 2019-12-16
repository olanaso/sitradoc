/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.be;

/**
 *
 * @author Erik
 */
public class ParametrosSystemBE {

    private String driverPostgres = "";
    private String urlPostgres = "";
    private String ipServidor = "";
    private String nombrePcServidor = "";
    private String ipCliente = "";
    private String nombrePcCliente = "";
    private String puertoPostgres = "";
    private String baseDatos = "";
    private String usuarioPostgres = "";
    private String passwordPostgres = "";
    private String pathPgDumpPostgres = "";
    private String pathReport = "";
    private String pathBackup = "";//ruta de la copia
    private String nickSistema = "";
    //otros
    private String esServidor = "";
    private String interrupcion = "";//se va la luz o se reinicia la pc
    private String esAutorizado = "";//para copias de seguridad
    //conexion con otra base de datos
    private String otroDB = "";//principalmente base de datos kardex
    private String otroIpServidor = "";
    private String otroPuertoPostgres = "";
    private String horaCierrePlanilla = "";

    private String ftp_ip_address, ftp_url_access, ftp_user, ftp_password, ftp_folder_save;
    private int ftp_port;

    private String txtEditorLayer = "";

    public String getTxtEditorLayer() {
        return txtEditorLayer;
    }

    public void setTxtEditorLayer(String txtEditorLayer) {
        this.txtEditorLayer = txtEditorLayer;
    }

    public String getDriverPostgres() {
        return driverPostgres;
    }

    public void setDriverPostgres(String driverPostgres) {
        this.driverPostgres = driverPostgres;
    }

    public String getUrlPostgres() {
        return urlPostgres;
    }

    public void setUrlPostgres(String urlPostgres) {
        this.urlPostgres = urlPostgres;
    }

    public String getIpServidor() {
        return ipServidor;
    }

    public void setIpServidor(String ipServidor) {
        this.ipServidor = ipServidor;
    }

    public String getNombrePcServidor() {
        return nombrePcServidor;
    }

    public void setNombrePcServidor(String nombrePcServidor) {
        this.nombrePcServidor = nombrePcServidor;
    }

    public String getIpCliente() {
        return ipCliente;
    }

    public void setIpCliente(String ipCliente) {
        this.ipCliente = ipCliente;
    }

    public String getNombrePcCliente() {
        return nombrePcCliente;
    }

    public void setNombrePcCliente(String nombrePcCliente) {
        this.nombrePcCliente = nombrePcCliente;
    }

    public String getPuertoPostgres() {
        return puertoPostgres;
    }

    public void setPuertoPostgres(String puertoPostgres) {
        this.puertoPostgres = puertoPostgres;
    }

    public String getBaseDatos() {
        return baseDatos;
    }

    public void setBaseDatos(String baseDatos) {
        this.baseDatos = baseDatos;
    }

    public String getUsuarioPostgres() {
        return usuarioPostgres;
    }

    public void setUsuarioPostgres(String usuarioPostgres) {
        this.usuarioPostgres = usuarioPostgres;
    }

    public String getPasswordPostgres() {
        return passwordPostgres;
    }

    public void setPasswordPostgres(String passwordPostgres) {
        this.passwordPostgres = passwordPostgres;
    }

    public String getPathPgDumpPostgres() {
        return pathPgDumpPostgres;
    }

    public void setPathPgDumpPostgres(String pathPgDumpPostgres) {
        this.pathPgDumpPostgres = pathPgDumpPostgres;
    }

    public String getPathReport() {
        return pathReport;
    }

    public void setPathReport(String pathReport) {
        this.pathReport = pathReport;
    }

    public String getPathBackup() {
        return pathBackup;
    }

    public void setPathBackup(String pathBackup) {
        this.pathBackup = pathBackup;
    }

    public String getNickSistema() {
        return nickSistema;
    }

    public void setNickSistema(String nickSistema) {
        this.nickSistema = nickSistema;
    }

    public String getEsServidor() {
        return esServidor;
    }

    public void setEsServidor(String esServidor) {
        this.esServidor = esServidor;
    }

    public String getInterrupcion() {
        return interrupcion;
    }

    public void setInterrupcion(String interrupcion) {
        this.interrupcion = interrupcion;
    }

    public String getEsAutorizado() {
        return esAutorizado;
    }

    public void setEsAutorizado(String esAutorizado) {
        this.esAutorizado = esAutorizado;
    }

    public String getOtroDB() {
        return otroDB;
    }

    public void setOtroDB(String otroDB) {
        this.otroDB = otroDB;
    }

    public String getOtroIpServidor() {
        return otroIpServidor;
    }

    public void setOtroIpServidor(String otroIpServidor) {
        this.otroIpServidor = otroIpServidor;
    }

    public String getOtroPuertoPostgres() {
        return otroPuertoPostgres;
    }

    public void setOtroPuertoPostgres(String otroPuertoPostgres) {
        this.otroPuertoPostgres = otroPuertoPostgres;
    }

    public String getHoraCierrePlanilla() {
        return horaCierrePlanilla;
    }

    public void setHoraCierrePlanilla(String horaCierrePlanilla) {
        this.horaCierrePlanilla = horaCierrePlanilla;
    }

    public String getFtp_ip_address() {
        return ftp_ip_address;
    }

    public void setFtp_ip_address(String ftp_ip_address) {
        this.ftp_ip_address = ftp_ip_address;
    }

    public String getFtp_url_access() {
        return ftp_url_access;
    }

    public void setFtp_url_access(String ftp_url_access) {
        this.ftp_url_access = ftp_url_access;
    }

    public String getFtp_user() {
        return ftp_user;
    }

    public void setFtp_user(String ftp_user) {
        this.ftp_user = ftp_user;
    }

    public String getFtp_password() {
        return ftp_password;
    }

    public void setFtp_password(String ftp_password) {
        this.ftp_password = ftp_password;
    }

    public int getFtp_port() {
        return ftp_port;
    }

    public void setFtp_port(int ftp_port) {
        this.ftp_port = ftp_port;
    }

    public String getFtp_folder_save() {
        return ftp_folder_save;
    }

    public void setFtp_folder_save(String ftp_folder_save) {
        this.ftp_folder_save = ftp_folder_save;
    }

}
