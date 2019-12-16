package mph.tramitedoc.da;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import mph.tramitedoc.be.TipoprocedimientoBE;

public class TipoprocedimientoDA extends BaseDA {
    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public TipoprocedimientoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public TipoprocedimientoBE listarTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE1) throws SQLException {
        TipoprocedimientoBE oTipoprocedimientoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oTipoprocedimientoBE = new TipoprocedimientoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oTipoprocedimientoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idtipoprocedimiento,denominacion,descripcion,orden,bindactual,estado FROM tipoprocedimiento WHERE idtipoprocedimiento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oTipoprocedimientoBE1.getIdtipoprocedimiento());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oTipoprocedimientoBE.setIdtipoprocedimiento(rs.getInt("tipoprocedimiento"));
                oTipoprocedimientoBE.setDenominacion(rs.getString("denominacion"));
                oTipoprocedimientoBE.setDescripcion(rs.getString("descripcion"));
                oTipoprocedimientoBE.setOrden(rs.getInt("orden"));
                oTipoprocedimientoBE.setBindactual(rs.getBoolean("bindactual"));
                oTipoprocedimientoBE.setEstado(rs.getBoolean("estado"));
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
        return oTipoprocedimientoBE;
    }

    public ArrayList<TipoprocedimientoBE> listarRegistroTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE1) throws SQLException {
        ArrayList<TipoprocedimientoBE> listaTipoprocedimientoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaTipoprocedimientoBE = new ArrayList<TipoprocedimientoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oTipoprocedimientoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idtipoprocedimiento||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idtipoprocedimiento||')\" class=\"fa fa-trash-o\"></i>',idtipoprocedimiento,denominacion,descripcion,orden,bindactual,estado FROM tipoprocedimiento WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    TipoprocedimientoBE oTipoprocedimientoBE = new TipoprocedimientoBE();
                    oTipoprocedimientoBE.setEdit(rs.getString(1));
                    oTipoprocedimientoBE.setDel(rs.getString(2));
                    oTipoprocedimientoBE.setIdtipoprocedimiento(rs.getInt("idtipoprocedimiento"));
                    oTipoprocedimientoBE.setDenominacion(rs.getString("denominacion"));
                    oTipoprocedimientoBE.setDescripcion(rs.getString("descripcion"));
                    oTipoprocedimientoBE.setOrden(rs.getInt("orden"));
                    oTipoprocedimientoBE.setBindactual(rs.getBoolean("bindactual"));
                    oTipoprocedimientoBE.setEstado(rs.getBoolean("estado"));
                    listaTipoprocedimientoBE.add(oTipoprocedimientoBE);
                }
            }
            if (oTipoprocedimientoBE1.getIndOpSp() == 2) {
                sql = " SELECT idtipoprocedimiento,denominacion,descripcion,orden,bindactual,estado FROM tipoprocedimiento WHERE idtipoprocedimiento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oTipoprocedimientoBE1.getIdtipoprocedimiento());
                rs = pst.executeQuery();
                while (rs.next()) {
                    TipoprocedimientoBE oTipoprocedimientoBE = new TipoprocedimientoBE();
                    oTipoprocedimientoBE.setEdit(rs.getString(1));
                    oTipoprocedimientoBE.setDel(rs.getString(2));
                    oTipoprocedimientoBE.setIdtipoprocedimiento(rs.getInt("idtipoprocedimiento"));
                    oTipoprocedimientoBE.setDenominacion(rs.getString("denominacion"));
                    oTipoprocedimientoBE.setDescripcion(rs.getString("descripcion"));
                    oTipoprocedimientoBE.setEstado(rs.getBoolean("estado"));
                    oTipoprocedimientoBE.setBindactual(rs.getBoolean("bindactual"));
                    oTipoprocedimientoBE.setOrden(rs.getInt("orden"));                    
                    listaTipoprocedimientoBE.add(oTipoprocedimientoBE);
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
            oTipoprocedimientoBE1 = null;
        }
        return listaTipoprocedimientoBE;
    }

    public int insertarRegistrosTipoprocedimientoBE(ArrayList<TipoprocedimientoBE> oListaTipoprocedimientoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (TipoprocedimientoBE oTipoprocedimientoBE : oListaTipoprocedimientoBE) {
                cs = cn.prepareCall("{call uspInsertarTipoprocedimiento(?,?,?,?,?,?)}");
                cs.setString(1, oTipoprocedimientoBE.getDenominacion());
                cs.setString(2, oTipoprocedimientoBE.getDescripcion());
                cs.setInt(3, oTipoprocedimientoBE.getOrden());
                cs.setBoolean(4, oTipoprocedimientoBE.isBindactual());
                cs.setBoolean(5, oTipoprocedimientoBE.isEstado());
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

    public int insertarTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarTipoprocedimiento(?,?,?,?,?,?)}");
            cs.setString(1, oTipoprocedimientoBE.getDenominacion());
            cs.setString(2, oTipoprocedimientoBE.getDescripcion());
            cs.setInt(3, oTipoprocedimientoBE.getOrden());
            cs.setBoolean(4, oTipoprocedimientoBE.isBindactual());
            cs.setBoolean(5, oTipoprocedimientoBE.isEstado());
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

    public int actualizarTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarTipoprocedimiento(?,?,?,?,?,?)}");
            cs.setInt(1, oTipoprocedimientoBE.getIdtipoprocedimiento());
            cs.setString(2, oTipoprocedimientoBE.getDenominacion());
            cs.setString(3, oTipoprocedimientoBE.getDescripcion());
            cs.setInt(4, oTipoprocedimientoBE.getOrden());
            cs.setBoolean(5, oTipoprocedimientoBE.isBindactual());
            cs.setBoolean(6, oTipoprocedimientoBE.isEstado());
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

    public int eliminarTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarTipoprocedimiento(?)}");
            cs.setInt(1, oTipoprocedimientoBE.getIdtipoprocedimiento());
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

    public List listObjectTipoprocedimientoBE(TipoprocedimientoBE oTipoprocedimientoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oTipoprocedimientoBE.getIndOpSp() == 1) {
                sql = " SELECT idtipoprocedimiento,denominacion,descripcion,orden,bindactual,estado FROM tipoprocedimiento WHERE idtipoprocedimiento=? and estado=true";
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
            oTipoprocedimientoBE = null;
        }
        return list;
    }
}
