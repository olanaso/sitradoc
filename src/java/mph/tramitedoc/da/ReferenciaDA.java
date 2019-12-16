package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.ReferenciaBE;
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

public class ReferenciaDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public ReferenciaDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public ReferenciaBE listarReferenciaBE(ReferenciaBE oReferenciaBE1) throws SQLException {
        ReferenciaBE oReferenciaBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oReferenciaBE = new ReferenciaBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oReferenciaBE1.getIndOpSp() == 1) {

                String sql = " SELECT idreferencia,iddocumento,iddocumentoreferencia,fecharegistro,idusuarioregistra,estado FROM referencia WHERE idreferencia=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oReferenciaBE1.getIdreferencia());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oReferenciaBE.setIdreferencia(rs.getInt("idreferencia"));
                oReferenciaBE.setIddocumento(rs.getInt("iddocumento"));
                oReferenciaBE.setIddocumentoreferencia(rs.getInt("iddocumentoreferencia"));
                oReferenciaBE.setFecharegistro(rs.getDate("fecharegistro"));
                oReferenciaBE.setIdusuarioregistra(rs.getInt("idusuarioregistra"));
                oReferenciaBE.setEstado(rs.getBoolean("estado"));
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
        return oReferenciaBE;
    }

    public ArrayList<ReferenciaBE> listarRegistroReferenciaBE(ReferenciaBE oReferenciaBE1) throws SQLException {
        ArrayList<ReferenciaBE> listaReferenciaBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaReferenciaBE = new ArrayList<ReferenciaBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oReferenciaBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idreferencia||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idreferencia||')\" class=\"fa fa-trash-o\"></i>',idreferencia,iddocumento,iddocumentoreferencia,fecharegistro,idusuarioregistra,estado FROM referencia WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oReferenciaBE1.getIndOpSp() == 2) {
                sql = " SELECT idreferencia,iddocumento,iddocumentoreferencia,fecharegistro,idusuarioregistra,estado FROM referencia WHERE idreferencia=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oReferenciaBE1.getIdreferencia());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                ReferenciaBE oReferenciaBE = new ReferenciaBE();
                oReferenciaBE.setEdit(rs.getString(1));
                oReferenciaBE.setDel(rs.getString(2));
                oReferenciaBE.setIdreferencia(rs.getInt("idreferencia"));
                oReferenciaBE.setIddocumento(rs.getInt("iddocumento"));
                oReferenciaBE.setIddocumentoreferencia(rs.getInt("iddocumentoreferencia"));
                oReferenciaBE.setFecharegistro(rs.getDate("fecharegistro"));
                oReferenciaBE.setIdusuarioregistra(rs.getInt("idusuarioregistra"));
                oReferenciaBE.setEstado(rs.getBoolean("estado"));
                listaReferenciaBE.add(oReferenciaBE);
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
            oReferenciaBE1 = null;
        }
        return listaReferenciaBE;
    }

    public int insertarRegistrosReferenciaBE(ArrayList<ReferenciaBE> oListaReferenciaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ReferenciaBE oReferenciaBE : oListaReferenciaBE) {
                cs = cn.prepareCall("{call uspInsertarReferencia(?,?,?,?,?,?)}");
                cs.setInt(1, oReferenciaBE.getIddocumento());
                cs.setInt(2, oReferenciaBE.getIddocumentoreferencia());
                Date fecharegistro = new Date(oReferenciaBE.getFecharegistro().getTime());
                cs.setDate(3, fecharegistro);
                cs.setInt(4, oReferenciaBE.getIdusuarioregistra());
                cs.setBoolean(5, oReferenciaBE.isEstado());
                cs.registerOutParameter(6, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(6);
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

    public int insertarReferenciaBE(ReferenciaBE oReferenciaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarReferencia(?,?,?,?,?,?)}");
            cs.setInt(1, oReferenciaBE.getIddocumento());
            cs.setInt(2, oReferenciaBE.getIddocumentoreferencia());
            Date fecharegistro = new Date(oReferenciaBE.getFecharegistro().getTime());
            cs.setDate(3, fecharegistro);
            cs.setInt(4, oReferenciaBE.getIdusuarioregistra());
            cs.setBoolean(5, oReferenciaBE.isEstado());
            cs.registerOutParameter(6, java.sql.Types.INTEGER);
            cs.execute();
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

    public int actualizarReferenciaBE(ReferenciaBE oReferenciaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarReferencia(?,?,?,?,?,?)}");
            cs.setInt(1, oReferenciaBE.getIdreferencia());
            cs.setInt(2, oReferenciaBE.getIddocumento());
            cs.setInt(3, oReferenciaBE.getIddocumentoreferencia());
            Date fecharegistro = new Date(oReferenciaBE.getFecharegistro().getTime());
            cs.setDate(4, fecharegistro);
            cs.setInt(5, oReferenciaBE.getIdusuarioregistra());
            cs.setBoolean(6, oReferenciaBE.isEstado());
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

    public int eliminarReferenciaBE(ReferenciaBE oReferenciaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarReferencia(?)}");
            cs.setInt(1, oReferenciaBE.getIdreferencia());
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

    public List listObjectReferenciaBE(ReferenciaBE oReferenciaBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oReferenciaBE.getIndOpSp() == 1) {
                sql = " SELECT idreferencia,iddocumento,iddocumentoreferencia,fecharegistro,idusuarioregistra,estado FROM referencia WHERE idreferencia=? and estado=true";
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
            oReferenciaBE = null;
        }
        return list;
    }

}
