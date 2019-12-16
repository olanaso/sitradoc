package mph.tramitedoc.da;


//@autor Sergio Medina


import mph.tramitedoc.be.AreagrupoBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
public class AreagrupoDA extends BaseDA {
	String cadenaConexion;
	String DriverConnection;
	String user;
	String password;
public AreagrupoDA(){
	cadenaConexion = super.getConnectionString();
	DriverConnection = super.getDriverConnection();
	user = super.getUser();
	password = super.getPassword();    
}
 public AreagrupoBE listarAreagrupoBE(AreagrupoBE oAreagrupoBE1) throws SQLException {
	AreagrupoBE oAreagrupoBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	oAreagrupoBE=new AreagrupoBE();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
if(oAreagrupoBE1.getIndOpSp()==1){

	String sql = " SELECT idareagrupo,denominacion,idusuariocreacion,estado FROM areagrupo WHERE idareagrupo=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oAreagrupoBE1.getIdareagrupo());
rs = pst.executeQuery();
System.out.println("consulta :" + sql);

}	while(rs.next()){
		oAreagrupoBE.setIdareagrupo(rs.getInt("idareagrupo"));
		oAreagrupoBE.setDenominacion(rs.getInt("denominacion"));
		oAreagrupoBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
		oAreagrupoBE.setEstado(rs.getBoolean("estado"));
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
return oAreagrupoBE;
}



public ArrayList<AreagrupoBE> listarRegistroAreagrupoBE(AreagrupoBE oAreagrupoBE1) throws SQLException {
	ArrayList<AreagrupoBE> listaAreagrupoBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	listaAreagrupoBE=new ArrayList<AreagrupoBE>();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
	String sql="";
if (oAreagrupoBE1.getIndOpSp() == 1) {
	sql = " SELECT idareagrupo,denominacion,idusuariocreacion,estado FROM areagrupo WHERE estado=true";
pst = cn.prepareStatement(sql);
rs = pst.executeQuery();
}
if (oAreagrupoBE1.getIndOpSp() == 2) {
	sql = " SELECT idareagrupo,denominacion,idusuariocreacion,estado FROM areagrupo WHERE idareagrupo=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oAreagrupoBE1.getIdareagrupo());
rs = pst.executeQuery();
}

while(rs.next()){
	AreagrupoBE oAreagrupoBE=new AreagrupoBE();
		oAreagrupoBE.setIdareagrupo(rs.getInt("idareagrupo"));
		oAreagrupoBE.setDenominacion(rs.getInt("denominacion"));
		oAreagrupoBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
		oAreagrupoBE.setEstado(rs.getBoolean("estado"));
	listaAreagrupoBE.add(oAreagrupoBE);}

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
	oAreagrupoBE1 = null;
}
return listaAreagrupoBE;
}


public  int insertarRegistrosAreagrupoBE(ArrayList<AreagrupoBE> oListaAreagrupoBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

for(AreagrupoBE oAreagrupoBE : oListaAreagrupoBE){
cs=cn.prepareCall("{call uspInsertarAreagrupo(?,?,?,?)}");
	cs.setInt(1, oAreagrupoBE.getDenominacion());
	cs.setInt(2, oAreagrupoBE.getIdusuariocreacion());
	cs.setBoolean(3, oAreagrupoBE.isEstado());
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


public  int insertarAreagrupoBE(AreagrupoBE oAreagrupoBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspInsertarAreagrupo(?,?,?,?)}");
	cs.setInt(1, oAreagrupoBE.getDenominacion());
	cs.setInt(2, oAreagrupoBE.getIdusuariocreacion());
	cs.setBoolean(3, oAreagrupoBE.isEstado());
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


public  int actualizarAreagrupoBE(AreagrupoBE oAreagrupoBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion, user, password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspActualizarAreagrupo(?,?,?,?)}");
	cs.setInt(1, oAreagrupoBE.getIdareagrupo());
	cs.setInt(2, oAreagrupoBE.getDenominacion());
	cs.setInt(3, oAreagrupoBE.getIdusuariocreacion());
	cs.setBoolean(4, oAreagrupoBE.isEstado());
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
