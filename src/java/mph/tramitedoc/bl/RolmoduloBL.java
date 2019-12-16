package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.RolmoduloBE;
import mph.tramitedoc.da.RolmoduloDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class RolmoduloBL {

    public RolmoduloBL() {
    }

    public RolmoduloBE listarRolmoduloBE(RolmoduloBE oRolmoduloBE1) {
        RolmoduloBE oRolmoduloBE = null;
        RolmoduloDA oRolmoduloDA = null;
        try {
            oRolmoduloDA = new RolmoduloDA();
            oRolmoduloBE = oRolmoduloDA.listarRolmoduloBE(oRolmoduloBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRolmoduloBE1 = null;
            oRolmoduloDA = null;
        }
        return oRolmoduloBE;
    }

    public ArrayList<RolmoduloBE> listarRegistrosRolmoduloBE(RolmoduloBE oRolmoduloBE) {
        ArrayList<RolmoduloBE> oListaRolmoduloBE = null;
        RolmoduloDA oRolmoduloDA = null;
        try {
            oRolmoduloDA = new RolmoduloDA();
            oListaRolmoduloBE = oRolmoduloDA.listarRegistroRolmoduloBE(oRolmoduloBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRolmoduloBE = null;
            oRolmoduloDA = null;
        }
        return oListaRolmoduloBE;
    }

    public int insertarRolmoduloBE(RolmoduloBE oRolmoduloBE) {
        int resultado = 0;
        RolmoduloDA oRolmoduloDA = null;

        try {
            oRolmoduloDA = new RolmoduloDA();
            resultado = oRolmoduloDA.insertarRolmoduloBE(oRolmoduloBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRolmoduloBE = null;
            oRolmoduloDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosRolmoduloBE(ArrayList<RolmoduloBE> oListaRolmoduloBE) {
        int resultado = 0;
        RolmoduloDA oRolmoduloDA = null;

        try {
            oRolmoduloDA = new RolmoduloDA();
            resultado = oRolmoduloDA.insertarRegistrosRolmoduloBE(oListaRolmoduloBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaRolmoduloBE = null;
            oRolmoduloDA = null;
        }
        return resultado;
    }

    public int actualizarRolmoduloBE(RolmoduloBE oRolmoduloBE1) {
        int resultado = 0;
        RolmoduloDA oRolmoduloDA = null;
        try {
            oRolmoduloDA = new RolmoduloDA();
            resultado = oRolmoduloDA.actualizarRolmoduloBE(oRolmoduloBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRolmoduloBE1 = null;
            oRolmoduloDA = null;
        }

        return resultado;
    }

    public int eliminarRolmoduloBE(RolmoduloBE oRolmoduloBE1) {
        int resultado = 0;
        RolmoduloDA oRolmoduloDA = null;
        try {
            oRolmoduloDA = new RolmoduloDA();
            resultado = oRolmoduloDA.eliminarRolmoduloBE(oRolmoduloBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRolmoduloBE1 = null;
            oRolmoduloDA = null;
        }

        return resultado;
    }

    public List listObjectRolmoduloBE(RolmoduloBE oRolmoduloBE1) {
        List list = new LinkedList();
        RolmoduloDA oRolmoduloDA = null;
        try {
            oRolmoduloDA = new RolmoduloDA();
            list = oRolmoduloDA.listObjectRolmoduloBE(oRolmoduloBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oRolmoduloBE1 = null;
            oRolmoduloDA = null;
        }

        return list;
    }

}
