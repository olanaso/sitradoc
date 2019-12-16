package mph.tramitedoc.be;


import java.util.Date;
//@autor Sergio Medina


public class DocumentomensajeBE
 { 
private int IndOpSp;
 private int iddocumentomensaje;
 private int idmensaje;
 private int iddocumento;
 private Date fechacreacion;
 private int idusuariocreacion;
 private boolean estado;

public DocumentomensajeBE(){
this.IndOpSp = 0;
this.iddocumentomensaje = 0;
this.idmensaje = 0;
this.iddocumento = 0;
this.fechacreacion = new Date();
this.idusuariocreacion = 0;
this.estado = false;

}
public DocumentomensajeBE(int pIndOpSp,int piddocumentomensaje,int pidmensaje,int piddocumento,Date pfechacreacion,int pidusuariocreacion,boolean pestado)

{
this.IndOpSp = pIndOpSp;
this.iddocumentomensaje = piddocumentomensaje;
this.idmensaje = pidmensaje;
this.iddocumento = piddocumento;
this.fechacreacion = pfechacreacion;
this.idusuariocreacion = pidusuariocreacion;
this.estado = pestado;
}
 public int getIndOpSp() {
    return IndOpSp;
    }

public int getIddocumentomensaje() {
return iddocumentomensaje;

 }
public int getIdmensaje() {
return idmensaje;

 }
public int getIddocumento() {
return iddocumento;

 }
public Date  getFechacreacion() {
return fechacreacion;

 }
public int getIdusuariocreacion() {
return idusuariocreacion;

 }
public boolean isEstado() {
return estado;

 }
 public void setIndOpSp(int IndOpSp) {
     this.IndOpSp = IndOpSp;
    }

public void setIddocumentomensaje(int iddocumentomensaje){

this.iddocumentomensaje = iddocumentomensaje;
}

public void setIdmensaje(int idmensaje){

this.idmensaje = idmensaje;
}

public void setIddocumento(int iddocumento){

this.iddocumento = iddocumento;
}

public void setFechacreacion(Date  fechacreacion){

this.fechacreacion = fechacreacion;
}

public void setIdusuariocreacion(int idusuariocreacion){

this.idusuariocreacion = idusuariocreacion;
}

public void setEstado(boolean estado){

this.estado = estado;
}

}
