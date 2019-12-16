package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.UsuariogrupoBE;
import mph.tramitedoc.da.UsuariogrupoDA;
import java.util.ArrayList;

public class UsuariogrupoBL {

    public UsuariogrupoBL() {
    }

    public UsuariogrupoBE listarUsuariogrupoBE(UsuariogrupoBE oUsuariogrupoBE1) {
        UsuariogrupoBE oUsuariogrupoBE = null;
        UsuariogrupoDA oUsuariogrupoDA = null;
        try {
            oUsuariogrupoDA = new UsuariogrupoDA();
            oUsuariogrupoBE = oUsuariogrupoDA.listarUsuariogrupoBE(oUsuariogrupoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariogrupoBE1 = null;
            oUsuariogrupoDA = null;
        }
        return oUsuariogrupoBE;
    }

    public ArrayList<UsuariogrupoBE> listarRegistrosUsuariogrupoBE(UsuariogrupoBE oUsuariogrupoBE) {
        ArrayList<UsuariogrupoBE> oListaUsuariogrupoBE = null;
        UsuariogrupoDA oUsuariogrupoDA = null;
        try {
            oUsuariogrupoDA = new UsuariogrupoDA();
            oListaUsuariogrupoBE = oUsuariogrupoDA.listarRegistroUsuariogrupoBE(oUsuariogrupoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariogrupoBE = null;
            oUsuariogrupoDA = null;
        }
        return oListaUsuariogrupoBE;
    }

    public int insertarUsuariogrupoBE(UsuariogrupoBE oUsuariogrupoBE) {
        int resultado = 0;
        UsuariogrupoDA oUsuariogrupoDA = null;

        try {
            oUsuariogrupoDA = new UsuariogrupoDA();
            resultado = oUsuariogrupoDA.insertarUsuariogrupoBE(oUsuariogrupoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariogrupoBE = null;
            oUsuariogrupoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosUsuariogrupoBE(ArrayList<UsuariogrupoBE> oListaUsuariogrupoBE) {
        int resultado = 0;
        UsuariogrupoDA oUsuariogrupoDA = null;

        try {
            oUsuariogrupoDA = new UsuariogrupoDA();
            resultado = oUsuariogrupoDA.insertarRegistrosUsuariogrupoBE(oListaUsuariogrupoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaUsuariogrupoBE = null;
            oUsuariogrupoDA = null;
        }
        return resultado;
    }

    public int actualizarUsuariogrupoBE(UsuariogrupoBE oUsuariogrupoBE1) {
        int resultado = 0;
        UsuariogrupoDA oUsuariogrupoDA = null;
        try {
            oUsuariogrupoDA = new UsuariogrupoDA();
            resultado = oUsuariogrupoDA.actualizarUsuariogrupoBE(oUsuariogrupoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariogrupoBE1 = null;
            oUsuariogrupoDA = null;
        }

        return resultado;
    }

}
