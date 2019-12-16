package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.ExpedienteBE;
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
import mph.tramitedoc.be.JQObjectBE;
import mph.tramitedoc.util.JQgridUtil;

public class ExpedienteDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public ExpedienteDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public ExpedienteBE listarExpedienteBE(ExpedienteBE oExpedienteBE1) throws SQLException {
        ExpedienteBE oExpedienteBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oExpedienteBE = new ExpedienteBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oExpedienteBE1.getIndOpSp() == 1) {

                String sql = " SELECT idexpediente,idusuariocargo,idprocedimiento,idarea,codigo,dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo,fecharegistro,asunto,estado,bindentregado FROM expediente WHERE idexpediente=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                oExpedienteBE.setIdusuariocargo(rs.getInt("idusuariocargo"));
                oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                oExpedienteBE.setIdarea(rs.getInt("idarea"));
                oExpedienteBE.setCodigo(rs.getInt("codigo"));
                oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                oExpedienteBE.setApellidos(rs.getString("apellidos"));
                oExpedienteBE.setDireccion(rs.getString("direccion"));
                oExpedienteBE.setTelefono(rs.getString("telefono"));
                oExpedienteBE.setCorreo(rs.getString("correo"));
                oExpedienteBE.setFecharegistro(rs.getDate("fecharegistro"));
                oExpedienteBE.setAsunto(rs.getString("asunto"));
                oExpedienteBE.setEstado(rs.getBoolean("estado"));
                oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
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
        return oExpedienteBE;
    }

    public ArrayList<ExpedienteBE> listarRegistroExpedienteBE(ExpedienteBE oExpedienteBE1) throws SQLException {
        ArrayList<ExpedienteBE> listaExpedienteBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaExpedienteBE = new ArrayList<ExpedienteBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oExpedienteBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idexpediente||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idexpediente||')\" class=\"fa fa-trash-o\"></i>',"
                        + "e.idexpediente,e.idprocedimiento,a.idarea,e.codigo,a.denominacion AS area, p.codigo AS Codigo_Procedimiento,p.denominacion AS procedimiento,e.dni_ruc,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,e.asunto,e.estado,e.bindentregado\n"
                        + " ,case when e.bindobservado=true then 'SI' else 'NO' end observado ,to_char(e.fecharegistro,'DD/MM/YYYY HH24:MI:SS') fecharegistro,folios,nombredocumento\n"
                        + "from expediente e inner join area a \n"
                        + "	on e.idarea = a.idarea inner join procedimiento p\n"
                        + "	on e.idprocedimiento = p.idprocedimiento\n"
                        + "\n"
                        + " where "
                        + " extract(year from e.fecharegistro)::integer = case when " + oExpedienteBE1.getIdarea() + "=0 then extract(year from e.fecharegistro)::integer else " + oExpedienteBE1.getIdarea() + " end "
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end"
                        + " and e.estado=true and e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "')\n"
                        + "order by e.fecharegistro desc limit 20";
                System.out.println("" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setEdit(rs.getString(1));
                    oExpedienteBE.setDel(rs.getString(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oExpedienteBE.setIdarea(rs.getInt("idarea"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setAreadenominacion(rs.getString("area"));
                    oExpedienteBE.setCodprocedimiento(rs.getString("Codigo_Procedimiento"));
                    oExpedienteBE.setDenoprocedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    oExpedienteBE.setObservado(rs.getString("observado"));
                    oExpedienteBE.setSfecharegistro(rs.getString("fecharegistro"));
                    oExpedienteBE.setFolios(rs.getInt("folios"));
                    oExpedienteBE.setNombredocumento(rs.getString("nombredocumento"));

                    listaExpedienteBE.add(oExpedienteBE);
                }

            }
            if (oExpedienteBE1.getIndOpSp() == 2) {
                sql = " SELECT idexpediente,idusuariocargo,idprocedimiento,idarea,codigo,dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo,fecharegistro,asunto,estado,bindentregado FROM expediente WHERE idexpediente=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setEdit(rs.getString(1));
                    oExpedienteBE.setDel(rs.getString(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setIdusuariocargo(rs.getInt("idusuariocargo"));
                    oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oExpedienteBE.setIdarea(rs.getInt("idarea"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setFecharegistro(rs.getDate("fecharegistro"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);
                }
            }

            if (oExpedienteBE1.getIndOpSp() == 3) {
                sql = " select \n"
                        + "dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo\n"
                        + "from expediente\n"
                        + "where dni_ruc='" + oExpedienteBE1.getDni_ruc() + "'";
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    listaExpedienteBE.add(oExpedienteBE);

                }
            }

            if (oExpedienteBE1.getIndOpSp() == 4) {
                sql = "select '<button class=\"btngrilla\" onclick=\"derivar('||e.idexpediente||','||a.idarea||','||r.idrecepcion||','||e.codigo||')\" >Derivar</button>'"
                        + ",r.idrecepcion,e.idexpediente,e.codigo,a.denominacion as area,p.denominacion as procedimiento,e.asunto,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,e.fecharegistro,e.estado,e.bindentregado\n"
                        + "from expediente e "
                        + " inner join recepcion r on e.idexpediente=r.idexpediente"
                        + " inner join area a\n"
                        + " on e.idarea=a.idarea inner join procedimiento p\n"
                        + " on p.idprocedimiento=e.idprocedimiento\n"
                        + "where "
                        + " e.estado=true "
                        + " and r.bindderivado=false  \n"
                        + " and r.bindentregado=false  \n"
                        + " and r.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and extract(year from e.fecharegistro)::integer = case when " + oExpedienteBE1.getIdusuariocargo() + "=0 then extract(year from e.fecharegistro)::integer else " + oExpedienteBE1.getIdusuariocargo() + " end "
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end"
                        + " and e.estado=true and e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " --or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "')\n"
                        + "order by e.codigo limit " + oExpedienteBE1.getIdexpediente();
                System.out.println("sql por recibir:" + sql);
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setDerivar(rs.getString(1));
                    oExpedienteBE.setIdrecepcion(rs.getInt(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setArea(rs.getString("area"));
                    oExpedienteBE.setProcedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setFecharegistro(rs.getDate("fecharegistro"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);
                }
            }

            if (oExpedienteBE1.getIndOpSp() == 5) {

                sql = "select e.idexpediente,e.codigo,a.denominacion as area,p.denominacion as procedimiento,e.asunto,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,e.fecharegistro,e.estado,e.bindentregado\n"
                        + "from expediente e "
                        + " inner join recepcion r on e.idexpediente=r.idexpediente"
                        + " inner join area a\n"
                        + "on e.idarea=a.idarea inner join procedimiento p\n"
                        + "on p.idprocedimiento=e.idprocedimiento\n"
                        + "where "
                        + " e.estado=true "
                        + " and r.bindderivado=false  \n"
                        + " and r.bindentregado=true  \n"
                        //+ " and e.bindentregado=true "
                        + " and r.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and extract(year from e.fecharegistro)::integer = case when " + oExpedienteBE1.getIdusuariocargo() + "=0 then extract(year from e.fecharegistro)::integer else " + oExpedienteBE1.getIdusuariocargo() + " end "
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end"
                        + " and e.estado=true "
                        + " and e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " --or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "')\n"
                        + "order by e.codigo limit " + oExpedienteBE1.getIdexpediente();

                System.out.println("sql recibidos:" + sql);
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {

                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setArea(rs.getString("area"));
                    oExpedienteBE.setProcedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setFecharegistro(rs.getDate("fecharegistro"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);

                }
            }

            if (oExpedienteBE1.getIndOpSp() == 6) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"addExpedienteReferencia('||idexpediente||',''Exp.'|| e.codigo||' - '|| e.asunto ||''')\" class=\"fa fa-plus\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idexpediente||')\" class=\"fa fa-trash-o\"></i>',"
                        + "e.idexpediente,e.idprocedimiento,a.idarea,e.codigo,a.denominacion AS area, p.codigo AS Codigo_Procedimiento,p.denominacion AS procedimiento,e.dni_ruc,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,e.asunto,e.estado,e.bindentregado\n"
                        + " ,case when e.bindobservado=true then 'SI' else 'NO' end observado ,to_char(e.fecharegistro,'DD/MM/YYYY HH24:MI:SS') fecharegistro,folios,nombredocumento\n"
                        + "from expediente e inner join area a \n"
                        + "	on e.idarea = a.idarea inner join procedimiento p\n"
                        + "	on e.idprocedimiento = p.idprocedimiento\n"
                        + "\n"
                        + " where "
                        + " extract(year from e.fecharegistro)::integer = case when " + oExpedienteBE1.getIdarea() + "=0 then extract(year from e.fecharegistro)::integer else " + oExpedienteBE1.getIdarea() + " end "
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end"
                        + " and e.estado=true and e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + "--or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "')\n"
                        + "order by e.fecharegistro desc limit 20";
                System.out.println("" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setEdit(rs.getString(1));
                    oExpedienteBE.setDel(rs.getString(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oExpedienteBE.setIdarea(rs.getInt("idarea"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setAreadenominacion(rs.getString("area"));
                    oExpedienteBE.setCodprocedimiento(rs.getString("Codigo_Procedimiento"));
                    oExpedienteBE.setDenoprocedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    oExpedienteBE.setObservado(rs.getString("observado"));
                    oExpedienteBE.setSfecharegistro(rs.getString("fecharegistro"));
                    oExpedienteBE.setFolios(rs.getInt("folios"));
                    oExpedienteBE.setNombredocumento(rs.getString("nombredocumento"));

                    listaExpedienteBE.add(oExpedienteBE);
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
            oExpedienteBE1 = null;
        }
        return listaExpedienteBE;
    }

    public JQObjectBE listarJQRegistroExpedienteBE(ExpedienteBE oExpedienteBE1) throws SQLException {
        JQObjectBE ojqbjectBE = new JQObjectBE();
        JQgridUtil oJQgridUtil = new JQgridUtil();
        ArrayList<ExpedienteBE> listaExpedienteBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaExpedienteBE = new ArrayList<ExpedienteBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            String sql_calc_cant_rows = "";
            if (oExpedienteBE1.getIndOpSp() == 1) {

                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"edit('||idexpediente||')\" class=\"fa fa-pencil-square-o\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||idexpediente||')\" class=\"fa fa-trash-o\"></i>',"
                        + "e.idexpediente,e.idprocedimiento,a.idarea,e.codigo,a.denominacion AS area, p.codigo AS Codigo_Procedimiento,p.denominacion AS procedimiento,e.dni_ruc,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,e.asunto,e.estado,e.bindentregado\n"
                        + " ,case when e.bindobservado=true then 'SI' else 'NO' end observado ,to_char(e.fecharegistro,'DD/MM/YYYY HH24:MI:SS') fecharegistro\n"
                        + "from expediente e inner join area a \n"
                        + "	on e.idarea = a.idarea inner join procedimiento p\n"
                        + "	on e.idprocedimiento = p.idprocedimiento\n"
                        + "\n"
                        + " where "
                        + " extract(year from e.fecharegistro)::integer = case when " + oExpedienteBE1.getIdarea() + "=0 then extract(year from e.fecharegistro)::integer else " + oExpedienteBE1.getIdarea() + " end "
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end"
                        + " and e.estado=true and e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + "--or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "')\n"
                        + "order by e.fecharegistro desc limit 20";
                System.out.println("" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setEdit(rs.getString(1));
                    oExpedienteBE.setDel(rs.getString(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oExpedienteBE.setIdarea(rs.getInt("idarea"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setAreadenominacion(rs.getString("area"));
                    oExpedienteBE.setCodprocedimiento(rs.getString("Codigo_Procedimiento"));
                    oExpedienteBE.setDenoprocedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    oExpedienteBE.setObservado(rs.getString("observado"));
                    oExpedienteBE.setSfecharegistro(rs.getString("fecharegistro"));

                    listaExpedienteBE.add(oExpedienteBE);
                }

            }
            if (oExpedienteBE1.getIndOpSp() == 2) {
                sql = " SELECT idexpediente,idusuariocargo,idprocedimiento,idarea,codigo,dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo,fecharegistro,asunto,estado,bindentregado FROM expediente WHERE idexpediente=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setEdit(rs.getString(1));
                    oExpedienteBE.setDel(rs.getString(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setIdusuariocargo(rs.getInt("idusuariocargo"));
                    oExpedienteBE.setIdprocedimiento(rs.getInt("idprocedimiento"));
                    oExpedienteBE.setIdarea(rs.getInt("idarea"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setFecharegistro(rs.getDate("fecharegistro"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);
                }
            }

            if (oExpedienteBE1.getIndOpSp() == 3) {
                sql = " select \n"
                        + "dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo\n"
                        + "from expediente\n"
                        + "where dni_ruc='" + oExpedienteBE1.getDni_ruc() + "'";
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setDni_ruc(rs.getString("dni_ruc"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    listaExpedienteBE.add(oExpedienteBE);

                }
            }

            if (oExpedienteBE1.getIndOpSp() == 4) {

                /*Calculando la paginacion*/
                sql_calc_cant_rows = "select count(e.idexpediente) total\n"
                        + "from expediente e "
                        + " inner join recepcion r on e.idexpediente=r.idexpediente"
                        + " inner join area a\n"
                        + " on e.idarea=a.idarea inner join procedimiento p\n"
                        + " on p.idprocedimiento=e.idprocedimiento\n"
                        + "where "
                        + " e.estado=true "
                        + " and r.bindderivado=false  \n"
                        + " and r.bindentregado=false  \n"
                        //                        + " and r.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and e.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and extract(year from e.fecharegistro)::integer = case when " + oExpedienteBE1.getIdusuariocargo() + "=0 then extract(year from e.fecharegistro)::integer else " + oExpedienteBE1.getIdusuariocargo() + " end \n"
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end"
                        + " and e.estado=true \n"
                        + " and \n"
                        + " e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " --or \n"
                        + " --to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "')*/";

                System.out.println("sql_calc_cant_rows:"+sql_calc_cant_rows);
                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oExpedienteBE1);

                /*Calculando la paginacion*/
                sql = "select '<button class=\"btngrilla\" onclick=\"derivar('||e.idexpediente||','||a.idarea||','||r.idrecepcion||','||e.codigo||')\" >Derivar</button>'"
                        + ",r.idrecepcion,e.idexpediente,e.codigo,a.denominacion as area,p.denominacion as procedimiento,e.asunto,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,to_char(e.fecharegistro,'DD/MM/YYYY HH24:MI') as fecharegistro,e.estado,e.bindentregado\n"
                        + "from expediente e "
                        + " inner join recepcion r on e.idexpediente=r.idexpediente and e.estado=true\n"
                        + " inner join area a\n"
                        + " on e.idarea=a.idarea inner join procedimiento p\n"
                        + " on p.idprocedimiento=e.idprocedimiento\n"
                        + "where "
                        + " e.estado=true "
                        + " and r.bindderivado=false  \n"
                        + " and r.bindentregado=false  \n"
                        //                        + " and r.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and e.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and extract(year from e.fecharegistro)::integer = case when " + oExpedienteBE1.getIdusuariocargo() + "=0 then extract(year from e.fecharegistro)::integer else " + oExpedienteBE1.getIdusuariocargo() + " end \n"
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end"
                        + " and e.estado=true \n"
                        + " and /*(*/ e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " --or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "'))\n"
                        + " order by e.fecharegistro desc limit " + oExpedienteBE1.getRows() + " offset " + oExpedienteBE1.getStart();
                System.out.println("sql por recibir 4:" + sql);
                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {
                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setDerivar(rs.getString(1));
                    oExpedienteBE.setIdrecepcion(rs.getInt(2));
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setArea(rs.getString("area"));
                    oExpedienteBE.setProcedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setSfecharegistro(rs.getString("fecharegistro"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);
                }

                ojqbjectBE.setPage(oExpedienteBE1.getPage());
                ojqbjectBE.setTotal(oExpedienteBE1.getTotal_pages());
                ojqbjectBE.setRecords(oExpedienteBE1.getTotal());
                ojqbjectBE.setRows(listaExpedienteBE);
            }

            if (oExpedienteBE1.getIndOpSp() == 5) {

                sql_calc_cant_rows = "select count(e.idexpediente) total\n"
                        + "from expediente e "
                        + " inner join recepcion r on e.idexpediente=r.idexpediente and e.estado=true"
                        + " inner join area a\n"
                        + "on e.idarea=a.idarea inner join procedimiento p\n"
                        + "on p.idprocedimiento=e.idprocedimiento\n"
                        + "where "
                        + " e.estado=true "
                        + " and r.bindderivado=false  \n"
                        + " and r.bindentregado=true  \n"
                        //+ " and e.bindentregado=true "
                        //                        + " and r.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and e.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and extract(year from r.fecharecepcion)::integer = case when " + oExpedienteBE1.getIdusuariocargo() + "=0 then extract(year from r.fecharecepcion)::integer else " + oExpedienteBE1.getIdusuariocargo() + " end \n"
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end\n"
                        + " and e.estado=true "
                        + " and /*(*/e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " --or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "'))";

                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oExpedienteBE1);

                sql = "select e.idexpediente,e.codigo,a.denominacion as area,p.denominacion as procedimiento,e.asunto,e.nombre_razonsocial,e.apellidos,e.direccion,e.telefono,e.correo,to_char(r.fecharecepcion,'DD/MM/YYYY HH24:MI') as fecharegistro ,e.estado,e.bindentregado\n"
                        + "from expediente e "
                        + " inner join recepcion r on e.idexpediente=r.idexpediente"
                        + " inner join area a\n"
                        + "on e.idarea=a.idarea inner join procedimiento p\n"
                        + "on p.idprocedimiento=e.idprocedimiento\n"
                        + "where "
                        + " e.estado=true "
                        + " and r.bindderivado=false  \n"
                        + " and r.bindentregado=true  \n"
                        //+ " and e.bindentregado=true "
                        //                        + " and r.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and e.idarea=" + oExpedienteBE1.getIdarea() + "\n"
                        + " and extract(year from r.fecharecepcion)::integer = case when " + oExpedienteBE1.getIdusuariocargo() + "=0 then extract(year from r.fecharecepcion)::integer else " + oExpedienteBE1.getIdusuariocargo() + " end \n"
                        + " and e.codigo= case when " + oExpedienteBE1.getCodigo() + "=0 then e.codigo  else " + oExpedienteBE1.getCodigo() + " end\n"
                        + " and e.estado=true "
                        + " and /*(*/e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc ||' '|| e.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oExpedienteBE1.getNombre_razonsocial() + "'  then '' else '" + oExpedienteBE1.getNombre_razonsocial() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " --or to_tsvector(e.nombre_razonsocial ||' '|| e.apellidos||' '|| e.dni_ruc||' '|| e.asunto)@@ plainto_tsquery('" + oExpedienteBE1.getNombre_razonsocial() + "'))\n"
                        + " order by e.codigo  limit " + oExpedienteBE1.getRows() + " offset " + oExpedienteBE1.getStart();

                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

                while (rs.next()) {

                    ExpedienteBE oExpedienteBE = new ExpedienteBE();
                    oExpedienteBE.setIdexpediente(rs.getInt("idexpediente"));
                    oExpedienteBE.setCodigo(rs.getInt("codigo"));
                    oExpedienteBE.setArea(rs.getString("area"));
                    oExpedienteBE.setProcedimiento(rs.getString("procedimiento"));
                    oExpedienteBE.setAsunto(rs.getString("asunto"));
                    oExpedienteBE.setNombre_razonsocial(rs.getString("nombre_razonsocial"));
                    oExpedienteBE.setApellidos(rs.getString("apellidos"));
                    oExpedienteBE.setDireccion(rs.getString("direccion"));
                    oExpedienteBE.setTelefono(rs.getString("telefono"));
                    oExpedienteBE.setCorreo(rs.getString("correo"));
                    oExpedienteBE.setSfecharegistro(rs.getString("fecharegistro"));
                    oExpedienteBE.setEstado(rs.getBoolean("estado"));
                    oExpedienteBE.setBindentregado(rs.getBoolean("bindentregado"));
                    listaExpedienteBE.add(oExpedienteBE);

                }

                /*configurando el objeto jqgrid*/
                ojqbjectBE.setPage(oExpedienteBE1.getPage());
                ojqbjectBE.setTotal(oExpedienteBE1.getTotal_pages());
                ojqbjectBE.setRecords(oExpedienteBE1.getTotal());
                ojqbjectBE.setRows(listaExpedienteBE);
                /**/

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
            oExpedienteBE1 = null;
        }

        return ojqbjectBE;
    }

    public int insertarRegistrosExpedienteBE(ArrayList<ExpedienteBE> oListaExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ExpedienteBE oExpedienteBE : oListaExpedienteBE) {
                cs = cn.prepareCall("{call uspInsertarExpediente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oExpedienteBE.getIdusuariocargo());
                cs.setInt(2, oExpedienteBE.getIdprocedimiento());
                cs.setInt(3, oExpedienteBE.getIdarea());
                cs.setInt(4, oExpedienteBE.getCodigo());
                cs.setString(5, oExpedienteBE.getDni_ruc());
                cs.setString(6, oExpedienteBE.getNombre_razonsocial());
                cs.setString(7, oExpedienteBE.getApellidos());
                cs.setString(8, oExpedienteBE.getDireccion());
                cs.setString(9, oExpedienteBE.getTelefono());
                cs.setString(10, oExpedienteBE.getCorreo());
                cs.setString(11, oExpedienteBE.getAsunto());
                cs.setBoolean(12, oExpedienteBE.isEstado());
                cs.setBoolean(13, oExpedienteBE.isBindentregado());
                cs.registerOutParameter(14, java.sql.Types.INTEGER);
                cs.execute();
                resultado = cs.getInt(14);
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

    public int insertarExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarExpediente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oExpedienteBE.getIdusuariocargo());
            cs.setInt(2, oExpedienteBE.getIdprocedimiento());
            cs.setInt(3, oExpedienteBE.getIdarea());
            cs.setInt(4, oExpedienteBE.getCodigo());
            cs.setString(5, oExpedienteBE.getDni_ruc());
            cs.setString(6, oExpedienteBE.getNombre_razonsocial());
            cs.setString(7, oExpedienteBE.getApellidos());
            cs.setString(8, oExpedienteBE.getDireccion());
            cs.setString(9, oExpedienteBE.getTelefono());
            cs.setString(10, oExpedienteBE.getCorreo());
            cs.setString(11, oExpedienteBE.getAsunto());
            cs.setBoolean(12, oExpedienteBE.isEstado());
            cs.setBoolean(13, oExpedienteBE.isBindentregado());
            cs.setBoolean(14, oExpedienteBE.isBindobservado());
            cs.setInt(15, oExpedienteBE.getFolios());
            cs.setString(16, oExpedienteBE.getNombredocumento());
            cs.setInt(17, oExpedienteBE.getIdarea_proviene());
            cs.setString(18, oExpedienteBE.getObservacion());
            cs.registerOutParameter(19, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(19);
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

    public int actualizarExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarExpediente(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");

            cs.setInt(1, oExpedienteBE.getIdexpediente());
            cs.setInt(2, oExpedienteBE.getIdprocedimiento());
            cs.setInt(3, oExpedienteBE.getIdarea());
            cs.setInt(4, oExpedienteBE.getIdusuariocargo());
            cs.setString(5, oExpedienteBE.getDni_ruc());
            cs.setString(6, oExpedienteBE.getNombre_razonsocial());
            cs.setString(7, oExpedienteBE.getApellidos());
            cs.setString(8, oExpedienteBE.getDireccion());
            cs.setString(9, oExpedienteBE.getTelefono());
            cs.setString(10, oExpedienteBE.getCorreo());
            cs.setString(11, oExpedienteBE.getAsunto());
            cs.setBoolean(12, oExpedienteBE.isBindobservado());
            cs.setInt(13, oExpedienteBE.getFolios());
            cs.setString(14, oExpedienteBE.getNombredocumento());
            cs.setString(15, oExpedienteBE.getObservacion());
            cs.registerOutParameter(15, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(15);
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

    public int derivarExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspderivarexpediente(?,?,?,?,?)}");

            cs.setInt(1, oExpedienteBE.getIdrecepcion());
            cs.setInt(2, oExpedienteBE.getIdarea());
            cs.setInt(3, oExpedienteBE.getIdprocedimiento());
            cs.setString(4, oExpedienteBE.getObservacion());
            cs.setInt(5, oExpedienteBE.getIdarea_proviene());

            cs.registerOutParameter(5, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(4);
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

    public int actualizarRegistrosExpedienteBE(ArrayList<ExpedienteBE> oListaExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (ExpedienteBE oExpedienteBE : oListaExpedienteBE) {
                cs = cn.prepareCall("{call uspentregaexpediente(?,?,?,?)}");
                cs.setInt(1, oExpedienteBE.getIdexpediente());
                cs.setInt(2, oExpedienteBE.getIdusuariorecepciona());
                cs.setInt(3, oExpedienteBE.getIdarea());
                cs.setString(4, oExpedienteBE.getSfecharecepciona());
                cs.registerOutParameter(4, java.sql.Types.INTEGER);
                cs.executeUpdate();
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

    public int eliminarExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarExpediente(?,?)}");
            cs.setInt(1, oExpedienteBE.getIdexpediente());
            cs.setInt(2, oExpedienteBE.getIdusuariocargo());
            //cs.setString(3, oExpedienteBE.getObservacion());
            cs.registerOutParameter(2, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(2);
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

    public List listObjectExpedienteBE(ExpedienteBE oExpedienteBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oExpedienteBE.getIndOpSp() == 1) {
                sql = " SELECT idexpediente,idusuariocargo,idprocedimiento,idarea,codigo,dni_ruc,nombre_razonsocial,apellidos,direccion,telefono,correo,asunto,estado,bindentregado FROM expediente WHERE idexpediente=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oExpedienteBE.getIndOpSp() == 2) {
                sql = "SELECT idusuariocargo, idusuario, estado FROM usuariocargo WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oExpedienteBE.getIndOpSp() == 3) {
                sql = "SELECT idarea, denominacion, estado FROM area WHERE estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oExpedienteBE.getIndOpSp() == 4) {
                sql = " select p.idprocedimiento,p.denominacion as nombre, p.estado From procedimiento p inner join area a on p.idarea = a.idarea\n"
                        + "where a.idarea=" + oExpedienteBE.getIdarea() + " and p.estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oExpedienteBE.getIndOpSp() == 5) {
                sql = "select idrequisitos,case when monto is null then denominacion else 'S/. '||to_char(  monto, 'FM999999999.00')||' - '||denominacion end as denominacion from requisitos where estado=true and idprocedimiento=" + oExpedienteBE.getIdprocedimiento();
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oExpedienteBE.getIndOpSp() == 6) {
                sql = "select a.idrequisitos,b.denominacion from expedienterequisito a\n"
                        + "inner join requisitos b on a.idrequisitos=b.idrequisitos\n"
                        + "where a.idexpediente=" + oExpedienteBE.getIdexpediente();
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oExpedienteBE.getIndOpSp() == 7) {
                sql = "select idrequisitos, denominacion from requisitos \n"
                        + "where idprocedimiento=" + oExpedienteBE.getIdprocedimiento() + " \n"
                        + "and idrequisitos not in (\n"
                        + "select a.idrequisitos from expedienterequisito a\n"
                        + "where a.idexpediente=" + oExpedienteBE.getIdexpediente() + ") ";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                System.out.println("sql: " + sql);
                rs = pst.executeQuery();

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
            oExpedienteBE = null;
        }
        return list;
    }

}
