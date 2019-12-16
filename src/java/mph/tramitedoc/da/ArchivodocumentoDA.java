package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.ArchivodocumentoBE;
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

public class ArchivodocumentoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public ArchivodocumentoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public ArchivodocumentoBE listarArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE1) throws SQLException {
        ArchivodocumentoBE oArchivodocumentoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oArchivodocumentoBE = new ArchivodocumentoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oArchivodocumentoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idarchivodocumento,documento,codigo,nombre,url,estado FROM archivodocumento WHERE idarchivodocumento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oArchivodocumentoBE1.getIdarchivodocumento());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oArchivodocumentoBE.setIdarchivodocumento(rs.getInt("idarchivodocumento"));
                oArchivodocumentoBE.setDocumento(rs.getInt("documento"));
                oArchivodocumentoBE.setCodigo(rs.getString("codigo"));
                oArchivodocumentoBE.setNombre(rs.getString("nombre"));
                oArchivodocumentoBE.setUrl(rs.getString("url"));
                oArchivodocumentoBE.setEstado(rs.getBoolean("estado"));
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
        return oArchivodocumentoBE;
    }

    public ArrayList<ArchivodocumentoBE> listarRegistroArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE1) throws SQLException {
        ArrayList<ArchivodocumentoBE> listaArchivodocumentoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaArchivodocumentoBE = new ArrayList<ArchivodocumentoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oArchivodocumentoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idarchivodocumento||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idarchivodocumento||')\" class=\"fa fa-trash-o\"></i>',idarchivodocumento,documento,codigo,nombre,url,estado FROM archivodocumento WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oArchivodocumentoBE1.getIndOpSp() == 2) {
                sql = " SELECT idarchivodocumento,documento,codigo,nombre,url,estado FROM archivodocumento WHERE idarchivodocumento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oArchivodocumentoBE1.getIdarchivodocumento());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                ArchivodocumentoBE oArchivodocumentoBE = new ArchivodocumentoBE();
                oArchivodocumentoBE.setEdit(rs.getString(1));
                oArchivodocumentoBE.setDel(rs.getString(2));
                oArchivodocumentoBE.setIdarchivodocumento(rs.getInt("idarchivodocumento"));
                oArchivodocumentoBE.setDocumento(rs.getInt("documento"));
                oArchivodocumentoBE.setCodigo(rs.getString("codigo"));
                oArchivodocumentoBE.setNombre(rs.getString("nombre"));
                oArchivodocumentoBE.setUrl(rs.getString("url"));
                oArchivodocumentoBE.setEstado(rs.getBoolean("estado"));
                listaArchivodocumentoBE.add(oArchivodocumentoBE);
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
            oArchivodocumentoBE1 = null;
        }
        return listaArchivodocumentoBE;
    }

    public int insertarRegistrosArchivodocumentoBE(ArrayList<ArchivodocumentoBE> oListaArchivodocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ArchivodocumentoBE oArchivodocumentoBE : oListaArchivodocumentoBE) {
                cs = cn.prepareCall("{call uspInsertarArchivodocumento(?,?,?,?,?,?)}");
                cs.setInt(1, oArchivodocumentoBE.getDocumento());
                cs.setString(2, oArchivodocumentoBE.getCodigo());
                cs.setString(3, oArchivodocumentoBE.getNombre());
                cs.setString(4, oArchivodocumentoBE.getUrl());
                cs.setBoolean(5, oArchivodocumentoBE.isEstado());
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

    public int insertarArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarArchivodocumento(?,?,?,?,?,?)}");
            cs.setInt(1, oArchivodocumentoBE.getDocumento());
            cs.setString(2, oArchivodocumentoBE.getCodigo());
            cs.setString(3, oArchivodocumentoBE.getNombre());
            cs.setString(4, oArchivodocumentoBE.getUrl());
            cs.setBoolean(5, oArchivodocumentoBE.isEstado());
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

    public int actualizarArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarArchivodocumento(?,?,?,?,?,?)}");
            cs.setInt(1, oArchivodocumentoBE.getIdarchivodocumento());
            cs.setInt(2, oArchivodocumentoBE.getDocumento());
            cs.setString(3, oArchivodocumentoBE.getCodigo());
            cs.setString(4, oArchivodocumentoBE.getNombre());
            cs.setString(5, oArchivodocumentoBE.getUrl());
            cs.setBoolean(6, oArchivodocumentoBE.isEstado());
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

    public int eliminarArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarArchivodocumento(?)}");
            cs.setInt(1, oArchivodocumentoBE.getIdarchivodocumento());
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

    public List listObjectArchivodocumentoBE(ArchivodocumentoBE oArchivodocumentoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oArchivodocumentoBE.getIndOpSp() == 1) {
                sql = " SELECT idarchivodocumento,documento,codigo,nombre,url,estado FROM archivodocumento WHERE idarchivodocumento=? and estado=true";
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
            oArchivodocumentoBE = null;
        }
        return list;
    }

}
