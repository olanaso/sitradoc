package mph.tramitedoc.bl;


//@autor Sergio Medina


import mph.tramitedoc.be.RecepcioninternaBE;
import mph.tramitedoc.da.RecepcioninternaDA;
import java.util.ArrayList;
public class RecepcioninternaBL {
public RecepcioninternaBL() {
}
 public RecepcioninternaBE listarRecepcioninternaBE(RecepcioninternaBE oRecepcioninternaBE1) {
	RecepcioninternaBE oRecepcioninternaBE=null;
	RecepcioninternaDA oRecepcioninternaDA=null;
try{
	oRecepcioninternaDA=new RecepcioninternaDA();
	oRecepcioninternaBE=oRecepcioninternaDA.listarRecepcioninternaBE(oRecepcioninternaBE1);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally{
	oRecepcioninternaBE1=null;
	oRecepcioninternaDA=null;
}
return oRecepcioninternaBE;
}
public ArrayList<RecepcioninternaBE> listarRegistrosRecepcioninternaBE(RecepcioninternaBE oRecepcioninternaBE){
ArrayList<RecepcioninternaBE> oListaRecepcioninternaBE=null;
RecepcioninternaDA oRecepcioninternaDA=null;
try{
	oRecepcioninternaDA=new RecepcioninternaDA();
	oListaRecepcioninternaBE=oRecepcioninternaDA.listarRegistroRecepcioninternaBE(oRecepcioninternaBE);
}
catch(Exception ex){
	ex.printStackTrace();
}
finally {
	oRecepcioninternaBE=null;
	oRecepcioninternaDA=null;
}
return oListaRecepcioninternaBE;
}

public int insertarRecepcioninternaBE(RecepcioninternaBE oRecepcioninternaBE){
	int resultado=0;
	RecepcioninternaDA oRecepcioninternaDA = null;

try {
	oRecepcioninternaDA=new RecepcioninternaDA();
	resultado=oRecepcioninternaDA.insertarRecepcioninternaBE(oRecepcioninternaBE);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally {
	oRecepcioninternaBE=null;
	oRecepcioninternaDA=null;
}
return resultado;
}


    public int insertarRegistrosRecepcioninternaBE(ArrayList<RecepcioninternaBE> oListaRecepcioninternaBE){
       int resultado=0;
        RecepcioninternaDA oRecepcioninternaDA=null;

        try {
            oRecepcioninternaDA=new RecepcioninternaDA();
            resultado=oRecepcioninternaDA.insertarRegistrosRecepcioninternaBE(oListaRecepcioninternaBE);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        finally
        {
            oListaRecepcioninternaBE=null;
            oRecepcioninternaDA=null;
        }
        return resultado;
    }


public int actualizarRecepcioninternaBE(RecepcioninternaBE oRecepcioninternaBE1){
        int resultado=0;
        RecepcioninternaDA oRecepcioninternaDA=null;
        try {
            oRecepcioninternaDA=new RecepcioninternaDA();
            resultado=oRecepcioninternaDA.actualizarRecepcioninternaBE(oRecepcioninternaBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oRecepcioninternaBE1=null;
            oRecepcioninternaDA=null;
        }

        return resultado;
    }


}
