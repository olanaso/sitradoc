package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.ExpedienteBE;
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

public class PreexpedienteDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public PreexpedienteDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public ExpedienteBE listarExpedienteBE(ExpedienteBE oExpedienteBE1) throws SQLException {
        ExpedienteBE oExpedienteBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oExpedienteBE = new ExpedienteBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oExpedienteBE1.getIndOpSp() == 1) {

                String sql = " SELECT idexpediente,idusuariocargo,idprocedimiento,idarea,codigo,dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo,fecharegistro,asunto,estado,bindentregado FROM expediente WHERE idexpediente=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                oExpedienteBE.setIdusuariocargo(rs.getInt("idusuariocargo"));
                oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                oExpedienteBE.setIdarea(rs.getInt("idarea"));
                oExpedienteBE.setCodigo(rs.getInt("codigo"));
                oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                oExpedienteBE.setApellidos(rs.getString("apellidos"));
                oExpedienteBE.setDireccion(rs.getString("direccion"));
                oExpedienteBE.setTelefono(rs.getString("telefono"));
                oExpedienteBE.setCorreo(rs.getString("correo"));
                oExpedienteBE.setFecharegistro(rs.getDate("fecharegistro"));
                oExpedienteBE.setAsunto(rs.getString("asunto"));
                oExpedienteBE.setEstado(rs.getBoolean("estado"));
                oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
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
        return oExpedienteBE;
    }

    public ArrayList<ExpedienteBE> listarRegistroExpedienteBE(ExpedienteBE oExpedienteBE1) throws SQLException {
        ArrayList<ExpedienteBE> listaExpedienteBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaExpedienteBE = new ArrayList<ExpedienteBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oExpedienteBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idexpediente||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idexpediente||')\" class=\"fa fa-trash-o\"></i>',"
                        + "e.idexpediente,e.idprocedimiento,e.codigo,a.denominacion AS area, p.codigo AS Codigo_Procedimiento,p.denominacion AS procedimiento,e.dni_ruc,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,e.asunto,e.estado,e.bindentregado\n"
                        + " ,case when e.bindobservado=true then 'SI' else 'NO' end observado \n"
                        + "from expediente e inner join area a \n"
                        + "	on e.idarea = a.idarea inner join procedimiento p\n"
                        + "	on e.idprocedimiento = p.idprocedimiento\n"
                        + "\n"
                        + "	where e.estado=true";
                pst = cn.prepareStatement(sql);
                System.out.println("" + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setEdit(rs.getString(1));
                    oExpedienteBE.setDel(rs.getString(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setAreadenominacion(rs.getString("area"));
                    oExpedienteBE.setCodprocedimiento(rs.getString("Codigo_Procedimiento"));
                    oExpedienteBE.setDenoprocedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    oExpedienteBE.setObservado(rs.getString("observado"));

                    listaExpedienteBE.add(oExpedienteBE);
                }

            }
            if (oExpedienteBE1.getIndOpSp() == 2) {
                sql = " SELECT idexpediente,idusuariocargo,idprocedimiento,idarea,codigo,dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo,fecharegistro,asunto,estado,bindentregado FROM expediente WHERE idexpediente=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setEdit(rs.getString(1));
                    oExpedienteBE.setDel(rs.getString(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setIdusuariocargo(rs.getInt("idusuariocargo"));
                    oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oExpedienteBE.setIdarea(rs.getInt("idarea"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setFecharegistro(rs.getDate("fecharegistro"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);
                }
            }

            if (oExpedienteBE1.getIndOpSp() == 3) {
                sql = " select \n"
                        + "dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo\n"
                        + "from expediente\n"
                        + "where dni_ruc='" + oExpedienteBE1.getDni_ruc() + "'";
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    listaExpedienteBE.add(oExpedienteBE);

                }
            }

            if (oExpedienteBE1.getIndOpSp() == 4) {
                sql = "select idexpediente,e.codigo,a.denominacion as area,p.denominacion as procedimiento,e.asunto,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,e.fecharegistro,e.estado,e.bindentregado\n"
                        + "\n"
                        + "From expediente e inner join area a\n"
                        + "	on e.idarea=a.idarea inner join procedimiento p\n"
                        + "	on p.idprocedimiento=e.idprocedimiento\n"
                        + "\n"
                        + "	where e.estado=true and e.bindentregado=false ";
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setArea(rs.getString("area"));
                    oExpedienteBE.setProcedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setFecharegistro(rs.getDate("fecharegistro"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);
                }
            }

            if (oExpedienteBE1.getIndOpSp() == 5) {
                sql = "select idexpediente,a.denominacion as area,p.denominacion as procedimiento,e.asunto,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,e.fecharecepciona,e.estado,e.bindentregado\n"
                        + "                    \n"
                        + "                        From expediente e inner join area a\n"
                        + "                        	on e.idarea=a.idarea inner join procedimiento p\n"
                        + "                        on p.idprocedimiento=e.idprocedimiento\n"
                        + "                        \n"
                        + "                       where e.estado=true and e.bindentregado=true  ";
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setArea(rs.getString("area"));
                    oExpedienteBE.setProcedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setFecharecepciona(rs.getDate("fecharecepciona"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);
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
            oExpedienteBE1 = null;
        }
        return listaExpedienteBE;
    }

    public int insertarRegistrosExpedienteBE(ArrayList<ExpedienteBE> oListaExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ExpedienteBE oExpedienteBE : oListaExpedienteBE) {
                cs = cn.prepareCall("{call uspInsertarExpediente(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oExpedienteBE.getIdusuariocargo());
                cs.setInt(2, oExpedienteBE.getIdprocedimiento());
                cs.setInt(3, oExpedienteBE.getIdarea());
                cs.setInt(4, oExpedienteBE.getCodigo());
                cs.setString(5, oExpedienteBE.getDni_ruc());
                cs.setString(6, oExpedienteBE.getNombre_razonsocial());
                cs.setString(7, oExpedienteBE.getApellidos());
                cs.setString(8, oExpedienteBE.getDireccion());
                cs.setString(9, oExpedienteBE.getTelefono());
                cs.setString(10, oExpedienteBE.getCorreo());
                cs.setString(11, oExpedienteBE.getAsunto());
                cs.setBoolean(12, oExpedienteBE.isEstado());
                cs.setBoolean(13, oExpedienteBE.isBindentregado());
                cs.registerOutParameter(14, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(14);
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

    public int insertarExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarExpediente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oExpedienteBE.getIdusuariocargo());
            cs.setInt(2, oExpedienteBE.getIdprocedimiento());
            cs.setInt(3, oExpedienteBE.getIdarea());
            cs.setInt(4, oExpedienteBE.getCodigo());
            cs.setString(5, oExpedienteBE.getDni_ruc());
            cs.setString(6, oExpedienteBE.getNombre_razonsocial());
            cs.setString(7, oExpedienteBE.getApellidos());
            cs.setString(8, oExpedienteBE.getDireccion());
            cs.setString(9, oExpedienteBE.getTelefono());
            cs.setString(10, oExpedienteBE.getCorreo());
            cs.setString(11, oExpedienteBE.getAsunto());
            cs.setBoolean(12, oExpedienteBE.isEstado());
            cs.setBoolean(13, oExpedienteBE.isBindentregado());
            cs.setBoolean(14, oExpedienteBE.isBindobservado());
            cs.registerOutParameter(15, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(15);
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

    public int actualizarExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarExpediente(?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oExpedienteBE.getIdexpediente());
            cs.setInt(2, oExpedienteBE.getIdusuariocargo());
            cs.setString(3, oExpedienteBE.getDni_ruc());
            cs.setString(4, oExpedienteBE.getNombre_razonsocial());
            cs.setString(5, oExpedienteBE.getApellidos());
            cs.setString(6, oExpedienteBE.getDireccion());
            cs.setString(7, oExpedienteBE.getTelefono());
            cs.setString(8, oExpedienteBE.getCorreo());
            cs.setString(9, oExpedienteBE.getAsunto());

            cs.registerOutParameter(9, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(9);
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

    public int actualizarRegistrosExpedienteBE(ArrayList<ExpedienteBE> oListaExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ExpedienteBE oExpedienteBE : oListaExpedienteBE) {
                cs = cn.prepareCall("{call uspentregaexpediente(?,?)}");
                cs.setInt(1, oExpedienteBE.getIdexpediente());
                cs.setInt(2, oExpedienteBE.getIdusuariorecepciona());

                cs.registerOutParameter(2, java.sql.Types.INTEGER);
                cs.executeUpdate();
                resultado = cs.getInt(2);
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

    public int eliminarExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarExpediente(?)}");
            cs.setInt(1, oExpedienteBE.getIdexpediente());
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

    public List listObjectExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oExpedienteBE.getIndOpSp() == 1) {
                sql = " SELECT idexpediente,idusuariocargo,idprocedimiento,idarea,codigo,dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo,asunto,estado,bindentregado FROM expediente WHERE idexpediente=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oExpedienteBE.getIndOpSp() == 2) {
                sql = "SELECT idusuariocargo, idusuario, estado FROM usuariocargo WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oExpedienteBE.getIndOpSp() == 3) {
                sql = "SELECT idarea, denominacion, estado FROM area WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oExpedienteBE.getIndOpSp() == 4) {
                sql = " select p.idprocedimiento,p.denominacion as nombre, p.estado From procedimiento p inner join area a on p.idarea = a.idarea\n"
                        + "where a.idarea=" + oExpedienteBE.getIdarea() + " and p.estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oExpedienteBE.getIndOpSp() == 5) {
                sql = "select idrequisitos,denominacion from requisitos where estado=true and idprocedimiento=" + oExpedienteBE.getIdprocedimiento();
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oExpedienteBE.getIndOpSp() == 6) {
                sql = "select a.idrequisitos,b.denominacion from expedienterequisito a\n"
                        + "inner join requisitos b on a.idrequisitos=b.idrequisitos\n"
                        + "where a.idexpediente=" + oExpedienteBE.getIdexpediente();
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oExpedienteBE.getIndOpSp() == 7) {
                sql = "select idrequisitos, denominacion from requisitos \n"
                        + "where idprocedimiento=" + oExpedienteBE.getIdprocedimiento() + " \n"
                        + "and idrequisitos not in (\n"
                        + "select a.idrequisitos from expedienterequisito a\n"
                        + "where a.idexpediente=" + oExpedienteBE.getIdexpediente() + ") ";
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
            oExpedienteBE = null;
        }
        return list;
    }

}
