package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.BandejaBE;
import mph.tramitedoc.da.BandejaDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.JQObjectBE;

public class BandejaBL {

    public BandejaBL() {
    }

    public BandejaBE listarBandejaBE(BandejaBE oBandejaBE1) {
        BandejaBE oBandejaBE = null;
        BandejaDA oBandejaDA = null;
        try {
            oBandejaDA = new BandejaDA();
            oBandejaBE = oBandejaDA.listarBandejaBE(oBandejaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oBandejaBE1 = null;
            oBandejaDA = null;
        }
        return oBandejaBE;
    }

    public ArrayList<BandejaBE> listarRegistrosBandejaBE(BandejaBE oBandejaBE) {
        ArrayList<BandejaBE> oListaBandejaBE = null;
        BandejaDA oBandejaDA = null;
        try {
            oBandejaDA = new BandejaDA();
            oListaBandejaBE = oBandejaDA.listarRegistroBandejaBE(oBandejaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oBandejaBE = null;
            oBandejaDA = null;
        }
        return oListaBandejaBE;
    }

    public int insertarBandejaBE(BandejaBE oBandejaBE) {
        int resultado = 0;
        BandejaDA oBandejaDA = null;

        try {
            oBandejaDA = new BandejaDA();
            resultado = oBandejaDA.insertarBandejaBE(oBandejaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oBandejaBE = null;
            oBandejaDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosBandejaBE(ArrayList<BandejaBE> oListaBandejaBE) {
        int resultado = 0;
        BandejaDA oBandejaDA = null;

        try {
            oBandejaDA = new BandejaDA();
            resultado = oBandejaDA.insertarRegistrosBandejaBE(oListaBandejaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaBandejaBE = null;
            oBandejaDA = null;
        }
        return resultado;
    }

    public int actualizarBandejaBE(BandejaBE oBandejaBE1) {
        int resultado = 0;
        BandejaDA oBandejaDA = null;
        try {
            oBandejaDA = new BandejaDA();
            resultado = oBandejaDA.actualizarBandejaBE(oBandejaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oBandejaBE1 = null;
            oBandejaDA = null;
        }

        return resultado;
    }

    public int eliminarBandejaBE(BandejaBE oBandejaBE1) {
        int resultado = 0;
        BandejaDA oBandejaDA = null;
        try {
            oBandejaDA = new BandejaDA();
            resultado = oBandejaDA.eliminarBandejaBE(oBandejaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oBandejaBE1 = null;
            oBandejaDA = null;
        }

        return resultado;
    }

    public List listObjectBandejaBE(BandejaBE oBandejaBE1) {
        List list = new LinkedList();
        BandejaDA oBandejaDA = null;
        try {
            oBandejaDA = new BandejaDA();
            list = oBandejaDA.listObjectBandejaBE(oBandejaBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oBandejaBE1 = null;
            oBandejaDA = null;
        }

        return list;
    }

    public JQObjectBE listarJQRegistroDocumentoBE(BandejaBE oBandejaBE) {

        JQObjectBE oJQObjectBE = null;
        BandejaDA oBandejaDA = null;
        try {
            oBandejaDA = new BandejaDA();
            oJQObjectBE = oBandejaDA.listarJQRegistroDocumentoBE(oBandejaBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oBandejaBE = null;
            oBandejaDA = null;
        }
        return oJQObjectBE;
    }

}
