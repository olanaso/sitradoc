package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.ArchivodocumentoBE;
import mph.tramitedoc.da.ArchivodocumentoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class ArchivodocumentoBL {

    public ArchivodocumentoBL() {
    }

    public ArchivodocumentoBE listarArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE1) {
        ArchivodocumentoBE oArchivodocumentoBE = null;
        ArchivodocumentoDA oArchivodocumentoDA = null;
        try {
            oArchivodocumentoDA = new ArchivodocumentoDA();
            oArchivodocumentoBE = oArchivodocumentoDA.listarArchivodocumentoBE(oArchivodocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivodocumentoBE1 = null;
            oArchivodocumentoDA = null;
        }
        return oArchivodocumentoBE;
    }

    public ArrayList<ArchivodocumentoBE> listarRegistrosArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE) {
        ArrayList<ArchivodocumentoBE> oListaArchivodocumentoBE = null;
        ArchivodocumentoDA oArchivodocumentoDA = null;
        try {
            oArchivodocumentoDA = new ArchivodocumentoDA();
            oListaArchivodocumentoBE = oArchivodocumentoDA.listarRegistroArchivodocumentoBE(oArchivodocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivodocumentoBE = null;
            oArchivodocumentoDA = null;
        }
        return oListaArchivodocumentoBE;
    }

    public int insertarArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE) {
        int resultado = 0;
        ArchivodocumentoDA oArchivodocumentoDA = null;

        try {
            oArchivodocumentoDA = new ArchivodocumentoDA();
            resultado = oArchivodocumentoDA.insertarArchivodocumentoBE(oArchivodocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivodocumentoBE = null;
            oArchivodocumentoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosArchivodocumentoBE(ArrayList<ArchivodocumentoBE> oListaArchivodocumentoBE) {
        int resultado = 0;
        ArchivodocumentoDA oArchivodocumentoDA = null;

        try {
            oArchivodocumentoDA = new ArchivodocumentoDA();
            resultado = oArchivodocumentoDA.insertarRegistrosArchivodocumentoBE(oListaArchivodocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaArchivodocumentoBE = null;
            oArchivodocumentoDA = null;
        }
        return resultado;
    }

    public int actualizarArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE1) {
        int resultado = 0;
        ArchivodocumentoDA oArchivodocumentoDA = null;
        try {
            oArchivodocumentoDA = new ArchivodocumentoDA();
            resultado = oArchivodocumentoDA.actualizarArchivodocumentoBE(oArchivodocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivodocumentoBE1 = null;
            oArchivodocumentoDA = null;
        }

        return resultado;
    }

    public int eliminarArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE1) {
        int resultado = 0;
        ArchivodocumentoDA oArchivodocumentoDA = null;
        try {
            oArchivodocumentoDA = new ArchivodocumentoDA();
            resultado = oArchivodocumentoDA.eliminarArchivodocumentoBE(oArchivodocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivodocumentoBE1 = null;
            oArchivodocumentoDA = null;
        }

        return resultado;
    }

    public List listObjectArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE1) {
        List list = new LinkedList();
        ArchivodocumentoDA oArchivodocumentoDA = null;
        try {
            oArchivodocumentoDA = new ArchivodocumentoDA();
            list = oArchivodocumentoDA.listObjectArchivodocumentoBE(oArchivodocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivodocumentoBE1 = null;
            oArchivodocumentoDA = null;
        }

        return list;
    }

}
