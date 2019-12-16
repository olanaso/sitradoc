package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.ProcedimientoBE;
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

public class ProcedimientoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public ProcedimientoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public ProcedimientoBE listarProcedimientoBE(ProcedimientoBE oProcedimientoBE1) throws SQLException {
        ProcedimientoBE oProcedimientoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oProcedimientoBE = new ProcedimientoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oProcedimientoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idprocedimiento,idarea,codigo,denominacion,plazodias,idcargoresolutor,descripcion,estado FROM procedimiento WHERE idprocedimiento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oProcedimientoBE1.getIdprocedimiento());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oProcedimientoBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                oProcedimientoBE.setIdarea(rs.getInt("idarea"));
                oProcedimientoBE.setCodigo(rs.getString("codigo"));
                oProcedimientoBE.setDenominacion(rs.getString("denominacion"));
                oProcedimientoBE.setPlazodias(rs.getInt("plazodias"));
                oProcedimientoBE.setIdcargoresolutor(rs.getInt("idcargoresolutor"));
                oProcedimientoBE.setDescripcion(rs.getString("descripcion"));
                oProcedimientoBE.setEstado(rs.getBoolean("estado"));
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
        return oProcedimientoBE;
    }

    public ArrayList<ProcedimientoBE> listarRegistroProcedimientoBE(ProcedimientoBE oProcedimientoBE1) throws SQLException {
        ArrayList<ProcedimientoBE> listaProcedimientoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaProcedimientoBE = new ArrayList<ProcedimientoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oProcedimientoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||a.idprocedimiento||')\" class=\"fa fa-pencil-square-o\"></i>',"
                        + "'<i style=\"cursor:pointer;\" onclick=\"del('||a.idprocedimiento||')\" class=\"fa fa-trash-o\"></i>',a.idprocedimiento,"
                        + "a.idarea,a.codigo,a.denominacion,a.plazodias,a.idcargoresolutor,c.denominacion as cargoresolutor,a.idtipoprocedimiento,"
                        + "b.denominacion as tipoprocedimiento,a.descripcion,a.montototal,a.estado FROM procedimiento a inner join tipoprocedimiento"
                        + " b on a.idtipoprocedimiento=b.idtipoprocedimiento inner join cargo c on a.idcargoresolutor=c.idcargo where a.estado=true "
                        + "AND a.idarea=" + oProcedimientoBE1.getIdarea() + " order by a.codigo desc";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    ProcedimientoBE oProcedimientoBE = new ProcedimientoBE();
                    oProcedimientoBE.setEdit(rs.getString(1));
                    oProcedimientoBE.setDel(rs.getString(2));
                    oProcedimientoBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oProcedimientoBE.setIdarea(rs.getInt("idarea"));
                    oProcedimientoBE.setCodigo(rs.getString("codigo"));
                    oProcedimientoBE.setDenominacion(rs.getString("denominacion"));
                    oProcedimientoBE.setPlazodias(rs.getInt("plazodias"));
                    oProcedimientoBE.setIdcargoresolutor(rs.getInt("idcargoresolutor"));
                    oProcedimientoBE.setCargoresolutor(rs.getString("cargoresolutor"));
                    oProcedimientoBE.setIdtipoprocedimiento(rs.getInt("idtipoprocedimiento"));
                    oProcedimientoBE.setTipoprocedimiento(rs.getString("tipoprocedimiento"));
                    oProcedimientoBE.setDescripcion(rs.getString("descripcion"));
                    oProcedimientoBE.setMontototal(rs.getDouble("montototal"));
                    oProcedimientoBE.setEstado(rs.getBoolean("estado"));
                    listaProcedimientoBE.add(oProcedimientoBE);
                }
            }

            if (oProcedimientoBE1.getIndOpSp() == 2) {
                sql = " SELECT idprocedimiento,idarea,codigo,denominacion,plazodias,idcargoresolutor,descripcion,estado FROM procedimiento WHERE idprocedimiento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oProcedimientoBE1.getIdprocedimiento());
                rs = pst.executeQuery();
                while (rs.next()) {
                    ProcedimientoBE oProcedimientoBE = new ProcedimientoBE();
                    oProcedimientoBE.setEdit(rs.getString(1));
                    oProcedimientoBE.setDel(rs.getString(2));
                    oProcedimientoBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oProcedimientoBE.setIdarea(rs.getInt("idarea"));
                    oProcedimientoBE.setCodigo(rs.getString("codigo"));
                    oProcedimientoBE.setDenominacion(rs.getString("denominacion"));
                    oProcedimientoBE.setPlazodias(rs.getInt("plazodias"));
                    oProcedimientoBE.setIdcargoresolutor(rs.getInt("idcargoresolutor"));
                    oProcedimientoBE.setDescripcion(rs.getString("descripcion"));
                    oProcedimientoBE.setEstado(rs.getBoolean("estado"));
                    listaProcedimientoBE.add(oProcedimientoBE);
                }
            }
            if (oProcedimientoBE1.getIndOpSp() == 3) {
                sql = " SELECT idprocedimiento,b.idarea,a.denominacion denominacion,b.denominacion area FROM procedimiento a\n"
                        + "inner join area b on a.idarea=b.idarea\n"
                        + "where \n"
                        + "a.estado=true\n"
                        + "and b.estado=true and bindweb=true \n"
                        + "and (a.denominacion ilike '%'||replace(rtrim(ltrim('" + oProcedimientoBE1.getDenominacion() + "', ' '),' '),' ','%')||'%' or to_tsvector(a.denominacion)@@ plainto_tsquery('" + oProcedimientoBE1.getDenominacion() + "'))\n"
                        + "limit 10";
                System.out.println("sql3:" + sql);
                pst = cn.prepareStatement(sql);

                rs = pst.executeQuery();
                while (rs.next()) {
                    ProcedimientoBE oProcedimientoBE = new ProcedimientoBE();

                    oProcedimientoBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oProcedimientoBE.setIdarea(rs.getInt("idarea"));
                    oProcedimientoBE.setDenominacion(rs.getString("denominacion"));
                    oProcedimientoBE.setArea(rs.getString("area"));

                    listaProcedimientoBE.add(oProcedimientoBE);
                }
            }

            if (oProcedimientoBE1.getIndOpSp() == 4) {
                sql = " SELECT idprocedimiento, b.idarea,a.denominacion  ||' - '|| b.denominacion||'' denominacion,b.denominacion area FROM procedimiento a\n"
                        + "inner join area b on a.idarea=b.idarea\n"
                        + "inner join tipoprocedimiento c on a.idtipoprocedimiento=c.idtipoprocedimiento  and c.estado=true and c.bindactual=true\n"
                        + "where \n"
                        + "a.estado=true\n"
                        + "and b.estado=true \n"
                        + "and a.denominacion||b.denominacion ilike '%'||replace(rtrim(ltrim('" + oProcedimientoBE1.getDenominacion() + "', ' '),' '),' ','%')||'%' or to_tsvector(a.denominacion)@@ plainto_tsquery('" + oProcedimientoBE1.getDenominacion() + "') \n"
                        + "limit 10";
                System.out.println("sql: 4" + sql);
                pst = cn.prepareStatement(sql);

                rs = pst.executeQuery();
                while (rs.next()) {
                    ProcedimientoBE oProcedimientoBE = new ProcedimientoBE();

                    oProcedimientoBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oProcedimientoBE.setIdarea(rs.getInt("idarea"));
                    oProcedimientoBE.setDenominacion(rs.getString("denominacion"));
                    oProcedimientoBE.setArea(rs.getString("area"));

                    listaProcedimientoBE.add(oProcedimientoBE);
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
            oProcedimientoBE1 = null;
        }
        return listaProcedimientoBE;
    }

    public int insertarRegistrosProcedimientoBE(ArrayList<ProcedimientoBE> oListaProcedimientoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ProcedimientoBE oProcedimientoBE : oListaProcedimientoBE) {
                cs = cn.prepareCall("{call uspInsertarProcedimiento(?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oProcedimientoBE.getIdarea());
                cs.setString(2, oProcedimientoBE.getCodigo());
                cs.setString(3, oProcedimientoBE.getDenominacion());
                cs.setInt(4, oProcedimientoBE.getPlazodias());
                cs.setInt(5, oProcedimientoBE.getIdcargoresolutor());
                cs.setInt(6, oProcedimientoBE.getIdtipoprocedimiento());
                cs.setString(7, oProcedimientoBE.getDescripcion());
                cs.setDouble(8, oProcedimientoBE.getMontototal());
                cs.setBoolean(9, oProcedimientoBE.isEstado());
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

    public int insertarProcedimientoBE(ProcedimientoBE oProcedimientoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarProcedimiento(?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oProcedimientoBE.getIdarea());
            cs.setString(2, oProcedimientoBE.getCodigo());
            cs.setString(3, oProcedimientoBE.getDenominacion());
            cs.setInt(4, oProcedimientoBE.getPlazodias());
            cs.setInt(5, oProcedimientoBE.getIdcargoresolutor());
            cs.setInt(6, oProcedimientoBE.getIdtipoprocedimiento());
            cs.setString(7, oProcedimientoBE.getDescripcion());
            cs.setDouble(8, oProcedimientoBE.getMontototal());
            cs.setBoolean(9, oProcedimientoBE.isEstado());
            cs.registerOutParameter(10, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(10);
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

    public int actualizarProcedimientoBE(ProcedimientoBE oProcedimientoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarProcedimiento(?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oProcedimientoBE.getIdprocedimiento());
            cs.setInt(2, oProcedimientoBE.getIdarea());
            cs.setString(3, oProcedimientoBE.getCodigo());
            cs.setString(4, oProcedimientoBE.getDenominacion());
            cs.setInt(5, oProcedimientoBE.getPlazodias());
            cs.setInt(6, oProcedimientoBE.getIdcargoresolutor());
            cs.setInt(7, oProcedimientoBE.getIdtipoprocedimiento());
            cs.setString(8, oProcedimientoBE.getDescripcion());
            cs.setDouble(9, oProcedimientoBE.getMontototal());
            cs.setBoolean(10, oProcedimientoBE.isEstado());
            cs.registerOutParameter(10, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(10);
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

    public int eliminarProcedimientoBE(ProcedimientoBE oProcedimientoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarProcedimiento(?)}");
            cs.setInt(1, oProcedimientoBE.getIdprocedimiento());
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

    public List listObjectProcedimientoBE(ProcedimientoBE oProcedimientoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oProcedimientoBE.getIndOpSp() == 1) {
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

            if (oProcedimientoBE.getIndOpSp() == 2) {
                sql = "SELECT idcargo, denominacion, estado FROM cargo WHERE estado=true AND idarea=" + oProcedimientoBE.getIdarea();
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }
            }

            if (oProcedimientoBE.getIndOpSp() == 3) {
                sql = "SELECT idtipoprocedimiento, denominacion, estado FROM tipoprocedimiento WHERE estado=true and bindactual=true";
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
            oProcedimientoBE = null;
        }
        return list;
    }

}
