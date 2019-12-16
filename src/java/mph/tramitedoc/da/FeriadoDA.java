package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.FeriadoBE;
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

public class FeriadoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public FeriadoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public FeriadoBE listarFeriadoBE(FeriadoBE oFeriadoBE1) throws SQLException {
        FeriadoBE oFeriadoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oFeriadoBE = new FeriadoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oFeriadoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idferiado,idanio,fecha,motivo,estado FROM feriado WHERE idferiado=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oFeriadoBE1.getIdferiado());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oFeriadoBE.setIdferiado(rs.getInt("idferiado"));
                oFeriadoBE.setIdanio(rs.getInt("idanio"));
                oFeriadoBE.setFecha(rs.getDate("fecha"));
                oFeriadoBE.setMotivo(rs.getString("motivo"));
                oFeriadoBE.setEstado(rs.getBoolean("estado"));
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
        return oFeriadoBE;
    }

    public ArrayList<FeriadoBE> listarRegistroFeriadoBE(FeriadoBE oFeriadoBE1) throws SQLException {
        ArrayList<FeriadoBE> listaFeriadoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaFeriadoBE = new ArrayList<FeriadoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oFeriadoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idferiado||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idferiado||')\" class=\"fa fa-trash-o\"></i>',idferiado,idanio,fecha,motivo,estado FROM feriado WHERE estado=true and idanio=" + oFeriadoBE1.getIdanio() + "";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    FeriadoBE oFeriadoBE = new FeriadoBE();
                    oFeriadoBE.setEdit(rs.getString(1));
                    oFeriadoBE.setDel(rs.getString(2));
                    oFeriadoBE.setIdferiado(rs.getInt("idferiado"));
                    oFeriadoBE.setIdanio(rs.getInt("idanio"));
                    oFeriadoBE.setFecha(rs.getDate("fecha"));
                    oFeriadoBE.setMotivo(rs.getString("motivo"));
                    oFeriadoBE.setEstado(rs.getBoolean("estado"));
                    listaFeriadoBE.add(oFeriadoBE);
                }
            }
            if (oFeriadoBE1.getIndOpSp() == 2) {
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oFeriadoBE1.getIdferiado());
                rs = pst.executeQuery();

                while (rs.next()) {
                    FeriadoBE oFeriadoBE = new FeriadoBE();
                    oFeriadoBE.setEdit(rs.getString(1));
                    oFeriadoBE.setDel(rs.getString(2));
                    oFeriadoBE.setIdferiado(rs.getInt("idferiado"));
                    oFeriadoBE.setIdanio(rs.getInt("idanio"));
                    oFeriadoBE.setFecha(rs.getDate("fecha"));
                    oFeriadoBE.setMotivo(rs.getString("motivo"));
                    oFeriadoBE.setEstado(rs.getBoolean("estado"));
                    listaFeriadoBE.add(oFeriadoBE);
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
            oFeriadoBE1 = null;
        }
        return listaFeriadoBE;
    }

    public int insertarRegistrosFeriadoBE(ArrayList<FeriadoBE> oListaFeriadoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (FeriadoBE oFeriadoBE : oListaFeriadoBE) {
                cs = cn.prepareCall("{call uspInsertarFeriado(?,?,?,?,?)}");
                cs.setInt(1, oFeriadoBE.getIdanio());
                Date fecha = new Date(oFeriadoBE.getFecha().getTime());
                cs.setDate(2, fecha);
                cs.setString(3, oFeriadoBE.getMotivo());
                cs.setBoolean(4, oFeriadoBE.isEstado());
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

    public int insertarFeriadoBE(FeriadoBE oFeriadoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarFeriado(?,?,?,?,?)}");
            cs.setInt(1, oFeriadoBE.getIdanio());
            Date fecha = new Date(oFeriadoBE.getFecha().getTime());
            cs.setDate(2, fecha);
            cs.setString(3, oFeriadoBE.getMotivo());
            cs.setBoolean(4, oFeriadoBE.isEstado());
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

    public int actualizarFeriadoBE(FeriadoBE oFeriadoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarFeriado(?,?,?,?,?)}");
            cs.setInt(1, oFeriadoBE.getIdferiado());
            cs.setInt(2, oFeriadoBE.getIdanio());
            Date fecha = new Date(oFeriadoBE.getFecha().getTime());
            cs.setDate(3, fecha);
            cs.setString(4, oFeriadoBE.getMotivo());
            cs.setBoolean(5, oFeriadoBE.isEstado());
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

    public int eliminarFeriadoBE(FeriadoBE oFeriadoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarFeriado(?)}");
            cs.setInt(1, oFeriadoBE.getIdferiado());
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

    public List listObjectFeriadoBE(FeriadoBE oFeriadoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oFeriadoBE.getIndOpSp() == 1) {
                sql = " SELECT idferiado,idanio,fecha,motivo,estado FROM feriado WHERE idferiado=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oFeriadoBE.getIndOpSp() == 2) {
                sql = " SELECT idanio,denominacion FROM anio WHERE estado=true";
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
            oFeriadoBE = null;
        }
        return list;
    }

}
