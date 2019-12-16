package mph.tramitedoc.bl;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.EventoBE;
import mph.tramitedoc.da.EventoDA;

/**
 * @author djackob
 */
public class EventoBL {
    public EventoBL() {
    }

    public EventoBE listarEventoBE(EventoBE oEventoBE1) {
        EventoBE oEventoBE = null;
        EventoDA oEventoDA = null;
        try {
            oEventoDA = new EventoDA();
            oEventoBE = oEventoDA.listarEventoBE(oEventoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEventoBE1 = null;
            oEventoDA = null;
        }
        return oEventoBE;
    }

    public ArrayList<EventoBE> listarRegistrosEventoBE(EventoBE oEventoBE) {
        ArrayList<EventoBE> oListaEventoBE = null;
        EventoDA oEventoDA = null;
        try {
            oEventoDA = new EventoDA();
            oListaEventoBE = oEventoDA.listarRegistroEventoBE(oEventoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEventoBE = null;
            oEventoDA = null;
        }
        return oListaEventoBE;
    }

    public int insertarEventoBE(EventoBE oEventoBE) {
        int resultado = 0;
        EventoDA oEventoDA = null;

        try {
            oEventoDA = new EventoDA();
            resultado = oEventoDA.insertarEventoBE(oEventoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEventoBE = null;
            oEventoDA = null;
        }
        return resultado;
    }

    public int insertarRegistrosEventoBE(ArrayList<EventoBE> oListaEventoBE) {
        int resultado = 0;
        EventoDA oEventoDA = null;

        try {
            oEventoDA = new EventoDA();
            resultado = oEventoDA.insertarRegistrosEventoBE(oListaEventoBE);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oListaEventoBE = null;
            oEventoDA = null;
        }
        return resultado;
    }

    public int actualizarEventoBE(EventoBE oEventoBE1) {
        int resultado = 0;
        EventoDA oEventoDA = null;
        try {
            oEventoDA = new EventoDA();
            resultado = oEventoDA.actualizarEventoBE(oEventoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEventoBE1 = null;
            oEventoDA = null;
        }

        return resultado;
    }

    public int eliminarEventoBE(EventoBE oEventoBE1) {
        int resultado = 0;
        EventoDA oEventoDA = null;
        try {
            oEventoDA = new EventoDA();
            resultado = oEventoDA.eliminarEventoBE(oEventoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEventoBE1 = null;
            oEventoDA = null;
        }

        return resultado;
    }

    public List listObjectEventoBE(EventoBE oEventoBE1) {
        List list = new LinkedList();
        EventoDA oEventoDA = null;
        try {
            oEventoDA = new EventoDA();
            list = oEventoDA.listObjectEventoBE(oEventoBE1);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            oEventoBE1 = null;
            oEventoDA = null;
        }

        return list;
    }
}