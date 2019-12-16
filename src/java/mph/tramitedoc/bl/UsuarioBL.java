package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.UsuarioBE;
import mph.tramitedoc.da.UsuarioDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class UsuarioBL {

    public UsuarioBL() {
    }

    public UsuarioBE listarUsuarioBE(UsuarioBE oUsuarioBE1) {
        UsuarioBE oUsuarioBE = null;
        UsuarioDA oUsuarioDA = null;
        try {
            oUsuarioDA = new UsuarioDA();
            oUsuarioBE = oUsuarioDA.listarUsuarioBE(oUsuarioBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuarioBE1 = null;
            oUsuarioDA = null;
        }
        return oUsuarioBE;
    }

    public ArrayList<UsuarioBE> listarRegistrosUsuarioBE(UsuarioBE oUsuarioBE) {
        ArrayList<UsuarioBE> oListaUsuarioBE = null;
        UsuarioDA oUsuarioDA = null;
        try {
            oUsuarioDA = new UsuarioDA();
            oListaUsuarioBE = oUsuarioDA.listarRegistroUsuarioBE(oUsuarioBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuarioBE = null;
            oUsuarioDA = null;
        }
        return oListaUsuarioBE;
    }

    public int insertarUsuarioBE(UsuarioBE oUsuarioBE) {
        int resultado = 0;
        UsuarioDA oUsuarioDA = null;

        try {
            oUsuarioDA = new UsuarioDA();
            resultado = oUsuarioDA.insertarUsuarioBE(oUsuarioBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuarioBE = null;
            oUsuarioDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosUsuarioBE(ArrayList<UsuarioBE> oListaUsuarioBE) {
        int resultado = 0;
        UsuarioDA oUsuarioDA = null;

        try {
            oUsuarioDA = new UsuarioDA();
            resultado = oUsuarioDA.insertarRegistrosUsuarioBE(oListaUsuarioBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaUsuarioBE = null;
            oUsuarioDA = null;
        }
        return resultado;
    }

    public int actualizarUsuarioBE(UsuarioBE oUsuarioBE1) {
        int resultado = 0;
        UsuarioDA oUsuarioDA = null;
        try {
            oUsuarioDA = new UsuarioDA();
            resultado = oUsuarioDA.actualizarUsuarioBE(oUsuarioBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuarioBE1 = null;
            oUsuarioDA = null;
        }

        return resultado;
    }

    public int eliminarUsuarioBE(UsuarioBE oUsuarioBE1) {
        int resultado = 0;
        UsuarioDA oUsuarioDA = null;
        try {
            oUsuarioDA = new UsuarioDA();
            resultado = oUsuarioDA.eliminarUsuarioBE(oUsuarioBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuarioBE1 = null;
            oUsuarioDA = null;
        }

        return resultado;
    }

    public List listObjectUsuarioBE(UsuarioBE oUsuarioBE1) {
        List list = new LinkedList();
        UsuarioDA oUsuarioDA = null;
        try {
            oUsuarioDA = new UsuarioDA();
            list = oUsuarioDA.listObjectUsuarioBE(oUsuarioBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuarioBE1 = null;
            oUsuarioDA = null;
        }

        return list;
    }

}
