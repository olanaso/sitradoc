package mph.tramitedoc.bl;


//@autor Sergio Medina


import mph.tramitedoc.be.EnvioBE;
import mph.tramitedoc.da.EnvioDA;
import java.util.ArrayList;import java.util.LinkedList;
import java.util.List;
public class EnvioBL {
public EnvioBL() {
}
 public EnvioBE listarEnvioBE(EnvioBE oEnvioBE1) {
	EnvioBE oEnvioBE=null;
	EnvioDA oEnvioDA=null;
try{
	oEnvioDA=new EnvioDA();
	oEnvioBE=oEnvioDA.listarEnvioBE(oEnvioBE1);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally{
	oEnvioBE1=null;
	oEnvioDA=null;
}
return oEnvioBE;
}
public ArrayList<EnvioBE> listarRegistrosEnvioBE(EnvioBE oEnvioBE){
ArrayList<EnvioBE> oListaEnvioBE=null;
EnvioDA oEnvioDA=null;
try{
	oEnvioDA=new EnvioDA();
	oListaEnvioBE=oEnvioDA.listarRegistroEnvioBE(oEnvioBE);
}
catch(Exception ex){
	ex.printStackTrace();
}
finally {
	oEnvioBE=null;
	oEnvioDA=null;
}
return oListaEnvioBE;
}

public int insertarEnvioBE(EnvioBE oEnvioBE){
	int resultado=0;
	EnvioDA oEnvioDA = null;

try {
	oEnvioDA=new EnvioDA();
	resultado=oEnvioDA.insertarEnvioBE(oEnvioBE);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally {
	oEnvioBE=null;
	oEnvioDA=null;
}
return resultado;
}


    public int insertarRegistrosEnvioBE(ArrayList<EnvioBE> oListaEnvioBE){
       int resultado=0;
        EnvioDA oEnvioDA=null;

        try {
            oEnvioDA=new EnvioDA();
            resultado=oEnvioDA.insertarRegistrosEnvioBE(oListaEnvioBE);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        finally
        {
            oListaEnvioBE=null;
            oEnvioDA=null;
        }
        return resultado;
    }


public int actualizarEnvioBE(EnvioBE oEnvioBE1){
        int resultado=0;
        EnvioDA oEnvioDA=null;
        try {
            oEnvioDA=new EnvioDA();
            resultado=oEnvioDA.actualizarEnvioBE(oEnvioBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oEnvioBE1=null;
            oEnvioDA=null;
        }

        return resultado;
    }

public int eliminarEnvioBE(EnvioBE oEnvioBE1){
        int resultado=0;
        EnvioDA oEnvioDA=null;
        try {
            oEnvioDA=new EnvioDA();
            resultado=oEnvioDA.eliminarEnvioBE(oEnvioBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oEnvioBE1=null;
            oEnvioDA=null;
        }

        return resultado;
    }

public List listObjectEnvioBE(EnvioBE oEnvioBE1){
        List list = new LinkedList();
        EnvioDA oEnvioDA=null;
        try {
            oEnvioDA=new EnvioDA();
            list=oEnvioDA.listObjectEnvioBE(oEnvioBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oEnvioBE1=null;
            oEnvioDA=null;
        }

        return list;
    }


}
