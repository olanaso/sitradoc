package mph.tramitedoc.be;


import java.util.Date;
//@autor Sergio Medina


public class AnioBE
 { 
private int IndOpSp;   private String edit;
    private String del;

 private int idanio;
 private String denominacion;
 private boolean estado;

public AnioBE(){
this.IndOpSp = 0;
this.idanio = 0;
this.denominacion = "";
this.estado = false;

}
public AnioBE(int pIndOpSp,int pidanio,String pdenominacion,boolean pestado)

{
this.IndOpSp = pIndOpSp;
this.idanio = pidanio;
this.denominacion = pdenominacion;
this.estado = pestado;
}
 public int getIndOpSp() {
    return IndOpSp;
    }

public int getIdanio() {
return idanio;

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

public void setIdanio(int idanio){

this.idanio = idanio;
}

public void setDenominacion(String denominacion){

this.denominacion = denominacion;
}

public void setEstado(boolean estado){

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
    }}
