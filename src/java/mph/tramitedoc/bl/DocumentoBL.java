package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.DocumentoBE;
import mph.tramitedoc.da.DocumentoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.ExpedienteBE;
import mph.tramitedoc.be.JQObjectBE;

public class DocumentoBL {

    public DocumentoBL() {
    }

    public DocumentoBE listarDocumentoBE(DocumentoBE oDocumentoBE1) {
        DocumentoBE oDocumentoBE = null;
        DocumentoDA oDocumentoDA = null;
        try {
            oDocumentoDA = new DocumentoDA();
            oDocumentoBE = oDocumentoDA.listarDocumentoBE(oDocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oDocumentoBE1 = null;
            oDocumentoDA = null;
        }
        return oDocumentoBE;
    }

    public ArrayList<DocumentoBE> listarRegistrosDocumentoBE(DocumentoBE oDocumentoBE) {
        ArrayList<DocumentoBE> oListaDocumentoBE = null;
        DocumentoDA oDocumentoDA = null;
        try {
            oDocumentoDA = new DocumentoDA();
            oListaDocumentoBE = oDocumentoDA.listarRegistroDocumentoBE(oDocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oDocumentoBE = null;
            oDocumentoDA = null;
        }
        return oListaDocumentoBE;
    }

    public int insertarDocumentoBE(DocumentoBE oDocumentoBE) {
        int resultado = 0;
        DocumentoDA oDocumentoDA = null;

        try {
            oDocumentoDA = new DocumentoDA();
            resultado = oDocumentoDA.insertarDocumentoBE(oDocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oDocumentoBE = null;
            oDocumentoDA = null;
        }
        return resultado;
    }

    public int actualizarRegistrosDocumentoBE(ArrayList<DocumentoBE> oListaDocumentos) {

        DocumentoDA oDocumentoDA = null;
        int res = 0;
        try {
            oDocumentoDA = new DocumentoDA();
            res = oDocumentoDA.actualizarRegistrosDocumentoBE(oListaDocumentos);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {

            oDocumentoDA = null;
        }
        return res;
    }

    public int derivarDocumentoBE(DocumentoBE oDocumentoBE) {
        int resultado = 0;
        DocumentoDA oDocumentoDA = null;

        try {
            oDocumentoDA = new DocumentoDA();
            resultado = oDocumentoDA.derivarDocumentoBE(oDocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oDocumentoBE = null;
            oDocumentoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosDocumentoBE(ArrayList<DocumentoBE> oListaDocumentoBE) {
        int resultado = 0;
        DocumentoDA oDocumentoDA = null;

        try {
            oDocumentoDA = new DocumentoDA();
            resultado = oDocumentoDA.insertarRegistrosDocumentoBE(oListaDocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaDocumentoBE = null;
            oDocumentoDA = null;
        }
        return resultado;
    }

    public int actualizarDocumentoBE(DocumentoBE oDocumentoBE1) {
        int resultado = 0;
        DocumentoDA oDocumentoDA = null;
        try {
            oDocumentoDA = new DocumentoDA();
            resultado = oDocumentoDA.actualizarDocumentoBE(oDocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oDocumentoBE1 = null;
            oDocumentoDA = null;
        }

        return resultado;
    }

    public int eliminarDocumentoBE(DocumentoBE oDocumentoBE1) {
        int resultado = 0;
        DocumentoDA oDocumentoDA = null;
        try {
            oDocumentoDA = new DocumentoDA();
            resultado = oDocumentoDA.eliminarDocumentoBE(oDocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oDocumentoBE1 = null;
            oDocumentoDA = null;
        }

        return resultado;
    }

    public List listObjectDocumentoBE(DocumentoBE oDocumentoBE1) {
        List list = new LinkedList();
        DocumentoDA oDocumentoDA = null;
        try {
            oDocumentoDA = new DocumentoDA();
            list = oDocumentoDA.listObjectDocumentoBE(oDocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oDocumentoBE1 = null;
            oDocumentoDA = null;
        }

        return list;
    }

    public JQObjectBE listarJQRegistroDocumentoBE(DocumentoBE oDocumentoBE1) {
        JQObjectBE oJQObjectBE = null;
        DocumentoDA oDocumentoDA = null;
        try {
            oDocumentoDA = new DocumentoDA();
            oJQObjectBE = oDocumentoDA.listarJQRegistroDocumentoBE(oDocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oDocumentoBE1 = null;
            oDocumentoDA = null;
        }
        return oJQObjectBE;
    }
}
