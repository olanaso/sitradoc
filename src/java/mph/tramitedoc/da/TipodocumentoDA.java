package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.TipodocumentoBE;
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

public class TipodocumentoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public TipodocumentoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public TipodocumentoBE listarTipodocumentoBE(TipodocumentoBE oTipodocumentoBE1) throws SQLException {
        TipodocumentoBE oTipodocumentoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oTipodocumentoBE = new TipodocumentoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oTipodocumentoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idtipodocumento,idregla,denominacion,descripcion,estado FROM tipodocumento WHERE idtipodocumento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oTipodocumentoBE1.getIdtipodocumento());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oTipodocumentoBE.setIdtipodocumento(rs.getInt("idtipodocumento"));
                oTipodocumentoBE.setIdregla(rs.getInt("idregla"));
                oTipodocumentoBE.setDenominacion(rs.getString("denominacion"));
                oTipodocumentoBE.setDescripcion(rs.getString("descripcion"));
                oTipodocumentoBE.setEstado(rs.getBoolean("estado"));
                oTipodocumentoBE.setSubida(rs.getBoolean("subida"));
                oTipodocumentoBE.setIgual(rs.getBoolean("igual"));
                oTipodocumentoBE.setBajada(rs.getBoolean("bajada"));
//                oTipodocumentoBE.setJefe(rs.getBoolean("jefe"));
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
        return oTipodocumentoBE;
    }

    public ArrayList<TipodocumentoBE> listarRegistroTipodocumentoBE(TipodocumentoBE oTipodocumentoBE1) throws SQLException {
        ArrayList<TipodocumentoBE> listaTipodocumentoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaTipodocumentoBE = new ArrayList<TipodocumentoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oTipodocumentoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idtipodocumento||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idtipodocumento||')\" class=\"fa fa-trash-o\"></i>',idtipodocumento,denominacion,descripcion,subida,igual,bajada,estado FROM tipodocumento WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    TipodocumentoBE oTipodocumentoBE = new TipodocumentoBE();
                    oTipodocumentoBE.setEdit(rs.getString(1));
                    oTipodocumentoBE.setDel(rs.getString(2));
                    oTipodocumentoBE.setIdtipodocumento(rs.getInt("idtipodocumento"));
                    //oTipodocumentoBE.setIdregla(rs.getInt("idregla"));
                    oTipodocumentoBE.setDenominacion(rs.getString("denominacion"));
                    oTipodocumentoBE.setDescripcion(rs.getString("descripcion"));
                    oTipodocumentoBE.setEstado(rs.getBoolean("estado"));
                    oTipodocumentoBE.setSubida(rs.getBoolean("subida"));
                    oTipodocumentoBE.setIgual(rs.getBoolean("igual"));
                    oTipodocumentoBE.setBajada(rs.getBoolean("bajada"));
//                    oTipodocumentoBE.setJefe(rs.getBoolean("jefe"));
                    listaTipodocumentoBE.add(oTipodocumentoBE);
                }
            }
            if (oTipodocumentoBE1.getIndOpSp() == 2) {
                sql = " SELECT idtipodocumento,idregla,denominacion,descripcion,estado FROM tipodocumento WHERE idtipodocumento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oTipodocumentoBE1.getIdtipodocumento());
                rs = pst.executeQuery();
                while (rs.next()) {
                    TipodocumentoBE oTipodocumentoBE = new TipodocumentoBE();
                    oTipodocumentoBE.setEdit(rs.getString(1));
                    oTipodocumentoBE.setDel(rs.getString(2));
                    oTipodocumentoBE.setIdtipodocumento(rs.getInt("idtipodocumento"));
                    oTipodocumentoBE.setIdregla(rs.getInt("idregla"));
                    oTipodocumentoBE.setDenominacion(rs.getString("denominacion"));
                    oTipodocumentoBE.setDescripcion(rs.getString("descripcion"));
                    oTipodocumentoBE.setEstado(rs.getBoolean("estado"));
                    oTipodocumentoBE.setSubida(rs.getBoolean("subida"));
                    oTipodocumentoBE.setIgual(rs.getBoolean("igual"));
                    oTipodocumentoBE.setBajada(rs.getBoolean("bajada"));
//                    oTipodocumentoBE.setJefe(rs.getBoolean("jefe"));
                    listaTipodocumentoBE.add(oTipodocumentoBE);
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
            oTipodocumentoBE1 = null;
        }
        return listaTipodocumentoBE;
    }

    public int insertarRegistrosTipodocumentoBE(ArrayList<TipodocumentoBE> oListaTipodocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (TipodocumentoBE oTipodocumentoBE : oListaTipodocumentoBE) {
                cs = cn.prepareCall("{call uspInsertarTipodocumento(?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oTipodocumentoBE.getIdregla());
                cs.setString(2, oTipodocumentoBE.getDenominacion());
                cs.setString(3, oTipodocumentoBE.getDescripcion());
                cs.setBoolean(4, oTipodocumentoBE.isEstado());
                cs.setBoolean(5, oTipodocumentoBE.isSubida());
                cs.setBoolean(6, oTipodocumentoBE.isIgual());
                cs.setBoolean(7, oTipodocumentoBE.isBajada());
//                cs.setBoolean(8, oTipodocumentoBE.isJefe());
                cs.registerOutParameter(8, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(8);
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

    public int insertarTipodocumentoBE(TipodocumentoBE oTipodocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarTipodocumento(?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oTipodocumentoBE.getIdregla());
            cs.setString(2, oTipodocumentoBE.getDenominacion());
            cs.setString(3, oTipodocumentoBE.getDescripcion());
            cs.setBoolean(4, oTipodocumentoBE.isSubida());
            cs.setBoolean(5, oTipodocumentoBE.isIgual());
            cs.setBoolean(6, oTipodocumentoBE.isBajada());
//            cs.setBoolean(7, oTipodocumentoBE.isJefe());
            cs.setBoolean(7, oTipodocumentoBE.isEstado());
            cs.registerOutParameter(8, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(8);
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

    public int actualizarTipodocumentoBE(TipodocumentoBE oTipodocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarTipodocumento(?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oTipodocumentoBE.getIdtipodocumento());
            cs.setInt(2, oTipodocumentoBE.getIdregla());
            cs.setString(3, oTipodocumentoBE.getDenominacion());
            cs.setString(4, oTipodocumentoBE.getDescripcion());
            cs.setBoolean(5, oTipodocumentoBE.isSubida());
            cs.setBoolean(6, oTipodocumentoBE.isIgual());
            cs.setBoolean(7, oTipodocumentoBE.isBajada());
//            cs.setBoolean(8, oTipodocumentoBE.isJefe());
            cs.setBoolean(8, oTipodocumentoBE.isEstado());
            cs.registerOutParameter(8, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(8);
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

    public int eliminarTipodocumentoBE(TipodocumentoBE oTipodocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarTipodocumento(?)}");
            cs.setInt(1, oTipodocumentoBE.getIdtipodocumento());
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

    public List listObjectTipodocumentoBE(TipodocumentoBE oTipodocumentoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oTipodocumentoBE.getIndOpSp() == 1) {
                sql = " SELECT idtipodocumento,idregla,denominacion,descripcion,estado FROM tipodocumento WHERE idtipodocumento=? and estado=true";
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
            oTipodocumentoBE = null;
        }
        return list;
    }

}
