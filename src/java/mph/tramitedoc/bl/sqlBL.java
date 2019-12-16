package mph.tramitedoc.bl;

//@autor Sergio Medina
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import mph.tramitedoc.be.AreaBE;
import mph.tramitedoc.da.AreaDA;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.da.sqlDA;

public class sqlBL {

    Gson gson = new GsonBuilder().serializeNulls().create();

    public sqlBL() {
    }

    public String getJSON(String query) {
        String json = "";
        sqlDA osqlDA = null;
        try {
            osqlDA = new sqlDA();
            json = osqlDA.listarRS(query);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            osqlDA = null;

        }
        return json;
    }

}
