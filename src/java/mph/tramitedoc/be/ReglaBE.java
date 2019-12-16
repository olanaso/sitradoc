package mph.tramitedoc.be;


import java.util.Date;
//@autor Sergio Medina


public class ReglaBE
 { 
private int IndOpSp;   private String edit;
    private String del;

 private Integer idregla;
 private boolean subida;
 private boolean igual;
 private boolean bajada;
 private boolean estado;

public ReglaBE(){
this.IndOpSp = 0;
this.idregla = 0;
this.subida = false;
this.igual = false;
this.bajada = false;
this.estado = false;

}
public ReglaBE(int pIndOpSp,Integer pidregla,boolean psubida,boolean pigual,boolean pbajada,boolean pestado)

{
this.IndOpSp = pIndOpSp;
this.idregla = pidregla;
this.subida = psubida;
this.igual = pigual;
this.bajada = pbajada;
this.estado = pestado;
}
 public int getIndOpSp() {
    return IndOpSp;
    }

public Integer getIdregla() {
return idregla;

 }
public boolean isSubida() {
return subida;

 }
public boolean isIgual() {
return igual;

 }
public boolean isBajada() {
return bajada;

 }
public boolean isEstado() {
return estado;

 }
 public void setIndOpSp(int IndOpSp) {
     this.IndOpSp = IndOpSp;
    }

public void setIdregla(Integer idregla){

this.idregla = idregla;
}

public void setSubida(boolean subida){

this.subida = subida;
}

public void setIgual(boolean igual){

this.igual = igual;
}

public void setBajada(boolean bajada){

this.bajada = bajada;
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
