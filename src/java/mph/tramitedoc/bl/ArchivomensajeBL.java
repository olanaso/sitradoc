package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.ArchivomensajeBE;
import mph.tramitedoc.da.ArchivomensajeDA;
import java.util.ArrayList;

public class ArchivomensajeBL {

    public ArchivomensajeBL() {
    }

    public ArchivomensajeBE listarArchivomensajeBE(ArchivomensajeBE oArchivomensajeBE1) {
        ArchivomensajeBE oArchivomensajeBE = null;
        ArchivomensajeDA oArchivomensajeDA = null;
        try {
            oArchivomensajeDA = new ArchivomensajeDA();
            oArchivomensajeBE = oArchivomensajeDA.listarArchivomensajeBE(oArchivomensajeBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivomensajeBE1 = null;
            oArchivomensajeDA = null;
        }
        return oArchivomensajeBE;
    }

    public ArrayList<ArchivomensajeBE> listarRegistrosArchivomensajeBE(ArchivomensajeBE oArchivomensajeBE) {
        ArrayList<ArchivomensajeBE> oListaArchivomensajeBE = null;
        ArchivomensajeDA oArchivomensajeDA = null;
        try {
            oArchivomensajeDA = new ArchivomensajeDA();
            oListaArchivomensajeBE = oArchivomensajeDA.listarRegistroArchivomensajeBE(oArchivomensajeBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivomensajeBE = null;
            oArchivomensajeDA = null;
        }
        return oListaArchivomensajeBE;
    }

    public int insertarArchivomensajeBE(ArchivomensajeBE oArchivomensajeBE) {
        int resultado = 0;
        ArchivomensajeDA oArchivomensajeDA = null;

        try {
            oArchivomensajeDA = new ArchivomensajeDA();
            resultado = oArchivomensajeDA.insertarArchivomensajeBE(oArchivomensajeBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivomensajeBE = null;
            oArchivomensajeDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosArchivomensajeBE(ArrayList<ArchivomensajeBE> oListaArchivomensajeBE) {
        int resultado = 0;
        ArchivomensajeDA oArchivomensajeDA = null;

        try {
            oArchivomensajeDA = new ArchivomensajeDA();
            resultado = oArchivomensajeDA.insertarRegistrosArchivomensajeBE(oListaArchivomensajeBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaArchivomensajeBE = null;
            oArchivomensajeDA = null;
        }
        return resultado;
    }

    public int actualizarArchivomensajeBE(ArchivomensajeBE oArchivomensajeBE1) {
        int resultado = 0;
        ArchivomensajeDA oArchivomensajeDA = null;
        try {
            oArchivomensajeDA = new ArchivomensajeDA();
            resultado = oArchivomensajeDA.actualizarArchivomensajeBE(oArchivomensajeBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oArchivomensajeBE1 = null;
            oArchivomensajeDA = null;
        }

        return resultado;
    }

}
