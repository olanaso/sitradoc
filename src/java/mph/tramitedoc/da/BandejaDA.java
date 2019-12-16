package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.BandejaBE;
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

public class BandejaDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public BandejaDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public BandejaBE listarBandejaBE(BandejaBE oBandejaBE1) throws SQLException {
        BandejaBE oBandejaBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oBandejaBE = new BandejaBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oBandejaBE1.getIndOpSp() == 1) {

                String sql = " SELECT idbandeja,iddocumento,idareaproviene,idareadestino,idusuarioenvia,idusuariodestino,bindrecepcion,idusuariorecepciona,fecharecepciona,fechalectura,fechaderivacion,fecharegistro,estado FROM bandeja WHERE idbandeja=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oBandejaBE1.getIdbandeja());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oBandejaBE.setIdbandeja(rs.getInt("idbandeja"));
                oBandejaBE.setIddocumento(rs.getInt("iddocumento"));
                oBandejaBE.setIdareaproviene(rs.getInt("idareaproviene"));
                oBandejaBE.setIdareadestino(rs.getInt("idareadestino"));
                oBandejaBE.setIdusuarioenvia(rs.getInt("idusuarioenvia"));
                oBandejaBE.setIdusuariodestino(rs.getInt("idusuariodestino"));
                oBandejaBE.setBindrecepcion(rs.getBoolean("bindrecepcion"));
                oBandejaBE.setIdusuariorecepciona(rs.getInt("idusuariorecepciona"));
                oBandejaBE.setFecharecepciona(rs.getDate("fecharecepciona"));
                oBandejaBE.setFechalectura(rs.getDate("fechalectura"));
                oBandejaBE.setFechaderivacion(rs.getDate("fechaderivacion"));
                oBandejaBE.setFecharegistro(rs.getDate("fecharegistro"));
                oBandejaBE.setEstado(rs.getBoolean("estado"));
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
        return oBandejaBE;
    }

    public ArrayList<BandejaBE> listarRegistroBandejaBE(BandejaBE oBandejaBE1) throws SQLException {
        ArrayList<BandejaBE> listaBandejaBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaBandejaBE = new ArrayList<BandejaBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oBandejaBE1.getIndOpSp() == 1) { //bandeja de entrada
                sql = " select b.idmensaje,\n"
                        + "case when a.bindleido=false then '<b>'||c.nombres||' '||c.apellidos||'</b>'  else c.nombres||' '||c.apellidos  end usuarioenvia ,\n"
                        + "case when a.bindleido=false then '<b>'||b.asunto||'</b>'  else b.asunto  end asunto ,\n"
                        + "case when a.bindleido=false then '<b>'||b.mensaje||'</b>'  else b.mensaje  end  mensaje,\n"
                        + "case when to_char( b.fechacreacion,'dd/mm/yyyy')=to_char(now(),'dd/mm/yyyy') \n"
                        + "then to_char(b.fechacreacion,'HH24:MI:SS') else to_char(b.fechacreacion,'DD Mon YYYY HH24:MI')  end  fechaenvio,\n"
                        + "case when (select  count(idmensaje) from archivomensaje where idmensaje=b.idmensaje)>0 then '<i class=\"fa fa-paperclip\" aria-hidden=\"true\"></i>'\n"
                        + "else '' end adjunto\n"
                        + "from bandeja a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "inner join usuario c on c.idusuario=a.idusuarioenvia\n"
                        + "where a.idusuariodestino=" + oBandejaBE1.getIdusuariodestino() + "\n"
                        + "and a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and c.estado=true\n"
                        + "order by b.fechacreacion desc";

                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    BandejaBE oBandejaBE = new BandejaBE();

                    oBandejaBE.setIdbandeja(rs.getInt("idbandeja"));
                    oBandejaBE.setUsuarioenvia(rs.getString("usuarioenvia"));
                    oBandejaBE.setAsunto(rs.getString("asunto"));
                    oBandejaBE.setMensaje(rs.getString("mensaje"));
                    oBandejaBE.setFechaenvio(rs.getString("fechaenvio"));
                    oBandejaBE.setAdjunto(rs.getString("adjunto"));

                    listaBandejaBE.add(oBandejaBE);
                }

            }
            if (oBandejaBE1.getIndOpSp() == 2) { //bandeja de salida
                sql = " select m.idmensaje,'PARA: '||(\n"
                        + "				select array_to_string(array_agg(b.nombres), ',') from bandeja a\n"
                        + "				inner join usuario b on b.idusuario=a.idusuariodestino\n"
                        + "where a.idmensaje=m.idmensaje\n"
                        + ") usuarioenvia, m.asunto,m.mensaje \n"
                        + ",case when to_char( m.fechacreacion,'dd/mm/yyyy')=to_char(now(),'dd/mm/yyyy') \n"
                        + "then to_char(m.fechacreacion,'HH24:MI:SS') else to_char(m.fechacreacion,'DD Mon YYYY HH24:MI')  end  fechaenvio,\n"
                        + "case when (select  count(idmensaje) from archivomensaje where idmensaje=m.idmensaje)>0 then '<i class=\"fa fa-paperclip\" aria-hidden=\"true\"></i>'\n"
                        + "else '' end adjunto\n"
                        + "from mensaje m\n"
                        + "where \n"
                        + "m.idusuariocreacion=" + oBandejaBE1.getIdusuariodestino() + "\n"
                        + "and m.estado=true\n"
                        + "order by m.fechacreacion desc";

                pst = cn.prepareStatement(sql);
                pst.setInt(1, oBandejaBE1.getIdbandeja());
                rs = pst.executeQuery();

                while (rs.next()) {
                    BandejaBE oBandejaBE = new BandejaBE();

                    oBandejaBE.setIdbandeja(rs.getInt("idbandeja"));
                    oBandejaBE.setUsuarioenvia(rs.getString("usuarioenvia"));
                    oBandejaBE.setAsunto(rs.getString("asunto"));
                    oBandejaBE.setMensaje(rs.getString("mensaje"));
                    oBandejaBE.setFechaenvio(rs.getString("fechaenvio"));
                    oBandejaBE.setAdjunto(rs.getString("adjunto"));

                    listaBandejaBE.add(oBandejaBE);
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
            oBandejaBE1 = null;
        }
        return listaBandejaBE;
    }

    ArrayList<BandejaBE> listaBandejaBE = null;

    public JQObjectBE listarJQRegistroDocumentoBE(BandejaBE oBandejaBE1) throws SQLException {
        JQObjectBE ojqbjectBE = new JQObjectBE();
        JQgridUtil oJQgridUtil = new JQgridUtil();

        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaBandejaBE = new ArrayList<BandejaBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            String sql_calc_cant_rows = "";

            if (oBandejaBE1.getIndOpSp() == 1) {

                /*Calculando la paginacion*/
                sql_calc_cant_rows = " select count(b.idmensaje) total\n"
                        + "from bandeja a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "inner join usuario c on c.idusuario=a.idusuarioenvia\n"
                        + "where a.idusuariodestino=" + oBandejaBE1.getIdusuariodestino() + "\n"
                        + "and a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and c.estado=true\n";

                System.out.println("sql calc cantidad:" + sql_calc_cant_rows);
                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oBandejaBE1);

                /*Calculando la paginacion*/
                sql = " select a.idbandeja,b.idmensaje,\n"
                        + "case when a.bindleido=false then '<b>'||c.nombres||' '||c.apellidos||'</b>'  else c.nombres||' '||c.apellidos  end usuarioenvia ,\n"
                        + "case when a.bindleido=false then '<b>'||b.asunto||'</b>'  else b.asunto  end asunto ,\n"
                        + "case when a.bindleido=false then '<b>'||b.mensaje||'</b>'  else b.mensaje  end  mensaje,\n"
                        + "case when to_char( b.fechacreacion,'dd/mm/yyyy')=to_char(now(),'dd/mm/yyyy') \n"
                        + "then to_char(b.fechacreacion,'HH24:MI:SS') else to_char(b.fechacreacion,'DD Mon YYYY HH24:MI')  end  fechaenvio,\n"
                        + "case when (select  count(idmensaje) from archivomensaje where idmensaje=b.idmensaje)>0 then '<i class=\"fa fa-paperclip\" aria-hidden=\"true\"></i>'\n"
                        + "else '' end adjunto,\n"
                        + "case when a.bindrecepcion=false then 'PENDIENTE'  else 'RECEPCIONADO - '||to_char(a.fecharecepciona,'HH24:MI:SS')   end  recepcion\n"
                        + ", a.bindrecepcion, b.bindrespuesta,b.prioridad, date_part('day', now() - b.fechacreacion ) + (select count(idferiado)  from feriado \n"
                        + " where fecha between b.fechacreacion and now() and estado=true)- b.diasrespuesta dias_restantes,b.diasrespuesta"
                        + " from bandeja a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "inner join usuario c on c.idusuario=a.idusuarioenvia\n"
                        + "where a.idusuariodestino=" + oBandejaBE1.getIdusuariodestino() + "\n"
                        + "and a.bindatendido=false\n"
                        + "and a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and c.estado=true\n"
                        + "order by b.fechacreacion desc\n"
                        + "limit " + oBandejaBE1.getRows() + " offset " + oBandejaBE1.getStart();
                System.out.println("listar  bandeja 1:" + sql);
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    BandejaBE oBandejaBE = new BandejaBE();

                    oBandejaBE.setIdbandeja(rs.getInt("idbandeja"));
                    oBandejaBE.setIdmensaje(rs.getInt("idmensaje"));
                    oBandejaBE.setUsuarioenvia(rs.getString("usuarioenvia"));
                    oBandejaBE.setAsunto(rs.getString("asunto"));
                    oBandejaBE.setMensaje(rs.getString("mensaje"));
                    oBandejaBE.setFechaenvio(rs.getString("fechaenvio"));
                    oBandejaBE.setAdjunto(rs.getString("adjunto"));
                    oBandejaBE.setRecepcion(rs.getString("recepcion"));

                    listaBandejaBE.add(oBandejaBE);
                }

                ojqbjectBE.setPage(oBandejaBE1.getPage());
                ojqbjectBE.setTotal(oBandejaBE1.getTotal_pages());
                ojqbjectBE.setRecords(oBandejaBE1.getTotal());
                ojqbjectBE.setRows(listaBandejaBE);
            }

            if (oBandejaBE1.getIndOpSp() == 2) {

                /*Calculando la paginacion*/
                sql_calc_cant_rows = "select count(m.idmensaje) total\n"
                        + "from mensaje m\n"
                        + "where \n"
                        + "m.idusuariocreacion=" + oBandejaBE1.getIdusuariodestino() + "\n"
                        + "and m.estado=true\n";

                System.out.println("sql calc cantidad:" + sql_calc_cant_rows);

                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oBandejaBE1);

                /*Calculando la paginacion*/
                sql = " select m.idmensaje,'PARA: '||(\n"
                        + "				select array_to_string(array_agg(b.nombres), ',') from bandeja a\n"
                        + "				inner join usuario b on b.idusuario=a.idusuariodestino\n"
                        + "where a.idmensaje=m.idmensaje\n"
                        + ") usuarioenvia, m.asunto,m.mensaje \n"
                        + ",case when to_char( m.fechacreacion,'dd/mm/yyyy')=to_char(now(),'dd/mm/yyyy') \n"
                        + "then to_char(m.fechacreacion,'HH24:MI:SS') else to_char(m.fechacreacion,'DD Mon YYYY HH24:MI')  end  fechaenvio,\n"
                        + "case when (select  count(idmensaje) from archivomensaje where idmensaje=m.idmensaje)>0 then '<i class=\"fa fa-paperclip\" aria-hidden=\"true\"></i>'\n"
                        + "else '' end adjunto\n"
                        + "from mensaje m\n"
                        + "where \n"
                        + "m.idusuariocreacion=" + oBandejaBE1.getIdusuariodestino() + "\n"
                        + "and m.estado=true\n"
                        + "order by m.fechacreacion desc"
                        + " limit " + oBandejaBE1.getRows() + " offset " + oBandejaBE1.getStart();
                System.out.println("sql por recibir 4:" + sql);
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    BandejaBE oBandejaBE = new BandejaBE();

                    oBandejaBE.setIdmensaje(rs.getInt("idmensaje"));
                    oBandejaBE.setUsuarioenvia(rs.getString("usuarioenvia"));
                    oBandejaBE.setAsunto(rs.getString("asunto"));
                    oBandejaBE.setMensaje(rs.getString("mensaje"));
                    oBandejaBE.setFechaenvio(rs.getString("fechaenvio"));
                    oBandejaBE.setAdjunto(rs.getString("adjunto"));

                    listaBandejaBE.add(oBandejaBE);
                }

                ojqbjectBE.setPage(oBandejaBE1.getPage());
                ojqbjectBE.setTotal(oBandejaBE1.getTotal_pages());
                ojqbjectBE.setRecords(oBandejaBE1.getTotal());
                ojqbjectBE.setRows(listaBandejaBE);
            }

            if (oBandejaBE1.getIndOpSp() == 3) {

                /*Calculando la paginacion*/
                //(IN _idsarea text, IN _idsusuarioenvia text, IN _asunto text, IN _mensaje text, IN _indsrecepcion text
                //, IN _indsrespuesta text, IN _indsprioridad text, IN _vencidosactivos text
                //, IN fechainicio text, IN fechafin text, IN limite text, IN offsete text)
                sql_calc_cant_rows = "select * from listar_bandeja_cant_entrada_tramite_interno"
                        + "('" + oBandejaBE1.getIdusuariodestino() + "','" + oBandejaBE1.getB_idsarea() + "','" + oBandejaBE1.getB_idsusuarioenvia() + "', '" + oBandejaBE1.getB_asunto() + "', '" + oBandejaBE1.getB_mensaje() + "','" + oBandejaBE1.getB_indsrecepcion() + "'"
                        + ", '" + oBandejaBE1.getB_indsrespuesta() + "', '" + oBandejaBE1.getB_indsprioridad() + "', '" + oBandejaBE1.getB_vencidosactivos() + "', '" + oBandejaBE1.getB_fechainicio() + "'"
                        + ", '" + oBandejaBE1.getB_fechafin() + "', '" + oBandejaBE1.getLimite() + "', '" + oBandejaBE1.getOffsete() + "')";

                System.out.println("sql calc cantidad:" + sql_calc_cant_rows);
                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oBandejaBE1);

                /*Calculando la paginacion*/
                sql = "select * from listar_bandeja_entrada_tramite_interno"
                        + "('" + oBandejaBE1.getIdusuariodestino() + "','" + oBandejaBE1.getB_idsarea() + "','" + oBandejaBE1.getB_idsusuarioenvia() + "', '" + oBandejaBE1.getB_asunto() + "', '" + oBandejaBE1.getB_mensaje() + "','" + oBandejaBE1.getB_indsrecepcion() + "'"
                        + ", '" + oBandejaBE1.getB_indsrespuesta() + "', '" + oBandejaBE1.getB_indsprioridad() + "', '" + oBandejaBE1.getB_vencidosactivos() + "', '" + oBandejaBE1.getB_fechainicio() + "'"
                        + ", '" + oBandejaBE1.getB_fechafin() + "', '" + oBandejaBE1.getLimite() + "', '" + oBandejaBE1.getOffsete() + "')";

                System.out.println("sql por recibir busqueda avanzada" + sql);
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    BandejaBE oBandejaBE = new BandejaBE();

                    oBandejaBE.setIdbandeja(rs.getInt("idbandeja"));
                    oBandejaBE.setIdmensaje(rs.getInt("idmensaje"));
                    oBandejaBE.setUsuarioenvia(rs.getString("usuarioenvia"));
                    oBandejaBE.setAsunto(rs.getString("asunto"));
                    oBandejaBE.setMensaje(rs.getString("mensaje"));
                    oBandejaBE.setFechaenvio(rs.getString("fechaenvio"));
                    oBandejaBE.setAdjunto(rs.getString("adjunto"));
                    oBandejaBE.setRecepcion(rs.getString("recepcion"));

                    listaBandejaBE.add(oBandejaBE);
                }

                ojqbjectBE.setPage(oBandejaBE1.getPage());
                ojqbjectBE.setTotal(oBandejaBE1.getTotal_pages());
                ojqbjectBE.setRecords(oBandejaBE1.getTotal());
                ojqbjectBE.setRows(listaBandejaBE);
            }

            if (oBandejaBE1.getIndOpSp() == 4) {

                /*Calculando la paginacion*/
                sql_calc_cant_rows = " select count(b.idmensaje) total\n"
                        + "from bandeja a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "inner join usuario c on c.idusuario=a.idusuarioenvia\n"
                        + "where a.idusuariodestino=" + oBandejaBE1.getIdusuariodestino() + "\n"
                        + "and a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and c.estado=true\n";

                System.out.println("sql calc cantidad:" + sql_calc_cant_rows);
                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oBandejaBE1);

                /*Calculando la paginacion*/
                sql = " select a.idbandeja,b.idmensaje,\n"
                        + "case when a.bindleido=false then '<b>'||c.nombres||' '||c.apellidos||'</b>'  else c.nombres||' '||c.apellidos  end usuarioenvia ,\n"
                        + "case when a.bindleido=false then '<b>'||b.asunto||'</b>'  else b.asunto  end asunto ,\n"
                        + "case when a.bindleido=false then '<b>'||b.mensaje||'</b>'  else b.mensaje  end  mensaje,\n"
                        + "case when to_char( b.fechacreacion,'dd/mm/yyyy')=to_char(now(),'dd/mm/yyyy') \n"
                        + "then to_char(b.fechacreacion,'HH24:MI:SS') else to_char(b.fechacreacion,'DD Mon YYYY HH24:MI')  end  fechaenvio,\n"
                        + "case when (select  count(idmensaje) from archivomensaje where idmensaje=b.idmensaje)>0 then '<i class=\"fa fa-paperclip\" aria-hidden=\"true\"></i>'\n"
                        + "else '' end adjunto,\n"
                        + "case when a.bindfinalizado=true then 'FINALIZADO EL'||' '||a.fechafinaliza else 'DERIVADO El'||' '||a.fechafinaliza end recepcion\n"
                        + ", a.bindrecepcion, b.bindrespuesta,b.prioridad, date_part('day', now() - b.fechacreacion ) + (select count(idferiado)  from feriado \n"
                        + " where fecha between b.fechacreacion and now() and estado=true)- b.diasrespuesta dias_restantes,b.diasrespuesta"
                        + " from bandeja a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "inner join usuario c on c.idusuario=a.idusuarioenvia\n"
                        + "where a.idusuariodestino=" + oBandejaBE1.getIdusuariodestino() + "\n"
                        + "and a.bindatendido=true\n"
                        + "and a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and c.estado=true\n"
                        + "order by b.fechacreacion desc\n"
                        + "limit " + oBandejaBE1.getRows() + " offset " + oBandejaBE1.getStart();
                System.out.println("listar  bandeja 2 atendidos:" + sql);
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    BandejaBE oBandejaBE = new BandejaBE();

                    oBandejaBE.setIdbandeja(rs.getInt("idbandeja"));
                    oBandejaBE.setIdmensaje(rs.getInt("idmensaje"));
                    oBandejaBE.setUsuarioenvia(rs.getString("usuarioenvia"));
                    oBandejaBE.setAsunto(rs.getString("asunto"));
                    oBandejaBE.setMensaje(rs.getString("mensaje"));
                    oBandejaBE.setFechaenvio(rs.getString("fechaenvio"));
                    oBandejaBE.setAdjunto(rs.getString("adjunto"));
                    oBandejaBE.setRecepcion(rs.getString("recepcion"));

                    listaBandejaBE.add(oBandejaBE);
                }

                ojqbjectBE.setPage(oBandejaBE1.getPage());
                ojqbjectBE.setTotal(oBandejaBE1.getTotal_pages());
                ojqbjectBE.setRecords(oBandejaBE1.getTotal());
                ojqbjectBE.setRows(listaBandejaBE);
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
            oBandejaBE1 = null;
        }

        return ojqbjectBE;
    }

    public int insertarRegistrosBandejaBE(ArrayList<BandejaBE> oListaBandejaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (BandejaBE oBandejaBE : oListaBandejaBE) {
                cs = cn.prepareCall("{call uspInsertarBandeja(?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oBandejaBE.getIdmensaje());
                cs.setInt(2, oBandejaBE.getIdareaproviene());
                cs.setInt(3, oBandejaBE.getIdareadestino());
                cs.setInt(4, oBandejaBE.getIdusuarioenvia());
                cs.setInt(5, oBandejaBE.getIdusuariodestino());
                cs.setBoolean(6, oBandejaBE.isBindrecepcion());
                cs.setInt(7, oBandejaBE.getIdusuariorecepciona());
                cs.setInt(8, oBandejaBE.getIddocumento());
                cs.setString(9, oBandejaBE.getDocumento());
                cs.setString(10, oBandejaBE.getFecha_manual());
                cs.registerOutParameter(11, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(11);
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

    public int insertarBandejaBE(BandejaBE oBandejaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarBandeja(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oBandejaBE.getIddocumento());
            cs.setInt(2, oBandejaBE.getIdareaproviene());
            cs.setInt(3, oBandejaBE.getIdareadestino());
            cs.setInt(4, oBandejaBE.getIdusuarioenvia());
            cs.setInt(5, oBandejaBE.getIdusuariodestino());
            cs.setBoolean(6, oBandejaBE.isBindrecepcion());
            cs.setInt(7, oBandejaBE.getIdusuariorecepciona());
            Date fecharecepciona = new Date(oBandejaBE.getFecharecepciona().getTime());
            cs.setDate(8, fecharecepciona);
            Date fechalectura = new Date(oBandejaBE.getFechalectura().getTime());
            cs.setDate(9, fechalectura);
            Date fechaderivacion = new Date(oBandejaBE.getFechaderivacion().getTime());
            cs.setDate(10, fechaderivacion);
            Date fecharegistro = new Date(oBandejaBE.getFecharegistro().getTime());
            cs.setDate(11, fecharegistro);
            cs.setBoolean(12, oBandejaBE.isEstado());
            cs.registerOutParameter(13, java.sql.Types.INTEGER);
            cs.execute();
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

    public int actualizarBandejaBE(BandejaBE oBandejaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            if (oBandejaBE.getIndOpSp() == 1) {

                cs = cn.prepareCall("{call uspActualizarBandeja(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oBandejaBE.getIdbandeja());
                cs.setInt(2, oBandejaBE.getIddocumento());
                cs.setInt(3, oBandejaBE.getIdareaproviene());
                cs.setInt(4, oBandejaBE.getIdareadestino());
                cs.setInt(5, oBandejaBE.getIdusuarioenvia());
                cs.setInt(6, oBandejaBE.getIdusuariodestino());
                cs.setBoolean(7, oBandejaBE.isBindrecepcion());
                cs.setInt(8, oBandejaBE.getIdusuariorecepciona());
                Date fecharecepciona = new Date(oBandejaBE.getFecharecepciona().getTime());
                cs.setDate(9, fecharecepciona);
                Date fechalectura = new Date(oBandejaBE.getFechalectura().getTime());
                cs.setDate(10, fechalectura);
                Date fechaderivacion = new Date(oBandejaBE.getFechaderivacion().getTime());
                cs.setDate(11, fechaderivacion);
                Date fecharegistro = new Date(oBandejaBE.getFecharegistro().getTime());
                cs.setDate(12, fecharegistro);
                cs.setBoolean(13, oBandejaBE.isEstado());
                cs.registerOutParameter(13, java.sql.Types.INTEGER);
                cs.executeUpdate();
                resultado = cs.getInt(13);
                cs.close();
                cs = null;
                cn.commit();
                cn.setAutoCommit(true);
            }

            if (oBandejaBE.getIndOpSp() == 2) {

                cs = cn.prepareCall("{call uspActualizarBandeja(?,?,?)}");
                cs.setInt(1, oBandejaBE.getIdbandeja());
                cs.setBoolean(2, oBandejaBE.isBindatendido());
                cs.setBoolean(3, oBandejaBE.isBindfinalizado());
                cs.registerOutParameter(3, java.sql.Types.INTEGER);
                cs.executeUpdate();
                resultado = cs.getInt(3);
                cs.close();
                cs = null;
                cn.commit();
                cn.setAutoCommit(true);
            }

            if (oBandejaBE.getIndOpSp() == 3) {

                cs = cn.prepareCall("{call uspverificarrecepcion(?)}");
                cs.setInt(1, oBandejaBE.getIdbandeja());
                cs.registerOutParameter(1, java.sql.Types.INTEGER);
                cs.executeUpdate();
                resultado = cs.getInt(1);
                cs.close();
                cs = null;
                cn.commit();
                cn.setAutoCommit(true);
            }

        } catch (Exception ex) {
            cn.rollback();
            ex.printStackTrace();
        } finally {
            cn.close();
            cn = null;

        }
        return resultado;
    }

    public int eliminarBandejaBE(BandejaBE oBandejaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarBandeja(?)}");
            cs.setInt(1, oBandejaBE.getIdbandeja());
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

    public List listObjectBandejaBE(BandejaBE oBandejaBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        CallableStatement cs = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oBandejaBE.getIndOpSp() == 1) {
                sql = " SELECT idbandeja,iddocumento,idareaproviene,idareadestino,idusuarioenvia,idusuariodestino,bindrecepcion,idusuariorecepciona,fecharecepciona,fechalectura,fechaderivacion,fecharegistro,estado FROM bandeja WHERE idbandeja=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oBandejaBE.getIndOpSp() == 2) {
                sql = "select * from usp_listar_estadobandeja(" + oBandejaBE.getIdusuariorecepciona() + ")";

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)};
                    list.add(obj);
                }

            }
            //mostrando la cantidad de los pendientes por ller
            if (oBandejaBE.getIndOpSp() == 3) {
                sql = "select count(a.idbandeja)\n"
                        + "from bandeja a\n"
                        + "where a.idusuariodestino=" + oBandejaBE.getIdusuariodestino() + "\n"
                        + "and a.estado=true\n"
                        + "and a.bindleido=false\n"
                        + "\n"
                        + "";

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1)};
                    list.add(obj);
                }

            }

            if (oBandejaBE.getIndOpSp() == 4) {
                sql = "select * from mostrar_mensaje("+ oBandejaBE.getIdmensaje()+","+oBandejaBE.getIdareaproviene()+")";
                
                  

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);
                while (rs.next()) {
                    Object[] obj = {rs.getString(1)};
                    list.add(obj);
                }
            }
            if (oBandejaBE.getIndOpSp() == 5) {
                sql = "select  a.iddocumento, b.codigo, b.asunto from documentomensaje a \n"
                        + "inner join documento b on a.iddocumento=b.iddocumento\n"
                        + "where a.idmensaje=" + oBandejaBE.getIdmensaje();

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3)};
                    list.add(obj);
                }

            }
            if (oBandejaBE.getIndOpSp() == 6) {
                sql = "select nombre,url from archivomensaje\n"
                        + "where idmensaje=" + oBandejaBE.getIdmensaje();

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oBandejaBE.getIndOpSp() == 7) {

                cs = cn.prepareCall("{call uspmarcarleidomensaje(?,?)}");
                cs.setInt(1, oBandejaBE.getIdbandeja());
                cs.registerOutParameter(2, java.sql.Types.INTEGER);
                cs.executeUpdate();
                Object[] obj = {cs.getInt(2)};
                list.add(obj);

                cs.close();
                cs = null;

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
            oBandejaBE = null;
        }
        return list;
    }

}
