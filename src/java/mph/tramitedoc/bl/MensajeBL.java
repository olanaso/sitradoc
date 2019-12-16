package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.MensajeBE;
import mph.tramitedoc.da.MensajeDA;
import java.util.ArrayList;

public class MensajeBL {

    public MensajeBL() {
    }

    public MensajeBE listarMensajeBE(MensajeBE oMensajeBE1) {
        MensajeBE oMensajeBE = null;
        MensajeDA oMensajeDA = null;
        try {
            oMensajeDA = new MensajeDA();
            oMensajeBE = oMensajeDA.listarMensajeBE(oMensajeBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oMensajeBE1 = null;
            oMensajeDA = null;
        }
        return oMensajeBE;
    }

    public ArrayList<MensajeBE> listarRegistrosMensajeBE(MensajeBE oMensajeBE) {
        ArrayList<MensajeBE> oListaMensajeBE = null;
        MensajeDA oMensajeDA = null;
        try {
            oMensajeDA = new MensajeDA();
            oListaMensajeBE = oMensajeDA.listarRegistroMensajeBE(oMensajeBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oMensajeBE = null;
            oMensajeDA = null;
        }
        return oListaMensajeBE;
    }

    public int insertarMensajeBE(MensajeBE oMensajeBE) {
        int resultado = 0;
        MensajeDA oMensajeDA = null;

        try {
            oMensajeDA = new MensajeDA();
            resultado = oMensajeDA.insertarMensajeBE(oMensajeBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oMensajeBE = null;
            oMensajeDA = null;
        }
        return resultado;
    }

    public int crearMensajeBE(MensajeBE oMensajeBE) {
        int resultado = 0;
        MensajeDA oMensajeDA = null;

        try {
            oMensajeDA = new MensajeDA();
            resultado = oMensajeDA.crearMensajeBE(oMensajeBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oMensajeBE = null;
            oMensajeDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosMensajeBE(ArrayList<MensajeBE> oListaMensajeBE) {
        int resultado = 0;
        MensajeDA oMensajeDA = null;

        try {
            oMensajeDA = new MensajeDA();
            resultado = oMensajeDA.insertarRegistrosMensajeBE(oListaMensajeBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaMensajeBE = null;
            oMensajeDA = null;
        }
        return resultado;
    }

    public int actualizarMensajeBE(MensajeBE oMensajeBE1) {
        int resultado = 0;
        MensajeDA oMensajeDA = null;
        try {
            oMensajeDA = new MensajeDA();
            resultado = oMensajeDA.actualizarMensajeBE(oMensajeBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oMensajeBE1 = null;
            oMensajeDA = null;
        }

        return resultado;
    }

}
