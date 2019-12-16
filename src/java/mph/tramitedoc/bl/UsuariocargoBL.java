package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.UsuariocargoBE;
import mph.tramitedoc.da.UsuariocargoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class UsuariocargoBL {

    public UsuariocargoBL() {
    }

    public UsuariocargoBE listarUsuariocargoBE(UsuariocargoBE oUsuariocargoBE1) {
        UsuariocargoBE oUsuariocargoBE = null;
        UsuariocargoDA oUsuariocargoDA = null;
        try {
            oUsuariocargoDA = new UsuariocargoDA();
            oUsuariocargoBE = oUsuariocargoDA.listarUsuariocargoBE(oUsuariocargoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariocargoBE1 = null;
            oUsuariocargoDA = null;
        }
        return oUsuariocargoBE;
    }

    public ArrayList<UsuariocargoBE> listarRegistrosUsuariocargoBE(UsuariocargoBE oUsuariocargoBE) {
        ArrayList<UsuariocargoBE> oListaUsuariocargoBE = null;
        UsuariocargoDA oUsuariocargoDA = null;
        try {
            oUsuariocargoDA = new UsuariocargoDA();
            oListaUsuariocargoBE = oUsuariocargoDA.listarRegistroUsuariocargoBE(oUsuariocargoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariocargoBE = null;
            oUsuariocargoDA = null;
        }
        return oListaUsuariocargoBE;
    }

    public int insertarUsuariocargoBE(UsuariocargoBE oUsuariocargoBE) {
        int resultado = 0;
        UsuariocargoDA oUsuariocargoDA = null;

        try {
            oUsuariocargoDA = new UsuariocargoDA();
            resultado = oUsuariocargoDA.insertarUsuariocargoBE(oUsuariocargoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariocargoBE = null;
            oUsuariocargoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosUsuariocargoBE(ArrayList<UsuariocargoBE> oListaUsuariocargoBE) {
        int resultado = 0;
        UsuariocargoDA oUsuariocargoDA = null;

        try {
            oUsuariocargoDA = new UsuariocargoDA();
            resultado = oUsuariocargoDA.insertarRegistrosUsuariocargoBE(oListaUsuariocargoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaUsuariocargoBE = null;
            oUsuariocargoDA = null;
        }
        return resultado;
    }

    public int actualizarUsuariocargoBE(UsuariocargoBE oUsuariocargoBE1) {
        int resultado = 0;
        UsuariocargoDA oUsuariocargoDA = null;
        try {
            oUsuariocargoDA = new UsuariocargoDA();
            resultado = oUsuariocargoDA.actualizarUsuariocargoBE(oUsuariocargoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariocargoBE1 = null;
            oUsuariocargoDA = null;
        }

        return resultado;
    }

    public int eliminarUsuariocargoBE(UsuariocargoBE oUsuariocargoBE1) {
        int resultado = 0;
        UsuariocargoDA oUsuariocargoDA = null;
        try {
            oUsuariocargoDA = new UsuariocargoDA();
            resultado = oUsuariocargoDA.eliminarUsuariocargoBE(oUsuariocargoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariocargoBE1 = null;
            oUsuariocargoDA = null;
        }

        return resultado;
    }

    public List listObjectUsuariocargoBE(UsuariocargoBE oUsuariocargoBE1) {
        List list = new LinkedList();
        UsuariocargoDA oUsuariocargoDA = null;
        try {
            oUsuariocargoDA = new UsuariocargoDA();
            list = oUsuariocargoDA.listObjectUsuariocargoBE(oUsuariocargoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oUsuariocargoBE1 = null;
            oUsuariocargoDA = null;
        }

        return list;
    }

}
