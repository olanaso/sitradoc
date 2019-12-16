package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.ExpedienterequisitoBE;
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

public class ExpedienterequisitoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public ExpedienterequisitoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public ExpedienterequisitoBE listarExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE1) throws SQLException {
        ExpedienterequisitoBE oExpedienterequisitoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oExpedienterequisitoBE = new ExpedienterequisitoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oExpedienterequisitoBE1.getIndOpSp() == 1) {

                String sql = " SELECT inexpedienterequisito,idrequisitos,idexpediente,fecha,estado FROM expedienterequisito WHERE inexpedienterequisito=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oExpedienterequisitoBE1.getIdexpedienterequisito());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oExpedienterequisitoBE.setIdexpedienterequisito(rs.getInt("inexpedienterequisito"));
                oExpedienterequisitoBE.setIdrequisitos(rs.getInt("idrequisitos"));
                oExpedienterequisitoBE.setIdexpediente(rs.getInt("idexpediente"));
                oExpedienterequisitoBE.setFecha(rs.getDate("fecha"));
                oExpedienterequisitoBE.setEstado(rs.getBoolean("estado"));
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
        return oExpedienterequisitoBE;
    }

    public ArrayList<ExpedienterequisitoBE> listarRegistroExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE1) throws SQLException {
        ArrayList<ExpedienterequisitoBE> listaExpedienterequisitoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaExpedienterequisitoBE = new ArrayList<ExpedienterequisitoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oExpedienterequisitoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idexpedienterequisito||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idexpedienterequisito||')\" class=\"fa fa-trash-o\"></i>',inexpedienterequisito,idrequisitos,idexpediente,fecha,estado FROM expedienterequisito WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oExpedienterequisitoBE1.getIndOpSp() == 2) {
                sql = " SELECT inexpedienterequisito,idrequisitos,idexpediente,fecha,estado FROM expedienterequisito WHERE inexpedienterequisito=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oExpedienterequisitoBE1.getIdexpedienterequisito());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                ExpedienterequisitoBE oExpedienterequisitoBE = new ExpedienterequisitoBE();
                oExpedienterequisitoBE.setEdit(rs.getString(1));
                oExpedienterequisitoBE.setDel(rs.getString(2));
                oExpedienterequisitoBE.setIdexpedienterequisito(rs.getInt("inexpedienterequisito"));
                oExpedienterequisitoBE.setIdrequisitos(rs.getInt("idrequisitos"));
                oExpedienterequisitoBE.setIdexpediente(rs.getInt("idexpediente"));
                oExpedienterequisitoBE.setFecha(rs.getDate("fecha"));
                oExpedienterequisitoBE.setEstado(rs.getBoolean("estado"));
                listaExpedienterequisitoBE.add(oExpedienterequisitoBE);
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
            oExpedienterequisitoBE1 = null;
        }
        return listaExpedienterequisitoBE;
    }

    public int insertarRegistrosExpedienterequisitoBE(ArrayList<ExpedienterequisitoBE> oListaExpedienterequisitoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ExpedienterequisitoBE oExpedienterequisitoBE : oListaExpedienterequisitoBE) {
                cs = cn.prepareCall("{call uspInsertarExpedienterequisito(?,?,?,?,?)}");
                cs.setInt(1, oExpedienterequisitoBE.getIdrequisitos());
                cs.setInt(2, oExpedienterequisitoBE.getIdexpediente());
                Date fecha = new Date(oExpedienterequisitoBE.getFecha().getTime());
                cs.setDate(3, fecha);
                cs.setBoolean(4, oExpedienterequisitoBE.isEstado());
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

    public int insertarExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarExpedienterequisito(?,?,?,?,?)}");
            cs.setInt(1, oExpedienterequisitoBE.getIdrequisitos());
            cs.setInt(2, oExpedienterequisitoBE.getIdexpediente());
            Date fecha = new Date(oExpedienterequisitoBE.getFecha().getTime());
            cs.setDate(3, fecha);
            cs.setBoolean(4, oExpedienterequisitoBE.isEstado());
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

    public int actualizarExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarExpedienterequisito(?,?,?,?,?)}");
            cs.setInt(1, oExpedienterequisitoBE.getIdexpedienterequisito());
            cs.setInt(2, oExpedienterequisitoBE.getIdrequisitos());
            cs.setInt(3, oExpedienterequisitoBE.getIdexpediente());
            Date fecha = new Date(oExpedienterequisitoBE.getFecha().getTime());
            cs.setDate(4, fecha);
            cs.setBoolean(5, oExpedienterequisitoBE.isEstado());
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

    public int actualizarRegistrosExpedienterequisitoBE(ArrayList<ExpedienterequisitoBE> oListaExpedienterequisitoBE, int idexpediente) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oListaExpedienterequisitoBE.size() == 0) {
                cs = cn.prepareCall("{call uspeliminarrequisitosexpediente(?)}");
                cs.setInt(1, idexpediente);
                cs.execute();
                cs.close();
                cs = null;
            } else {

                cs = cn.prepareCall("{call uspeliminarrequisitosexpediente(?)}");
                cs.setInt(1, idexpediente);
                cs.execute();
                cs.close();
                cs = null;
                
                for (ExpedienterequisitoBE oExpedienterequisitoBE : oListaExpedienterequisitoBE) {
                    cs = cn.prepareCall("{call uspActualizarExpedienterequisito(?,?,?)}");
                    cs.setInt(1, oExpedienterequisitoBE.getIdrequisitos());
                    cs.setInt(2, oExpedienterequisitoBE.getIdexpediente());
                    cs.registerOutParameter(3, java.sql.Types.INTEGER);
                    cs.execute();
                    resultado = cs.getInt(3);
                    cs.close();
                    cs = null;
                }
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

    public int eliminarExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarExpedienterequisito(?)}");
            cs.setInt(1, oExpedienterequisitoBE.getIdexpedienterequisito());
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

    public List listObjectExpedienterequisitoBE(ExpedienterequisitoBE oExpedienterequisitoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oExpedienterequisitoBE.getIndOpSp() == 1) {
                sql = " SELECT inexpedienterequisito,idrequisitos,idexpediente,fecha,estado FROM expedienterequisito WHERE inexpedienterequisito=? and estado=true";
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
            oExpedienterequisitoBE = null;
        }
        return list;
    }

}
