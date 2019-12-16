package mph.tramitedoc.bl;


//@autor Sergio Medina


import mph.tramitedoc.be.ArchivoBE;
import mph.tramitedoc.da.ArchivoDA;
import java.util.ArrayList;import java.util.LinkedList;
import java.util.List;
public class ArchivoBL {
public ArchivoBL() {
}
 public ArchivoBE listarArchivoBE(ArchivoBE oArchivoBE1) {
	ArchivoBE oArchivoBE=null;
	ArchivoDA oArchivoDA=null;
try{
	oArchivoDA=new ArchivoDA();
	oArchivoBE=oArchivoDA.listarArchivoBE(oArchivoBE1);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally{
	oArchivoBE1=null;
	oArchivoDA=null;
}
return oArchivoBE;
}
public ArrayList<ArchivoBE> listarRegistrosArchivoBE(ArchivoBE oArchivoBE){
ArrayList<ArchivoBE> oListaArchivoBE=null;
ArchivoDA oArchivoDA=null;
try{
	oArchivoDA=new ArchivoDA();
	oListaArchivoBE=oArchivoDA.listarRegistroArchivoBE(oArchivoBE);
}
catch(Exception ex){
	ex.printStackTrace();
}
finally {
	oArchivoBE=null;
	oArchivoDA=null;
}
return oListaArchivoBE;
}

public int insertarArchivoBE(ArchivoBE oArchivoBE){
	int resultado=0;
	ArchivoDA oArchivoDA = null;

try {
	oArchivoDA=new ArchivoDA();
	resultado=oArchivoDA.insertarArchivoBE(oArchivoBE);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally {
	oArchivoBE=null;
	oArchivoDA=null;
}
return resultado;
}


    public int insertarRegistrosArchivoBE(ArrayList<ArchivoBE> oListaArchivoBE){
       int resultado=0;
        ArchivoDA oArchivoDA=null;

        try {
            oArchivoDA=new ArchivoDA();
            resultado=oArchivoDA.insertarRegistrosArchivoBE(oListaArchivoBE);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        finally
        {
            oListaArchivoBE=null;
            oArchivoDA=null;
        }
        return resultado;
    }


public int actualizarArchivoBE(ArchivoBE oArchivoBE1){
        int resultado=0;
        ArchivoDA oArchivoDA=null;
        try {
            oArchivoDA=new ArchivoDA();
            resultado=oArchivoDA.actualizarArchivoBE(oArchivoBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oArchivoBE1=null;
            oArchivoDA=null;
        }

        return resultado;
    }

public int eliminarArchivoBE(ArchivoBE oArchivoBE1){
        int resultado=0;
        ArchivoDA oArchivoDA=null;
        try {
            oArchivoDA=new ArchivoDA();
            resultado=oArchivoDA.eliminarArchivoBE(oArchivoBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oArchivoBE1=null;
            oArchivoDA=null;
        }

        return resultado;
    }

public List listObjectArchivoBE(ArchivoBE oArchivoBE1){
        List list = new LinkedList();
        ArchivoDA oArchivoDA=null;
        try {
            oArchivoDA=new ArchivoDA();
            list=oArchivoDA.listObjectArchivoBE(oArchivoBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oArchivoBE1=null;
            oArchivoDA=null;
        }

        return list;
    }


}
