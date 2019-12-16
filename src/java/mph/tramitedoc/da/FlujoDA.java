package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.FlujoBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.JQObjectBE;
import mph.tramitedoc.util.JQgridUtil;

public class FlujoDA extends BaseDA {
    
    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;
    
    public FlujoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }
    
    public FlujoBE listarFlujoBE(FlujoBE oFlujoBE1) throws SQLException {
        FlujoBE oFlujoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        
        try {
            oFlujoBE = new FlujoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oFlujoBE1.getIndOpSp() == 1) {
                
                String sql = " SELECT idflujo,idexpediente,idestadoflujo,idusuario,idusuarioenvia,idusuariorecepciona,fechaenvio,fechalectura,asunto,descripcion,observacion,binderror,estado FROM flujo WHERE idflujo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oFlujoBE1.getIdflujo());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);
                
            }
            while (rs.next()) {
                oFlujoBE.setIdflujo(rs.getInt("idflujo"));
                oFlujoBE.setIdexpediente(rs.getInt("idexpediente"));
                oFlujoBE.setIdestadoflujo(rs.getInt("idestadoflujo"));
                oFlujoBE.setIdusuario(rs.getInt("idusuario"));
                oFlujoBE.setIdusuarioenvia(rs.getInt("idusuarioenvia"));
                oFlujoBE.setIdusuariorecepciona(rs.getInt("idusuariorecepciona"));
                oFlujoBE.setFechaenvio(rs.getDate("fechaenvio"));
                oFlujoBE.setFechalectura(rs.getDate("fechalectura"));
                oFlujoBE.setAsunto(rs.getString("asunto"));
                oFlujoBE.setDescripcion(rs.getString("descripcion"));
                oFlujoBE.setObservacion(rs.getString("observacion"));
                oFlujoBE.setBinderror(rs.getBoolean("binderror"));
                oFlujoBE.setEstado(rs.getBoolean("estado"));
            }
            
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            
            rs.close();
            rs = null;
            cn.close();
            cn = null;
            
        }
        return oFlujoBE;
    }
    
    public ArrayList<FlujoBE> listarRegistroFlujoBE(FlujoBE oFlujoBE1) throws SQLException {
        ArrayList<FlujoBE> listaFlujoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        
        try {
            listaFlujoBE = new ArrayList<FlujoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oFlujoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idflujo||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idflujo||')\" class=\"fa fa-trash-o\"></i>',idflujo,idexpediente,idestadoflujo,idusuario,idusuarioenvia,idusuariorecepciona,fechaenvio,fechalectura,asunto,descripcion,observacion,binderror,estado FROM flujo WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                
                while (rs.next()) {
                    FlujoBE oFlujoBE = new FlujoBE();
                    oFlujoBE.setEdit(rs.getString(1));
                    oFlujoBE.setDel(rs.getString(2));
                    oFlujoBE.setIdflujo(rs.getInt("idflujo"));
                    oFlujoBE.setIdexpediente(rs.getInt("idexpediente"));
                    oFlujoBE.setIdestadoflujo(rs.getInt("idestadoflujo"));
                    oFlujoBE.setIdusuario(rs.getInt("idusuario"));
                    oFlujoBE.setIdusuarioenvia(rs.getInt("idusuarioenvia"));
                    oFlujoBE.setIdusuariorecepciona(rs.getInt("idusuariorecepciona"));
                    oFlujoBE.setFechaenvio(rs.getDate("fechaenvio"));
                    oFlujoBE.setFechalectura(rs.getDate("fechalectura"));
                    oFlujoBE.setAsunto(rs.getString("asunto"));
                    oFlujoBE.setDescripcion(rs.getString("descripcion"));
                    oFlujoBE.setObservacion(rs.getString("observacion"));
                    oFlujoBE.setBinderror(rs.getBoolean("binderror"));
                    oFlujoBE.setEstado(rs.getBoolean("estado"));
                    listaFlujoBE.add(oFlujoBE);
                }
                
            }
            if (oFlujoBE1.getIndOpSp() == 2) {
                
                sql = "select '<button onclick=\"visualizar('||a.idflujo||','||a.idexpediente||','\''||e.asunto||'\'')\" >Visualizar</button>',"
                        + "'<button onclick=\"resolver('||a.idflujo||','||a.idexpediente||','\''||e.asunto||'\'')\" >Resolver</button>', \n"
                        + "'<button onclick=\"derivar('||a.idflujo||','||a.idexpediente||','\''||e.asunto||'\'')\" >Derivar</button>',"
                        + "'<button onclick=\"generartraminterno('||e.codigo||'\'')\" >Tramite Interno</button>',"
                        + "a.idflujo,a.idexpediente,e.asunto,e.nombre_razonsocial||' '||e.apellidos usuario\n"
                        + ",c.nombres||' '||c.apellidos||' '||c.telefono remitente,p.plazodias - date_part('day' ,now()-e.fecharegistro)+(select count(idferiado)  from feriado \n"
                        + "where fecha between e.fecharegistro and now() and estado=true) diasrestantes,to_char(e.fecharegistro,'DD/MM/YYYY HH24:MI:SS') fechaingreso,to_char(a.fechaenvio,'DD/MM/YYYY HH24:MI:SS') fecharecepcion\n"
                        + ",case when bindicaleido is true then 'SI' else 'NO' end bindicaleido \n"
                        + ",case when bindicaleido is true then 'SI' else 'NO' end bindicaleido \n"
                        + "from flujo a \n"
                        + "inner join usuario c on a.idusuarioenvia=c.idusuario\n"
                        + "inner join expediente e on e.idexpediente=a.idexpediente\n"
                        + "inner join procedimiento p on e.idprocedimiento=p.idprocedimiento\n"
                        + "where a.idusuariorecepciona=" + oFlujoBE1.getIdusuariorecepciona() + " \n"
                        + "and idestadoflujo=" + oFlujoBE1.getIdestadoflujo() + "\n"
                        + "and a.bindparent=true\n"
                        + "and a.estado=true\n"
                        + "and c.estado=true\n"
                        + "and e.estado=true\n"
                        + "order by e.fecharegistro asc";
                
                System.out.println("sql:" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                
                while (rs.next()) {
                    FlujoBE oFlujoBE = new FlujoBE();
                    
                    oFlujoBE.setVisualizar(rs.getString(1));
                    oFlujoBE.setResolver(rs.getString(2));
                    oFlujoBE.setDerivar(rs.getString(3));
                    oFlujoBE.setGentraminterno(rs.getString(4));
                    oFlujoBE.setIdflujo(rs.getInt("idflujo"));
                    oFlujoBE.setIdexpediente(rs.getInt("idexpediente"));
                    oFlujoBE.setNombres(rs.getString("usuario"));
                    oFlujoBE.setAsunto(rs.getString("asunto"));
                    oFlujoBE.setRemitente(rs.getString("remitente"));
                    oFlujoBE.setDiasrestantes(rs.getString("diasrestantes"));
                    oFlujoBE.setFechaingreso(rs.getString("fechaingreso"));
                    oFlujoBE.setFecharecepcion(rs.getString("fecharecepcion"));
                    oFlujoBE.setIsleido(rs.getString("bindicaleido"));
                    listaFlujoBE.add(oFlujoBE);
                    
                }
                
            }

            /*   if (oFlujoBE1.getIndOpSp() == 3) {

             sql = "select '<button onclick=\"derivar('||a.idflujo||','||a.idexpediente||','''||e.asunto||''')\" >Derivar</button>','<button onclick=\"resolver('||a.idflujo||','||a.idexpediente||','''||e.asunto||''')\" >Resolver</button>', \n"
             + "'<button onclick=\"responder('||a.idflujo||','||a.idexpediente||','''||e.asunto||''')\" >Responder</button>',\n"
             + "a.idflujo,a.idexpediente,a.asunto,e.nombre_razonsocial||' '||e.apellidos usuario\n"
             + ",c.nombres||' '||c.apellidos||' '||c.telefono remitente,p.plazodias - date_part('day' ,now()-e.fecharegistro)+(select count(idferiado)  from feriado \n"
             + "where fecha between e.fecharegistro and now() and estado=true) diasrestantes,to_char(e.fecharegistro,'dd/mm/yyyy hh:mm') fechaingreso,to_char(a.fechaenvio,'dd/mm/yyyy hh:mm') fecharecepcion\n"
             + ",case when bindicaleido is true then 'SI' else 'NO' end bindicaleido \n"
             + "from flujo a \n"
             + "inner join usuario c on a.idusuarioenvia=c.idusuario\n"
             + "inner join expediente e on e.idexpediente=a.idexpediente\n"
             + "inner join procedimiento p on e.idprocedimiento=p.idprocedimiento\n"
             + "where \n"
             + "a.idusuariorecepciona=" + oFlujoBE1.getIdusuariorecepciona() + " \n"
             + "and bindparent=false\n"
             + "and bindatendido=" + oFlujoBE1.isBindatendido() + "\n"
             + "and a.estado=true\n"
             + "and c.estado=true\n"
             + "and e.estado=true\n"
             + "order by e.fecharegistro asc";

             System.out.println("sql:" + sql);
             pst = cn.prepareStatement(sql);
             rs = pst.executeQuery();

             while (rs.next()) {
             FlujoBE oFlujoBE = new FlujoBE();

             oFlujoBE.setDerivar(rs.getString(1));
             oFlujoBE.setResolver(rs.getString(2));
             oFlujoBE.setResponder(rs.getString(3));
             oFlujoBE.setIdflujo(rs.getInt("idflujo"));
             oFlujoBE.setIdexpediente(rs.getInt("idexpediente"));
             oFlujoBE.setNombres(rs.getString("usuario"));
             oFlujoBE.setAsunto(rs.getString("asunto"));
             oFlujoBE.setRemitente(rs.getString("remitente"));
             oFlujoBE.setDiasrestantes(rs.getString("diasrestantes"));
             oFlujoBE.setFechaingreso(rs.getString("fechaingreso"));
             oFlujoBE.setFecharecepcion(rs.getString("fecharecepcion"));
             oFlujoBE.setIsleido(rs.getString("bindicaleido"));
             listaFlujoBE.add(oFlujoBE);

             }

             }*/
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            rs.close();
            rs = null;
            cn.close();
            cn = null;
            oFlujoBE1 = null;
        }
        return listaFlujoBE;
    }
    
    public JQObjectBE listarJQRegistroFlujoBE(FlujoBE oFlujoBE1) throws SQLException {
        JQObjectBE ojqbjectBE = new JQObjectBE();
        JQgridUtil oJQgridUtil = new JQgridUtil();
        
        ArrayList<FlujoBE> listaFlujoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        
        try {
            listaFlujoBE = new ArrayList<FlujoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            String sql_calc_cant_rows = "";
            if (oFlujoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idflujo||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idflujo||')\" class=\"fa fa-trash-o\"></i>',idflujo,idexpediente,idestadoflujo,idusuario,idusuarioenvia,idusuariorecepciona,fechaenvio,fechalectura,asunto,descripcion,observacion,binderror,estado FROM flujo WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                
                while (rs.next()) {
                    FlujoBE oFlujoBE = new FlujoBE();
                    oFlujoBE.setEdit(rs.getString(1));
                    oFlujoBE.setDel(rs.getString(2));
                    oFlujoBE.setIdflujo(rs.getInt("idflujo"));
                    oFlujoBE.setIdexpediente(rs.getInt("idexpediente"));
                    oFlujoBE.setIdestadoflujo(rs.getInt("idestadoflujo"));
                    oFlujoBE.setIdusuario(rs.getInt("idusuario"));
                    oFlujoBE.setIdusuarioenvia(rs.getInt("idusuarioenvia"));
                    oFlujoBE.setIdusuariorecepciona(rs.getInt("idusuariorecepciona"));
                    oFlujoBE.setFechaenvio(rs.getDate("fechaenvio"));
                    oFlujoBE.setFechalectura(rs.getDate("fechalectura"));
                    oFlujoBE.setAsunto(rs.getString("asunto"));
                    oFlujoBE.setDescripcion(rs.getString("descripcion"));
                    oFlujoBE.setObservacion(rs.getString("observacion"));
                    oFlujoBE.setBinderror(rs.getBoolean("binderror"));
                    oFlujoBE.setEstado(rs.getBoolean("estado"));
                    listaFlujoBE.add(oFlujoBE);
                }
                
            }
            if (oFlujoBE1.getIndOpSp() == 2) {
                
                sql_calc_cant_rows = "select count(a.idflujo) total\n"
                        + "from flujo a \n"
                        + "inner join usuario c on a.idusuarioenvia=c.idusuario\n"
                        + "inner join expediente e on e.idexpediente=a.idexpediente\n"
                        + "inner join procedimiento p on e.idprocedimiento=p.idprocedimiento\n"
                        + "where \n"
                        + " a.idarea=" + oFlujoBE1.getIdarea() + " \n"
                        + "and idestadoflujo=" + oFlujoBE1.getIdestadoflujo() + "\n"
                        + "--and a.bindparent=true\n"
                        + "and a.estado=true\n"
                        + "and c.estado=true\n"
                        + "and e.estado=true\n"
                        + " and extract(year from e.fecharegistro)::integer = case when " + oFlujoBE1.getAnio() + "=0 then extract(year from e.fecharegistro)::integer else " + oFlujoBE1.getAnio() + " end "
                        + " and e.codigo= case when " + oFlujoBE1.getCodigo() + "=0 then e.codigo  else " + oFlujoBE1.getCodigo() + " end"
                        + " and ( e.estado=true and e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oFlujoBE1.getNombre_razonsocial() + "'  then '' else '" + oFlujoBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oFlujoBE1.getNombre_razonsocial() + "') )";
                
                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oFlujoBE1);

                /*calculo de cantidad de filas y limitstart*/
                sql = "select '<button class=\"ui-state-default ui-corner-all\" onclick=\"visualizar('||a.idflujo||','||a.idexpediente||','\''||e.asunto||'\'')\" ><i class=\"fa fa-eye\" aria-hidden=\"true\"></i> Visualizar</button>',"
                        + "'<button class=\"ui-state-default ui-corner-all\" onclick=\"resolver('||a.idflujo||','||a.idexpediente||','\''||e.asunto||'\'')\" > <i class=\"fa fa-check\" aria-hidden=\"true\"></i> Resolver</button>', \n"
                        + "'<button class=\"ui-state-default ui-corner-all\" onclick=\"derivar('||e.codigo||','||a.idflujo||','||a.idexpediente||','\''||e.asunto||'\'')\" ><i class=\"fa fa-random\" aria-hidden=\"true\"></i> Derivar a otra Area</button>',"
                        + "'<button class=\"ui-state-default ui-corner-all\" onclick=\"generartraminterno('||e.idexpediente||','||e.codigo||')\" ><i class=\"fa fa-file-text-o\" aria-hidden=\"true\"></i> Tramite Interno</button>',"
                        + "a.idflujo,a.idexpediente,e.codigo,e.asunto,e.nombre_razonsocial||' '||e.apellidos usuario\n"
                        + ",c.nombres||' '||c.apellidos||' '||c.telefono remitente,p.plazodias - date_part('day' ,now()-e.fecharegistro)+(select count(idferiado)  from feriado \n"
                        + "where fecha between e.fecharegistro and now() and estado=true) diasrestantes,to_char(e.fecharegistro,'DD/MM/YYYY HH24:MI:SS') fechaingreso,to_char(a.fechaenvio,'DD/MM/YYYY HH24:MI:SS') fecharecepcion\n"
                        + ",case when bindicaleido is true then 'SI' else 'NO' end bindicaleido \n"
                        + ",case when bindicaleido is true then 'SI' else 'NO' end bindicaleido \n"
                        + ",case when (p.plazodias \n"
                        + "- date_part('day' ,now()-e.fecharegistro)\n"
                        + "+ (select count(idferiado)  from feriado where fecha between e.fecharegistro and now() and estado=true)) <1 \n"
                        + "then '<span title=\"Vencidos\" class=\"pulse\" style=\"background: #FF2B2B;\"></span>'\n"
                        + "else \n"
                        + "case when (p.plazodias \n"
                        + "- date_part('day' ,now()-e.fecharegistro)\n"
                        + "+ (select count(idferiado)  from feriado where fecha between e.fecharegistro and now() and estado=true)) <3 \n"
                        + "then '<span title=\"A punto de vencer\" class=\"pulse\" style=\"background: #FFA579;\"></span>'\n"
                        + "else \n"
                        + "'<span title=\"No vencidos\" class=\"pulse\" style=\"background: #008040;\"></span>'\n"
                        + "end \n"
                        + "end semaforo \n"
                        + "from flujo a \n"
                        + "inner join usuario c on a.idusuarioenvia=c.idusuario\n"
                        + "inner join expediente e on e.idexpediente=a.idexpediente\n"
                        + "inner join procedimiento p on e.idprocedimiento=p.idprocedimiento\n"
                        + "where \n"
                        + " a.idarea=" + oFlujoBE1.getIdarea() + " \n"
                        + "and idestadoflujo=" + oFlujoBE1.getIdestadoflujo() + "\n"
                        + " --and a.bindparent=true\n"
                        + "and a.estado=true\n"
                        + "and c.estado=true\n"
                        + "and e.estado=true\n"
                        + " and extract(year from e.fecharegistro)::integer = case when " + oFlujoBE1.getAnio() + "=0 then extract(year from e.fecharegistro)::integer else " + oFlujoBE1.getAnio() + " end "
                        + " and e.codigo= case when " + oFlujoBE1.getCodigo() + "=0 then e.codigo  else " + oFlujoBE1.getCodigo() + " end"
                        + " and (e.estado=true and e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oFlujoBE1.getNombre_razonsocial() + "'  then '' else '" + oFlujoBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oFlujoBE1.getNombre_razonsocial() + "')"
                        + " )order by e.fecharegistro asc limit " + oFlujoBE1.getRows() + " offset " + oFlujoBE1.getStart();
                
                System.out.println("sql modificado:" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                
                while (rs.next()) {
                    FlujoBE oFlujoBE = new FlujoBE();
                    
                    oFlujoBE.setVisualizar(rs.getString(1));
                    oFlujoBE.setResolver(rs.getString(2));
                    oFlujoBE.setDerivar(rs.getString(3));
                    oFlujoBE.setGentraminterno(rs.getString(4));
                    oFlujoBE.setIdflujo(rs.getInt("idflujo"));
                    oFlujoBE.setIdexpediente(rs.getInt("idexpediente"));
                    oFlujoBE.setCodigo(rs.getInt("codigo"));
                    oFlujoBE.setNombres(rs.getString("usuario"));
                    oFlujoBE.setAsunto(rs.getString("asunto"));
                    oFlujoBE.setRemitente(rs.getString("remitente"));
                    oFlujoBE.setDiasrestantes(rs.getString("diasrestantes"));
                    oFlujoBE.setFechaingreso(rs.getString("fechaingreso"));
                    oFlujoBE.setFecharecepcion(rs.getString("fecharecepcion"));
                    oFlujoBE.setIsleido(rs.getString("bindicaleido"));
                    oFlujoBE.setSemaforo(rs.getString("semaforo"));
                    listaFlujoBE.add(oFlujoBE);
                    
                }
                
                ojqbjectBE.setPage(oFlujoBE1.getPage());
                ojqbjectBE.setTotal(oFlujoBE1.getTotal_pages());
                ojqbjectBE.setRecords(oFlujoBE1.getTotal());
                ojqbjectBE.setRows(listaFlujoBE);
                
            }
            
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            rs.close();
            rs = null;
            cn.close();
            cn = null;
            oFlujoBE1 = null;
        }
        return ojqbjectBE;
    }
    
    public int insertarRegistrosFlujoBE(ArrayList<FlujoBE> oListaFlujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            
            cn.setAutoCommit(false);
            
            for (FlujoBE oFlujoBE : oListaFlujoBE) {
                cs = cn.prepareCall("{call uspInsertarFlujo(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oFlujoBE.getIdexpediente());
                cs.setInt(2, oFlujoBE.getIdestadoflujo());
                cs.setInt(3, oFlujoBE.getIdusuario());
                cs.setInt(4, oFlujoBE.getIdusuarioenvia());
                cs.setInt(5, oFlujoBE.getIdusuariorecepciona());
                Date fechaenvio = new Date(oFlujoBE.getFechaenvio().getTime());
                cs.setDate(6, fechaenvio);
                Date fechalectura = new Date(oFlujoBE.getFechalectura().getTime());
                cs.setDate(7, fechalectura);
                cs.setString(8, oFlujoBE.getAsunto());
                cs.setString(9, oFlujoBE.getDescripcion());
                cs.setString(10, oFlujoBE.getObservacion());
                cs.setBoolean(11, oFlujoBE.isBinderror());
                cs.setBoolean(12, oFlujoBE.isEstado());
                cs.setInt(13, oFlujoBE.getIdenvio());
                cs.registerOutParameter(14, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(14);
                cs.close();
                cs = null;
            }
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
            
        }
        return resultado;
    }
    
    public int derivarExpedienteFlujo(ArrayList<FlujoBE> oListaFlujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            
            cn.setAutoCommit(false);
            
            for (FlujoBE oFlujoBE : oListaFlujoBE) {
                cs = cn.prepareCall("{call uspderivarflujo(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oFlujoBE.getIdflujoparent());
                cs.setInt(2, oFlujoBE.getIdexpediente());
                cs.setInt(3, oFlujoBE.getIdestadoflujo());
                cs.setInt(4, oFlujoBE.getIdusuario());
                cs.setInt(5, oFlujoBE.getIdusuarioenvia());
                cs.setInt(6, oFlujoBE.getIdusuariorecepciona());
                cs.setString(7, oFlujoBE.getAsunto());
                cs.setString(8, oFlujoBE.getDescripcion());
                cs.setString(9, oFlujoBE.getObservacion());
                cs.setBoolean(10, oFlujoBE.isBinderror());
                cs.setBoolean(11, oFlujoBE.isEstado());
                cs.setInt(12, oFlujoBE.getIdenvio());
                cs.registerOutParameter(13, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(13);
                cs.close();
                cs = null;
            }
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
            
        }
        return resultado;
    }
    
    public int insertarFlujoBE(FlujoBE oFlujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            
            cn.setAutoCommit(false);
            
            cs = cn.prepareCall("{call uspInsertarFlujo(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oFlujoBE.getIdexpediente());
            cs.setInt(2, oFlujoBE.getIdestadoflujo());
            cs.setInt(3, oFlujoBE.getIdusuario());
            cs.setInt(4, oFlujoBE.getIdusuarioenvia());
            cs.setInt(5, oFlujoBE.getIdusuariorecepciona());
            Date fechaenvio = new Date(oFlujoBE.getFechaenvio().getTime());
            cs.setDate(6, fechaenvio);
            //Date fechalectura = new Date(oFlujoBE.getFechalectura().getTime());
            cs.setDate(7, null);
            cs.setString(8, oFlujoBE.getAsunto());
            cs.setString(9, oFlujoBE.getDescripcion());
            cs.setString(10, oFlujoBE.getObservacion());
            cs.setBoolean(11, oFlujoBE.isBinderror());
            cs.setBoolean(12, oFlujoBE.isEstado());
            cs.registerOutParameter(13, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(13);
            cs.close();
            cs = null;
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            System.out.println("message: " + ex.getMessage());
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
            
        }
        return resultado;
    }
    
    public int actualizarFlujoBE(FlujoBE oFlujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            
            cn.setAutoCommit(false);
            
            cs = cn.prepareCall("{call uspActualizarFlujo(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oFlujoBE.getIdflujo());
            cs.setInt(2, oFlujoBE.getIdexpediente());
            cs.setInt(3, oFlujoBE.getIdestadoflujo());
            cs.setInt(4, oFlujoBE.getIdusuario());
            cs.setInt(5, oFlujoBE.getIdusuarioenvia());
            cs.setInt(6, oFlujoBE.getIdusuariorecepciona());
            Date fechaenvio = new Date(oFlujoBE.getFechaenvio().getTime());
            cs.setDate(7, fechaenvio);
            Date fechalectura = new Date(oFlujoBE.getFechalectura().getTime());
            cs.setDate(8, fechalectura);
            cs.setString(9, oFlujoBE.getAsunto());
            cs.setString(10, oFlujoBE.getDescripcion());
            cs.setString(11, oFlujoBE.getObservacion());
            cs.setBoolean(12, oFlujoBE.isBinderror());
            cs.setBoolean(13, oFlujoBE.isEstado());
            cs.registerOutParameter(13, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(13);
            cs.close();
            cs = null;
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
            
        }
        return resultado;
    }
    
    public int actualizarEstadoFlujoBE(FlujoBE oFlujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            
            cs = cn.prepareCall("{call uspcambiarestadoflujo(?,?,?,?,?,?)}");
            cs.setInt(1, oFlujoBE.getIdflujo());
            cs.setInt(2, oFlujoBE.getIdestadoflujo());
            cs.setString(3, oFlujoBE.getCuerporespuesta());
            cs.setInt(4, oFlujoBE.getIdusuario());
            cs.setInt(5, oFlujoBE.getIdarea());
            cs.setString(6, oFlujoBE.getSfecharegistro());
            cs.registerOutParameter(6, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(6);
            cs.close();
            cs = null;
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
            
        }
        return resultado;
    }
    
    public int registroderivarflujo(FlujoBE oFlujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            
            cs = cn.prepareCall("{call uspderivarexpediente_area(?,?,?,?)}");
            cs.setInt(1, oFlujoBE.getIdflujo());
            cs.setInt(2, oFlujoBE.getIdusuario());
            cs.setInt(3, oFlujoBE.getIdarea());
            cs.setInt(4, oFlujoBE.getIdexpediente());
            
            cs.registerOutParameter(4, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(4);
            cs.close();
            cs = null;
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
            
        }
        return resultado;
    }
    
    public int eliminarFlujoBE(FlujoBE oFlujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            
            cn.setAutoCommit(false);
            
            cs = cn.prepareCall("{call uspEliminarFlujo(?)}");
            cs.setInt(1, oFlujoBE.getIdflujo());
            cs.registerOutParameter(1, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(1);
            cs.close();
            cs = null;
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
            
        }
        return resultado;
    }
    
    public int lecturaFlujoBE(FlujoBE oFlujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            
            cn.setAutoCommit(false);
            
            cs = cn.prepareCall("{call upssetexpleido(?)}");
            cs.setInt(1, oFlujoBE.getIdflujo());
            cs.registerOutParameter(1, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(1);
            cs.close();
            cs = null;
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
            
        }
        return resultado;
    }
    
    public ResultSet listarRS(String query) throws SQLException {
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = query;
            pst = cn.prepareStatement(sql);
            rs = pst.executeQuery();
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;
        }
        return rs;
    }
    
    public List listObjectFlujoBE(FlujoBE oFlujoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";
        
        try {
            
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            
            if (oFlujoBE.getIndOpSp() == 1) {
                sql = " SELECT idflujo,idexpediente,idestadoflujo,idusuario,idusuarioenvia,idusuariorecepciona,fechaenvio,fechalectura,asunto,descripcion,observacion,binderror,estado FROM flujo WHERE idflujo=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);
                
                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }
                
            }
            if (oFlujoBE.getIndOpSp() == 2) {
                sql = "select * from usp_listar_estadoexpediente2(" + oFlujoBE.getIdusuariorecepciona() + ")";
                
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);
                
                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3)};
                    list.add(obj);
                }
                
            }
            
            if (oFlujoBE.getIndOpSp() == 3) {
                sql = "SELECT * FROM usp_listarexpedientes_estado_atencion(" + oFlujoBE.getIdusuariorecepciona() + ")";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);
                
                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3)};
                    list.add(obj);
                }
                
            }
            
            if (oFlujoBE.getIndOpSp() == 4) { //detalle del expediente que llego
                sql = "select  b.codigo nro_expediente,b.asunto,b.dni_ruc,b.nombre_razonsocial,b.apellidos,b.direccion,b.telefono,b.correo\n"
                        + ",to_char(b.fecharegistro,'dd/mm/yyyy hh:mm') fecharegistro,to_char(r.fecharecepcion,'DD/MM/YYYY HH24:MI:SS') fecha_recepcion \n"
                        + ",c.denominacion area,d.denominacion procedimiento\n"
                        + "from flujo a\n"
                        + "inner join expediente b on a.idexpediente=b.idexpediente\n"
                        + "inner join recepcion r  on a.idexpediente=r.idexpediente\n"
                        + "inner join area c on b.idarea=c.idarea\n"
                        + "inner join procedimiento d on b.idprocedimiento=d.idprocedimiento\n"
                        + "where a.idflujo=" + oFlujoBE.getIdflujo() + "\n"
                        + "--and bindparent=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql4 Flujo Controller: " + sql);
                
                while (rs.next()) {
                    Object[] obj = {
                        rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getString(7), rs.getString(8), rs.getString(9), rs.getString(10), rs.getString(11), rs.getString(12)
                    };
                    list.add(obj);
                }
                
            }
            
            if (oFlujoBE.getIndOpSp() == 5) { //detalle del expediente que llego
                sql = "select idestadoflujo,denominacion from estadoflujo where\n"
                        + "estado=true \n"
                        + "order by orden asc limit 3";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);
                
                while (rs.next()) {
                    Object[] obj = {
                        rs.getString(1), rs.getString(2)
                    };
                    list.add(obj);
                }
                
            }
            
            if (oFlujoBE.getIndOpSp() == 6) { //cargando los tipos de documentos
                sql = "select idtipodocumento,denominacion from tipodocumento \n"
                        + "where estado=true\n"
                        + "order by orden asc";
                
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);
                
                while (rs.next()) {
                    Object[] obj = {
                        rs.getString(1), rs.getString(2)
                    };
                    list.add(obj);
                }
                
            }
            
            if (oFlujoBE.getIndOpSp() == 7) { //cargando los tipos de documentos
                sql = "select uspgenerarcodigodocumento(" + oFlujoBE.getIdtipodocumento() + "," + oFlujoBE.getIdarea() + "," + oFlujoBE.getIdusuario() + "," + oFlujoBE.getIdcargo() + "," + oFlujoBE.isFirma() + ")";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);
                
                while (rs.next()) {
                    Object[] obj = {
                        rs.getString(1)
                    };
                    list.add(obj);
                }
                
            }
            
            cn.commit();
            cn.setAutoCommit(true);
        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            rs.close();
            rs = null;
            cn.close();
            cn = null;
            oFlujoBE = null;
        }
        return list;
    }
    
}
