package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.RecepcioninternaBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class RecepcioninternaDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public RecepcioninternaDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public RecepcioninternaBE listarRecepcioninternaBE(RecepcioninternaBE oRecepcioninternaBE1) throws SQLException {
        RecepcioninternaBE oRecepcioninternaBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oRecepcioninternaBE = new RecepcioninternaBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oRecepcioninternaBE1.getIndOpSp() == 1) {

                String sql = " SELECT idrecepcioninterna,idexpediente,iddocumento,idarea_destino,idarea_proviene,idusuariorecepciona,idusuarioenvia,idrecepcion_proviene,bindentregado,fecharecepcion,bindderivado,bindprimero,fechaderivacion,observacion,estado FROM recepcioninterna WHERE idrecepcioninterna=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oRecepcioninternaBE1.getIdrecepcioninterna());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                
                oRecepcioninternaBE.setIdrecepcioninterna(rs.getInt("idrecepcioninterna"));
                oRecepcioninternaBE.setIdexpediente(rs.getInt("idexpediente"));
                oRecepcioninternaBE.setIdmensaje(rs.getInt("iddocumento"));
                oRecepcioninternaBE.setIdarea_destino(rs.getInt("idarea_destino"));
                oRecepcioninternaBE.setIdarea_proviene(rs.getInt("idarea_proviene"));
                oRecepcioninternaBE.setIdusuariorecepciona(rs.getInt("idusuariorecepciona"));
                oRecepcioninternaBE.setIdusuarioenvia(rs.getInt("idusuarioenvia"));
                oRecepcioninternaBE.setIdrecepcion_proviene(rs.getInt("idrecepcion_proviene"));
                oRecepcioninternaBE.setBindentregado(rs.getBoolean("bindentregado"));
                oRecepcioninternaBE.setFecharecepcion(rs.getDate("fecharecepcion"));
                oRecepcioninternaBE.setBindderivado(rs.getBoolean("bindderivado"));
                oRecepcioninternaBE.setBindprimero(rs.getBoolean("bindprimero"));
                oRecepcioninternaBE.setFechaderivacion(rs.getDate("fechaderivacion"));
                oRecepcioninternaBE.setObservacion(rs.getString("observacion"));
                oRecepcioninternaBE.setEstado(rs.getBoolean("estado"));
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
        return oRecepcioninternaBE;
    }

    public ArrayList<RecepcioninternaBE> listarRegistroRecepcioninternaBE(RecepcioninternaBE oRecepcioninternaBE1) throws SQLException {
        ArrayList<RecepcioninternaBE> listaRecepcioninternaBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaRecepcioninternaBE = new ArrayList<RecepcioninternaBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oRecepcioninternaBE1.getIndOpSp() == 1) {
                sql = " SELECT idrecepcioninterna,idexpediente,iddocumento,idarea_destino,idarea_proviene,idusuariorecepciona,idusuarioenvia,idrecepcion_proviene,bindentregado,fecharecepcion,bindderivado,bindprimero,fechaderivacion,observacion,estado FROM recepcioninterna WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oRecepcioninternaBE1.getIndOpSp() == 2) {
                sql = " SELECT idrecepcioninterna,idexpediente,iddocumento,idarea_destino,idarea_proviene,idusuariorecepciona,idusuarioenvia,idrecepcion_proviene,bindentregado,fecharecepcion,bindderivado,bindprimero,fechaderivacion,observacion,estado FROM recepcioninterna WHERE idrecepcioninterna=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oRecepcioninternaBE1.getIdrecepcioninterna());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                RecepcioninternaBE oRecepcioninternaBE = new RecepcioninternaBE();
                oRecepcioninternaBE.setIdrecepcioninterna(rs.getInt("idrecepcioninterna"));
                oRecepcioninternaBE.setIdexpediente(rs.getInt("idexpediente"));
                oRecepcioninternaBE.setIdmensaje(rs.getInt("idmensaje"));
                oRecepcioninternaBE.setIdarea_destino(rs.getInt("idarea_destino"));
                oRecepcioninternaBE.setIdarea_proviene(rs.getInt("idarea_proviene"));
                oRecepcioninternaBE.setIdusuariorecepciona(rs.getInt("idusuariorecepciona"));
                oRecepcioninternaBE.setIdusuarioenvia(rs.getInt("idusuarioenvia"));
                oRecepcioninternaBE.setIdrecepcion_proviene(rs.getInt("idrecepcion_proviene"));
                oRecepcioninternaBE.setBindentregado(rs.getBoolean("bindentregado"));
                oRecepcioninternaBE.setFecharecepcion(rs.getDate("fecharecepcion"));
                oRecepcioninternaBE.setBindderivado(rs.getBoolean("bindderivado"));
                oRecepcioninternaBE.setBindprimero(rs.getBoolean("bindprimero"));
                oRecepcioninternaBE.setFechaderivacion(rs.getDate("fechaderivacion"));
                oRecepcioninternaBE.setObservacion(rs.getString("observacion"));
                oRecepcioninternaBE.setEstado(rs.getBoolean("estado"));
                listaRecepcioninternaBE.add(oRecepcioninternaBE);
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
            oRecepcioninternaBE1 = null;
        }
        return listaRecepcioninternaBE;
    }

    public int insertarRegistrosRecepcioninternaBE(ArrayList<RecepcioninternaBE> oListaRecepcioninternaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (RecepcioninternaBE oRecepcioninternaBE : oListaRecepcioninternaBE) {
                cs = cn.prepareCall("{call uspInsertarRecepcioninterna(?,?,?,?,?,?,?)}");
  
                cs.setInt(1, oRecepcioninternaBE.getIdmensaje());
                cs.setInt(2, oRecepcioninternaBE.getIdarea_destino());
                cs.setInt(3, oRecepcioninternaBE.getIdarea_proviene());
                cs.setInt(4, oRecepcioninternaBE.getIdusuariorecepciona());
                cs.setInt(5, oRecepcioninternaBE.getIdusuarioenvia());
                cs.setInt(6, oRecepcioninternaBE.getIdrecepcion_proviene());
               
                cs.registerOutParameter(7, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(7);
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

    public int insertarRecepcioninternaBE(RecepcioninternaBE oRecepcioninternaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarRecepcioninterna(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oRecepcioninternaBE.getIdexpediente());
            cs.setInt(2, oRecepcioninternaBE.getIdmensaje());
            cs.setInt(3, oRecepcioninternaBE.getIdarea_destino());
            cs.setInt(4, oRecepcioninternaBE.getIdarea_proviene());
            cs.setInt(5, oRecepcioninternaBE.getIdusuariorecepciona());
            cs.setInt(6, oRecepcioninternaBE.getIdusuarioenvia());
            cs.setInt(7, oRecepcioninternaBE.getIdrecepcion_proviene());
            cs.setBoolean(8, oRecepcioninternaBE.isBindentregado());
            Date fecharecepcion = new Date(oRecepcioninternaBE.getFecharecepcion().getTime());
            cs.setDate(9, fecharecepcion);
            cs.setBoolean(10, oRecepcioninternaBE.isBindderivado());
            cs.setBoolean(11, oRecepcioninternaBE.isBindprimero());
            Date fechaderivacion = new Date(oRecepcioninternaBE.getFechaderivacion().getTime());
            cs.setDate(12, fechaderivacion);
            cs.setString(13, oRecepcioninternaBE.getObservacion());
            cs.setBoolean(14, oRecepcioninternaBE.isEstado());
            cs.registerOutParameter(15, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(15);
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

    public int actualizarRecepcioninternaBE(RecepcioninternaBE oRecepcioninternaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarRecepcioninterna(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oRecepcioninternaBE.getIdrecepcioninterna());
            cs.setInt(2, oRecepcioninternaBE.getIdexpediente());
            cs.setInt(3, oRecepcioninternaBE.getIdmensaje());
            cs.setInt(4, oRecepcioninternaBE.getIdarea_destino());
            cs.setInt(5, oRecepcioninternaBE.getIdarea_proviene());
            cs.setInt(6, oRecepcioninternaBE.getIdusuariorecepciona());
            cs.setInt(7, oRecepcioninternaBE.getIdusuarioenvia());
            cs.setInt(8, oRecepcioninternaBE.getIdrecepcion_proviene());
            cs.setBoolean(9, oRecepcioninternaBE.isBindentregado());
            Date fecharecepcion = new Date(oRecepcioninternaBE.getFecharecepcion().getTime());
            cs.setDate(10, fecharecepcion);
            cs.setBoolean(11, oRecepcioninternaBE.isBindderivado());
            cs.setBoolean(12, oRecepcioninternaBE.isBindprimero());
            Date fechaderivacion = new Date(oRecepcioninternaBE.getFechaderivacion().getTime());
            cs.setDate(13, fechaderivacion);
            cs.setString(14, oRecepcioninternaBE.getObservacion());
            cs.setBoolean(15, oRecepcioninternaBE.isEstado());
            cs.registerOutParameter(15, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(15);
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
}
