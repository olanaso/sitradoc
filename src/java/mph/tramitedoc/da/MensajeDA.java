package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.MensajeBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class MensajeDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public MensajeDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public MensajeBE listarMensajeBE(MensajeBE oMensajeBE1) throws SQLException {
        MensajeBE oMensajeBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oMensajeBE = new MensajeBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oMensajeBE1.getIndOpSp() == 1) {

                String sql = " SELECT idmensaje,asunto,mensaje,prioridad,bindrespuesta,diasrespuesta,idareacioncreacion,idusuariocreacion,fechacreacion,estado FROM mensaje WHERE idmensaje=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oMensajeBE1.getIdmensaje());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oMensajeBE.setIdmensaje(rs.getInt("idmensaje"));
                oMensajeBE.setAsunto(rs.getString("asunto"));
                oMensajeBE.setPrioridad(rs.getInt("prioridad"));
                oMensajeBE.setBindrespuesta(rs.getBoolean("bindrespuesta"));
                oMensajeBE.setDiasrespuesta(rs.getInt("diasrespuesta"));
                oMensajeBE.setIdareacioncreacion(rs.getInt("idareacioncreacion"));
                oMensajeBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
                oMensajeBE.setFechacreacion(rs.getDate("fechacreacion"));
                oMensajeBE.setEstado(rs.getBoolean("estado"));
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
        return oMensajeBE;
    }

    public ArrayList<MensajeBE> listarRegistroMensajeBE(MensajeBE oMensajeBE1) throws SQLException {
        ArrayList<MensajeBE> listaMensajeBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaMensajeBE = new ArrayList<MensajeBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oMensajeBE1.getIndOpSp() == 1) {
                sql = " SELECT idmensaje,asunto,mensaje,prioridad,bindrespuesta,diasrespuesta,idareacioncreacion,idusuariocreacion,fechacreacion,estado FROM mensaje WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oMensajeBE1.getIndOpSp() == 2) {
                sql = " SELECT idmensaje,asunto,mensaje,prioridad,bindrespuesta,diasrespuesta,idareacioncreacion,idusuariocreacion,fechacreacion,estado FROM mensaje WHERE idmensaje=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oMensajeBE1.getIdmensaje());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                MensajeBE oMensajeBE = new MensajeBE();
                oMensajeBE.setIdmensaje(rs.getInt("idmensaje"));
                oMensajeBE.setAsunto(rs.getString("asunto"));
                oMensajeBE.setPrioridad(rs.getInt("prioridad"));
                oMensajeBE.setBindrespuesta(rs.getBoolean("bindrespuesta"));
                oMensajeBE.setDiasrespuesta(rs.getInt("diasrespuesta"));
                oMensajeBE.setIdareacioncreacion(rs.getInt("idareacioncreacion"));
                oMensajeBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
                oMensajeBE.setFechacreacion(rs.getDate("fechacreacion"));
                oMensajeBE.setEstado(rs.getBoolean("estado"));
                listaMensajeBE.add(oMensajeBE);
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
            oMensajeBE1 = null;
        }
        return listaMensajeBE;
    }

    public int insertarRegistrosMensajeBE(ArrayList<MensajeBE> oListaMensajeBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (MensajeBE oMensajeBE : oListaMensajeBE) {
                cs = cn.prepareCall("{call uspInsertarMensaje(?,?,?,?,?,?,?,?,?,?)}");
                cs.setString(1, oMensajeBE.getAsunto());
                cs.setInt(3, oMensajeBE.getPrioridad());
                cs.setBoolean(4, oMensajeBE.isBindrespuesta());
                cs.setInt(5, oMensajeBE.getDiasrespuesta());
                cs.setInt(6, oMensajeBE.getIdareacioncreacion());
                cs.setInt(7, oMensajeBE.getIdusuariocreacion());
                Date fechacreacion = new Date(oMensajeBE.getFechacreacion().getTime());
                cs.setDate(8, fechacreacion);
                cs.setBoolean(9, oMensajeBE.isEstado());
                cs.registerOutParameter(10, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(10);
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

    public int insertarMensajeBE(MensajeBE oMensajeBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarMensaje(?,?,?,?,?,?,?,?,?,?)}");
            cs.setString(1, oMensajeBE.getAsunto());
            cs.setInt(3, oMensajeBE.getPrioridad());
            cs.setBoolean(4, oMensajeBE.isBindrespuesta());
            cs.setInt(5, oMensajeBE.getDiasrespuesta());
            cs.setInt(6, oMensajeBE.getIdareacioncreacion());
            cs.setInt(7, oMensajeBE.getIdusuariocreacion());
            Date fechacreacion = new Date(oMensajeBE.getFechacreacion().getTime());
            cs.setDate(8, fechacreacion);
            cs.setBoolean(9, oMensajeBE.isEstado());
            cs.registerOutParameter(10, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(10);
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

    public int crearMensajeBE(MensajeBE oMensajeBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspcrearmensaje(?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oMensajeBE.getIdexpediente());
            cs.setString(2, oMensajeBE.getAsunto());
            cs.setString(3, oMensajeBE.getMensaje());
            cs.setInt(4, oMensajeBE.getPrioridad());
            cs.setBoolean(5, oMensajeBE.isBindrespuesta());
            cs.setBoolean(6, oMensajeBE.isBindrecepcion());
            cs.setInt(7, oMensajeBE.getDiasrespuesta());
            cs.setInt(8, oMensajeBE.getIdareacioncreacion());
            cs.setInt(9, oMensajeBE.getIdusuariocreacion());
            cs.setString(10, oMensajeBE.getFecha_manual());
            cs.registerOutParameter(11, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(11);
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

    public int actualizarMensajeBE(MensajeBE oMensajeBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarMensaje(?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oMensajeBE.getIdmensaje());
            cs.setString(2, oMensajeBE.getAsunto());
            cs.setInt(4, oMensajeBE.getPrioridad());
            cs.setBoolean(5, oMensajeBE.isBindrespuesta());
            cs.setInt(6, oMensajeBE.getDiasrespuesta());
            cs.setInt(7, oMensajeBE.getIdareacioncreacion());
            cs.setInt(8, oMensajeBE.getIdusuariocreacion());
            Date fechacreacion = new Date(oMensajeBE.getFechacreacion().getTime());
            cs.setDate(9, fechacreacion);
            cs.setBoolean(10, oMensajeBE.isEstado());
            cs.registerOutParameter(10, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(10);
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
