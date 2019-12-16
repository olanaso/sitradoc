package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.ProcedimientoBE;
import mph.tramitedoc.da.ProcedimientoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class ProcedimientoBL {

    public ProcedimientoBL() {
    }

    public ProcedimientoBE listarProcedimientoBE(ProcedimientoBE oProcedimientoBE1) {
        ProcedimientoBE oProcedimientoBE = null;
        ProcedimientoDA oProcedimientoDA = null;
        try {
            oProcedimientoDA = new ProcedimientoDA();
            oProcedimientoBE = oProcedimientoDA.listarProcedimientoBE(oProcedimientoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oProcedimientoBE1 = null;
            oProcedimientoDA = null;
        }
        return oProcedimientoBE;
    }

    public ArrayList<ProcedimientoBE> listarRegistrosProcedimientoBE(ProcedimientoBE oProcedimientoBE) {
        ArrayList<ProcedimientoBE> oListaProcedimientoBE = null;
        ProcedimientoDA oProcedimientoDA = null;
        try {
            oProcedimientoDA = new ProcedimientoDA();
            oListaProcedimientoBE = oProcedimientoDA.listarRegistroProcedimientoBE(oProcedimientoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oProcedimientoBE = null;
            oProcedimientoDA = null;
        }
        return oListaProcedimientoBE;
    }

    public int insertarProcedimientoBE(ProcedimientoBE oProcedimientoBE) {
        int resultado = 0;
        ProcedimientoDA oProcedimientoDA = null;

        try {
            oProcedimientoDA = new ProcedimientoDA();
            resultado = oProcedimientoDA.insertarProcedimientoBE(oProcedimientoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oProcedimientoBE = null;
            oProcedimientoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosProcedimientoBE(ArrayList<ProcedimientoBE> oListaProcedimientoBE) {
        int resultado = 0;
        ProcedimientoDA oProcedimientoDA = null;

        try {
            oProcedimientoDA = new ProcedimientoDA();
            resultado = oProcedimientoDA.insertarRegistrosProcedimientoBE(oListaProcedimientoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaProcedimientoBE = null;
            oProcedimientoDA = null;
        }
        return resultado;
    }

    public int actualizarProcedimientoBE(ProcedimientoBE oProcedimientoBE1) {
        int resultado = 0;
        ProcedimientoDA oProcedimientoDA = null;
        try {
            oProcedimientoDA = new ProcedimientoDA();
            resultado = oProcedimientoDA.actualizarProcedimientoBE(oProcedimientoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oProcedimientoBE1 = null;
            oProcedimientoDA = null;
        }

        return resultado;
    }

    public int eliminarProcedimientoBE(ProcedimientoBE oProcedimientoBE1) {
        int resultado = 0;
        ProcedimientoDA oProcedimientoDA = null;
        try {
            oProcedimientoDA = new ProcedimientoDA();
            resultado = oProcedimientoDA.eliminarProcedimientoBE(oProcedimientoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oProcedimientoBE1 = null;
            oProcedimientoDA = null;
        }

        return resultado;
    }

    public List listObjectProcedimientoBE(ProcedimientoBE oProcedimientoBE1) {
        List list = new LinkedList();
        ProcedimientoDA oProcedimientoDA = null;
        try {
            oProcedimientoDA = new ProcedimientoDA();
            list = oProcedimientoDA.listObjectProcedimientoBE(oProcedimientoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oProcedimientoBE1 = null;
            oProcedimientoDA = null;
        }

        return list;
    }

}
