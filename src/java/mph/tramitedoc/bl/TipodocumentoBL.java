package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.TipodocumentoBE;
import mph.tramitedoc.da.TipodocumentoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class TipodocumentoBL {

    public TipodocumentoBL() {
    }

    public TipodocumentoBE listarTipodocumentoBE(TipodocumentoBE oTipodocumentoBE1) {
        TipodocumentoBE oTipodocumentoBE = null;
        TipodocumentoDA oTipodocumentoDA = null;
        try {
            oTipodocumentoDA = new TipodocumentoDA();
            oTipodocumentoBE = oTipodocumentoDA.listarTipodocumentoBE(oTipodocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipodocumentoBE1 = null;
            oTipodocumentoDA = null;
        }
        return oTipodocumentoBE;
    }

    public ArrayList<TipodocumentoBE> listarRegistrosTipodocumentoBE(TipodocumentoBE oTipodocumentoBE) {
        ArrayList<TipodocumentoBE> oListaTipodocumentoBE = null;
        TipodocumentoDA oTipodocumentoDA = null;
        try {
            oTipodocumentoDA = new TipodocumentoDA();
            oListaTipodocumentoBE = oTipodocumentoDA.listarRegistroTipodocumentoBE(oTipodocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipodocumentoBE = null;
            oTipodocumentoDA = null;
        }
        return oListaTipodocumentoBE;
    }

    public int insertarTipodocumentoBE(TipodocumentoBE oTipodocumentoBE) {
        int resultado = 0;
        TipodocumentoDA oTipodocumentoDA = null;

        try {
            oTipodocumentoDA = new TipodocumentoDA();
            resultado = oTipodocumentoDA.insertarTipodocumentoBE(oTipodocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipodocumentoBE = null;
            oTipodocumentoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosTipodocumentoBE(ArrayList<TipodocumentoBE> oListaTipodocumentoBE) {
        int resultado = 0;
        TipodocumentoDA oTipodocumentoDA = null;

        try {
            oTipodocumentoDA = new TipodocumentoDA();
            resultado = oTipodocumentoDA.insertarRegistrosTipodocumentoBE(oListaTipodocumentoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaTipodocumentoBE = null;
            oTipodocumentoDA = null;
        }
        return resultado;
    }

    public int actualizarTipodocumentoBE(TipodocumentoBE oTipodocumentoBE1) {
        int resultado = 0;
        TipodocumentoDA oTipodocumentoDA = null;
        try {
            oTipodocumentoDA = new TipodocumentoDA();
            resultado = oTipodocumentoDA.actualizarTipodocumentoBE(oTipodocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipodocumentoBE1 = null;
            oTipodocumentoDA = null;
        }

        return resultado;
    }

    public int eliminarTipodocumentoBE(TipodocumentoBE oTipodocumentoBE1) {
        int resultado = 0;
        TipodocumentoDA oTipodocumentoDA = null;
        try {
            oTipodocumentoDA = new TipodocumentoDA();
            resultado = oTipodocumentoDA.eliminarTipodocumentoBE(oTipodocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipodocumentoBE1 = null;
            oTipodocumentoDA = null;
        }

        return resultado;
    }

    public List listObjectTipodocumentoBE(TipodocumentoBE oTipodocumentoBE1) {
        List list = new LinkedList();
        TipodocumentoDA oTipodocumentoDA = null;
        try {
            oTipodocumentoDA = new TipodocumentoDA();
            list = oTipodocumentoDA.listObjectTipodocumentoBE(oTipodocumentoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipodocumentoBE1 = null;
            oTipodocumentoDA = null;
        }

        return list;
    }

}
