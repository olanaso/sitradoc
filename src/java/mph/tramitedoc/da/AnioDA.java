package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.AnioBE;
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

public class AnioDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public AnioDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public AnioBE listarAnioBE(AnioBE oAnioBE1) throws SQLException {
        AnioBE oAnioBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oAnioBE = new AnioBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oAnioBE1.getIndOpSp() == 1) {

                String sql = " SELECT idanio,denominacion,estado FROM anio WHERE idanio=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oAnioBE1.getIdanio());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oAnioBE.setIdanio(rs.getInt("idanio"));
                oAnioBE.setDenominacion(rs.getString("denominacion"));
                oAnioBE.setEstado(rs.getBoolean("estado"));
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
        return oAnioBE;
    }

    public ArrayList<AnioBE> listarRegistroAnioBE(AnioBE oAnioBE1) throws SQLException {
        ArrayList<AnioBE> listaAnioBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaAnioBE = new ArrayList<AnioBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oAnioBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idanio||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idanio||')\" class=\"fa fa-trash-o\"></i>',idanio,denominacion,estado FROM anio WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    AnioBE oAnioBE = new AnioBE();
                    oAnioBE.setEdit(rs.getString(1));
                    oAnioBE.setDel(rs.getString(2));
                    oAnioBE.setIdanio(rs.getInt("idanio"));
                    oAnioBE.setDenominacion(rs.getString("denominacion"));
                    oAnioBE.setEstado(rs.getBoolean("estado"));
                    listaAnioBE.add(oAnioBE);
                }

            }
            if (oAnioBE1.getIndOpSp() == 2) {
                sql = " SELECT idanio,denominacion,estado FROM anio WHERE idanio=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oAnioBE1.getIdanio());
                rs = pst.executeQuery();

                while (rs.next()) {
                    AnioBE oAnioBE = new AnioBE();
                    oAnioBE.setEdit(rs.getString(1));
                    oAnioBE.setDel(rs.getString(2));
                    oAnioBE.setIdanio(rs.getInt("idanio"));
                    oAnioBE.setDenominacion(rs.getString("denominacion"));
                    oAnioBE.setEstado(rs.getBoolean("estado"));
                    listaAnioBE.add(oAnioBE);
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
            oAnioBE1 = null;
        }
        return listaAnioBE;
    }

    public int insertarRegistrosAnioBE(ArrayList<AnioBE> oListaAnioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (AnioBE oAnioBE : oListaAnioBE) {
                cs = cn.prepareCall("{call uspInsertarAnio(?,?,?)}");
                cs.setString(1, oAnioBE.getDenominacion());
                cs.setBoolean(2, oAnioBE.isEstado());
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

    public int insertarAnioBE(AnioBE oAnioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarAnio(?,?,?)}");
            cs.setString(1, oAnioBE.getDenominacion());
            cs.setBoolean(2, oAnioBE.isEstado());
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

    public int actualizarAnioBE(AnioBE oAnioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarAnio(?,?,?)}");
            cs.setInt(1, oAnioBE.getIdanio());
            cs.setString(2, oAnioBE.getDenominacion());
            cs.setBoolean(3, oAnioBE.isEstado());
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

    public int eliminarAnioBE(AnioBE oAnioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarAnio(?)}");
            cs.setInt(1, oAnioBE.getIdanio());
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

    public List listObjectAnioBE(AnioBE oAnioBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oAnioBE.getIndOpSp() == 1) {
                sql = " SELECT idanio,denominacion,estado FROM anio WHERE idanio=? and estado=true";
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
            oAnioBE = null;
        }
        return list;
    }

}
