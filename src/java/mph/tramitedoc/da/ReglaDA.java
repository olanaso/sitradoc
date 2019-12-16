package mph.tramitedoc.da;


//@autor Sergio Medina


import mph.tramitedoc.be.ReglaBE;
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
public class ReglaDA extends BaseDA {
	String cadenaConexion;
	String DriverConnection;
	String user;
	String password;
public ReglaDA(){
	cadenaConexion = super.getConnectionString();
	DriverConnection = super.getDriverConnection();
	user = super.getUser();
	password = super.getPassword();    
}
 public ReglaBE listarReglaBE(ReglaBE oReglaBE1) throws SQLException {
	ReglaBE oReglaBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	oReglaBE=new ReglaBE();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
if(oReglaBE1.getIndOpSp()==1){

	String sql = " SELECT idregla,subida,igual,bajada,estado FROM regla WHERE idregla=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oReglaBE1.getIdregla());
rs = pst.executeQuery();
System.out.println("consulta :" + sql);

}	while(rs.next()){
		oReglaBE.setIdregla(rs.getInt("idregla"));
		oReglaBE.setSubida(rs.getBoolean("subida"));
		oReglaBE.setIgual(rs.getBoolean("igual"));
		oReglaBE.setBajada(rs.getBoolean("bajada"));
		oReglaBE.setEstado(rs.getBoolean("estado"));
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
return oReglaBE;
}



public ArrayList<ReglaBE> listarRegistroReglaBE(ReglaBE oReglaBE1) throws SQLException {
	ArrayList<ReglaBE> listaReglaBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	listaReglaBE=new ArrayList<ReglaBE>();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
	String sql="";
if (oReglaBE1.getIndOpSp() == 1) {
	sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idregla||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idregla||')\" class=\"fa fa-trash-o\"></i>',idregla,subida,igual,bajada,estado FROM regla WHERE estado=true";
pst = cn.prepareStatement(sql);
rs = pst.executeQuery();
}
if (oReglaBE1.getIndOpSp() == 2) {
	sql = " SELECT idregla,subida,igual,bajada,estado FROM regla WHERE idregla=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oReglaBE1.getIdregla());
rs = pst.executeQuery();
}

while(rs.next()){
	ReglaBE oReglaBE=new ReglaBE();
oReglaBE.setEdit(rs.getString(1));
oReglaBE.setDel(rs.getString(2));
		oReglaBE.setIdregla(rs.getInt("idregla"));
		oReglaBE.setSubida(rs.getBoolean("subida"));
		oReglaBE.setIgual(rs.getBoolean("igual"));
		oReglaBE.setBajada(rs.getBoolean("bajada"));
		oReglaBE.setEstado(rs.getBoolean("estado"));
	listaReglaBE.add(oReglaBE);}

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
	oReglaBE1 = null;
}
return listaReglaBE;
}


public  int insertarRegistrosReglaBE(ArrayList<ReglaBE> oListaReglaBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

for(ReglaBE oReglaBE : oListaReglaBE){
cs=cn.prepareCall("{call uspInsertarRegla(?,?,?,?,?)}");
	cs.setBoolean(1, oReglaBE.isSubida());
	cs.setBoolean(2, oReglaBE.isIgual());
	cs.setBoolean(3, oReglaBE.isBajada());
	cs.setBoolean(4, oReglaBE.isEstado());
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


public  int insertarReglaBE(ReglaBE oReglaBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspInsertarRegla(?,?,?,?,?)}");
	cs.setBoolean(1, oReglaBE.isSubida());
	cs.setBoolean(2, oReglaBE.isIgual());
	cs.setBoolean(3, oReglaBE.isBajada());
	cs.setBoolean(4, oReglaBE.isEstado());
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


public  int actualizarReglaBE(ReglaBE oReglaBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion, user, password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspActualizarRegla(?,?,?,?,?)}");
	cs.setInt(1, oReglaBE.getIdregla());
	cs.setBoolean(2, oReglaBE.isSubida());
	cs.setBoolean(3, oReglaBE.isIgual());
	cs.setBoolean(4, oReglaBE.isBajada());
	cs.setBoolean(5, oReglaBE.isEstado());
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





public  int eliminarReglaBE(ReglaBE oReglaBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion, user, password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspEliminarRegla(?)}");cs.setInt(1, oReglaBE.getIdregla());	cs.registerOutParameter(1, java.sql.Types.INTEGER);
	cs.executeUpdate();
	resultado = cs.getInt(1);
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
  public List listObjectReglaBE(ReglaBE oReglaBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oReglaBE.getIndOpSp() == 1) {
	 sql = " SELECT idregla,subida,igual,bajada,estado FROM regla WHERE idregla=? and estado=true";                pst = cn.prepareStatement(sql);
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
            oReglaBE = null;
        }
        return list;
    }
    
  }  
