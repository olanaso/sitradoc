package mph.tramitedoc.bl;


//@autor Sergio Medina


import mph.tramitedoc.be.RolBE;
import mph.tramitedoc.da.RolDA;
import java.util.ArrayList;import java.util.LinkedList;
import java.util.List;
public class RolBL {
public RolBL() {
}
 public RolBE listarRolBE(RolBE oRolBE1) {
	RolBE oRolBE=null;
	RolDA oRolDA=null;
try{
	oRolDA=new RolDA();
	oRolBE=oRolDA.listarRolBE(oRolBE1);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally{
	oRolBE1=null;
	oRolDA=null;
}
return oRolBE;
}
public ArrayList<RolBE> listarRegistrosRolBE(RolBE oRolBE){
ArrayList<RolBE> oListaRolBE=null;
RolDA oRolDA=null;
try{
	oRolDA=new RolDA();
	oListaRolBE=oRolDA.listarRegistroRolBE(oRolBE);
}
catch(Exception ex){
	ex.printStackTrace();
}
finally {
	oRolBE=null;
	oRolDA=null;
}
return oListaRolBE;
}

public int insertarRolBE(RolBE oRolBE){
	int resultado=0;
	RolDA oRolDA = null;

try {
	oRolDA=new RolDA();
	resultado=oRolDA.insertarRolBE(oRolBE);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally {
	oRolBE=null;
	oRolDA=null;
}
return resultado;
}


    public int insertarRegistrosRolBE(ArrayList<RolBE> oListaRolBE){
       int resultado=0;
        RolDA oRolDA=null;

        try {
            oRolDA=new RolDA();
            resultado=oRolDA.insertarRegistrosRolBE(oListaRolBE);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        finally
        {
            oListaRolBE=null;
            oRolDA=null;
        }
        return resultado;
    }


public int actualizarRolBE(RolBE oRolBE1){
        int resultado=0;
        RolDA oRolDA=null;
        try {
            oRolDA=new RolDA();
            resultado=oRolDA.actualizarRolBE(oRolBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oRolBE1=null;
            oRolDA=null;
        }

        return resultado;
    }

public int eliminarRolBE(RolBE oRolBE1){
        int resultado=0;
        RolDA oRolDA=null;
        try {
            oRolDA=new RolDA();
            resultado=oRolDA.eliminarRolBE(oRolBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oRolBE1=null;
            oRolDA=null;
        }

        return resultado;
    }

public List listObjectRolBE(RolBE oRolBE1){
        List list = new LinkedList();
        RolDA oRolDA=null;
        try {
            oRolDA=new RolDA();
            list=oRolDA.listObjectRolBE(oRolBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oRolBE1=null;
            oRolDA=null;
        }

        return list;
    }


}
