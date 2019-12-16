package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.RequisitosBE;
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

public class RequisitosDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public RequisitosDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public RequisitosBE listarRequisitosBE(RequisitosBE oRequisitosBE1) throws SQLException {
        RequisitosBE oRequisitosBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oRequisitosBE = new RequisitosBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oRequisitosBE1.getIndOpSp() == 1) {

                String sql = " SELECT idrequisitos,idprocedimiento,denominacion,estado FROM requisitos WHERE idrequisitos=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oRequisitosBE1.getIdrequisitos());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oRequisitosBE.setIdrequisitos(rs.getInt("idrequisitos"));
                oRequisitosBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                oRequisitosBE.setDenominacion(rs.getString("denominacion"));
                oRequisitosBE.setEstado(rs.getBoolean("estado"));
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
        return oRequisitosBE;
    }

    public ArrayList<RequisitosBE> listarRegistroRequisitosBE(RequisitosBE oRequisitosBE1) throws SQLException {
        ArrayList<RequisitosBE> listaRequisitosBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaRequisitosBE = new ArrayList<RequisitosBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oRequisitosBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idrequisitos||')\" class=\"fa fa-pencil-square-o\"></i>',"
                        + "'<i style=\"cursor:pointer;\" onclick=\"del('||idrequisitos||')\" class=\"fa fa-trash-o\"></i>',r.idrequisitos,"
                        + "r.idprocedimiento,p.denominacion as procdenominacion,r.denominacion,r.estado FROM requisitos r inner join "
                        + "procedimiento p on r.idprocedimiento=p.idprocedimiento where r.estado=true and r.idprocedimiento="
                        + oRequisitosBE1.getIdprocedimiento() + "order by r.idrequisitos asc";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    RequisitosBE oRequisitosBE = new RequisitosBE();
                    oRequisitosBE.setEdit(rs.getString(1));
                    oRequisitosBE.setDel(rs.getString(2));
                    oRequisitosBE.setIdrequisitos(rs.getInt("idrequisitos"));
                    oRequisitosBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oRequisitosBE.setProcdenominacion(rs.getString("procdenominacion"));
                    oRequisitosBE.setDenominacion(rs.getString("denominacion"));
                    oRequisitosBE.setEstado(rs.getBoolean("estado"));
                    listaRequisitosBE.add(oRequisitosBE);
                }
            }

            if (oRequisitosBE1.getIndOpSp() == 2) {
                sql = " SELECT idrequisitos,idprocedimiento,denominacion,estado FROM requisitos WHERE idrequisitos=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oRequisitosBE1.getIdrequisitos());
                rs = pst.executeQuery();

                while (rs.next()) {
                    RequisitosBE oRequisitosBE = new RequisitosBE();
                    oRequisitosBE.setEdit(rs.getString(1));
                    oRequisitosBE.setDel(rs.getString(2));
                    oRequisitosBE.setIdrequisitos(rs.getInt("idrequisitos"));
                    oRequisitosBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oRequisitosBE.setDenominacion(rs.getString("denominacion"));
                    oRequisitosBE.setEstado(rs.getBoolean("estado"));
                    listaRequisitosBE.add(oRequisitosBE);
                }
            }

            if (oRequisitosBE1.getIndOpSp() == 3) {
                sql = " select idrequisitos,denominacion from requisitos where idprocedimiento=" + oRequisitosBE1.getIdprocedimiento() + " and estado=true";
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oRequisitosBE1.getIdrequisitos());
                rs = pst.executeQuery();

                while (rs.next()) {
                    RequisitosBE oRequisitosBE = new RequisitosBE();
                    oRequisitosBE.setIdrequisitos(rs.getInt("idrequisitos"));
                    oRequisitosBE.setDenominacion(rs.getString("denominacion"));
                    listaRequisitosBE.add(oRequisitosBE);
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
            oRequisitosBE1 = null;
        }
        return listaRequisitosBE;
    }

    public int insertarRegistrosRequisitosBE(ArrayList<RequisitosBE> oListaRequisitosBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (RequisitosBE oRequisitosBE : oListaRequisitosBE) {
                cs = cn.prepareCall("{call uspInsertarRequisitos(?,?,?,?)}");
                cs.setInt(1, oRequisitosBE.getIdprocedimiento());
                cs.setString(2, oRequisitosBE.getDenominacion());
                cs.setBoolean(3, oRequisitosBE.isEstado());
                cs.registerOutParameter(4, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(4);
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

    public int insertarRequisitosBE(RequisitosBE oRequisitosBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarRequisitos(?,?,?,?)}");
            cs.setInt(1, oRequisitosBE.getIdprocedimiento());
            cs.setString(2, oRequisitosBE.getDenominacion());
            cs.setBoolean(3, oRequisitosBE.isEstado());
            cs.registerOutParameter(4, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(4);
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

    public int actualizarRequisitosBE(RequisitosBE oRequisitosBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarRequisitos(?,?,?,?)}");
            cs.setInt(1, oRequisitosBE.getIdrequisitos());
            cs.setInt(2, oRequisitosBE.getIdprocedimiento());
            cs.setString(3, oRequisitosBE.getDenominacion());
            cs.setBoolean(4, oRequisitosBE.isEstado());
            cs.registerOutParameter(4, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(4);
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

    public int eliminarRequisitosBE(RequisitosBE oRequisitosBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarRequisitos(?)}");
            cs.setInt(1, oRequisitosBE.getIdrequisitos());
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

    public List listObjectRequisitosBE(RequisitosBE oRequisitosBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oRequisitosBE.getIndOpSp() == 1) {
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

            if (oRequisitosBE.getIndOpSp() == 2) {
                sql = "SELECT idprocedimiento,denominacion FROM procedimiento WHERE estado=true AND idarea="
                        + oRequisitosBE.getIdprocedimiento();
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
            oRequisitosBE = null;
        }
        return list;
    }

}
