package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.AnioBE;
import mph.tramitedoc.da.AnioDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class AnioBL {

    public AnioBL() {
    }

    public AnioBE listarAnioBE(AnioBE oAnioBE1) {
        AnioBE oAnioBE = null;
        AnioDA oAnioDA = null;
        try {
            oAnioDA = new AnioDA();
            oAnioBE = oAnioDA.listarAnioBE(oAnioBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAnioBE1 = null;
            oAnioDA = null;
        }
        return oAnioBE;
    }

    public ArrayList<AnioBE> listarRegistrosAnioBE(AnioBE oAnioBE) {
        ArrayList<AnioBE> oListaAnioBE = null;
        AnioDA oAnioDA = null;
        try {
            oAnioDA = new AnioDA();
            oListaAnioBE = oAnioDA.listarRegistroAnioBE(oAnioBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAnioBE = null;
            oAnioDA = null;
        }
        return oListaAnioBE;
    }

    public int insertarAnioBE(AnioBE oAnioBE) {
        int resultado = 0;
        AnioDA oAnioDA = null;

        try {
            oAnioDA = new AnioDA();
            resultado = oAnioDA.insertarAnioBE(oAnioBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAnioBE = null;
            oAnioDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosAnioBE(ArrayList<AnioBE> oListaAnioBE) {
        int resultado = 0;
        AnioDA oAnioDA = null;

        try {
            oAnioDA = new AnioDA();
            resultado = oAnioDA.insertarRegistrosAnioBE(oListaAnioBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaAnioBE = null;
            oAnioDA = null;
        }
        return resultado;
    }

    public int actualizarAnioBE(AnioBE oAnioBE1) {
        int resultado = 0;
        AnioDA oAnioDA = null;
        try {
            oAnioDA = new AnioDA();
            resultado = oAnioDA.actualizarAnioBE(oAnioBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAnioBE1 = null;
            oAnioDA = null;
        }

        return resultado;
    }

    public int eliminarAnioBE(AnioBE oAnioBE1) {
        int resultado = 0;
        AnioDA oAnioDA = null;
        try {
            oAnioDA = new AnioDA();
            resultado = oAnioDA.eliminarAnioBE(oAnioBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAnioBE1 = null;
            oAnioDA = null;
        }

        return resultado;
    }

    public List listObjectAnioBE(AnioBE oAnioBE1) {
        List list = new LinkedList();
        AnioDA oAnioDA = null;
        try {
            oAnioDA = new AnioDA();
            list = oAnioDA.listObjectAnioBE(oAnioBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oAnioBE1 = null;
            oAnioDA = null;
        }

        return list;
    }

}
