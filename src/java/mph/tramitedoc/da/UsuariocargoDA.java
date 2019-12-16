package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.UsuariocargoBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class UsuariocargoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public UsuariocargoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public UsuariocargoBE listarUsuariocargoBE(UsuariocargoBE oUsuariocargoBE1) throws SQLException {
        UsuariocargoBE oUsuariocargoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oUsuariocargoBE = new UsuariocargoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oUsuariocargoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idusuariocargo,idusuario,idcargo,fechaasignado,estado FROM usuariocargo WHERE idusuariocargo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oUsuariocargoBE1.getIdusuariocargo());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {

                oUsuariocargoBE.setIdusuariocargo(rs.getInt("idusuariocargo"));
                oUsuariocargoBE.setIdusuario(rs.getInt("idusuario"));
                oUsuariocargoBE.setIdcargo(rs.getInt("idcargo"));
                oUsuariocargoBE.setFechaasignado(rs.getDate("fechaasignado"));
                oUsuariocargoBE.setEstado(rs.getBoolean("estado"));

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
        return oUsuariocargoBE;
    }

    public ArrayList<UsuariocargoBE> listarRegistroUsuariocargoBE(UsuariocargoBE oUsuariocargoBE1) throws SQLException {
        ArrayList<UsuariocargoBE> listaUsuariocargoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaUsuariocargoBE = new ArrayList<UsuariocargoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oUsuariocargoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||a.idusuariocargo||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||a.idusuariocargo||')\" class=\"fa fa-trash-o\"></i>',a.idusuariocargo,\n"
                        + "d.denominacion||' - '||b.denominacion area_cargo,c.nombres||' '||c.apellidos||' - '||c.usuario usuario,\n"
                        + " a.idusuario,a.idcargo,to_char(a.fechaasignado,'DD/MM/YYYY HH24:MI:SS') fechaasignado,a.estado \n"
                        + " FROM usuariocargo a\n"
                        + "inner join cargo b on a.idcargo=b.idcargo \n"
                        + "inner join area d on b.idarea=d.idarea\n"
                        + "inner join usuario c on a.idusuario=c.idusuario\n"
                        + "WHERE a.estado=true";
                System.out.println("sql:" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    UsuariocargoBE oUsuariocargoBE = new UsuariocargoBE();
                    oUsuariocargoBE.setEdit(rs.getString(1));
                    oUsuariocargoBE.setDel(rs.getString(2));
                    oUsuariocargoBE.setArea_cargo(rs.getString("area_cargo"));
                    oUsuariocargoBE.setUsuario(rs.getString("usuario"));
                    oUsuariocargoBE.setIdusuariocargo(rs.getInt("idusuariocargo"));
                    oUsuariocargoBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuariocargoBE.setIdcargo(rs.getInt("idcargo"));
                    SimpleDateFormat fromUser = new SimpleDateFormat("dd/MM/yyyy");
                    oUsuariocargoBE.setFechaasignado(fromUser.parse(rs.getString("fechaasignado")));
                    //oUsuariocargoBE.setFechaasignado(rs.getDate("fechaasignado"));
                    oUsuariocargoBE.setEstado(rs.getBoolean("estado"));
                    listaUsuariocargoBE.add(oUsuariocargoBE);
                }

            }
            if (oUsuariocargoBE1.getIndOpSp() == 2) {
                sql = " SELECT idusuariocargo,idusuario,idcargo,fechaasignado,estado FROM usuariocargo WHERE idusuariocargo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oUsuariocargoBE1.getIdusuariocargo());
                rs = pst.executeQuery();
                while (rs.next()) {
                    UsuariocargoBE oUsuariocargoBE = new UsuariocargoBE();
                    oUsuariocargoBE.setEdit(rs.getString(1));
                    oUsuariocargoBE.setDel(rs.getString(2));
                    oUsuariocargoBE.setIdusuariocargo(rs.getInt("idusuariocargo"));
                    oUsuariocargoBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuariocargoBE.setIdcargo(rs.getInt("idcargo"));

                    oUsuariocargoBE.setFechaasignado(rs.getDate("fechaasignado"));
                    oUsuariocargoBE.setEstado(rs.getBoolean("estado"));
                    listaUsuariocargoBE.add(oUsuariocargoBE);
                }

            }

            if (oUsuariocargoBE1.getIndOpSp() == 3) {
                sql = " select c.idarea,c.denominacion area,a.idcargo,a.denominacion cargo,a.bindjefe from cargo a\n"
                        + "                   \n"
                        + "                        inner join usuariocargo b on b.idcargo=a.idcargo\n"
                        + "                        inner join area c on a.idarea=c.idarea\n"
                        + "                        where b.idusuario=" + oUsuariocargoBE1.getIdusuario() + "\n"
                        + "                        and a.estado=true\n"
                        + "                        and b.estado=true\n"
                        + "                        and c.estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setInt(1, oUsuariocargoBE1.getIdusuariocargo());
                rs = pst.executeQuery();
                while (rs.next()) {
                    UsuariocargoBE oUsuariocargoBE = new UsuariocargoBE();

                    oUsuariocargoBE.setIdarea(rs.getInt("idarea"));
                    oUsuariocargoBE.setArea(rs.getString("area"));
                    oUsuariocargoBE.setIdcargo(rs.getInt("idcargo"));
                    oUsuariocargoBE.setCargo(rs.getString("cargo"));
                    oUsuariocargoBE.setBindjefe(rs.getBoolean("bindjefe"));

                    listaUsuariocargoBE.add(oUsuariocargoBE);
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
            oUsuariocargoBE1 = null;
        }
        return listaUsuariocargoBE;
    }

    public int insertarRegistrosUsuariocargoBE(ArrayList<UsuariocargoBE> oListaUsuariocargoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (UsuariocargoBE oUsuariocargoBE : oListaUsuariocargoBE) {
                cs = cn.prepareCall("{call uspInsertarUsuariocargo(?,?,?,?,?)}");
                cs.setInt(1, oUsuariocargoBE.getIdusuario());
                cs.setInt(2, oUsuariocargoBE.getIdcargo());
                Date fechaasignado = new Date(oUsuariocargoBE.getFechaasignado().getTime());
                cs.setDate(3, fechaasignado);
                cs.setBoolean(4, oUsuariocargoBE.isEstado());
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

    public int insertarUsuariocargoBE(UsuariocargoBE oUsuariocargoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarUsuariocargo(?,?,?,?,?)}");
            cs.setInt(1, oUsuariocargoBE.getIdusuario());
            cs.setInt(2, oUsuariocargoBE.getIdcargo());
            Date fechaasignado = new Date(oUsuariocargoBE.getFechaasignado().getTime());
            cs.setDate(3, fechaasignado);
            cs.setBoolean(4, oUsuariocargoBE.isEstado());
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

    public int actualizarUsuariocargoBE(UsuariocargoBE oUsuariocargoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarUsuariocargo(?,?,?,?,?)}");
            cs.setInt(1, oUsuariocargoBE.getIdusuariocargo());
            cs.setInt(2, oUsuariocargoBE.getIdusuario());
            cs.setInt(3, oUsuariocargoBE.getIdcargo());
            Date fechaasignado = new Date(oUsuariocargoBE.getFechaasignado().getTime());
            cs.setDate(4, fechaasignado);
            cs.setBoolean(5, oUsuariocargoBE.isEstado());
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

    public int eliminarUsuariocargoBE(UsuariocargoBE oUsuariocargoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarUsuariocargo(?)}");
            cs.setInt(1, oUsuariocargoBE.getIdusuariocargo());
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

    public List listObjectUsuariocargoBE(UsuariocargoBE oUsuariocargoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oUsuariocargoBE.getIndOpSp() == 1) {
                sql = " select idusuario,usuario||' - '||nombres||' '||apellidos from usuario where estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oUsuariocargoBE.getIndOpSp() == 2) {
                sql = "select idcargo,b.denominacion||' - '||a.denominacion from cargo a\n"
                        + "inner join  area b on a.idarea=b.idarea\n"
                        + " where a.estado=true ";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

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
            oUsuariocargoBE = null;
        }
        return list;
    }

}
