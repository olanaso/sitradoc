package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.ExpedienterequisitoBE;
import mph.tramitedoc.da.ExpedienterequisitoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class ExpedienterequisitoBL {

    public ExpedienterequisitoBL() {
    }

    public ExpedienterequisitoBE listarExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE1) {
        ExpedienterequisitoBE oExpedienterequisitoBE = null;
        ExpedienterequisitoDA oExpedienterequisitoDA = null;
        try {
            oExpedienterequisitoDA = new ExpedienterequisitoDA();
            oExpedienterequisitoBE = oExpedienterequisitoDA.listarExpedienterequisitoBE(oExpedienterequisitoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienterequisitoBE1 = null;
            oExpedienterequisitoDA = null;
        }
        return oExpedienterequisitoBE;
    }

    public ArrayList<ExpedienterequisitoBE> listarRegistrosExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE) {
        ArrayList<ExpedienterequisitoBE> oListaExpedienterequisitoBE = null;
        ExpedienterequisitoDA oExpedienterequisitoDA = null;
        try {
            oExpedienterequisitoDA = new ExpedienterequisitoDA();
            oListaExpedienterequisitoBE = oExpedienterequisitoDA.listarRegistroExpedienterequisitoBE(oExpedienterequisitoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienterequisitoBE = null;
            oExpedienterequisitoDA = null;
        }
        return oListaExpedienterequisitoBE;
    }

    public int insertarExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE) {
        int resultado = 0;
        ExpedienterequisitoDA oExpedienterequisitoDA = null;

        try {
            oExpedienterequisitoDA = new ExpedienterequisitoDA();
            resultado = oExpedienterequisitoDA.insertarExpedienterequisitoBE(oExpedienterequisitoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienterequisitoBE = null;
            oExpedienterequisitoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosExpedienterequisitoBE(ArrayList<ExpedienterequisitoBE> oListaExpedienterequisitoBE) {
        int resultado = 0;
        ExpedienterequisitoDA oExpedienterequisitoDA = null;

        try {
            oExpedienterequisitoDA = new ExpedienterequisitoDA();
            resultado = oExpedienterequisitoDA.insertarRegistrosExpedienterequisitoBE(oListaExpedienterequisitoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaExpedienterequisitoBE = null;
            oExpedienterequisitoDA = null;
        }
        return resultado;
    }

    public int actualizarRegistrosExpedienterequisitoBE(ArrayList<ExpedienterequisitoBE> oListaExpedienterequisitoBE, int idexpediente) {
        int resultado = 0;
        ExpedienterequisitoDA oExpedienterequisitoDA = null;
        try {
            oExpedienterequisitoDA = new ExpedienterequisitoDA();
            resultado = oExpedienterequisitoDA.actualizarRegistrosExpedienterequisitoBE(oListaExpedienterequisitoBE, idexpediente);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaExpedienterequisitoBE = null;
            oExpedienterequisitoDA = null;
        }
        return resultado;
    }

    public int actualizarExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE1) {
        int resultado = 0;
        ExpedienterequisitoDA oExpedienterequisitoDA = null;
        try {
            oExpedienterequisitoDA = new ExpedienterequisitoDA();
            resultado = oExpedienterequisitoDA.actualizarExpedienterequisitoBE(oExpedienterequisitoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienterequisitoBE1 = null;
            oExpedienterequisitoDA = null;
        }

        return resultado;
    }

    public int eliminarExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE1) {
        int resultado = 0;
        ExpedienterequisitoDA oExpedienterequisitoDA = null;
        try {
            oExpedienterequisitoDA = new ExpedienterequisitoDA();
            resultado = oExpedienterequisitoDA.eliminarExpedienterequisitoBE(oExpedienterequisitoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienterequisitoBE1 = null;
            oExpedienterequisitoDA = null;
        }

        return resultado;
    }

    public List listObjectExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE1) {
        List list = new LinkedList();
        ExpedienterequisitoDA oExpedienterequisitoDA = null;
        try {
            oExpedienterequisitoDA = new ExpedienterequisitoDA();
            list = oExpedienterequisitoDA.listObjectExpedienterequisitoBE(oExpedienterequisitoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienterequisitoBE1 = null;
            oExpedienterequisitoDA = null;
        }

        return list;
    }

}
