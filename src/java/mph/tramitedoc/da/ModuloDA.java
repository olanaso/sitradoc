package mph.tramitedoc.da;


//@autor Sergio Medina


import mph.tramitedoc.be.ModuloBE;
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
public class ModuloDA extends BaseDA {
	String cadenaConexion;
	String DriverConnection;
	String user;
	String password;
public ModuloDA(){
	cadenaConexion = super.getConnectionString();
	DriverConnection = super.getDriverConnection();
	user = super.getUser();
	password = super.getPassword();    
}
 public ModuloBE listarModuloBE(ModuloBE oModuloBE1) throws SQLException {
	ModuloBE oModuloBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	oModuloBE=new ModuloBE();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
if(oModuloBE1.getIndOpSp()==1){

	String sql = " SELECT idmodulo,denominacion,paginainicio,estado FROM modulo WHERE idmodulo=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oModuloBE1.getIdmodulo());
rs = pst.executeQuery();
System.out.println("consulta :" + sql);

}	while(rs.next()){
		oModuloBE.setIdmodulo(rs.getInt("idmodulo"));
		oModuloBE.setDenominacion(rs.getString("denominacion"));
		oModuloBE.setPaginainicio(rs.getString("paginainicio"));
		oModuloBE.setEstado(rs.getBoolean("estado"));
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
return oModuloBE;
}



public ArrayList<ModuloBE> listarRegistroModuloBE(ModuloBE oModuloBE1) throws SQLException {
	ArrayList<ModuloBE> listaModuloBE=null;
	Connection cn = null;
	ResultSet rs = null;
	PreparedStatement pst = null;


try{
	listaModuloBE=new ArrayList<ModuloBE>();
	Class.forName(DriverConnection);
	cn = DriverManager.getConnection(cadenaConexion, user, password);
	cn.setAutoCommit(false);
	String sql="";
if (oModuloBE1.getIndOpSp() == 1) {
	sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idmodulo||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idmodulo||')\" class=\"fa fa-trash-o\"></i>',idmodulo,denominacion,paginainicio,estado FROM modulo WHERE estado=true";
pst = cn.prepareStatement(sql);
rs = pst.executeQuery();
}
if (oModuloBE1.getIndOpSp() == 2) {
	sql = " SELECT idmodulo,denominacion,paginainicio,estado FROM modulo WHERE idmodulo=? and estado=true";
pst = cn.prepareStatement(sql);
pst.setInt(1,oModuloBE1.getIdmodulo());
rs = pst.executeQuery();
}

while(rs.next()){
	ModuloBE oModuloBE=new ModuloBE();
oModuloBE.setEdit(rs.getString(1));
oModuloBE.setDel(rs.getString(2));
		oModuloBE.setIdmodulo(rs.getInt("idmodulo"));
		oModuloBE.setDenominacion(rs.getString("denominacion"));
		oModuloBE.setPaginainicio(rs.getString("paginainicio"));
		oModuloBE.setEstado(rs.getBoolean("estado"));
	listaModuloBE.add(oModuloBE);}

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
	oModuloBE1 = null;
}
return listaModuloBE;
}


public  int insertarRegistrosModuloBE(ArrayList<ModuloBE> oListaModuloBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

for(ModuloBE oModuloBE : oListaModuloBE){
cs=cn.prepareCall("{call uspInsertarModulo(?,?,?,?)}");
	cs.setString(1, oModuloBE.getDenominacion());
	cs.setString(2, oModuloBE.getPaginainicio());
	cs.setBoolean(3, oModuloBE.isEstado());
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


public  int insertarModuloBE(ModuloBE oModuloBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion,user,password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspInsertarModulo(?,?,?,?)}");
	cs.setString(1, oModuloBE.getDenominacion());
	cs.setString(2, oModuloBE.getPaginainicio());
	cs.setBoolean(3, oModuloBE.isEstado());
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


public  int actualizarModuloBE(ModuloBE oModuloBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion, user, password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspActualizarModulo(?,?,?,?)}");
	cs.setInt(1, oModuloBE.getIdmodulo());
	cs.setString(2, oModuloBE.getDenominacion());
	cs.setString(3, oModuloBE.getPaginainicio());
	cs.setBoolean(4, oModuloBE.isEstado());
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





public  int eliminarModuloBE(ModuloBE oModuloBE) throws SQLException {
	int resultado=0;
	Connection cn = null;
	CallableStatement cs = null;


try{
	Class.forName(DriverConnection);
	cn=DriverManager.getConnection(cadenaConexion, user, password);

	cn.setAutoCommit(false);

cs=cn.prepareCall("{call uspEliminarModulo(?)}");cs.setInt(1, oModuloBE.getIdmodulo());	cs.registerOutParameter(1, java.sql.Types.INTEGER);
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
  public List listObjectModuloBE(ModuloBE oModuloBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oModuloBE.getIndOpSp() == 1) {
	 sql = " SELECT idmodulo,denominacion,paginainicio,estado FROM modulo WHERE idmodulo=? and estado=true";                pst = cn.prepareStatement(sql);
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
            oModuloBE = null;
        }
        return list;
    }
    
  }  
