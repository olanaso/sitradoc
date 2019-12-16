package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.UsuarioBE;
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
import mph.tramitedoc.util.Blowfish;
import mph.tramitedoc.util.Parameter;

public class UsuarioDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public UsuarioDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public UsuarioBE listarUsuarioBE(UsuarioBE oUsuarioBE1) throws SQLException {
        UsuarioBE oUsuarioBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oUsuarioBE = new UsuarioBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oUsuarioBE1.getIndOpSp() == 1) {

                String sql = " SELECT idusuario,nombres,apellidos,dni,direccion,telefono,usuario,password,estado,foto,iniciales FROM usuario WHERE idusuario=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oUsuarioBE1.getIdusuario());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);
                while (rs.next()) {
                    oUsuarioBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuarioBE.setNombres(rs.getString("nombres"));
                    oUsuarioBE.setApellidos(rs.getString("apellidos"));
                    oUsuarioBE.setDni(rs.getString("dni"));
                    oUsuarioBE.setDireccion(rs.getString("direccion"));
                    oUsuarioBE.setTelefono(rs.getString("telefono"));
                    oUsuarioBE.setUsuario(rs.getString("usuario"));
                    oUsuarioBE.setPassword(rs.getString("password"));
                    oUsuarioBE.setEstado(rs.getBoolean("estado"));
                    oUsuarioBE.setFoto(rs.getString("foto"));
                }

            }

            if (oUsuarioBE1.getIndOpSp() == 2) {

                Blowfish oBlowfish = new Blowfish(Parameter.password_key);

                String sql = " SELECT idusuario,nombres,apellidos,dni,direccion,telefono,usuario,password,estado,foto FROM usuario WHERE usuario='" + oUsuarioBE1.getUsuario() + "' and password='" + oUsuarioBE1.getPassword() + "'  and estado=true limit 1";
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oUsuarioBE1.getIdusuario());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);
                while (rs.next()) {
                    oUsuarioBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuarioBE.setNombres(rs.getString("nombres"));
                    oUsuarioBE.setApellidos(rs.getString("apellidos"));
                    oUsuarioBE.setDni(rs.getString("dni"));
                    oUsuarioBE.setDireccion(rs.getString("direccion"));
                    oUsuarioBE.setTelefono(rs.getString("telefono"));
                    oUsuarioBE.setUsuario(rs.getString("usuario"));
                    //oUsuarioBE.setPassword(rs.getString("password"));
                    oUsuarioBE.setEstado(rs.getBoolean("estado"));
                    oUsuarioBE.setFoto(rs.getString("foto"));
                }

//                if (!oBlowfish.decrypt(oUsuarioBE.getPassword()).equals(oUsuarioBE1.getPassword())) {
//                    System.out.println("" + oBlowfish.decrypt(oUsuarioBE.getPassword()).compareTo(oUsuarioBE1.getPassword()));
//                    oUsuarioBE.setIdusuario(-1);
//                    System.out.println(oBlowfish.decrypt(oUsuarioBE.getPassword()));
//                    System.out.println(oUsuarioBE1.getPassword());
//                } else {
//                    System.out.println("" + oBlowfish.decrypt(oUsuarioBE.getPassword()).compareTo(oUsuarioBE1.getPassword()));
//                    System.out.println(oBlowfish.decrypt(oUsuarioBE.getPassword()));
//                    System.out.println(oUsuarioBE1.getPassword());
//                }
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
        return oUsuarioBE;
    }

    public ArrayList<UsuarioBE> listarRegistroUsuarioBE(UsuarioBE oUsuarioBE1) throws SQLException {
        ArrayList<UsuarioBE> listaUsuarioBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        Blowfish oBlowfish = new Blowfish(Parameter.password_key);

        try {
            listaUsuarioBE = new ArrayList<UsuarioBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oUsuarioBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idusuario||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idusuario||')\" class=\"fa fa-trash-o\"></i>',idusuario,nombres,apellidos,dni,direccion,telefono,usuario,password,estado,foto,iniciales FROM usuario WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    UsuarioBE oUsuarioBE = new UsuarioBE();
                    oUsuarioBE.setEdit(rs.getString(1));
                    oUsuarioBE.setDel(rs.getString(2));
                    oUsuarioBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuarioBE.setNombres(rs.getString("nombres"));
                    oUsuarioBE.setApellidos(rs.getString("apellidos"));
                    oUsuarioBE.setDni(rs.getString("dni"));
                    oUsuarioBE.setDireccion(rs.getString("direccion"));
                    oUsuarioBE.setTelefono(rs.getString("telefono"));
                    oUsuarioBE.setUsuario(rs.getString("usuario"));
                    System.out.println("" + oBlowfish.decrypt(rs.getString("password")));
                    oUsuarioBE.setPassword(oBlowfish.decrypt(rs.getString("password")));
                    oUsuarioBE.setEstado(rs.getBoolean("estado"));
                    oUsuarioBE.setFoto(rs.getString("foto"));
                    oUsuarioBE.setIniciales(rs.getString("iniciales"));

                    listaUsuarioBE.add(oUsuarioBE);
                }
            }

            if (oUsuarioBE1.getIndOpSp() == 2) {
                sql = "SELECT idusuario,nombres||' '||apellidos||' '||usuario nombres,apellidos,dni,direccion,telefono,usuario,password,estado FROM usuario WHERE \n"
                        + "nombres ||' '|| apellidos ||' '|| dni||' '|| usuario ilike replace(rtrim(ltrim( case when ''='" + oUsuarioBE1.getNombres() + "'  then '' else '" + oUsuarioBE1.getNombres() + "' end, ' '),' '),' ','%')||'%'\n"
                        + "or to_tsvector(nombres ||' '|| apellidos ||' '|| dni||' '|| usuario)@@ plainto_tsquery('" + oUsuarioBE1.getNombres() + "')\n"
                        + " and estado=true limit 5";

                pst = cn.prepareStatement(sql);
                //pst.setInt(1, oUsuarioBE1.getIdusuario());
                System.out.println("sql autocomplete:" + sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    UsuarioBE oUsuarioBE = new UsuarioBE();
                    oUsuarioBE.setEdit(rs.getString(1));
                    oUsuarioBE.setDel(rs.getString(2));
                    oUsuarioBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuarioBE.setNombres(rs.getString("nombres"));
                    oUsuarioBE.setApellidos(rs.getString("apellidos"));
                    oUsuarioBE.setDni(rs.getString("dni"));
                    oUsuarioBE.setDireccion(rs.getString("direccion"));
                    oUsuarioBE.setTelefono(rs.getString("telefono"));
                    oUsuarioBE.setUsuario(rs.getString("usuario"));
                    oUsuarioBE.setPassword(oBlowfish.decrypt(rs.getString("password")));
                    oUsuarioBE.setEstado(rs.getBoolean("estado"));
                    listaUsuarioBE.add(oUsuarioBE);
                }
            }

            if (oUsuarioBE1.getIndOpSp() == 3) {
                sql = "select a.idusuario,d.idarea,a.nombres||' '||a.apellidos||' '||a.usuario /*|| ' - '|| d.denominacion*/ nombres from usuario a\n"
                        + "inner join usuariocargo b on a.idusuario=b.idusuario\n"
                        + "inner join cargo c on b.idcargo=c.idcargo\n"
                        + "inner join area d on c.idarea=d.idarea\n"
                        + "where \n"
                        + "(a.nombres ||' '|| a.apellidos ||' '|| a.dni||' '|| a.usuario ilike '%'||replace(rtrim(ltrim( case when ''='" + oUsuarioBE1.getNombres() + "'  then '' else '" + oUsuarioBE1.getNombres() + "' end, ' '),' '),' ','%')||'%'\n"
                        + "or to_tsvector(a.nombres ||' '|| a.apellidos ||' '|| a.dni||' '|| a.usuario)@@ plainto_tsquery('" + oUsuarioBE1.getNombres() + "'))\n"
                        + "and a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and c.estado=true\n"
                        + "and d.estado=true\n"
                        + "limit 5";

                pst = cn.prepareStatement(sql);
                //pst.setInt(1, oUsuarioBE1.getIdusuario());
                System.out.println("autocompletado usuario :" + sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    UsuarioBE oUsuarioBE = new UsuarioBE();

                    oUsuarioBE.setIdusuario(rs.getInt("idusuario"));
                    oUsuarioBE.setIdarea(rs.getInt("idarea"));
                    oUsuarioBE.setNombres(rs.getString("nombres"));
                    listaUsuarioBE.add(oUsuarioBE);
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
            oUsuarioBE1 = null;
        }
        return listaUsuarioBE;
    }

    public int insertarRegistrosUsuarioBE(ArrayList<UsuarioBE> oListaUsuarioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (UsuarioBE oUsuarioBE : oListaUsuarioBE) {
                cs = cn.prepareCall("{call uspInsertarUsuario(?,?,?,?,?,?,?,?,?,?)}");
                cs.setString(1, oUsuarioBE.getNombres());
                cs.setString(2, oUsuarioBE.getApellidos());
                cs.setString(3, oUsuarioBE.getDni());
                cs.setString(4, oUsuarioBE.getDireccion());
                cs.setString(5, oUsuarioBE.getTelefono());
                cs.setString(6, oUsuarioBE.getUsuario());
                cs.setString(7, oUsuarioBE.getPassword());
                cs.setBoolean(8, oUsuarioBE.isEstado());
                cs.setString(9, oUsuarioBE.getFoto());
                cs.registerOutParameter(10, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(10);
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

    public int insertarUsuarioBE(UsuarioBE oUsuarioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarUsuario(?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setString(1, oUsuarioBE.getNombres());
            cs.setString(2, oUsuarioBE.getApellidos());
            cs.setString(3, oUsuarioBE.getDni());
            cs.setString(4, oUsuarioBE.getDireccion());
            cs.setString(5, oUsuarioBE.getTelefono());
            cs.setString(6, oUsuarioBE.getUsuario());
            cs.setString(7, oUsuarioBE.getPassword());
            cs.setBoolean(8, oUsuarioBE.isEstado());
            cs.setString(9, oUsuarioBE.getCreationdate());
            cs.setString(10, oUsuarioBE.getFoto());
            cs.setString(11, oUsuarioBE.getIniciales());
            cs.registerOutParameter(12, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(12);
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

    public int actualizarUsuarioBE(UsuarioBE oUsuarioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarUsuario(?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oUsuarioBE.getIdusuario());
            cs.setString(2, oUsuarioBE.getNombres());
            cs.setString(3, oUsuarioBE.getApellidos());
            cs.setString(4, oUsuarioBE.getDni());
            cs.setString(5, oUsuarioBE.getDireccion());
            cs.setString(6, oUsuarioBE.getTelefono());
            cs.setString(7, oUsuarioBE.getUsuario());
            cs.setString(8, oUsuarioBE.getPassword());
            cs.setBoolean(9, oUsuarioBE.isEstado());
            cs.setString(10, oUsuarioBE.getFoto());
             cs.setString(11, oUsuarioBE.getIniciales());
            cs.registerOutParameter(11, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(11);
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

    public int eliminarUsuarioBE(UsuarioBE oUsuarioBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarUsuario(?)}");
            cs.setInt(1, oUsuarioBE.getIdusuario());
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

    public List listObjectUsuarioBE(UsuarioBE oUsuarioBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oUsuarioBE.getIndOpSp() == 1) {
                sql = " SELECT idusuario,nombres,apellidos,dni,direccion,telefono,usuario,password,estado FROM usuario WHERE idusuario=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oUsuarioBE.getIndOpSp() == 2) { //obtteniendo los roles del ususario
                sql = " select array_to_string(array_agg(a.denominacion), ',') roles from rol a\n"
                        + "inner join usuariorol b on a.idrol=b.idrol \n"
                        + "where b.idusuario=" + oUsuarioBE.getIdusuario() + " and a.estado=true and b.estado";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1)};
                    list.add(obj);
                }

            }

            if (oUsuarioBE.getIndOpSp() == 3) { //datos del usuario 
                sql = " select c.idarea,c.denominacion,a.idcargo,a.denominacion,a.bindjefe from cargo a\n"
                        + "inner join usuariocargo b on b.idcargo=a.idcargo\n"
                        + "inner join area c on a.idarea=c.idarea\n"
                        + "where b.idusuario=" + oUsuarioBE.getIdusuario() + "";
                System.out.println("sql" + sql);
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5)};
                    list.add(obj);
                }

            }

            if (oUsuarioBE.getIndOpSp() == 4) {
                sql = " select m.idmodulo,m.denominacion Modulo,m.paginainicio\n"
                        + "from usuario u inner join usuariorol ur\n"
                        + "	on  u.idusuario = ur.idusuario inner join rol r\n"
                        + "	on r.idrol=ur.idrol inner join rolmodulo rm\n"
                        + "	on rm.idrol = r.idrol inner join modulo m\n"
                        + "	on m.idmodulo = rm.idmodulo\n"
                        + "	where u.idusuario=" + oUsuarioBE.getIdusuario() + " and ur.estado=true and m.estado=true and rm.estado=true\n"
                        + "	group by m.idmodulo,m.denominacion ,m.paginainicio";

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3)};
                    list.add(obj);
                }

            }
            
            if (oUsuarioBE.getIndOpSp() == 5) {
                sql = "select idusuariorol,idusuario,idrol from usuariorol"
                        + " where idusuario=" + oUsuarioBE.getIdusuario() + " and estado=true and idrol in (3,4)";//idrol=3.Secretario, idrol=4.Jefe de Area tabla rol

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3)};
                    list.add(obj);
                }
            }
            
            if (oUsuarioBE.getIndOpSp() == 6) {
                sql = "select idusuariorol,idusuario,idrol from usuariorol"
                        + " where idusuario=" + oUsuarioBE.getIdusuario() + " and estado=true and idrol=4";//idrol=4.Jefe de Area tabla rol

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3)};
                    list.add(obj);
                }
            }
            
            if (oUsuarioBE.getIndOpSp() == 7) {
                sql = "select idusuariorol,idusuario,idrol from usuariorol"
                        + " where idusuario=" + oUsuarioBE.getIdusuario() + " and estado=true and idrol=3";//idrol=3.Secretario tabla rol

                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3)};
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
            oUsuarioBE = null;
        }
        return list;
    }

}
