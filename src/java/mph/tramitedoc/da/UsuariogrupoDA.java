package mph.tramitedoc.da;


//@autor Sergio Medina


import mph.tramitedoc.be.UsuariogrupoBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
public class UsuariogrupoDA extends BaseDA {
	String cadenaConexion;
	String DriverConnection;
	String user;
	String password;
public UsuariogrupoDA(){
	cadenaConexion = super.getConnectionString();
	DriverConnection = super.getDriverConnection();
	user = super.getUser();
	password = super.getPassword();    
}
 public UsuariogrupoBE listarUsuariogrupoBE(UsuariogrupoBE oUsuariogrupoBE1) throws SQLException {
	UsuariogrupoBE oUsuariogrupoBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	oUsuariogrupoBE=new UsuariogrupoBE();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
if(oUsuariogrupoBE1.getIndOpSp()==1){

	String sql = " SELECT idusuariogrupo,denominacion,idusuariocreacion,estado FROM usuariogrupo WHERE idusuariogrupo=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oUsuariogrupoBE1.getIdusuariogrupo());
rs = pst.executeQuery();
System.out.println("consulta :" + sql);

}	while(rs.next()){
		oUsuariogrupoBE.setIdusuariogrupo(rs.getInt("idusuariogrupo"));
		oUsuariogrupoBE.setDenominacion(rs.getInt("denominacion"));
		oUsuariogrupoBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
		oUsuariogrupoBE.setEstado(rs.getBoolean("estado"));
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
return oUsuariogrupoBE;
}



public ArrayList<UsuariogrupoBE> listarRegistroUsuariogrupoBE(UsuariogrupoBE oUsuariogrupoBE1) throws SQLException {
	ArrayList<UsuariogrupoBE> listaUsuariogrupoBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	listaUsuariogrupoBE=new ArrayList<UsuariogrupoBE>();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
	String sql="";
if (oUsuariogrupoBE1.getIndOpSp() == 1) {
	sql = " SELECT idusuariogrupo,denominacion,idusuariocreacion,estado FROM usuariogrupo WHERE estado=true";
pst = cn.prepareStatement(sql);
rs = pst.executeQuery();
}
if (oUsuariogrupoBE1.getIndOpSp() == 2) {
	sql = " SELECT idusuariogrupo,denominacion,idusuariocreacion,estado FROM usuariogrupo WHERE idusuariogrupo=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oUsuariogrupoBE1.getIdusuariogrupo());
rs = pst.executeQuery();
}

while(rs.next()){
	UsuariogrupoBE oUsuariogrupoBE=new UsuariogrupoBE();
		oUsuariogrupoBE.setIdusuariogrupo(rs.getInt("idusuariogrupo"));
		oUsuariogrupoBE.setDenominacion(rs.getInt("denominacion"));
		oUsuariogrupoBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
		oUsuariogrupoBE.setEstado(rs.getBoolean("estado"));
	listaUsuariogrupoBE.add(oUsuariogrupoBE);}

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
	oUsuariogrupoBE1 = null;
}
return listaUsuariogrupoBE;
}


public  int insertarRegistrosUsuariogrupoBE(ArrayList<UsuariogrupoBE> oListaUsuariogrupoBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

for(UsuariogrupoBE oUsuariogrupoBE : oListaUsuariogrupoBE){
cs=cn.prepareCall("{call uspInsertarUsuariogrupo(?,?,?,?)}");
	cs.setInt(1, oUsuariogrupoBE.getDenominacion());
	cs.setInt(2, oUsuariogrupoBE.getIdusuariocreacion());
	cs.setBoolean(3, oUsuariogrupoBE.isEstado());
	cs.registerOutParameter(4, java.sql.Types.INTEGER);
	cs.execute();
	resultado = cs.getInt(4);
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


public  int insertarUsuariogrupoBE(UsuariogrupoBE oUsuariogrupoBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspInsertarUsuariogrupo(?,?,?,?)}");
	cs.setInt(1, oUsuariogrupoBE.getDenominacion());
	cs.setInt(2, oUsuariogrupoBE.getIdusuariocreacion());
	cs.setBoolean(3, oUsuariogrupoBE.isEstado());
	cs.registerOutParameter(4, java.sql.Types.INTEGER);
	cs.execute();
	resultado = cs.getInt(4);
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


public  int actualizarUsuariogrupoBE(UsuariogrupoBE oUsuariogrupoBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion, user, password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspActualizarUsuariogrupo(?,?,?,?)}");
	cs.setInt(1, oUsuariogrupoBE.getIdusuariogrupo());
	cs.setInt(2, oUsuariogrupoBE.getDenominacion());
	cs.setInt(3, oUsuariogrupoBE.getIdusuariocreacion());
	cs.setBoolean(4, oUsuariogrupoBE.isEstado());
	cs.registerOutParameter(4, java.sql.Types.INTEGER);
	cs.executeUpdate();
	resultado = cs.getInt(4);
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
