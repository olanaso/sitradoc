package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.AreaBE;
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

public class AreaDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public AreaDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public AreaBE listarAreaBE(AreaBE oAreaBE1) throws SQLException {
        AreaBE oAreaBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oAreaBE = new AreaBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oAreaBE1.getIndOpSp() == 1) {

                String sql = " SELECT idarea,denominacion,estado FROM area WHERE idarea=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oAreaBE1.getIdarea());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oAreaBE.setIdarea(rs.getInt("idarea"));
                oAreaBE.setDenominacion(rs.getString("denominacion"));
                oAreaBE.setEstado(rs.getBoolean("estado"));
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
        return oAreaBE;
    }

    public ArrayList<AreaBE> listarRegistroAreaBE(AreaBE oAreaBE1) throws SQLException {
        ArrayList<AreaBE> listaAreaBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaAreaBE = new ArrayList<AreaBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oAreaBE1.getIndOpSp() == 1) {
                sql = "SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||a1.idarea||')\" class=\"fa fa-pencil-square-o\">"
                        + "</i>','<i style=\"cursor:pointer;\" onclick=\"del('||a1.idarea||')\" class=\"fa fa-trash-o\"></i>',"
                        + "a1.idarea,a1.abreviatura,a1.codigo,a1.denominacion,a1.idareasuperior,a2.denominacion as areasuperior,a1.estado "
                        + "from area a1 left join area a2 on a1.idareasuperior = a2.idarea where a1.estado = true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    AreaBE oAreaBE = new AreaBE();
                    oAreaBE.setEdit(rs.getString(1));
                    oAreaBE.setDel(rs.getString(2));
                    oAreaBE.setIdarea(rs.getInt("idarea"));
                    oAreaBE.setAbreviatura(rs.getString("abreviatura"));
                    oAreaBE.setCodigo(rs.getString("codigo"));
                    oAreaBE.setDenominacion(rs.getString("denominacion"));
                    oAreaBE.setIdareasuperior(rs.getInt("idareasuperior"));
                    oAreaBE.setAreasuperior(rs.getString("areasuperior"));
                    oAreaBE.setEstado(rs.getBoolean("estado"));
                    listaAreaBE.add(oAreaBE);
                }
            }
            if (oAreaBE1.getIndOpSp() == 2) {
                sql = " SELECT idarea,denominacion,estado FROM area WHERE denominacion ilike '%" + oAreaBE1.getDenominacion() + "%' limit 4";
                pst = cn.prepareStatement(sql);
                //pst.setInt(1, oAreaBE1.getIdarea());
                rs = pst.executeQuery();
                while (rs.next()) {
                    AreaBE oAreaBE = new AreaBE();

                    oAreaBE.setIdarea(rs.getInt("idarea"));
                    oAreaBE.setDenominacion(rs.getString("denominacion"));
                    oAreaBE.setEstado(rs.getBoolean("estado"));
                    listaAreaBE.add(oAreaBE);
                }
            }

            if (oAreaBE1.getIndOpSp() == 3) {
                sql = "select distinct a.idarea,/*d.nombres ||' '|| d.apellidos ||' '|| d.usuario ||' - '||*/a.denominacion AS denominacion ,c.idusuario idusuariojefe from area a\n"
                        + "			inner join cargo b on a.idarea=b.idarea \n"
                        + "			inner join usuariocargo c on c.idcargo=b.idcargo \n"
                        + "			inner join usuario d on c.idusuario=d.idusuario \n"
                        + "			where \n"
                        + "			(a.denominacion ilike '%'||replace(rtrim(ltrim(case when ''='" + oAreaBE1.getDenominacion() + "'  then '' else '" + oAreaBE1.getDenominacion() + "' end, ' '),' '),' ','%')||'%'\n"
                        + "			or\n"
                        + "			to_tsvector(a.denominacion)@@ plainto_tsquery('" + oAreaBE1.getDenominacion() + "'))\n"
                        + "			and bindjefe=true\n"
                        + "			and a.estado=true\n"
                        + "			and b.estado=true\n"
                        + "			and c.estado=true\n"
                        + "			and d.estado=true\n"
                        + "			limit 5";
                pst = cn.prepareStatement(sql);
                //pst.setInt(1, oAreaBE1.getIdarea());
                System.out.println("sql :" + sql);
                rs = pst.executeQuery();
                while (rs.next()) {
                    AreaBE oAreaBE = new AreaBE();

                    oAreaBE.setIdarea(rs.getInt("idarea"));
                    oAreaBE.setDenominacion(rs.getString("denominacion"));
                    oAreaBE.setIdusuariojefe(rs.getInt("idusuariojefe"));
                    listaAreaBE.add(oAreaBE);
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
            oAreaBE1 = null;
        }
        return listaAreaBE;
    }

    public int insertarRegistrosAreaBE(ArrayList<AreaBE> oListaAreaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (AreaBE oAreaBE : oListaAreaBE) {
                cs = cn.prepareCall("{call uspInsertarArea(?,?,?,?,?,?)}");
                cs.setString(1, oAreaBE.getDenominacion());
                cs.setString(2, oAreaBE.getAbreviatura());
                cs.setString(3, oAreaBE.getCodigo());
                cs.setInt(4, oAreaBE.getIdareasuperior());
                cs.setBoolean(5, oAreaBE.isEstado());
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

    public int insertarAreaBE(AreaBE oAreaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarArea(?,?,?,?,?,?)}");
            cs.setString(1, oAreaBE.getDenominacion());
            cs.setString(2, oAreaBE.getAbreviatura());
            cs.setString(3, oAreaBE.getCodigo());
            cs.setInt(4, oAreaBE.getIdareasuperior());
            cs.setBoolean(5, oAreaBE.isEstado());
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

    public int actualizarAreaBE(AreaBE oAreaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarArea(?,?,?,?,?,?)}");
            cs.setInt(1, oAreaBE.getIdarea());
            cs.setString(2, oAreaBE.getDenominacion());
            cs.setString(3, oAreaBE.getAbreviatura());
            cs.setString(4, oAreaBE.getCodigo());
            cs.setInt(5, oAreaBE.getIdareasuperior());
            cs.setBoolean(6, oAreaBE.isEstado());
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

    public int eliminarAreaBE(AreaBE oAreaBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarArea(?)}");
            cs.setInt(1, oAreaBE.getIdarea());
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

    public List listObjectAreaBE(AreaBE oAreaBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oAreaBE.getIndOpSp() == 1) {
                sql = " SELECT idarea,denominacion,estado FROM area WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oAreaBE.getIndOpSp() == 2) {
                sql = " SELECT idarea,denominacion FROM area WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oAreaBE.getIndOpSp() == 3) {
                sql = "select '['||a.idarea||','||c.idusuario||']',a.denominacion  from area a\n"
                        + "                       			inner join cargo b on a.idarea=b.idarea \n"
                        + "                       			inner join usuariocargo c on c.idcargo=b.idcargo \n"
                        + "                       			where \n"
                        + "                       			\n"
                        + "                       			bindjefe=true\n"
                        + "                       			and a.estado=true\n"
                        + "                       			and b.estado=true\n"
                        + "                       			and c.estado=true\n"
                        + "                       ";
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
            oAreaBE = null;
        }
        return list;
    }

    public String getJSON(AreaBE oAreaBE) throws SQLException {
        // List list = new LinkedList();
        String json = "";
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";
        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oAreaBE.getIndOpSp() == 1) {
                sql = "select array_to_json(array_agg(row_to_json(d)))from (\n"
                        + "select idarea,abreviatura,denominacion  from area where estado=true\n"
                        + "order by idarea\n"
                        + ") as d"
                        + "                       ";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    json = rs.getString(1);
                    //list.add(obj);
                }

            }
            if (oAreaBE.getIndOpSp() == 2) {
                sql = "select case when array_to_json(array_agg(row_to_json(d))) is null then '[{ \"error\": true, \"mensaje\":\"No hay usuarios para esta area\"}]'  else array_to_json(array_agg(row_to_json(d))) end json from (\n"
                        + "select a.idusuario,a.usuario,a.nombres||' '||a.apellidos nombre,d.denominacion area,c.denominacion cargo \n"
                        + ", c.bindjefe from usuario a\n"
                        + "inner join usuariocargo  b on a.idusuario=b.idusuario\n"
                        + "inner join cargo c on b.idcargo=c.idcargo\n"
                        + "inner join area d on c.idarea=d.idarea\n"
                        + "where \n"
                        + "a.estado=true\n"
                        + "and b.estado=true \n"
                        + "and c.estado=true \n"
                        + "and d.estado=true \n"
                        + "and d.idarea in (" + oAreaBE.getAreasuperior() + ")\n"
                        + ") as d";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    json = rs.getString(1);
                    //list.add(obj);
                }

            }
            if (oAreaBE.getIndOpSp() == 3) {
                sql = "select array_to_json(array_agg(row_to_json(d))) json from (\n"
                        + "select distinct a.idusuario,a.usuario,a.nombres||' '||a.apellidos nombre from usuario a\n"
                        + "inner join usuariocargo  b on a.idusuario=b.idusuario\n"
                        + "inner join cargo c on b.idcargo=c.idcargo\n"
                        + "inner join area d on c.idarea=d.idarea\n"
                        + "where \n"
                        + "a.estado=true\n"
                        + "and b.estado=true \n"
                        + "and c.estado=true \n"
                        + "and d.estado=true \n"
                        + "and bindjefe=true\n"
                        + "and d.idarea in (" + oAreaBE.getAreasuperior() + ")\n"
                        + ") as d";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    json = rs.getString(1);
                    //list.add(obj);
                }

            }

            if (oAreaBE.getIndOpSp() == 4) {
                sql = "select case when array_to_json(array_agg(row_to_json(d))) is null then '{}' else array_to_json(array_agg(row_to_json(d))) end  json from (\n"
                        + " select b.idtipodocumento, b.denominacion denominacion, max(a.codigo) codigo , '' ultimocodigo from areatipodocumento a \n"
                        + "	right join tipodocumento b on a.idtipodocumento=b.idtipodocumento\n"
                        + "	where \n"
                        + "	a.idusuario=" + oAreaBE.getIdusuariojefe() + "\n"
                        + "	and a.idarea=" + oAreaBE.getIdarea() + "\n"
                        + "	and extract(year from a.fecharegistro)=extract(year from now())\n"
                        + "	GROUP BY b.denominacion,b.idtipodocumento"
                        + ") as d";
                System.out.println("sql: " + sql);
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    json = rs.getString(1);
                    //list.add(obj);
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
            oAreaBE = null;
        }
        return json;
    }

}
