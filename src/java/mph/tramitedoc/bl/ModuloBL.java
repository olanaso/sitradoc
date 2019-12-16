package mph.tramitedoc.bl;


//@autor Sergio Medina


import mph.tramitedoc.be.ModuloBE;
import mph.tramitedoc.da.ModuloDA;
import java.util.ArrayList;import java.util.LinkedList;
import java.util.List;
public class ModuloBL {
public ModuloBL() {
}
 public ModuloBE listarModuloBE(ModuloBE oModuloBE1) {
	ModuloBE oModuloBE=null;
	ModuloDA oModuloDA=null;
try{
	oModuloDA=new ModuloDA();
	oModuloBE=oModuloDA.listarModuloBE(oModuloBE1);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally{
	oModuloBE1=null;
	oModuloDA=null;
}
return oModuloBE;
}
public ArrayList<ModuloBE> listarRegistrosModuloBE(ModuloBE oModuloBE){
ArrayList<ModuloBE> oListaModuloBE=null;
ModuloDA oModuloDA=null;
try{
	oModuloDA=new ModuloDA();
	oListaModuloBE=oModuloDA.listarRegistroModuloBE(oModuloBE);
}
catch(Exception ex){
	ex.printStackTrace();
}
finally {
	oModuloBE=null;
	oModuloDA=null;
}
return oListaModuloBE;
}

public int insertarModuloBE(ModuloBE oModuloBE){
	int resultado=0;
	ModuloDA oModuloDA = null;

try {
	oModuloDA=new ModuloDA();
	resultado=oModuloDA.insertarModuloBE(oModuloBE);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally {
	oModuloBE=null;
	oModuloDA=null;
}
return resultado;
}


    public int insertarRegistrosModuloBE(ArrayList<ModuloBE> oListaModuloBE){
       int resultado=0;
        ModuloDA oModuloDA=null;

        try {
            oModuloDA=new ModuloDA();
            resultado=oModuloDA.insertarRegistrosModuloBE(oListaModuloBE);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        finally
        {
            oListaModuloBE=null;
            oModuloDA=null;
        }
        return resultado;
    }


public int actualizarModuloBE(ModuloBE oModuloBE1){
        int resultado=0;
        ModuloDA oModuloDA=null;
        try {
            oModuloDA=new ModuloDA();
            resultado=oModuloDA.actualizarModuloBE(oModuloBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oModuloBE1=null;
            oModuloDA=null;
        }

        return resultado;
    }

public int eliminarModuloBE(ModuloBE oModuloBE1){
        int resultado=0;
        ModuloDA oModuloDA=null;
        try {
            oModuloDA=new ModuloDA();
            resultado=oModuloDA.eliminarModuloBE(oModuloBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oModuloBE1=null;
            oModuloDA=null;
        }

        return resultado;
    }

public List listObjectModuloBE(ModuloBE oModuloBE1){
        List list = new LinkedList();
        ModuloDA oModuloDA=null;
        try {
            oModuloDA=new ModuloDA();
            list=oModuloDA.listObjectModuloBE(oModuloBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oModuloBE1=null;
            oModuloDA=null;
        }

        return list;
    }


}
