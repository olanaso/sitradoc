package mph.tramitedoc.bl;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.TipoprocedimientoBE;
import mph.tramitedoc.da.TipoprocedimientoDA;

public class TipoprocedimientoBL {
    public TipoprocedimientoBL() {
    }

    public TipoprocedimientoBE listarTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE1) {
        TipoprocedimientoBE oTipoprocedimientoBE = null;
        TipoprocedimientoDA oTipoprocedimientoDA = null;
        try {
            oTipoprocedimientoDA = new TipoprocedimientoDA();
            oTipoprocedimientoBE = oTipoprocedimientoDA.listarTipoprocedimientoBE(oTipoprocedimientoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipoprocedimientoBE1 = null;
            oTipoprocedimientoDA = null;
        }
        return oTipoprocedimientoBE;
    }

    public ArrayList<TipoprocedimientoBE> listarRegistrosTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE) {
        ArrayList<TipoprocedimientoBE> oListaTipoprocedimientoBE = null;
        TipoprocedimientoDA oTipoprocedimientoDA = null;
        try {
            oTipoprocedimientoDA = new TipoprocedimientoDA();
            oListaTipoprocedimientoBE = oTipoprocedimientoDA.listarRegistroTipoprocedimientoBE(oTipoprocedimientoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipoprocedimientoBE = null;
            oTipoprocedimientoDA = null;
        }
        return oListaTipoprocedimientoBE;
    }

    public int insertarTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE) {
        int resultado = 0;
        TipoprocedimientoDA oTipoprocedimientoDA = null;

        try {
            oTipoprocedimientoDA = new TipoprocedimientoDA();
            resultado = oTipoprocedimientoDA.insertarTipoprocedimientoBE(oTipoprocedimientoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipoprocedimientoBE = null;
            oTipoprocedimientoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosTipoprocedimientoBE(ArrayList<TipoprocedimientoBE> oListaTipoprocedimientoBE) {
        int resultado = 0;
        TipoprocedimientoDA oTipoprocedimientoDA = null;

        try {
            oTipoprocedimientoDA = new TipoprocedimientoDA();
            resultado = oTipoprocedimientoDA.insertarRegistrosTipoprocedimientoBE(oListaTipoprocedimientoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaTipoprocedimientoBE = null;
            oTipoprocedimientoDA = null;
        }
        return resultado;
    }

    public int actualizarTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE1) {
        int resultado = 0;
        TipoprocedimientoDA oTipoprocedimientoDA = null;
        try {
            oTipoprocedimientoDA = new TipoprocedimientoDA();
            resultado = oTipoprocedimientoDA.actualizarTipoprocedimientoBE(oTipoprocedimientoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipoprocedimientoBE1 = null;
            oTipoprocedimientoDA = null;
        }

        return resultado;
    }

    public int eliminarTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE1) {
        int resultado = 0;
        TipoprocedimientoDA oTipoprocedimientoDA = null;
        try {
            oTipoprocedimientoDA = new TipoprocedimientoDA();
            resultado = oTipoprocedimientoDA.eliminarTipoprocedimientoBE(oTipoprocedimientoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipoprocedimientoBE1 = null;
            oTipoprocedimientoDA = null;
        }

        return resultado;
    }

    public List listObjectTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE1) {
        List list = new LinkedList();
        TipoprocedimientoDA oTipoprocedimientoDA = null;
        try {
            oTipoprocedimientoDA = new TipoprocedimientoDA();
            list = oTipoprocedimientoDA.listObjectTipoprocedimientoBE(oTipoprocedimientoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oTipoprocedimientoBE1 = null;
            oTipoprocedimientoDA = null;
        }

        return list;
    }
}
