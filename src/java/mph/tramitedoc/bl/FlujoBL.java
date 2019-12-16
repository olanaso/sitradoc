package mph.tramitedoc.bl;

//@autor Sergio Medina
import mph.tramitedoc.be.FlujoBE;
import mph.tramitedoc.da.FlujoDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.JQObjectBE;

public class FlujoBL {

    public FlujoBL() {
    }

    public FlujoBE listarFlujoBE(FlujoBE oFlujoBE1) {
        FlujoBE oFlujoBE = null;
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            oFlujoBE = oFlujoDA.listarFlujoBE(oFlujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE1 = null;
            oFlujoDA = null;
        }
        return oFlujoBE;
    }

    public ArrayList<FlujoBE> listarRegistrosFlujoBE(FlujoBE oFlujoBE) {
        ArrayList<FlujoBE> oListaFlujoBE = null;
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            oListaFlujoBE = oFlujoDA.listarRegistroFlujoBE(oFlujoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE = null;
            oFlujoDA = null;
        }
        return oListaFlujoBE;
    }

    public JQObjectBE listarJQRegistrosFlujoBE(FlujoBE oFlujoBE) {
        JQObjectBE oJQObjectBE = null;
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            oJQObjectBE = oFlujoDA.listarJQRegistroFlujoBE(oFlujoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE = null;
            oFlujoDA = null;
        }
        return oJQObjectBE;
    }

    public int insertarFlujoBE(FlujoBE oFlujoBE) {
        int resultado = 0;
        FlujoDA oFlujoDA = null;

        try {
            oFlujoDA = new FlujoDA();
            resultado = oFlujoDA.insertarFlujoBE(oFlujoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE = null;
            oFlujoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosFlujoBE(ArrayList<FlujoBE> oListaFlujoBE) {
        int resultado = 0;
        FlujoDA oFlujoDA = null;

        try {
            oFlujoDA = new FlujoDA();
            resultado = oFlujoDA.insertarRegistrosFlujoBE(oListaFlujoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaFlujoBE = null;
            oFlujoDA = null;
        }
        return resultado;
    }

    public int derivarExpedienteFlujo(ArrayList<FlujoBE> oListaFlujoBE) {
        int resultado = 0;
        FlujoDA oFlujoDA = null;

        try {
            oFlujoDA = new FlujoDA();
            resultado = oFlujoDA.derivarExpedienteFlujo(oListaFlujoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaFlujoBE = null;
            oFlujoDA = null;
        }
        return resultado;
    }

    public int actualizarFlujoBE(FlujoBE oFlujoBE1) {
        int resultado = 0;
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            resultado = oFlujoDA.actualizarFlujoBE(oFlujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE1 = null;
            oFlujoDA = null;
        }

        return resultado;
    }

    public int actualizarEstadoFlujoBE(FlujoBE oFlujoBE1) {
        int resultado = 0;
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            resultado = oFlujoDA.actualizarEstadoFlujoBE(oFlujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE1 = null;
            oFlujoDA = null;
        }

        return resultado;
    }

    public int registroderivarflujo(FlujoBE oFlujoBE1) {
        int resultado = 0;
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            resultado = oFlujoDA.registroderivarflujo(oFlujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE1 = null;
            oFlujoDA = null;
        }

        return resultado;
    }

    public int eliminarFlujoBE(FlujoBE oFlujoBE1) {
        int resultado = 0;
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            resultado = oFlujoDA.eliminarFlujoBE(oFlujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE1 = null;
            oFlujoDA = null;
        }

        return resultado;
    }

    public int lecturaFlujoBE(FlujoBE oFlujoBE1) {
        int resultado = 0;
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            resultado = oFlujoDA.lecturaFlujoBE(oFlujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE1 = null;
            oFlujoDA = null;
        }

        return resultado;
    }

    public List listObjectFlujoBE(FlujoBE oFlujoBE1) {
        List list = new LinkedList();
        FlujoDA oFlujoDA = null;
        try {
            oFlujoDA = new FlujoDA();
            list = oFlujoDA.listObjectFlujoBE(oFlujoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oFlujoBE1 = null;
            oFlujoDA = null;
        }

        return list;
    }

}
