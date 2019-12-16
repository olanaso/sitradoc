package mph.tramitedoc.bl;


//@autor Sergio Medina


import mph.tramitedoc.be.ReglaBE;
import mph.tramitedoc.da.ReglaDA;
import java.util.ArrayList;import java.util.LinkedList;
import java.util.List;
public class ReglaBL {
public ReglaBL() {
}
 public ReglaBE listarReglaBE(ReglaBE oReglaBE1) {
	ReglaBE oReglaBE=null;
	ReglaDA oReglaDA=null;
try{
	oReglaDA=new ReglaDA();
	oReglaBE=oReglaDA.listarReglaBE(oReglaBE1);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally{
	oReglaBE1=null;
	oReglaDA=null;
}
return oReglaBE;
}
public ArrayList<ReglaBE> listarRegistrosReglaBE(ReglaBE oReglaBE){
ArrayList<ReglaBE> oListaReglaBE=null;
ReglaDA oReglaDA=null;
try{
	oReglaDA=new ReglaDA();
	oListaReglaBE=oReglaDA.listarRegistroReglaBE(oReglaBE);
}
catch(Exception ex){
	ex.printStackTrace();
}
finally {
	oReglaBE=null;
	oReglaDA=null;
}
return oListaReglaBE;
}

public int insertarReglaBE(ReglaBE oReglaBE){
	int resultado=0;
	ReglaDA oReglaDA = null;

try {
	oReglaDA=new ReglaDA();
	resultado=oReglaDA.insertarReglaBE(oReglaBE);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally {
	oReglaBE=null;
	oReglaDA=null;
}
return resultado;
}


    public int insertarRegistrosReglaBE(ArrayList<ReglaBE> oListaReglaBE){
       int resultado=0;
        ReglaDA oReglaDA=null;

        try {
            oReglaDA=new ReglaDA();
            resultado=oReglaDA.insertarRegistrosReglaBE(oListaReglaBE);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        finally
        {
            oListaReglaBE=null;
            oReglaDA=null;
        }
        return resultado;
    }


public int actualizarReglaBE(ReglaBE oReglaBE1){
        int resultado=0;
        ReglaDA oReglaDA=null;
        try {
            oReglaDA=new ReglaDA();
            resultado=oReglaDA.actualizarReglaBE(oReglaBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oReglaBE1=null;
            oReglaDA=null;
        }

        return resultado;
    }

public int eliminarReglaBE(ReglaBE oReglaBE1){
        int resultado=0;
        ReglaDA oReglaDA=null;
        try {
            oReglaDA=new ReglaDA();
            resultado=oReglaDA.eliminarReglaBE(oReglaBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oReglaBE1=null;
            oReglaDA=null;
        }

        return resultado;
    }

public List listObjectReglaBE(ReglaBE oReglaBE1){
        List list = new LinkedList();
        ReglaDA oReglaDA=null;
        try {
            oReglaDA=new ReglaDA();
            list=oReglaDA.listObjectReglaBE(oReglaBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oReglaBE1=null;
            oReglaDA=null;
        }

        return list;
    }


}
