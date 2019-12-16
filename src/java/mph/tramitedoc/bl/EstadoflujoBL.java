package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.EstadoflujoBE;
import mph.tramitedoc.da.EstadoflujoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class EstadoflujoBL {

    public EstadoflujoBL() {
    }

    public EstadoflujoBE listarEstadoflujoBE(EstadoflujoBE oEstadoflujoBE1) {
        EstadoflujoBE oEstadoflujoBE = null;
        EstadoflujoDA oEstadoflujoDA = null;
        try {
            oEstadoflujoDA = new EstadoflujoDA();
            oEstadoflujoBE = oEstadoflujoDA.listarEstadoflujoBE(oEstadoflujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadoflujoBE1 = null;
            oEstadoflujoDA = null;
        }
        return oEstadoflujoBE;
    }

    public ArrayList<EstadoflujoBE> listarRegistrosEstadoflujoBE(EstadoflujoBE oEstadoflujoBE) {
        ArrayList<EstadoflujoBE> oListaEstadoflujoBE = null;
        EstadoflujoDA oEstadoflujoDA = null;
        try {
            oEstadoflujoDA = new EstadoflujoDA();
            oListaEstadoflujoBE = oEstadoflujoDA.listarRegistroEstadoflujoBE(oEstadoflujoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadoflujoBE = null;
            oEstadoflujoDA = null;
        }
        return oListaEstadoflujoBE;
    }

    public int insertarEstadoflujoBE(EstadoflujoBE oEstadoflujoBE) {
        int resultado = 0;
        EstadoflujoDA oEstadoflujoDA = null;

        try {
            oEstadoflujoDA = new EstadoflujoDA();
            resultado = oEstadoflujoDA.insertarEstadoflujoBE(oEstadoflujoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadoflujoBE = null;
            oEstadoflujoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosEstadoflujoBE(ArrayList<EstadoflujoBE> oListaEstadoflujoBE) {
        int resultado = 0;
        EstadoflujoDA oEstadoflujoDA = null;

        try {
            oEstadoflujoDA = new EstadoflujoDA();
            resultado = oEstadoflujoDA.insertarRegistrosEstadoflujoBE(oListaEstadoflujoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaEstadoflujoBE = null;
            oEstadoflujoDA = null;
        }
        return resultado;
    }

    public int actualizarEstadoflujoBE(EstadoflujoBE oEstadoflujoBE1) {
        int resultado = 0;
        EstadoflujoDA oEstadoflujoDA = null;
        try {
            oEstadoflujoDA = new EstadoflujoDA();
            resultado = oEstadoflujoDA.actualizarEstadoflujoBE(oEstadoflujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadoflujoBE1 = null;
            oEstadoflujoDA = null;
        }

        return resultado;
    }

    public int eliminarEstadoflujoBE(EstadoflujoBE oEstadoflujoBE1) {
        int resultado = 0;
        EstadoflujoDA oEstadoflujoDA = null;
        try {
            oEstadoflujoDA = new EstadoflujoDA();
            resultado = oEstadoflujoDA.eliminarEstadoflujoBE(oEstadoflujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadoflujoBE1 = null;
            oEstadoflujoDA = null;
        }

        return resultado;
    }

    public List listObjectEstadoflujoBE(EstadoflujoBE oEstadoflujoBE1) {
        List list = new LinkedList();
        EstadoflujoDA oEstadoflujoDA = null;
        try {
            oEstadoflujoDA = new EstadoflujoDA();
            list = oEstadoflujoDA.listObjectEstadoflujoBE(oEstadoflujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEstadoflujoBE1 = null;
            oEstadoflujoDA = null;
        }

        return list;
    }

}
