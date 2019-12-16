package mph.tramitedoc.be;

import java.util.Date;
//@autor Sergio Medina

public class ArchivomensajeBE {

    private int IndOpSp;
    private int idarchivomensaje;
    private int idmensaje;
    private String nombre;
    private String url;
    private boolean estado;
    private String name;

  

    public int getIndOpSp() {
        return IndOpSp;
    }

    public int getIdarchivomensaje() {
        return idarchivomensaje;

    }

    public int getIdmensaje() {
        return idmensaje;

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

    public void setIdarchivomensaje(int idarchivomensaje) {

        this.idarchivomensaje = idarchivomensaje;
    }

    public void setIdmensaje(int idmensaje) {

        this.idmensaje = idmensaje;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
    

}
