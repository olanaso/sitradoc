package mph.tramitedoc.be;


import java.util.Date;
//@autor Sergio Medina


public class RolBE
 { 
private int IndOpSp;   private String edit;
    private String del;

 private int idrol;
 private String denominacion;
 private boolean estado;

public RolBE(){
this.IndOpSp = 0;
this.idrol = 0;
this.denominacion = "";
this.estado = false;

}
public RolBE(int pIndOpSp,int pidrol,String pdenominacion,boolean pestado)

{
this.IndOpSp = pIndOpSp;
this.idrol = pidrol;
this.denominacion = pdenominacion;
this.estado = pestado;
}
 public int getIndOpSp() {
    return IndOpSp;
    }

public int getIdrol() {
return idrol;

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

public void setIdrol(int idrol){

this.idrol = idrol;
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
