package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.FeriadoBE;
import mph.tramitedoc.da.FeriadoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class FeriadoBL {

    public FeriadoBL() {
    }

    public FeriadoBE listarFeriadoBE(FeriadoBE oFeriadoBE1) {
        FeriadoBE oFeriadoBE = null;
        FeriadoDA oFeriadoDA = null;
        try {
            oFeriadoDA = new FeriadoDA();
            oFeriadoBE = oFeriadoDA.listarFeriadoBE(oFeriadoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFeriadoBE1 = null;
            oFeriadoDA = null;
        }
        return oFeriadoBE;
    }

    public ArrayList<FeriadoBE> listarRegistrosFeriadoBE(FeriadoBE oFeriadoBE) {
        ArrayList<FeriadoBE> oListaFeriadoBE = null;
        FeriadoDA oFeriadoDA = null;
        try {
            oFeriadoDA = new FeriadoDA();
            oListaFeriadoBE = oFeriadoDA.listarRegistroFeriadoBE(oFeriadoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFeriadoBE = null;
            oFeriadoDA = null;
        }
        return oListaFeriadoBE;
    }

    public int insertarFeriadoBE(FeriadoBE oFeriadoBE) {
        int resultado = 0;
        FeriadoDA oFeriadoDA = null;

        try {
            oFeriadoDA = new FeriadoDA();
            resultado = oFeriadoDA.insertarFeriadoBE(oFeriadoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFeriadoBE = null;
            oFeriadoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosFeriadoBE(ArrayList<FeriadoBE> oListaFeriadoBE) {
        int resultado = 0;
        FeriadoDA oFeriadoDA = null;

        try {
            oFeriadoDA = new FeriadoDA();
            resultado = oFeriadoDA.insertarRegistrosFeriadoBE(oListaFeriadoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaFeriadoBE = null;
            oFeriadoDA = null;
        }
        return resultado;
    }

    public int actualizarFeriadoBE(FeriadoBE oFeriadoBE1) {
        int resultado = 0;
        FeriadoDA oFeriadoDA = null;
        try {
            oFeriadoDA = new FeriadoDA();
            resultado = oFeriadoDA.actualizarFeriadoBE(oFeriadoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFeriadoBE1 = null;
            oFeriadoDA = null;
        }

        return resultado;
    }

    public int eliminarFeriadoBE(FeriadoBE oFeriadoBE1) {
        int resultado = 0;
        FeriadoDA oFeriadoDA = null;
        try {
            oFeriadoDA = new FeriadoDA();
            resultado = oFeriadoDA.eliminarFeriadoBE(oFeriadoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFeriadoBE1 = null;
            oFeriadoDA = null;
        }

        return resultado;
    }

    public List listObjectFeriadoBE(FeriadoBE oFeriadoBE1) {
        List list = new LinkedList();
        FeriadoDA oFeriadoDA = null;
        try {
            oFeriadoDA = new FeriadoDA();
            list = oFeriadoDA.listObjectFeriadoBE(oFeriadoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFeriadoBE1 = null;
            oFeriadoDA = null;
        }

        return list;
    }

}
