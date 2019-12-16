package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.EstadobandejaBE;
import mph.tramitedoc.da.EstadobandejaDA;
import java.util.ArrayList;

public class EstadobandejaBL {

    public EstadobandejaBL() {
    }

    public EstadobandejaBE listarEstadobandejaBE(EstadobandejaBE oEstadobandejaBE1) {
        EstadobandejaBE oEstadobandejaBE = null;
        EstadobandejaDA oEstadobandejaDA = null;
        try {
            oEstadobandejaDA = new EstadobandejaDA();
            oEstadobandejaBE = oEstadobandejaDA.listarEstadobandejaBE(oEstadobandejaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadobandejaBE1 = null;
            oEstadobandejaDA = null;
        }
        return oEstadobandejaBE;
    }

    public ArrayList<EstadobandejaBE> listarRegistrosEstadobandejaBE(EstadobandejaBE oEstadobandejaBE) {
        ArrayList<EstadobandejaBE> oListaEstadobandejaBE = null;
        EstadobandejaDA oEstadobandejaDA = null;
        try {
            oEstadobandejaDA = new EstadobandejaDA();
            oListaEstadobandejaBE = oEstadobandejaDA.listarRegistroEstadobandejaBE(oEstadobandejaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadobandejaBE = null;
            oEstadobandejaDA = null;
        }
        return oListaEstadobandejaBE;
    }

    public int insertarEstadobandejaBE(EstadobandejaBE oEstadobandejaBE) {
        int resultado = 0;
        EstadobandejaDA oEstadobandejaDA = null;

        try {
            oEstadobandejaDA = new EstadobandejaDA();
            resultado = oEstadobandejaDA.insertarEstadobandejaBE(oEstadobandejaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadobandejaBE = null;
            oEstadobandejaDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosEstadobandejaBE(ArrayList<EstadobandejaBE> oListaEstadobandejaBE) {
        int resultado = 0;
        EstadobandejaDA oEstadobandejaDA = null;

        try {
            oEstadobandejaDA = new EstadobandejaDA();
            resultado = oEstadobandejaDA.insertarRegistrosEstadobandejaBE(oListaEstadobandejaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaEstadobandejaBE = null;
            oEstadobandejaDA = null;
        }
        return resultado;
    }

    public int actualizarEstadobandejaBE(EstadobandejaBE oEstadobandejaBE1) {
        int resultado = 0;
        EstadobandejaDA oEstadobandejaDA = null;
        try {
            oEstadobandejaDA = new EstadobandejaDA();
            resultado = oEstadobandejaDA.actualizarEstadobandejaBE(oEstadobandejaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadobandejaBE1 = null;
            oEstadobandejaDA = null;
        }

        return resultado;
    }

}
