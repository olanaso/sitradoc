package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.EnvioBE;
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

public class EnvioDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public EnvioDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public EnvioBE listarEnvioBE(EnvioBE oEnvioBE1) throws SQLException {
        EnvioBE oEnvioBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oEnvioBE = new EnvioBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oEnvioBE1.getIndOpSp() == 1) {

                String sql = " SELECT idenvio,idusuario,fechaenvio,estado FROM envio WHERE idenvio=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oEnvioBE1.getIdenvio());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oEnvioBE.setIdenvio(rs.getInt("idenvio"));
                oEnvioBE.setIdusuario(rs.getInt("idusuario"));
                oEnvioBE.setFechaenvio(rs.getDate("fechaenvio"));
                oEnvioBE.setEstado(rs.getBoolean("estado"));
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
        return oEnvioBE;
    }

    public ArrayList<EnvioBE> listarRegistroEnvioBE(EnvioBE oEnvioBE1) throws SQLException {
        ArrayList<EnvioBE> listaEnvioBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaEnvioBE = new ArrayList<EnvioBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oEnvioBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idenvio||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idenvio||')\" class=\"fa fa-trash-o\"></i>',idenvio,idusuario,fechaenvio,estado FROM envio WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oEnvioBE1.getIndOpSp() == 2) {
                sql = " SELECT idenvio,idusuario,fechaenvio,estado FROM envio WHERE idenvio=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oEnvioBE1.getIdenvio());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                EnvioBE oEnvioBE = new EnvioBE();
                oEnvioBE.setEdit(rs.getString(1));
                oEnvioBE.setDel(rs.getString(2));
                oEnvioBE.setIdenvio(rs.getInt("idenvio"));
                oEnvioBE.setIdusuario(rs.getInt("idusuario"));
                oEnvioBE.setFechaenvio(rs.getDate("fechaenvio"));
                oEnvioBE.setEstado(rs.getBoolean("estado"));
                listaEnvioBE.add(oEnvioBE);
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
            oEnvioBE1 = null;
        }
        return listaEnvioBE;
    }

    public int insertarRegistrosEnvioBE(ArrayList<EnvioBE> oListaEnvioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (EnvioBE oEnvioBE : oListaEnvioBE) {
                cs = cn.prepareCall("{call uspInsertarEnvio(?,?,?,?)}");
                cs.setInt(1, oEnvioBE.getIdusuario());
                Date fechaenvio = new Date(oEnvioBE.getFechaenvio().getTime());
                cs.setDate(2, fechaenvio);
                cs.setBoolean(3, oEnvioBE.isEstado());
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

    public int insertarEnvioBE(EnvioBE oEnvioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarEnvio(?,?,?,?)}");
            cs.setInt(1, oEnvioBE.getIdusuario());
            Date fechaenvio = new Date(oEnvioBE.getFechaenvio().getTime());
            cs.setDate(2, fechaenvio);
            cs.setBoolean(3, oEnvioBE.isEstado());
            cs.registerOutParameter(4, java.sql.Types.INTEGER);
            cs.execute();
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

    public int actualizarEnvioBE(EnvioBE oEnvioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarEnvio(?,?,?,?)}");
            cs.setInt(1, oEnvioBE.getIdenvio());
            cs.setInt(2, oEnvioBE.getIdusuario());
            Date fechaenvio = new Date(oEnvioBE.getFechaenvio().getTime());
            cs.setDate(3, fechaenvio);
            cs.setBoolean(4, oEnvioBE.isEstado());
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

    public int eliminarEnvioBE(EnvioBE oEnvioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarEnvio(?)}");
            cs.setInt(1, oEnvioBE.getIdenvio());
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

    public List listObjectEnvioBE(EnvioBE oEnvioBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oEnvioBE.getIndOpSp() == 1) {
                sql = " SELECT idenvio,idusuario,fechaenvio,estado FROM envio WHERE idenvio=? and estado=true";
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
            oEnvioBE = null;
        }
        return list;
    }

}
