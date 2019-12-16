package mph.tramitedoc.da;


//@autor Sergio Medina


import mph.tramitedoc.be.ArchivomensajeBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
public class ArchivomensajeDA extends BaseDA {
	String cadenaConexion;
	String DriverConnection;
	String user;
	String password;
public ArchivomensajeDA(){
	cadenaConexion = super.getConnectionString();
	DriverConnection = super.getDriverConnection();
	user = super.getUser();
	password = super.getPassword();    
}
 public ArchivomensajeBE listarArchivomensajeBE(ArchivomensajeBE oArchivomensajeBE1) throws SQLException {
	ArchivomensajeBE oArchivomensajeBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	oArchivomensajeBE=new ArchivomensajeBE();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
if(oArchivomensajeBE1.getIndOpSp()==1){

	String sql = " SELECT idarchivomensaje,idmensaje,nombre,url,estado FROM archivomensaje WHERE idarchivomensaje=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oArchivomensajeBE1.getIdarchivomensaje());
rs = pst.executeQuery();
System.out.println("consulta :" + sql);

}	while(rs.next()){
		oArchivomensajeBE.setIdarchivomensaje(rs.getInt("idarchivomensaje"));
		oArchivomensajeBE.setIdmensaje(rs.getInt("idmensaje"));
		oArchivomensajeBE.setNombre(rs.getString("nombre"));
		oArchivomensajeBE.setUrl(rs.getString("url"));
		oArchivomensajeBE.setEstado(rs.getBoolean("estado"));
}

	cn.commit();
	cn.setAutoCommit(true);
}
catch (Exception ex) {
	cn.rollback();
	ex.printStackTrace();
}
finally {
	
	rs.close();
	rs = null;
	cn.close();
	cn = null;

}
return oArchivomensajeBE;
}



public ArrayList<ArchivomensajeBE> listarRegistroArchivomensajeBE(ArchivomensajeBE oArchivomensajeBE1) throws SQLException {
	ArrayList<ArchivomensajeBE> listaArchivomensajeBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	listaArchivomensajeBE=new ArrayList<ArchivomensajeBE>();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
	String sql="";
if (oArchivomensajeBE1.getIndOpSp() == 1) {
	sql = " SELECT idarchivomensaje,idmensaje,nombre,url,estado FROM archivomensaje WHERE estado=true";
pst = cn.prepareStatement(sql);
rs = pst.executeQuery();
}
if (oArchivomensajeBE1.getIndOpSp() == 2) {
	sql = " SELECT idarchivomensaje,idmensaje,nombre,url,estado FROM archivomensaje WHERE idarchivomensaje=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oArchivomensajeBE1.getIdarchivomensaje());
rs = pst.executeQuery();
}

while(rs.next()){
	ArchivomensajeBE oArchivomensajeBE=new ArchivomensajeBE();
		oArchivomensajeBE.setIdarchivomensaje(rs.getInt("idarchivomensaje"));
		oArchivomensajeBE.setIdmensaje(rs.getInt("idmensaje"));
		oArchivomensajeBE.setNombre(rs.getString("nombre"));
		oArchivomensajeBE.setUrl(rs.getString("url"));
		oArchivomensajeBE.setEstado(rs.getBoolean("estado"));
	listaArchivomensajeBE.add(oArchivomensajeBE);}

	cn.commit();
	cn.setAutoCommit(true);
}
catch (Exception ex) {
	cn.rollback();
	ex.printStackTrace();
}finally {
	rs.close();
	rs = null;
	cn.close();
	cn = null;
	oArchivomensajeBE1 = null;
}
return listaArchivomensajeBE;
}


public  int insertarRegistrosArchivomensajeBE(ArrayList<ArchivomensajeBE> oListaArchivomensajeBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

for(ArchivomensajeBE oArchivomensajeBE : oListaArchivomensajeBE){
cs=cn.prepareCall("{call uspInsertarArchivomensaje(?,?,?,?,?)}");
	cs.setInt(1, oArchivomensajeBE.getIdmensaje());
	cs.setString(2, oArchivomensajeBE.getNombre());
	cs.setString(3, oArchivomensajeBE.getUrl());
	cs.setBoolean(4, oArchivomensajeBE.isEstado());
	cs.registerOutParameter(5, java.sql.Types.INTEGER);
	cs.execute();
	resultado = cs.getInt(5);
	cs.close();
	cs=null;
}
	cn.commit();
	cn.setAutoCommit(true);
}
catch (Exception ex) {
	cn.rollback();
	ex.printStackTrace();
}
finally {
	cn.close();
	cn = null;
	
}
return resultado;
}


public  int insertarArchivomensajeBE(ArchivomensajeBE oArchivomensajeBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspInsertarArchivomensaje(?,?,?,?,?)}");
	cs.setInt(1, oArchivomensajeBE.getIdmensaje());
	cs.setString(2, oArchivomensajeBE.getNombre());
	cs.setString(3, oArchivomensajeBE.getUrl());
	cs.setBoolean(4, oArchivomensajeBE.isEstado());
	cs.registerOutParameter(5, java.sql.Types.INTEGER);
	cs.execute();
	resultado = cs.getInt(5);
	cs.close();
	cs=null;
	cn.commit();
	cn.setAutoCommit(true);
}
catch (Exception ex) {
	cn.rollback();
	ex.printStackTrace();
}
finally {
	cn.close();
	cn = null;
	
}
return resultado;
}


public  int actualizarArchivomensajeBE(ArchivomensajeBE oArchivomensajeBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion, user, password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspActualizarArchivomensaje(?,?,?,?,?)}");
	cs.setInt(1, oArchivomensajeBE.getIdarchivomensaje());
	cs.setInt(2, oArchivomensajeBE.getIdmensaje());
	cs.setString(3, oArchivomensajeBE.getNombre());
	cs.setString(4, oArchivomensajeBE.getUrl());
	cs.setBoolean(5, oArchivomensajeBE.isEstado());
	cs.registerOutParameter(5, java.sql.Types.INTEGER);
	cs.executeUpdate();
	resultado = cs.getInt(5);
	cs.close();
	cs=null;
	cn.commit();
	cn.setAutoCommit(true);
}
catch (Exception ex) {
	cn.rollback();
	ex.printStackTrace();
}
finally {
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
