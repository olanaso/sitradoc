package mph.tramitedoc.da;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.EventoBE;

/**
 * @author djackob
 */
public class EventoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public EventoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public EventoBE listarEventoBE(EventoBE oEventoBE1) throws SQLException {
        EventoBE oEventoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oEventoBE = new EventoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oEventoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idevento, iddocumento, idexpediente, idarearecepciona, idareadestino, idusuariorecepciona, idusuariodestino, estadoevento, denominacion, codigo, arearecepciona, areadestino, usuariorecepciona, usuariodestino, diasatencion, fecharecepciona, fechadestino, estado from evento WHERE idevento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oEventoBE1.getIdevento());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
             
            while (rs.next()) {
                oEventoBE.setIdevento(rs.getInt("idevento"));
                oEventoBE.setDenominacion(rs.getString("denominacion"));
                oEventoBE.setEstado(rs.getBoolean("estado"));
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
        return oEventoBE;
    }

    public ArrayList<EventoBE> listarRegistroEventoBE(EventoBE oEventoBE1) throws SQLException {
        ArrayList<EventoBE> listaEventoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaEventoBE = new ArrayList<EventoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oEventoBE1.getIndOpSp() == 1) {
                sql = "SELECT '<i style=\\\"cursor:pointer;\\\" onclick=\\\"edit('||a1.idevento||')\\\" class=\\\"fa fa-pencil-square-o\\\">"
                        + "</i>','<i style=\\\"cursor:pointer;\\\" onclick=\\\"del('||a1.idevento||')\\\" class=\\\"fa fa-trash-o\\\"></i>',"
                        + "a1.idevento,a1.abreviatura,a1.codigo,a1.denominacion,a1.ideventosuperior,a2.denominacion as eventosuperior,a1.estado "
                        + "from evento a1 left join evento a2 on a1.ideventosuperior = a2.idevento where a1.estado = true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    EventoBE oEventoBE = new EventoBE();
                    oEventoBE.setEdit(rs.getString(1));
                    oEventoBE.setDel(rs.getString(2));
                    oEventoBE.setIdevento(rs.getInt("idevento"));
                    oEventoBE.setCodigo(rs.getString("codigo"));
                    oEventoBE.setDenominacion(rs.getString("denominacion"));
                    oEventoBE.setEstado(rs.getBoolean("estado"));
                    listaEventoBE.add(oEventoBE);
                }
            }
            if (oEventoBE1.getIndOpSp() == 2) {
                sql = " SELECT idevento, iddocumento, idexpediente, idarearecepciona, idareadestino, idusuariorecepciona, idusuariodestino, estadoevento, denominacion, codigo, arearecepciona, areadestino, usuariorecepciona, usuariodestino, diasatencion, fecharecepciona, fechadestino, estado from evento WHERE idevento=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setInt(1, oEventoBE1.getIdevento());
                rs = pst.executeQuery();
                while (rs.next()) {
                    EventoBE oEventoBE = new EventoBE();

                    oEventoBE.setIdevento(rs.getInt("idevento"));
                    oEventoBE.setDenominacion(rs.getString("denominacion"));
                    oEventoBE.setEstado(rs.getBoolean("estado"));
                    listaEventoBE.add(oEventoBE);
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
            oEventoBE1 = null;
        }
        return listaEventoBE;
    }

    public int insertarRegistrosEventoBE(ArrayList<EventoBE> oListaEventoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (EventoBE oEventoBE : oListaEventoBE) {
                cs = cn.prepareCall("{call uspInsertarEvento(?,?,?,?)}");
                cs.setInt(1, oEventoBE.getIddocumento());
//                cs.setInt(2, oEventoBE.getIdexpediente());
                cs.setInt(2, oEventoBE.getIdarearecepciona());
                cs.setInt(3, oEventoBE.getIdusuariorecepciona());
//                cs.setString(7, oEventoBE.getEstadoevento());
//                cs.setString(8, oEventoBE.getDenominacion());
//                cs.setString(9, oEventoBE.getCodigo());
//                cs.setString(10, oEventoBE.getArearecepciona());
//                cs.setString(11, oEventoBE.getAreadestino());
//                cs.setString(12, oEventoBE.getUsuariorecepciona());
//                cs.setString(13, oEventoBE.getUsuariodestino());
//                cs.setDouble(14, oEventoBE.getDiasatencion());
//                Date fecharecepciona = new Date(oEventoBE.getFecharecepciona().getTime());
//                cs.setDate(15, (java.sql.Date) fecharecepciona);
//                Date fechadestino = new Date(oEventoBE.getFechadestino().getTime());
//                cs.setDate(16, (java.sql.Date) fechadestino);
//                cs.setBoolean(17, oEventoBE.isEstado());
                cs.registerOutParameter(4, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(4);
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

    public int insertarEventoBE(EventoBE oEventoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarEvento(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oEventoBE.getIddocumento());
            cs.setInt(2, oEventoBE.getIdexpediente());
            cs.setInt(3, oEventoBE.getIdarearecepciona());
            cs.setInt(4, oEventoBE.getIdareadestino());
            cs.setInt(5, oEventoBE.getIdusuariorecepciona());
            cs.setInt(6, oEventoBE.getIdusuariodestino());
            cs.setString(7, oEventoBE.getEstadoevento());
            cs.setString(8, oEventoBE.getDenominacion());
            cs.setString(9, oEventoBE.getCodigo());
            cs.setString(10, oEventoBE.getArearecepciona());
            cs.setString(11, oEventoBE.getAreadestino());
            cs.setString(12, oEventoBE.getUsuariorecepciona());
            cs.setString(13, oEventoBE.getUsuariodestino());
            cs.setDouble(14, oEventoBE.getDiasatencion());
            Date fecharecepciona = new Date(oEventoBE.getFecharecepciona().getTime());
            cs.setDate(15, (java.sql.Date) fecharecepciona);
            Date fechadestino = new Date(oEventoBE.getFechadestino().getTime());
            cs.setDate(16, (java.sql.Date) fechadestino);
            cs.setBoolean(17, oEventoBE.isEstado());
            cs.registerOutParameter(18, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(18);
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

    public int actualizarEventoBE(EventoBE oEventoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarEvento(?,?,?)}");
//            cs.setInt(1, oEventoBE.getIdevento());
//            cs.setInt(2, oEventoBE.getIddocumento());
            cs.setInt(1, oEventoBE.getIdexpediente());
//            cs.setInt(4, oEventoBE.getIdarearecepciona());
//            cs.setInt(5, oEventoBE.getIdareadestino());
//            cs.setInt(6, oEventoBE.getIdusuariorecepciona());
//            cs.setInt(7, oEventoBE.getIdusuariodestino());
//            cs.setString(8, oEventoBE.getEstadoevento());
//            cs.setString(9, oEventoBE.getDenominacion());
//            cs.setString(10, oEventoBE.getCodigo());
//            cs.setString(11, oEventoBE.getArearecepciona());
            cs.setString(2, oEventoBE.getAreadestino());
//            cs.setString(13, oEventoBE.getUsuariorecepciona());
            cs.setString(3, oEventoBE.getUsuariodestino());
//            cs.setDouble(15, oEventoBE.getDiasatencion());
//            Date fecharecepciona = new Date(oEventoBE.getFecharecepciona().getTime());
//            cs.setDate(16, (java.sql.Date) fecharecepciona);
//            Date fechadestino = new Date(oEventoBE.getFechadestino().getTime());
//            cs.setDate(17, (java.sql.Date) fechadestino);
//            cs.setBoolean(18, oEventoBE.isEstado());
            cs.registerOutParameter(3, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(3);
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

    public int eliminarEventoBE(EventoBE oEventoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarEvento(?)}");
            cs.setInt(1, oEventoBE.getIdevento());
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

    public List listObjectEventoBE(EventoBE oEventoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oEventoBE.getIndOpSp() == 1) {
                sql = " SELECT idevento,denominacion,estado FROM evento WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oEventoBE.getIndOpSp() == 2) {
                sql = " SELECT idevento,denominacion FROM evento WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
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
            oEventoBE = null;
        }
        return list;
    }
}
