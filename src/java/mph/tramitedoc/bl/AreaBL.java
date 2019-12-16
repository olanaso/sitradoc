package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.AreaBE;
import mph.tramitedoc.da.AreaDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class AreaBL {

    public AreaBL() {
    }

    public AreaBE listarAreaBE(AreaBE oAreaBE1) {
        AreaBE oAreaBE = null;
        AreaDA oAreaDA = null;
        try {
            oAreaDA = new AreaDA();
            oAreaBE = oAreaDA.listarAreaBE(oAreaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreaBE1 = null;
            oAreaDA = null;
        }
        return oAreaBE;
    }

    public ArrayList<AreaBE> listarRegistrosAreaBE(AreaBE oAreaBE) {
        ArrayList<AreaBE> oListaAreaBE = null;
        AreaDA oAreaDA = null;
        try {
            oAreaDA = new AreaDA();
            oListaAreaBE = oAreaDA.listarRegistroAreaBE(oAreaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreaBE = null;
            oAreaDA = null;
        }
        return oListaAreaBE;
    }

    public int insertarAreaBE(AreaBE oAreaBE) {
        int resultado = 0;
        AreaDA oAreaDA = null;

        try {
            oAreaDA = new AreaDA();
            resultado = oAreaDA.insertarAreaBE(oAreaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreaBE = null;
            oAreaDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosAreaBE(ArrayList<AreaBE> oListaAreaBE) {
        int resultado = 0;
        AreaDA oAreaDA = null;

        try {
            oAreaDA = new AreaDA();
            resultado = oAreaDA.insertarRegistrosAreaBE(oListaAreaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaAreaBE = null;
            oAreaDA = null;
        }
        return resultado;
    }

    public int actualizarAreaBE(AreaBE oAreaBE1) {
        int resultado = 0;
        AreaDA oAreaDA = null;
        try {
            oAreaDA = new AreaDA();
            resultado = oAreaDA.actualizarAreaBE(oAreaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreaBE1 = null;
            oAreaDA = null;
        }

        return resultado;
    }

    public int eliminarAreaBE(AreaBE oAreaBE1) {
        int resultado = 0;
        AreaDA oAreaDA = null;
        try {
            oAreaDA = new AreaDA();
            resultado = oAreaDA.eliminarAreaBE(oAreaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreaBE1 = null;
            oAreaDA = null;
        }

        return resultado;
    }

    public List listObjectAreaBE(AreaBE oAreaBE1) {
        List list = new LinkedList();
        AreaDA oAreaDA = null;
        try {
            oAreaDA = new AreaDA();
            list = oAreaDA.listObjectAreaBE(oAreaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreaBE1 = null;
            oAreaDA = null;
        }

        return list;
    }

    public String getJSON(AreaBE oAreaBE) {
        String json = "";
        AreaDA oAreaDA = null;
        try {
            oAreaDA = new AreaDA();
            json = oAreaDA.getJSON(oAreaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAreaBE = null;
            oAreaDA = null;
        }

        return json;
    }
    
   

}
