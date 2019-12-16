package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.ExpedienteBE;
import mph.tramitedoc.da.ExpedienteDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.JQObjectBE;

public class ExpedienteBL {

    public ExpedienteBL() {
    }

    public ExpedienteBE listarExpedienteBE(ExpedienteBE oExpedienteBE1) {
        ExpedienteBE oExpedienteBE = null;
        ExpedienteDA oExpedienteDA = null;
        try {
            oExpedienteDA = new ExpedienteDA();
            oExpedienteBE = oExpedienteDA.listarExpedienteBE(oExpedienteBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienteBE1 = null;
            oExpedienteDA = null;
            
        }
        return oExpedienteBE;
    }

    public ArrayList<ExpedienteBE> listarRegistrosExpedienteBE(ExpedienteBE oExpedienteBE) {
        ArrayList<ExpedienteBE> oListaExpedienteBE = null;
        ExpedienteDA oExpedienteDA = null;
        try {
            oExpedienteDA = new ExpedienteDA();
            oListaExpedienteBE = oExpedienteDA.listarRegistroExpedienteBE(oExpedienteBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienteBE = null;
            oExpedienteDA = null;
        }
        return oListaExpedienteBE;
    }
    
    
     public JQObjectBE  listarJQRegistroExpedienteBE(ExpedienteBE oExpedienteBE) {
        JQObjectBE oJQObjectBE = null;
        ExpedienteDA oExpedienteDA = null;
        try {
            oExpedienteDA = new ExpedienteDA();
            oJQObjectBE = oExpedienteDA.listarJQRegistroExpedienteBE(oExpedienteBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienteBE = null;
            oExpedienteDA = null;
        }
        return oJQObjectBE;
    }

    public int insertarExpedienteBE(ExpedienteBE oExpedienteBE) {
        int resultado = 0;
        ExpedienteDA oExpedienteDA = null;

        try {
            oExpedienteDA = new ExpedienteDA();
            resultado = oExpedienteDA.insertarExpedienteBE(oExpedienteBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienteBE = null;
            oExpedienteDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosExpedienteBE(ArrayList<ExpedienteBE> oListaExpedienteBE) {
        int resultado = 0;
        ExpedienteDA oExpedienteDA = null;

        try {
            oExpedienteDA = new ExpedienteDA();
            resultado = oExpedienteDA.insertarRegistrosExpedienteBE(oListaExpedienteBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaExpedienteBE = null;
            oExpedienteDA = null;
        }
        return resultado;
    }

    public int actualizarRegistrosExpedienteBE(ArrayList<ExpedienteBE> oListaExpedienteBE) {
        int resultado = 0;
        ExpedienteDA oExpedienteDA = null;

        try {
            oExpedienteDA = new ExpedienteDA();
            resultado = oExpedienteDA.actualizarRegistrosExpedienteBE(oListaExpedienteBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaExpedienteBE = null;
            oExpedienteDA = null;
        }
        return resultado;
    }

    public int actualizarExpedienteBE(ExpedienteBE oExpedienteBE1) {
        int resultado = 0;
        ExpedienteDA oExpedienteDA = null;
        try {
            oExpedienteDA = new ExpedienteDA();
            resultado = oExpedienteDA.actualizarExpedienteBE(oExpedienteBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienteBE1 = null;
            oExpedienteDA = null;
        }

        return resultado;
    }

    
      public int derivarExpedienteBE(ExpedienteBE oExpedienteBE1) {
        int resultado = 0;
        ExpedienteDA oExpedienteDA = null;
        try {
            oExpedienteDA = new ExpedienteDA();
            resultado = oExpedienteDA.derivarExpedienteBE(oExpedienteBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienteBE1 = null;
            oExpedienteDA = null;
        }

        return resultado;
    }
      
    public int eliminarExpedienteBE(ExpedienteBE oExpedienteBE1) {
        int resultado = 0;
        ExpedienteDA oExpedienteDA = null;
        try {
            oExpedienteDA = new ExpedienteDA();
            resultado = oExpedienteDA.eliminarExpedienteBE(oExpedienteBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienteBE1 = null;
            oExpedienteDA = null;
        }

        return resultado;
    }

    public List listObjectExpedienteBE(ExpedienteBE oExpedienteBE1) {
        List list = new LinkedList();
        ExpedienteDA oExpedienteDA = null;
        try {
            oExpedienteDA = new ExpedienteDA();
            list = oExpedienteDA.listObjectExpedienteBE(oExpedienteBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oExpedienteBE1 = null;
            oExpedienteDA = null;
        }

        return list;
    }

}
