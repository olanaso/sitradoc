package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.ArchivoBE;
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

public class ArchivoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public ArchivoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public ArchivoBE listarArchivoBE(ArchivoBE oArchivoBE1) throws SQLException {
        ArchivoBE oArchivoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oArchivoBE = new ArchivoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oArchivoBE1.getIndOpSp() == 1) {

                String sql = " SELECT idarchivo,idflujo,denominacion,ruta,estado FROM archivo WHERE idarchivo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oArchivoBE1.getIdarchivo());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oArchivoBE.setIdarchivo(rs.getInt("idarchivo"));
                oArchivoBE.setIdflujo(rs.getInt("idflujo"));
                oArchivoBE.setDenominacion(rs.getString("denominacion"));
                oArchivoBE.setRuta(rs.getString("ruta"));
                oArchivoBE.setEstado(rs.getBoolean("estado"));
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
        return oArchivoBE;
    }

    public ArrayList<ArchivoBE> listarRegistroArchivoBE(ArchivoBE oArchivoBE1) throws SQLException {
        ArrayList<ArchivoBE> listaArchivoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaArchivoBE = new ArrayList<ArchivoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oArchivoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idarchivo||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idarchivo||')\" class=\"fa fa-trash-o\"></i>',idarchivo,idflujo,denominacion,ruta,estado FROM archivo WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oArchivoBE1.getIndOpSp() == 2) {
                sql = " SELECT idarchivo,idflujo,denominacion,ruta,estado FROM archivo WHERE idarchivo=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oArchivoBE1.getIdarchivo());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                ArchivoBE oArchivoBE = new ArchivoBE();
                oArchivoBE.setEdit(rs.getString(1));
                oArchivoBE.setDel(rs.getString(2));
                oArchivoBE.setIdarchivo(rs.getInt("idarchivo"));
                oArchivoBE.setIdflujo(rs.getInt("idflujo"));
                oArchivoBE.setDenominacion(rs.getString("denominacion"));
                oArchivoBE.setRuta(rs.getString("ruta"));
                oArchivoBE.setEstado(rs.getBoolean("estado"));
                listaArchivoBE.add(oArchivoBE);
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
            oArchivoBE1 = null;
        }
        return listaArchivoBE;
    }

    public int insertarRegistrosArchivoBE(ArrayList<ArchivoBE> oListaArchivoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ArchivoBE oArchivoBE : oListaArchivoBE) {
                cs = cn.prepareCall("{call uspInsertarArchivo(?,?,?,?,?,?)}");
                cs.setInt(1, oArchivoBE.getIdflujo());
                cs.setString(2, oArchivoBE.getDenominacion());
                cs.setString(3, oArchivoBE.getRuta());
                cs.setBoolean(4, oArchivoBE.isEstado());
                cs.setInt(5, oArchivoBE.getIdenvio());
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

    public int insertarArchivoBE(ArchivoBE oArchivoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarArchivo(?,?,?,?,?)}");
            cs.setInt(1, oArchivoBE.getIdflujo());
            cs.setString(2, oArchivoBE.getDenominacion());
            cs.setString(3, oArchivoBE.getRuta());
            cs.setBoolean(4, oArchivoBE.isEstado());
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

    public int actualizarArchivoBE(ArchivoBE oArchivoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarArchivo(?,?,?,?,?)}");
            cs.setInt(1, oArchivoBE.getIdarchivo());
            cs.setInt(2, oArchivoBE.getIdflujo());
            cs.setString(3, oArchivoBE.getDenominacion());
            cs.setString(4, oArchivoBE.getRuta());
            cs.setBoolean(5, oArchivoBE.isEstado());
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

    public int eliminarArchivoBE(ArchivoBE oArchivoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarArchivo(?)}");
            cs.setInt(1, oArchivoBE.getIdarchivo());
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

    public List listObjectArchivoBE(ArchivoBE oArchivoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oArchivoBE.getIndOpSp() == 1) {
                sql = " SELECT idarchivo,idflujo,denominacion,ruta,estado FROM archivo WHERE idarchivo=? and estado=true";
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
            oArchivoBE = null;
        }
        return list;
    }

}
