package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.AreagrupoBE;
import mph.tramitedoc.da.AreagrupoDA;
import java.util.ArrayList;

public class AreagrupoBL {

    public AreagrupoBL() {
    }

    public AreagrupoBE listarAreagrupoBE(AreagrupoBE oAreagrupoBE1) {
        AreagrupoBE oAreagrupoBE = null;
        AreagrupoDA oAreagrupoDA = null;
        try {
            oAreagrupoDA = new AreagrupoDA();
            oAreagrupoBE = oAreagrupoDA.listarAreagrupoBE(oAreagrupoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreagrupoBE1 = null;
            oAreagrupoDA = null;
        }
        return oAreagrupoBE;
    }

    public ArrayList<AreagrupoBE> listarRegistrosAreagrupoBE(AreagrupoBE oAreagrupoBE) {
        ArrayList<AreagrupoBE> oListaAreagrupoBE = null;
        AreagrupoDA oAreagrupoDA = null;
        try {
            oAreagrupoDA = new AreagrupoDA();
            oListaAreagrupoBE = oAreagrupoDA.listarRegistroAreagrupoBE(oAreagrupoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreagrupoBE = null;
            oAreagrupoDA = null;
        }
        return oListaAreagrupoBE;
    }

    public int insertarAreagrupoBE(AreagrupoBE oAreagrupoBE) {
        int resultado = 0;
        AreagrupoDA oAreagrupoDA = null;

        try {
            oAreagrupoDA = new AreagrupoDA();
            resultado = oAreagrupoDA.insertarAreagrupoBE(oAreagrupoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreagrupoBE = null;
            oAreagrupoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosAreagrupoBE(ArrayList<AreagrupoBE> oListaAreagrupoBE) {
        int resultado = 0;
        AreagrupoDA oAreagrupoDA = null;

        try {
            oAreagrupoDA = new AreagrupoDA();
            resultado = oAreagrupoDA.insertarRegistrosAreagrupoBE(oListaAreagrupoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaAreagrupoBE = null;
            oAreagrupoDA = null;
        }
        return resultado;
    }

    public int actualizarAreagrupoBE(AreagrupoBE oAreagrupoBE1) {
        int resultado = 0;
        AreagrupoDA oAreagrupoDA = null;
        try {
            oAreagrupoDA = new AreagrupoDA();
            resultado = oAreagrupoDA.actualizarAreagrupoBE(oAreagrupoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreagrupoBE1 = null;
            oAreagrupoDA = null;
        }

        return resultado;
    }

}
