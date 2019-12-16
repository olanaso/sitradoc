package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.DocumentomensajeBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DocumentomensajeDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public DocumentomensajeDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public DocumentomensajeBE listarDocumentomensajeBE(DocumentomensajeBE oDocumentomensajeBE1) throws SQLException {
        DocumentomensajeBE oDocumentomensajeBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oDocumentomensajeBE = new DocumentomensajeBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oDocumentomensajeBE1.getIndOpSp() == 1) {

                String sql = " SELECT iddocumentomensaje,idmensaje,iddocumento,fechacreacion,idusuariocreacion,estado FROM documentomensaje WHERE iddocumentomensaje=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oDocumentomensajeBE1.getIddocumentomensaje());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oDocumentomensajeBE.setIddocumentomensaje(rs.getInt("iddocumentomensaje"));
                oDocumentomensajeBE.setIdmensaje(rs.getInt("idmensaje"));
                oDocumentomensajeBE.setIddocumento(rs.getInt("iddocumento"));
                oDocumentomensajeBE.setFechacreacion(rs.getDate("fechacreacion"));
                oDocumentomensajeBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
                oDocumentomensajeBE.setEstado(rs.getBoolean("estado"));
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
        return oDocumentomensajeBE;
    }

    public ArrayList<DocumentomensajeBE> listarRegistroDocumentomensajeBE(DocumentomensajeBE oDocumentomensajeBE1) throws SQLException {
        ArrayList<DocumentomensajeBE> listaDocumentomensajeBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaDocumentomensajeBE = new ArrayList<DocumentomensajeBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oDocumentomensajeBE1.getIndOpSp() == 1) {
                sql = " SELECT iddocumentomensaje,idmensaje,iddocumento,fechacreacion,idusuariocreacion,estado FROM documentomensaje WHERE estado=true";
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
            }
            if (oDocumentomensajeBE1.getIndOpSp() == 2) {
                sql = " SELECT iddocumentomensaje,idmensaje,iddocumento,fechacreacion,idusuariocreacion,estado FROM documentomensaje WHERE iddocumentomensaje=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oDocumentomensajeBE1.getIddocumentomensaje());
                rs = pst.executeQuery();
            }

            while (rs.next()) {
                DocumentomensajeBE oDocumentomensajeBE = new DocumentomensajeBE();
                oDocumentomensajeBE.setIddocumentomensaje(rs.getInt("iddocumentomensaje"));
                oDocumentomensajeBE.setIdmensaje(rs.getInt("idmensaje"));
                oDocumentomensajeBE.setIddocumento(rs.getInt("iddocumento"));
                oDocumentomensajeBE.setFechacreacion(rs.getDate("fechacreacion"));
                oDocumentomensajeBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
                oDocumentomensajeBE.setEstado(rs.getBoolean("estado"));
                listaDocumentomensajeBE.add(oDocumentomensajeBE);
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
            oDocumentomensajeBE1 = null;
        }
        return listaDocumentomensajeBE;
    }

    public int insertarRegistrosDocumentomensajeBE(ArrayList<DocumentomensajeBE> oListaDocumentomensajeBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (DocumentomensajeBE oDocumentomensajeBE : oListaDocumentomensajeBE) {
                cs = cn.prepareCall("{call uspInsertarDocumentomensaje(?,?,?,?)}");
                cs.setInt(1, oDocumentomensajeBE.getIdmensaje());
                cs.setInt(2, oDocumentomensajeBE.getIddocumento());
                cs.setInt(3, oDocumentomensajeBE.getIdusuariocreacion());
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

    public int insertarDocumentomensajeBE(DocumentomensajeBE oDocumentomensajeBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarDocumentomensaje(?,?,?,?,?,?)}");
            cs.setInt(1, oDocumentomensajeBE.getIdmensaje());
            cs.setInt(2, oDocumentomensajeBE.getIddocumento());
            Date fechacreacion = new Date(oDocumentomensajeBE.getFechacreacion().getTime());
            cs.setDate(3, fechacreacion);
            cs.setInt(4, oDocumentomensajeBE.getIdusuariocreacion());
            cs.setBoolean(5, oDocumentomensajeBE.isEstado());
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

    public int actualizarDocumentomensajeBE(DocumentomensajeBE oDocumentomensajeBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarDocumentomensaje(?,?,?,?,?,?)}");
            cs.setInt(1, oDocumentomensajeBE.getIddocumentomensaje());
            cs.setInt(2, oDocumentomensajeBE.getIdmensaje());
            cs.setInt(3, oDocumentomensajeBE.getIddocumento());
            Date fechacreacion = new Date(oDocumentomensajeBE.getFechacreacion().getTime());
            cs.setDate(4, fechacreacion);
            cs.setInt(5, oDocumentomensajeBE.getIdusuariocreacion());
            cs.setBoolean(6, oDocumentomensajeBE.isEstado());
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
}
