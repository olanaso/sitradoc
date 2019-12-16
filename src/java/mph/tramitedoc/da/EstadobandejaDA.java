package mph.tramitedoc.da;


//@autor Sergio Medina


import mph.tramitedoc.be.EstadobandejaBE;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
public class EstadobandejaDA extends BaseDA {
	String cadenaConexion;
	String DriverConnection;
	String user;
	String password;
public EstadobandejaDA(){
	cadenaConexion = super.getConnectionString();
	DriverConnection = super.getDriverConnection();
	user = super.getUser();
	password = super.getPassword();    
}
 public EstadobandejaBE listarEstadobandejaBE(EstadobandejaBE oEstadobandejaBE1) throws SQLException {
	EstadobandejaBE oEstadobandejaBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	oEstadobandejaBE=new EstadobandejaBE();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
if(oEstadobandejaBE1.getIndOpSp()==1){

	String sql = " SELECT idestadobandeja,idusuario,icono,denominacion,estado,orden,bindfinal FROM estadobandeja WHERE idestadobandeja=? and bindfinal=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oEstadobandejaBE1.getIdestadobandeja());
rs = pst.executeQuery();
System.out.println("consulta :" + sql);

}	while(rs.next()){
		oEstadobandejaBE.setIdestadobandeja(rs.getInt("idestadobandeja"));
		oEstadobandejaBE.setIdusuario(rs.getInt("idusuario"));
		oEstadobandejaBE.setIcono(rs.getString("icono"));
		oEstadobandejaBE.setDenominacion(rs.getString("denominacion"));
		oEstadobandejaBE.setEstado(rs.getBoolean("estado"));
		oEstadobandejaBE.setOrden(rs.getInt("orden"));
		oEstadobandejaBE.setBindfinal(rs.getBoolean("bindfinal"));
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
return oEstadobandejaBE;
}



public ArrayList<EstadobandejaBE> listarRegistroEstadobandejaBE(EstadobandejaBE oEstadobandejaBE1) throws SQLException {
	ArrayList<EstadobandejaBE> listaEstadobandejaBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	listaEstadobandejaBE=new ArrayList<EstadobandejaBE>();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
	String sql="";
if (oEstadobandejaBE1.getIndOpSp() == 1) {
	sql = " SELECT idestadobandeja,idusuario,icono,denominacion,estado,orden,bindfinal FROM estadobandeja WHERE bindfinal=true";
pst = cn.prepareStatement(sql);
rs = pst.executeQuery();
}
if (oEstadobandejaBE1.getIndOpSp() == 2) {
	sql = " SELECT idestadobandeja,idusuario,icono,denominacion,estado,orden,bindfinal FROM estadobandeja WHERE idestadobandeja=? and bindfinal=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oEstadobandejaBE1.getIdestadobandeja());
rs = pst.executeQuery();
}

while(rs.next()){
	EstadobandejaBE oEstadobandejaBE=new EstadobandejaBE();
		oEstadobandejaBE.setIdestadobandeja(rs.getInt("idestadobandeja"));
		oEstadobandejaBE.setIdusuario(rs.getInt("idusuario"));
		oEstadobandejaBE.setIcono(rs.getString("icono"));
		oEstadobandejaBE.setDenominacion(rs.getString("denominacion"));
		oEstadobandejaBE.setEstado(rs.getBoolean("estado"));
		oEstadobandejaBE.setOrden(rs.getInt("orden"));
		oEstadobandejaBE.setBindfinal(rs.getBoolean("bindfinal"));
	listaEstadobandejaBE.add(oEstadobandejaBE);}

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
	oEstadobandejaBE1 = null;
}
return listaEstadobandejaBE;
}


public  int insertarRegistrosEstadobandejaBE(ArrayList<EstadobandejaBE> oListaEstadobandejaBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

for(EstadobandejaBE oEstadobandejaBE : oListaEstadobandejaBE){
cs=cn.prepareCall("{call uspInsertarEstadobandeja(?,?,?,?,?,?,?)}");
	cs.setInt(1, oEstadobandejaBE.getIdusuario());
	cs.setString(2, oEstadobandejaBE.getIcono());
	cs.setString(3, oEstadobandejaBE.getDenominacion());
	cs.setBoolean(4, oEstadobandejaBE.isEstado());
	cs.setInt(5, oEstadobandejaBE.getOrden());
	cs.setBoolean(6, oEstadobandejaBE.isBindfinal());
	cs.registerOutParameter(7, java.sql.Types.INTEGER);
	cs.execute();
	resultado = cs.getInt(7);
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


public  int insertarEstadobandejaBE(EstadobandejaBE oEstadobandejaBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspInsertarEstadobandeja(?,?,?,?,?,?,?)}");
	cs.setInt(1, oEstadobandejaBE.getIdusuario());
	cs.setString(2, oEstadobandejaBE.getIcono());
	cs.setString(3, oEstadobandejaBE.getDenominacion());
	cs.setBoolean(4, oEstadobandejaBE.isEstado());
	cs.setInt(5, oEstadobandejaBE.getOrden());
	cs.setBoolean(6, oEstadobandejaBE.isBindfinal());
	cs.registerOutParameter(7, java.sql.Types.INTEGER);
	cs.execute();
	resultado = cs.getInt(7);
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


public  int actualizarEstadobandejaBE(EstadobandejaBE oEstadobandejaBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion, user, password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspActualizarEstadobandeja(?,?,?,?,?,?,?)}");
	cs.setInt(1, oEstadobandejaBE.getIdestadobandeja());
	cs.setInt(2, oEstadobandejaBE.getIdusuario());
	cs.setString(3, oEstadobandejaBE.getIcono());
	cs.setString(4, oEstadobandejaBE.getDenominacion());
	cs.setBoolean(5, oEstadobandejaBE.isEstado());
	cs.setInt(6, oEstadobandejaBE.getOrden());
	cs.setBoolean(7, oEstadobandejaBE.isBindfinal());
	cs.registerOutParameter(7, java.sql.Types.INTEGER);
	cs.executeUpdate();
	resultado = cs.getInt(7);
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
