package mph.tramitedoc.be;

import java.util.Date;
import java.util.List;
import java.util.Map;
//@autor Sergio Medina

public class UsuarioBE {

    private int IndOpSp;
    private String edit;
    private String del;

    private int idusuario;
    private String nombres;
    private String apellidos;
    private String dni;
    private String direccion;
    private String telefono;
    private String usuario;
    private String creationdate;
    private String password;
    private int idcargo;
    private String cargo;
    private int idarea;
    private String area;
    private String roles;
    private String iniciales;
    private Object[] modulos;
    private boolean bindcargoseleccionado;
    private List<UsuariocargoBE> listacargos;
    private String foto;

    private boolean estado;
    private boolean bindjefe;

    public boolean isBindcargoseleccionado() {
        return bindcargoseleccionado;
    }

    public void setBindcargoseleccionado(boolean bindcargoseleccionado) {
        this.bindcargoseleccionado = bindcargoseleccionado;
    }

    public List<UsuariocargoBE> getListacargos() {
        return listacargos;
    }

    public void setListacargos(List<UsuariocargoBE> listacargos) {
        this.listacargos = listacargos;
    }

    public boolean isBindjefe() {
        return bindjefe;
    }

    public void setBindjefe(boolean bindjefe) {
        this.bindjefe = bindjefe;
    }

    public String getCreationdate() {
        return creationdate;
    }

    public void setCreationdate(String creationdate) {
        this.creationdate = creationdate;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdusuario() {
        return idusuario;

    }

    public String getNombres() {
        return nombres;

    }

    public String getApellidos() {
        return apellidos;

    }

    public String getDni() {
        return dni;

    }

    public String getDireccion() {
        return direccion;

    }

    public String getTelefono() {
        return telefono;

    }

    public String getUsuario() {
        return usuario;

    }

    public String getPassword() {
        return password;

    }

    public boolean isEstado() {
        return estado;

    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public void setIdusuario(int idusuario) {

        this.idusuario = idusuario;
    }

    public void setNombres(String nombres) {

        this.nombres = nombres;
    }

    public void setApellidos(String apellidos) {

        this.apellidos = apellidos;
    }

    public void setDni(String dni) {

        this.dni = dni;
    }

    public void setDireccion(String direccion) {

        this.direccion = direccion;
    }

    public void setTelefono(String telefono) {

        this.telefono = telefono;
    }

    public void setUsuario(String usuario) {

        this.usuario = usuario;
    }

    public void setPassword(String password) {

        this.password = password;
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

    public int getIdcargo() {
        return idcargo;
    }

    public void setIdcargo(int idcargo) {
        this.idcargo = idcargo;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public int getIdarea() {
        return idarea;
    }

    public void setIdarea(int idarea) {
        this.idarea = idarea;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getRoles() {
        return roles;
    }

    public void setRoles(String roles) {
        this.roles = roles;
    }

    public Object[] getModulos() {
        return modulos;
    }

    public void setModulos(Object[] modulos) {
        this.modulos = modulos;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public String getIniciales() {
        return iniciales;
    }

    public void setIniciales(String iniciales) {
        this.iniciales = iniciales;
    }

 

}
