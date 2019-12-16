package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.RequisitosBE;
import mph.tramitedoc.da.RequisitosDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class RequisitosBL {

    public RequisitosBL() {
    }

    public RequisitosBE listarRequisitosBE(RequisitosBE oRequisitosBE1) {
        RequisitosBE oRequisitosBE = null;
        RequisitosDA oRequisitosDA = null;
        try {
            oRequisitosDA = new RequisitosDA();
            oRequisitosBE = oRequisitosDA.listarRequisitosBE(oRequisitosBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRequisitosBE1 = null;
            oRequisitosDA = null;
        }
        return oRequisitosBE;
    }

    public ArrayList<RequisitosBE> listarRegistrosRequisitosBE(RequisitosBE oRequisitosBE) {
        ArrayList<RequisitosBE> oListaRequisitosBE = null;
        RequisitosDA oRequisitosDA = null;
        try {
            oRequisitosDA = new RequisitosDA();
            oListaRequisitosBE = oRequisitosDA.listarRegistroRequisitosBE(oRequisitosBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRequisitosBE = null;
            oRequisitosDA = null;
        }
        return oListaRequisitosBE;
    }

    public int insertarRequisitosBE(RequisitosBE oRequisitosBE) {
        int resultado = 0;
        RequisitosDA oRequisitosDA = null;

        try {
            oRequisitosDA = new RequisitosDA();
            resultado = oRequisitosDA.insertarRequisitosBE(oRequisitosBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRequisitosBE = null;
            oRequisitosDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosRequisitosBE(ArrayList<RequisitosBE> oListaRequisitosBE) {
        int resultado = 0;
        RequisitosDA oRequisitosDA = null;

        try {
            oRequisitosDA = new RequisitosDA();
            resultado = oRequisitosDA.insertarRegistrosRequisitosBE(oListaRequisitosBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaRequisitosBE = null;
            oRequisitosDA = null;
        }
        return resultado;
    }

    public int actualizarRequisitosBE(RequisitosBE oRequisitosBE1) {
        int resultado = 0;
        RequisitosDA oRequisitosDA = null;
        try {
            oRequisitosDA = new RequisitosDA();
            resultado = oRequisitosDA.actualizarRequisitosBE(oRequisitosBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRequisitosBE1 = null;
            oRequisitosDA = null;
        }

        return resultado;
    }

    public int eliminarRequisitosBE(RequisitosBE oRequisitosBE1) {
        int resultado = 0;
        RequisitosDA oRequisitosDA = null;
        try {
            oRequisitosDA = new RequisitosDA();
            resultado = oRequisitosDA.eliminarRequisitosBE(oRequisitosBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRequisitosBE1 = null;
            oRequisitosDA = null;
        }

        return resultado;
    }

    public List listObjectRequisitosBE(RequisitosBE oRequisitosBE1) {
        List list = new LinkedList();
        RequisitosDA oRequisitosDA = null;
        try {
            oRequisitosDA = new RequisitosDA();
            list = oRequisitosDA.listObjectRequisitosBE(oRequisitosBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRequisitosBE1 = null;
            oRequisitosDA = null;
        }

        return list;
    }

}
