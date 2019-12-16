package mph.tramitedoc.be;

import java.util.Date;

/**
 * @author djackob
 */
public class EventoBE {
    private int IndOpSp;
    private String edit;
    private String del;
    
    private Integer idevento;
    private Integer iddocumento;
    private Integer idexpediente;
    private int idarearecepciona;
    private int idareadestino;
    private int idusuariorecepciona;
    private int idusuariodestino;
    private String estadoevento;
    private String denominacion;
    private String codigo;
    private String arearecepciona;
    private String areadestino;
    private String usuariorecepciona;
    private String usuariodestino;
    private Double diasatencion;
    private Date fecharecepciona;
    private Date fechadestino;
    private boolean estado;
    
    public EventoBE(){
        this.IndOpSp = 0;
        this.idevento = 0;
        this.iddocumento = 0;
        this.idexpediente = 0;
        this.idarearecepciona = 0;
        this.idareadestino = 0;
        this.idusuariorecepciona = 0;
        this.idusuariodestino = 0;
        this.estadoevento = "";
        this.denominacion = "";
        this.codigo = "";
        this.arearecepciona = "";
        this.areadestino = "";
        this.usuariorecepciona = "";
        this.usuariodestino = "";
        this.diasatencion = 0.0;
        this.fecharecepciona = new Date();
        this.fechadestino = new Date();
        this.estado = false;
    }
    
    public EventoBE(int pIndOpSp, Integer pidevento, Integer piddocumento, Integer pidexpediente, int pidarearecepciona,
            int pidareadestino, int pidusuariorecepciona, int pidusuariodestino, String pestadoevento, String pdenominacion,
            String pcodigo, String parearecepciona, String pareadestino, String pusuariorecepciona, String pusuariodestino,
            Double pdiasatencion, Date pfecharecepciona, Date pfechadestino, boolean pestado){
        this.IndOpSp = pIndOpSp;
        this.idevento = pidevento;
        this.iddocumento = piddocumento;
        this.idexpediente = pidexpediente;
        this.idarearecepciona = pidarearecepciona;
        this.idareadestino = pidareadestino;
        this.idusuariorecepciona = pidusuariorecepciona;
        this.idusuariodestino = pidusuariodestino;
        this.estadoevento = pestadoevento;
        this.denominacion = pdenominacion;
        this.codigo = pcodigo;
        this.arearecepciona = parearecepciona;
        this.areadestino = pareadestino;
        this.usuariorecepciona = pusuariorecepciona;
        this.usuariodestino = pusuariodestino;
        this.diasatencion = pdiasatencion;
        this.fecharecepciona = pfecharecepciona;
        this.fechadestino = pfechadestino;
        this.estado = pestado;
    }

    public int getIndOpSp() {
        return IndOpSp;
    }

    public void setIndOpSp(int IndOpSp) {
        this.IndOpSp = IndOpSp;
    }

    public String getEdit() {
        return edit;
    }

    public void setEdit(String edit) {
        this.edit = edit;
    }

    public String getDel() {
        return del;
    }

    public void setDel(String del) {
        this.del = del;
    }

    public Integer getIdevento() {
        return idevento;
    }

    public void setIdevento(Integer idevento) {
        this.idevento = idevento;
    }

    public Integer getIddocumento() {
        return iddocumento;
    }

    public void setIddocumento(Integer iddocumento) {
        this.iddocumento = iddocumento;
    }

    public Integer getIdexpediente() {
        return idexpediente;
    }

    public void setIdexpediente(Integer idexpediente) {
        this.idexpediente = idexpediente;
    }

    public int getIdarearecepciona() {
        return idarearecepciona;
    }

    public void setIdarearecepciona(int idarearecepciona) {
        this.idarearecepciona = idarearecepciona;
    }

    public int getIdareadestino() {
        return idareadestino;
    }

    public void setIdareadestino(int idareadestino) {
        this.idareadestino = idareadestino;
    }

    public int getIdusuariorecepciona() {
        return idusuariorecepciona;
    }

    public void setIdusuariorecepciona(int idusuariorecepciona) {
        this.idusuariorecepciona = idusuariorecepciona;
    }

    public int getIdusuariodestino() {
        return idusuariodestino;
    }

    public void setIdusuariodestino(int idusuariodestino) {
        this.idusuariodestino = idusuariodestino;
    }

    public String getEstadoevento() {
        return estadoevento;
    }

    public void setEstadoevento(String estadoevento) {
        this.estadoevento = estadoevento;
    }

    public String getDenominacion() {
        return denominacion;
    }

    public void setDenominacion(String denominacion) {
        this.denominacion = denominacion;
    }

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getArearecepciona() {
        return arearecepciona;
    }

    public void setArearecepciona(String arearecepciona) {
        this.arearecepciona = arearecepciona;
    }

    public String getAreadestino() {
        return areadestino;
    }

    public void setAreadestino(String areadestino) {
        this.areadestino = areadestino;
    }

    public String getUsuariorecepciona() {
        return usuariorecepciona;
    }

    public void setUsuariorecepciona(String usuariorecepciona) {
        this.usuariorecepciona = usuariorecepciona;
    }

    public String getUsuariodestino() {
        return usuariodestino;
    }

    public void setUsuariodestino(String usuariodestino) {
        this.usuariodestino = usuariodestino;
    }

    public Double getDiasatencion() {
        return diasatencion;
    }

    public void setDiasatencion(Double diasatencion) {
        this.diasatencion = diasatencion;
    }

    public Date getFecharecepciona() {
        return fecharecepciona;
    }

    public void setFecharecepciona(Date fecharecepciona) {
        this.fecharecepciona = fecharecepciona;
    }

    public Date getFechadestino() {
        return fechadestino;
    }

    public void setFechadestino(Date fechadestino) {
        this.fechadestino = fechadestino;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }
}
