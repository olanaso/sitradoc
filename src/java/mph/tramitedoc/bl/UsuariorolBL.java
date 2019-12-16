package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.UsuariorolBE;
import mph.tramitedoc.da.UsuariorolDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class UsuariorolBL {

    public UsuariorolBL() {
    }

    public UsuariorolBE listarUsuariorolBE(UsuariorolBE oUsuariorolBE1) {
        UsuariorolBE oUsuariorolBE = null;
        UsuariorolDA oUsuariorolDA = null;
        try {
            oUsuariorolDA = new UsuariorolDA();
            oUsuariorolBE = oUsuariorolDA.listarUsuariorolBE(oUsuariorolBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariorolBE1 = null;
            oUsuariorolDA = null;
        }
        return oUsuariorolBE;
    }

    public ArrayList<UsuariorolBE> listarRegistrosUsuariorolBE(UsuariorolBE oUsuariorolBE) {
        ArrayList<UsuariorolBE> oListaUsuariorolBE = null;
        UsuariorolDA oUsuariorolDA = null;
        try {
            oUsuariorolDA = new UsuariorolDA();
            oListaUsuariorolBE = oUsuariorolDA.listarRegistroUsuariorolBE(oUsuariorolBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariorolBE = null;
            oUsuariorolDA = null;
        }
        return oListaUsuariorolBE;
    }

    public int insertarUsuariorolBE(UsuariorolBE oUsuariorolBE) {
        int resultado = 0;
        UsuariorolDA oUsuariorolDA = null;

        try {
            oUsuariorolDA = new UsuariorolDA();
            resultado = oUsuariorolDA.insertarUsuariorolBE(oUsuariorolBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariorolBE = null;
            oUsuariorolDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosUsuariorolBE(ArrayList<UsuariorolBE> oListaUsuariorolBE) {
        int resultado = 0;
        UsuariorolDA oUsuariorolDA = null;

        try {
            oUsuariorolDA = new UsuariorolDA();
            resultado = oUsuariorolDA.insertarRegistrosUsuariorolBE(oListaUsuariorolBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaUsuariorolBE = null;
            oUsuariorolDA = null;
        }
        return resultado;
    }

    public int actualizarUsuariorolBE(UsuariorolBE oUsuariorolBE1) {
        int resultado = 0;
        UsuariorolDA oUsuariorolDA = null;
        try {
            oUsuariorolDA = new UsuariorolDA();
            resultado = oUsuariorolDA.actualizarUsuariorolBE(oUsuariorolBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariorolBE1 = null;
            oUsuariorolDA = null;
        }

        return resultado;
    }

    public int eliminarUsuariorolBE(UsuariorolBE oUsuariorolBE1) {
        int resultado = 0;
        UsuariorolDA oUsuariorolDA = null;
        try {
            oUsuariorolDA = new UsuariorolDA();
            resultado = oUsuariorolDA.eliminarUsuariorolBE(oUsuariorolBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariorolBE1 = null;
            oUsuariorolDA = null;
        }

        return resultado;
    }

    public List listObjectUsuariorolBE(UsuariorolBE oUsuariorolBE1) {
        List list = new LinkedList();
        UsuariorolDA oUsuariorolDA = null;
        try {
            oUsuariorolDA = new UsuariorolDA();
            list = oUsuariorolDA.listObjectUsuariorolBE(oUsuariorolBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariorolBE1 = null;
            oUsuariorolDA = null;
        }

        return list;
    }

}
