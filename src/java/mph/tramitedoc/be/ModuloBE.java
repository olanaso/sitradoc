package mph.tramitedoc.be;


import java.util.Date;
//@autor Sergio Medina


public class ModuloBE
 { 
private int IndOpSp;   private String edit;
    private String del;

 private int idmodulo;
 private String denominacion;
 private String paginainicio;
 private boolean estado;

public ModuloBE(){
this.IndOpSp = 0;
this.idmodulo = 0;
this.denominacion = "";
this.paginainicio = "";
this.estado = false;

}
public ModuloBE(int pIndOpSp,int pidmodulo,String pdenominacion,String ppaginainicio,boolean pestado)

{
this.IndOpSp = pIndOpSp;
this.idmodulo = pidmodulo;
this.denominacion = pdenominacion;
this.paginainicio = ppaginainicio;
this.estado = pestado;
}
 public int getIndOpSp() {
    return IndOpSp;
    }

public int getIdmodulo() {
return idmodulo;

 }
public String getDenominacion() {
return denominacion;

 }
public String getPaginainicio() {
return paginainicio;

 }
public boolean isEstado() {
return estado;

 }
 public void setIndOpSp(int IndOpSp) {
     this.IndOpSp = IndOpSp;
    }

public void setIdmodulo(int idmodulo){

this.idmodulo = idmodulo;
}

public void setDenominacion(String denominacion){

this.denominacion = denominacion;
}

public void setPaginainicio(String paginainicio){

this.paginainicio = paginainicio;
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
