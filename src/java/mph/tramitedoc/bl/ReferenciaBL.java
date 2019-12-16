package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.ReferenciaBE;
import mph.tramitedoc.da.ReferenciaDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class ReferenciaBL {

    public ReferenciaBL() {
    }

    public ReferenciaBE listarReferenciaBE(ReferenciaBE oReferenciaBE1) {
        ReferenciaBE oReferenciaBE = null;
        ReferenciaDA oReferenciaDA = null;
        try {
            oReferenciaDA = new ReferenciaDA();
            oReferenciaBE = oReferenciaDA.listarReferenciaBE(oReferenciaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oReferenciaBE1 = null;
            oReferenciaDA = null;
        }
        return oReferenciaBE;
    }

    public ArrayList<ReferenciaBE> listarRegistrosReferenciaBE(ReferenciaBE oReferenciaBE) {
        ArrayList<ReferenciaBE> oListaReferenciaBE = null;
        ReferenciaDA oReferenciaDA = null;
        try {
            oReferenciaDA = new ReferenciaDA();
            oListaReferenciaBE = oReferenciaDA.listarRegistroReferenciaBE(oReferenciaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oReferenciaBE = null;
            oReferenciaDA = null;
        }
        return oListaReferenciaBE;
    }

    public int insertarReferenciaBE(ReferenciaBE oReferenciaBE) {
        int resultado = 0;
        ReferenciaDA oReferenciaDA = null;

        try {
            oReferenciaDA = new ReferenciaDA();
            resultado = oReferenciaDA.insertarReferenciaBE(oReferenciaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oReferenciaBE = null;
            oReferenciaDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosReferenciaBE(ArrayList<ReferenciaBE> oListaReferenciaBE) {
        int resultado = 0;
        ReferenciaDA oReferenciaDA = null;

        try {
            oReferenciaDA = new ReferenciaDA();
            resultado = oReferenciaDA.insertarRegistrosReferenciaBE(oListaReferenciaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaReferenciaBE = null;
            oReferenciaDA = null;
        }
        return resultado;
    }

    public int actualizarReferenciaBE(ReferenciaBE oReferenciaBE1) {
        int resultado = 0;
        ReferenciaDA oReferenciaDA = null;
        try {
            oReferenciaDA = new ReferenciaDA();
            resultado = oReferenciaDA.actualizarReferenciaBE(oReferenciaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oReferenciaBE1 = null;
            oReferenciaDA = null;
        }

        return resultado;
    }

    public int eliminarReferenciaBE(ReferenciaBE oReferenciaBE1) {
        int resultado = 0;
        ReferenciaDA oReferenciaDA = null;
        try {
            oReferenciaDA = new ReferenciaDA();
            resultado = oReferenciaDA.eliminarReferenciaBE(oReferenciaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oReferenciaBE1 = null;
            oReferenciaDA = null;
        }

        return resultado;
    }

    public List listObjectReferenciaBE(ReferenciaBE oReferenciaBE1) {
        List list = new LinkedList();
        ReferenciaDA oReferenciaDA = null;
        try {
            oReferenciaDA = new ReferenciaDA();
            list = oReferenciaDA.listObjectReferenciaBE(oReferenciaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oReferenciaBE1 = null;
            oReferenciaDA = null;
        }

        return list;
    }

}
