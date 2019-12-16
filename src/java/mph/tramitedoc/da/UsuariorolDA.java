package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.UsuariorolBE;
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

public class UsuariorolDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public UsuariorolDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public UsuariorolBE listarUsuariorolBE(UsuariorolBE oUsuariorolBE1) throws SQLException {
        UsuariorolBE oUsuariorolBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oUsuariorolBE = new UsuariorolBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oUsuariorolBE1.getIndOpSp() == 1) {

                String sql = " SELECT idusuariorol,idusuario,idrol,fechaasignacion,estado FROM usuariorol WHERE idusuariorol=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oUsuariorolBE1.getIdusuariorol());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oUsuariorolBE.setIdusuariorol(rs.getInt("idusuariorol"));
                oUsuariorolBE.setIdusuario(rs.getInt("idusuario"));
                oUsuariorolBE.setIdrol(rs.getInt("idrol"));
                oUsuariorolBE.setFechaasignacion(rs.getDate("fechaasignacion"));
                oUsuariorolBE.setEstado(rs.getBoolean("estado"));
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
        return oUsuariorolBE;
    }

    public ArrayList<UsuariorolBE> listarRegistroUsuariorolBE(UsuariorolBE oUsuariorolBE1) throws SQLException {
        ArrayList<UsuariorolBE> listaUsuariorolBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaUsuariorolBE = new ArrayList<UsuariorolBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oUsuariorolBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idusuariorol||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idusuariorol||')\" class=\"fa fa-trash-o\"></i>',"
                        + "  ur.idusuariorol,ur.idusuario,ur.idrol,u.usuario as telefono,r.denominacion as rol,u.nombres, u.apellidos,\n"
                        + "  ur.fechaasignacion,ur.estado\n"
                        + "  \n"
                        + "  from rol r inner join usuariorol ur \n"
                        + "  on r.idrol=ur.idrol inner join usuario u\n"
                        + "  on u.idusuario=ur.idusuario\n"
                        + "	where ur.estado=true \n"
                        //+ "and u.idusuario=" + oUsuariorolBE1.getIdusuario() + "\n"
                        + "	order by r.idrol asc";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    UsuariorolBE oUsuariorolBE = new UsuariorolBE();
                    oUsuariorolBE.setEdit(rs.getString(1));
                    oUsuariorolBE.setDel(rs.getString(2));
                    oUsuariorolBE.setIdusuariorol(rs.getInt("idusuariorol"));
                    oUsuariorolBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuariorolBE.setIdrol(rs.getInt("idrol"));
                    oUsuariorolBE.setTelefono(rs.getString("telefono"));
                    oUsuariorolBE.setDenominacionrol(rs.getString("rol"));
                    oUsuariorolBE.setNombres(rs.getString("nombres"));
                    oUsuariorolBE.setApellidos(rs.getString("apellidos"));
                    oUsuariorolBE.setFechaasignacion(rs.getDate("fechaasignacion"));
                    oUsuariorolBE.setEstado(rs.getBoolean("estado"));
                    listaUsuariorolBE.add(oUsuariorolBE);
                }

            }
            if (oUsuariorolBE1.getIndOpSp() == 2) {
                sql = " SELECT idusuariorol,idusuario,idrol,fechaasignacion,estado FROM usuariorol WHERE idusuariorol=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oUsuariorolBE1.getIdusuariorol());
                rs = pst.executeQuery();
                while (rs.next()) {
                    UsuariorolBE oUsuariorolBE = new UsuariorolBE();
                    oUsuariorolBE.setEdit(rs.getString(1));
                    oUsuariorolBE.setDel(rs.getString(2));
                    oUsuariorolBE.setIdusuariorol(rs.getInt("idusuariorol"));
                    oUsuariorolBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuariorolBE.setIdrol(rs.getInt("idrol"));
                    oUsuariorolBE.setFechaasignacion(rs.getDate("fechaasignacion"));
                    oUsuariorolBE.setEstado(rs.getBoolean("estado"));
                    listaUsuariorolBE.add(oUsuariorolBE);
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
            oUsuariorolBE1 = null;
        }
        return listaUsuariorolBE;
    }

    public int insertarRegistrosUsuariorolBE(ArrayList<UsuariorolBE> oListaUsuariorolBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (UsuariorolBE oUsuariorolBE : oListaUsuariorolBE) {
                cs = cn.prepareCall("{call uspInsertarUsuariorol(?,?,?,?,?)}");
                cs.setInt(1, oUsuariorolBE.getIdusuario());
                cs.setInt(2, oUsuariorolBE.getIdrol());
                Date fechaasignacion = new Date(oUsuariorolBE.getFechaasignacion().getTime());
                cs.setDate(3, fechaasignacion);
                cs.setBoolean(4, oUsuariorolBE.isEstado());
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

    public int insertarUsuariorolBE(UsuariorolBE oUsuariorolBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarUsuariorol(?,?,?,?,?)}");
            cs.setInt(1, oUsuariorolBE.getIdusuario());
            cs.setInt(2, oUsuariorolBE.getIdrol());
            Date fechaasignacion = new Date(oUsuariorolBE.getFechaasignacion().getTime());
            cs.setDate(3, fechaasignacion);
            cs.setBoolean(4, oUsuariorolBE.isEstado());
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

    public int actualizarUsuariorolBE(UsuariorolBE oUsuariorolBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarUsuariorol(?,?,?,?,?)}");
            cs.setInt(1, oUsuariorolBE.getIdusuariorol());
            cs.setInt(2, oUsuariorolBE.getIdusuario());
            cs.setInt(3, oUsuariorolBE.getIdrol());
            Date fechaasignacion = new Date(oUsuariorolBE.getFechaasignacion().getTime());
            cs.setDate(4, fechaasignacion);
            cs.setBoolean(5, oUsuariorolBE.isEstado());
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

    public int eliminarUsuariorolBE(UsuariorolBE oUsuariorolBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarUsuariorol(?)}");
            cs.setInt(1, oUsuariorolBE.getIdusuariorol());
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

    public List listObjectUsuariorolBE(UsuariorolBE oUsuariorolBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oUsuariorolBE.getIndOpSp() == 1) {
                sql = " SELECT idusuariorol,idusuario,idrol,fechaasignacion,estado FROM usuariorol WHERE idusuariorol=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oUsuariorolBE.getIndOpSp() == 2) {
                sql = " select idusuario,nombres||' '||apellidos||'-'||usuario from usuario WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
        

            if (oUsuariorolBE.getIndOpSp() == 3) {
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
            oUsuariorolBE = null;
        }
        return list;
    }

}
