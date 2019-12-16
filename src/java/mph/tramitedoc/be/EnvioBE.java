package mph.tramitedoc.be;


import java.util.Date;
//@autor Sergio Medina


public class EnvioBE
 { 
private int IndOpSp;   private String edit;
    private String del;

 private Integer idenvio;
 private Integer idusuario;
 private Date fechaenvio;
 private boolean estado;

public EnvioBE(){
this.IndOpSp = 0;
this.idenvio = 0;
this.idusuario = 0;
this.fechaenvio = new Date();
this.estado = false;

}
public EnvioBE(int pIndOpSp,Integer pidenvio,Integer pidusuario,Date pfechaenvio,boolean pestado)

{
this.IndOpSp = pIndOpSp;
this.idenvio = pidenvio;
this.idusuario = pidusuario;
this.fechaenvio = pfechaenvio;
this.estado = pestado;
}
 public int getIndOpSp() {
    return IndOpSp;
    }

public Integer getIdenvio() {
return idenvio;

 }
public Integer getIdusuario() {
return idusuario;

 }
public Date  getFechaenvio() {
return fechaenvio;

 }
public boolean isEstado() {
return estado;

 }
 public void setIndOpSp(int IndOpSp) {
     this.IndOpSp = IndOpSp;
    }

public void setIdenvio(Integer idenvio){

this.idenvio = idenvio;
}

public void setIdusuario(Integer idusuario){

this.idusuario = idusuario;
}

public void setFechaenvio(Date  fechaenvio){

this.fechaenvio = fechaenvio;
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
