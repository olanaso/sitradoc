package mph.tramitedoc.controller;

//@Erick Escalante Olano
import mph.tramitedoc.be.AreaBE;
import mph.tramitedoc.bl.AreaBL;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import mph.tramitedoc.bl.sqlBL;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/SqlController")
@SessionAttributes({"oSession"})
public class SqlController {

    Gson gson = new GsonBuilder().serializeNulls().create();
    String json = "";

    @RequestMapping(value = "/guardar-configuracion-documento", method = RequestMethod.POST)
    public @ResponseBody
    String sql(@RequestBody Map<String, Object> param) throws UnsupportedEncodingException {
        sqlBL osqlBL = new sqlBL();
        AreaBE oAreaBE = gson.fromJson(gson.toJson(param.get("poAreaBE")), AreaBE.class);
        String query = "SELECT * from uspinsertarareatipodocumento(\n"
                + " "+oAreaBE.getOpcion()+"  ,\n"
                + " "+oAreaBE.getIdtipodocumento()+"   ,\n"
                + " "+oAreaBE.getIdarea()+"   ,\n"
                + " "+oAreaBE.getIdusuario()+"  ,\n"
                + " "+oAreaBE.getCodigodoc()+"  \n"
                + ");";
        return osqlBL.getJSON(query);
    }

}
