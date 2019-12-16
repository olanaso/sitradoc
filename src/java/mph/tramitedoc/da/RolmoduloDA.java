package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.RolmoduloBE;
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

public class RolmoduloDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public RolmoduloDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public RolmoduloBE listarRolmoduloBE(RolmoduloBE oRolmoduloBE1) throws SQLException {
        RolmoduloBE oRolmoduloBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oRolmoduloBE = new RolmoduloBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oRolmoduloBE1.getIndOpSp() == 1) {

                String sql = " SELECT idrolmodulo,idrol,idmodulo,fechaasignacion,estado FROM rolmodulo WHERE idrolmodulo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oRolmoduloBE1.getIdrolmodulo());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oRolmoduloBE.setIdrolmodulo(rs.getInt("idrolmodulo"));
                oRolmoduloBE.setIdrol(rs.getInt("idrol"));
                oRolmoduloBE.setIdmodulo(rs.getInt("idmodulo"));
                oRolmoduloBE.setFechaasignacion(rs.getDate("fechaasignacion"));
                oRolmoduloBE.setEstado(rs.getBoolean("estado"));
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
        return oRolmoduloBE;
    }

    public ArrayList<RolmoduloBE> listarRegistroRolmoduloBE(RolmoduloBE oRolmoduloBE1) throws SQLException {
        ArrayList<RolmoduloBE> listaRolmoduloBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaRolmoduloBE = new ArrayList<RolmoduloBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oRolmoduloBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idrolmodulo||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idrolmodulo||')\" class=\"fa fa-trash-o\"></i>',"
                        + "rm.idrolmodulo,rm.idrol,rm.idmodulo,r.denominacion as rol,m.denominacion as modulo,m.paginainicio,\n"
                        + "       rm.fechaasignacion, rm.estado\n"
                        + "       from rol r \n"
                        + "       inner join  rolmodulo rm\n"
                        + "	on r.idrol=rm.idrol inner join modulo m\n"
                        + "	on m.idmodulo=rm.idmodulo\n"
                        + "	where rm.estado=true\n"
                        //+ "     and r.idrol="+oRolmoduloBE1.getIdrol()
                        + "     order by r.idrol asc";

                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    RolmoduloBE oRolmoduloBE = new RolmoduloBE();
                    oRolmoduloBE.setEdit(rs.getString(1));
                    oRolmoduloBE.setDel(rs.getString(2));
                    oRolmoduloBE.setIdrolmodulo(rs.getInt("idrolmodulo"));
                    oRolmoduloBE.setIdrol(rs.getInt("idrol"));
                    oRolmoduloBE.setIdmodulo(rs.getInt("idmodulo"));
                    oRolmoduloBE.setDenominacionrol(rs.getString("rol"));
                    oRolmoduloBE.setDenominacionmodulo(rs.getString("modulo"));
                    oRolmoduloBE.setPaginainiciomodulo(rs.getString("paginainicio"));
                    oRolmoduloBE.setFechaasignacion(rs.getDate("fechaasignacion"));
                    oRolmoduloBE.setEstado(rs.getBoolean("estado"));
                    listaRolmoduloBE.add(oRolmoduloBE);
                }
            }
            if (oRolmoduloBE1.getIndOpSp() == 2) {
                sql = " SELECT idrolmodulo,idrol,idmodulo,fechaasignacion,estado FROM rolmodulo WHERE idrolmodulo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oRolmoduloBE1.getIdrolmodulo());
                rs = pst.executeQuery();

                while (rs.next()) {
                    RolmoduloBE oRolmoduloBE = new RolmoduloBE();
                    oRolmoduloBE.setEdit(rs.getString(1));
                    oRolmoduloBE.setDel(rs.getString(2));
                    oRolmoduloBE.setIdrolmodulo(rs.getInt("idrolmodulo"));
                    oRolmoduloBE.setIdrol(rs.getInt("idrol"));
                    oRolmoduloBE.setIdmodulo(rs.getInt("idmodulo"));
                    oRolmoduloBE.setFechaasignacion(rs.getDate("fechaasignacion"));
                    oRolmoduloBE.setEstado(rs.getBoolean("estado"));
                    listaRolmoduloBE.add(oRolmoduloBE);
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
            oRolmoduloBE1 = null;
        }
        return listaRolmoduloBE;
    }

    public int insertarRegistrosRolmoduloBE(ArrayList<RolmoduloBE> oListaRolmoduloBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (RolmoduloBE oRolmoduloBE : oListaRolmoduloBE) {
                cs = cn.prepareCall("{call uspInsertarRolmodulo(?,?,?,?,?)}");
                cs.setInt(1, oRolmoduloBE.getIdrol());
                cs.setInt(2, oRolmoduloBE.getIdmodulo());
                Date fechaasignacion = new Date(oRolmoduloBE.getFechaasignacion().getTime());
                cs.setDate(3, fechaasignacion);
                cs.setBoolean(4, oRolmoduloBE.isEstado());
                cs.registerOutParameter(5, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(5);
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

    public int insertarRolmoduloBE(RolmoduloBE oRolmoduloBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarRolmodulo(?,?,?,?,?)}");
            cs.setInt(1, oRolmoduloBE.getIdrol());
            cs.setInt(2, oRolmoduloBE.getIdmodulo());
            Date fechaasignacion = new Date(oRolmoduloBE.getFechaasignacion().getTime());
            cs.setDate(3, fechaasignacion);
            cs.setBoolean(4, oRolmoduloBE.isEstado());
            cs.registerOutParameter(5, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(5);
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

    public int actualizarRolmoduloBE(RolmoduloBE oRolmoduloBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarRolmodulo(?,?,?,?,?)}");
            cs.setInt(1, oRolmoduloBE.getIdrolmodulo());
            cs.setInt(2, oRolmoduloBE.getIdrol());
            cs.setInt(3, oRolmoduloBE.getIdmodulo());
            Date fechaasignacion = new Date(oRolmoduloBE.getFechaasignacion().getTime());
            cs.setDate(4, fechaasignacion);
            cs.setBoolean(5, oRolmoduloBE.isEstado());
            cs.registerOutParameter(5, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(5);
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

    public int eliminarRolmoduloBE(RolmoduloBE oRolmoduloBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarRolmodulo(?)}");
            cs.setInt(1, oRolmoduloBE.getIdrolmodulo());
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

    public List listObjectRolmoduloBE(RolmoduloBE oRolmoduloBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oRolmoduloBE.getIndOpSp() == 1) {
                sql = " SELECT idrolmodulo,idrol,idmodulo,fechaasignacion,estado FROM rolmodulo WHERE idrolmodulo=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oRolmoduloBE.getIndOpSp() == 2) {
                sql = " SELECT idrol,denominacion FROM rol WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oRolmoduloBE.getIndOpSp() == 3) {
                sql = " SELECT idmodulo,denominacion FROM modulo WHERE estado=true";
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
            oRolmoduloBE = null;
        }
        return list;
    }

}
