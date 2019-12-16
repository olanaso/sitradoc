package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.CargoBE;
import mph.tramitedoc.da.CargoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class CargoBL {

    public CargoBL() {
    }

    public CargoBE listarCargoBE(CargoBE oCargoBE1) {
        CargoBE oCargoBE = null;
        CargoDA oCargoDA = null;
        try {
            oCargoDA = new CargoDA();
            oCargoBE = oCargoDA.listarCargoBE(oCargoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oCargoBE1 = null;
            oCargoDA = null;
        }
        return oCargoBE;
    }

    public ArrayList<CargoBE> listarRegistrosCargoBE(CargoBE oCargoBE) {
        ArrayList<CargoBE> oListaCargoBE = null;
        CargoDA oCargoDA = null;
        try {
            oCargoDA = new CargoDA();
            oListaCargoBE = oCargoDA.listarRegistroCargoBE(oCargoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oCargoBE = null;
            oCargoDA = null;
        }
        return oListaCargoBE;
    }

    public int insertarCargoBE(CargoBE oCargoBE) {
        int resultado = 0;
        CargoDA oCargoDA = null;

        try {
            oCargoDA = new CargoDA();
            resultado = oCargoDA.insertarCargoBE(oCargoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oCargoBE = null;
            oCargoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosCargoBE(ArrayList<CargoBE> oListaCargoBE) {
        int resultado = 0;
        CargoDA oCargoDA = null;

        try {
            oCargoDA = new CargoDA();
            resultado = oCargoDA.insertarRegistrosCargoBE(oListaCargoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaCargoBE = null;
            oCargoDA = null;
        }
        return resultado;
    }

    public int actualizarCargoBE(CargoBE oCargoBE1) {
        int resultado = 0;
        CargoDA oCargoDA = null;
        try {
            oCargoDA = new CargoDA();
            resultado = oCargoDA.actualizarCargoBE(oCargoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oCargoBE1 = null;
            oCargoDA = null;
        }

        return resultado;
    }

    public int eliminarCargoBE(CargoBE oCargoBE1) {
        int resultado = 0;
        CargoDA oCargoDA = null;
        try {
            oCargoDA = new CargoDA();
            resultado = oCargoDA.eliminarCargoBE(oCargoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oCargoBE1 = null;
            oCargoDA = null;
        }

        return resultado;
    }

    public List listObjectCargoBE(CargoBE oCargoBE1) {
        List list = new LinkedList();
        CargoDA oCargoDA = null;
        try {
            oCargoDA = new CargoDA();
            list = oCargoDA.listObjectCargoBE(oCargoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oCargoBE1 = null;
            oCargoDA = null;
        }

        return list;
    }

}
