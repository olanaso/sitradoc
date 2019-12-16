package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.EstadoflujoBE;
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

public class EstadoflujoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public EstadoflujoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public EstadoflujoBE listarEstadoflujoBE(EstadoflujoBE oEstadoflujoBE1) throws SQLException {
        EstadoflujoBE oEstadoflujoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oEstadoflujoBE = new EstadoflujoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oEstadoflujoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idestadoflujo,denominacion,estado FROM estadoflujo WHERE idestadoflujo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oEstadoflujoBE1.getIdestadoflujo());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oEstadoflujoBE.setIdestadoflujo(rs.getInt("idestadoflujo"));
                oEstadoflujoBE.setDenominacion(rs.getString("denominacion"));
                oEstadoflujoBE.setEstado(rs.getBoolean("estado"));
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
        return oEstadoflujoBE;
    }

    public ArrayList<EstadoflujoBE> listarRegistroEstadoflujoBE(EstadoflujoBE oEstadoflujoBE1) throws SQLException {
        ArrayList<EstadoflujoBE> listaEstadoflujoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaEstadoflujoBE = new ArrayList<EstadoflujoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oEstadoflujoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idestadoflujo||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idestadoflujo||')\" class=\"fa fa-trash-o\"></i>',idestadoflujo,denominacion,estado FROM estadoflujo WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oEstadoflujoBE1.getIndOpSp() == 2) {
                sql = " SELECT idestadoflujo,denominacion,estado FROM estadoflujo WHERE idestadoflujo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oEstadoflujoBE1.getIdestadoflujo());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                EstadoflujoBE oEstadoflujoBE = new EstadoflujoBE();
                oEstadoflujoBE.setEdit(rs.getString(1));
                oEstadoflujoBE.setDel(rs.getString(2));
                oEstadoflujoBE.setIdestadoflujo(rs.getInt("idestadoflujo"));
                oEstadoflujoBE.setDenominacion(rs.getString("denominacion"));
                oEstadoflujoBE.setEstado(rs.getBoolean("estado"));
                listaEstadoflujoBE.add(oEstadoflujoBE);
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
            oEstadoflujoBE1 = null;
        }
        return listaEstadoflujoBE;
    }

    public int insertarRegistrosEstadoflujoBE(ArrayList<EstadoflujoBE> oListaEstadoflujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (EstadoflujoBE oEstadoflujoBE : oListaEstadoflujoBE) {
                cs = cn.prepareCall("{call uspInsertarEstadoflujo(?,?,?)}");
                cs.setString(1, oEstadoflujoBE.getDenominacion());
                cs.setBoolean(2, oEstadoflujoBE.isEstado());
                cs.registerOutParameter(3, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(3);
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

    public int insertarEstadoflujoBE(EstadoflujoBE oEstadoflujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarEstadoflujo(?,?,?)}");
            cs.setString(1, oEstadoflujoBE.getDenominacion());
            cs.setBoolean(2, oEstadoflujoBE.isEstado());
            cs.registerOutParameter(3, java.sql.Types.INTEGER);
            cs.execute();
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

    public int actualizarEstadoflujoBE(EstadoflujoBE oEstadoflujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarEstadoflujo(?,?,?)}");
            cs.setInt(1, oEstadoflujoBE.getIdestadoflujo());
            cs.setString(2, oEstadoflujoBE.getDenominacion());
            cs.setBoolean(3, oEstadoflujoBE.isEstado());
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

    public int eliminarEstadoflujoBE(EstadoflujoBE oEstadoflujoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarEstadoflujo(?)}");
            cs.setInt(1, oEstadoflujoBE.getIdestadoflujo());
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

    public List listObjectEstadoflujoBE(EstadoflujoBE oEstadoflujoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oEstadoflujoBE.getIndOpSp() == 1) {
                sql = " SELECT idestadoflujo,denominacion,estado FROM estadoflujo WHERE idestadoflujo=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            
            if (oEstadoflujoBE.getIndOpSp() == 2) {
                sql = " select num_mes,area,mes,cantidad from usp_estadistica_ingresos("+oEstadoflujoBE.getIdestadoflujo()+")";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4)};
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
            oEstadoflujoBE = null;
        }
        return list;
    }

}
