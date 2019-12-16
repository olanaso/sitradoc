package mph.tramitedoc.bl;


//@autor Sergio Medina


import mph.tramitedoc.be.DocumentomensajeBE;
import mph.tramitedoc.da.DocumentomensajeDA;
import java.util.ArrayList;
public class DocumentomensajeBL {
public DocumentomensajeBL() {
}
 public DocumentomensajeBE listarDocumentomensajeBE(DocumentomensajeBE oDocumentomensajeBE1) {
	DocumentomensajeBE oDocumentomensajeBE=null;
	DocumentomensajeDA oDocumentomensajeDA=null;
try{
	oDocumentomensajeDA=new DocumentomensajeDA();
	oDocumentomensajeBE=oDocumentomensajeDA.listarDocumentomensajeBE(oDocumentomensajeBE1);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally{
	oDocumentomensajeBE1=null;
	oDocumentomensajeDA=null;
}
return oDocumentomensajeBE;
}
public ArrayList<DocumentomensajeBE> listarRegistrosDocumentomensajeBE(DocumentomensajeBE oDocumentomensajeBE){
ArrayList<DocumentomensajeBE> oListaDocumentomensajeBE=null;
DocumentomensajeDA oDocumentomensajeDA=null;
try{
	oDocumentomensajeDA=new DocumentomensajeDA();
	oListaDocumentomensajeBE=oDocumentomensajeDA.listarRegistroDocumentomensajeBE(oDocumentomensajeBE);
}
catch(Exception ex){
	ex.printStackTrace();
}
finally {
	oDocumentomensajeBE=null;
	oDocumentomensajeDA=null;
}
return oListaDocumentomensajeBE;
}

public int insertarDocumentomensajeBE(DocumentomensajeBE oDocumentomensajeBE){
	int resultado=0;
	DocumentomensajeDA oDocumentomensajeDA = null;

try {
	oDocumentomensajeDA=new DocumentomensajeDA();
	resultado=oDocumentomensajeDA.insertarDocumentomensajeBE(oDocumentomensajeBE);
}
catch (Exception ex){
	ex.printStackTrace();
}
finally {
	oDocumentomensajeBE=null;
	oDocumentomensajeDA=null;
}
return resultado;
}


    public int insertarRegistrosDocumentomensajeBE(ArrayList<DocumentomensajeBE> oListaDocumentomensajeBE){
       int resultado=0;
        DocumentomensajeDA oDocumentomensajeDA=null;

        try {
            oDocumentomensajeDA=new DocumentomensajeDA();
            resultado=oDocumentomensajeDA.insertarRegistrosDocumentomensajeBE(oListaDocumentomensajeBE);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        finally
        {
            oListaDocumentomensajeBE=null;
            oDocumentomensajeDA=null;
        }
        return resultado;
    }


public int actualizarDocumentomensajeBE(DocumentomensajeBE oDocumentomensajeBE1){
        int resultado=0;
        DocumentomensajeDA oDocumentomensajeDA=null;
        try {
            oDocumentomensajeDA=new DocumentomensajeDA();
            resultado=oDocumentomensajeDA.actualizarDocumentomensajeBE(oDocumentomensajeBE1);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
       finally
        {
            oDocumentomensajeBE1=null;
            oDocumentomensajeDA=null;
        }

        return resultado;
    }


}
