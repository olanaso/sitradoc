package mph.tramitedoc.da;

//@autor Sergio Medina
import mph.tramitedoc.be.DocumentoBE;
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

public class DocumentoDA extends BaseDA {

    String cadenaConexion;
    String DriverConnection;
    String user;
    String password;

    public DocumentoDA() {
        cadenaConexion = super.getConnectionString();
        DriverConnection = super.getDriverConnection();
        user = super.getUser();
        password = super.getPassword();
    }

    public DocumentoBE listarDocumentoBE(DocumentoBE oDocumentoBE1) throws SQLException {
        DocumentoBE oDocumentoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            oDocumentoBE = new DocumentoBE();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            if (oDocumentoBE1.getIndOpSp() == 1) {

                String sql = " SELECT iddocumento,tipodocumento,asunto,mensaje,prioridad,bindrespuesta,diasrespuesta,bindllegadausuario,idareacioncreacion,idusuariocreacion,fechacreacion,idexpediente,codigoexpediente,estado FROM documento WHERE iddocumento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oDocumentoBE1.getIddocumento());
                rs = pst.executeQuery();
                System.out.println("consulta :" + sql);

            }
            while (rs.next()) {
                oDocumentoBE.setIddocumento(rs.getInt("iddocumento"));
                oDocumentoBE.setIdtipodocumento(rs.getInt("tipodocumento"));
                oDocumentoBE.setAsunto(rs.getString("asunto"));
                oDocumentoBE.setMensaje(rs.getString("mensaje"));
                oDocumentoBE.setPrioridad(rs.getInt("prioridad"));
                oDocumentoBE.setBindrespuesta(rs.getBoolean("bindrespuesta"));
                oDocumentoBE.setDiasrespuesta(rs.getInt("diasrespuesta"));
                oDocumentoBE.setBindllegadausuario(rs.getBoolean("bindllegadausuario"));
                oDocumentoBE.setIdareacioncreacion(rs.getInt("idareacioncreacion"));
                oDocumentoBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
                oDocumentoBE.setFechacreacion(rs.getDate("fechacreacion"));
                oDocumentoBE.setIdexpediente(rs.getInt("idexpediente"));
                oDocumentoBE.setCodigoexpediente(rs.getInt("codigoexpediente"));
                oDocumentoBE.setEstado(rs.getBoolean("estado"));
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
        return oDocumentoBE;
    }

    public ArrayList<DocumentoBE> listarRegistroDocumentoBE(DocumentoBE oDocumentoBE1) throws SQLException {
        ArrayList<DocumentoBE> listaDocumentoBE = null;
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaDocumentoBE = new ArrayList<DocumentoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            if (oDocumentoBE1.getIndOpSp() == 1) {
                sql = " SELECT '<i style=\"cursor:pointer;\" onclick=\"show_regDocumento('||a.iddocumento||')\" class=\"fa fa-eye\"></i>','<i style=\"cursor:pointer;\" onclick=\"del('||a.iddocumento||')\" class=\"fa fa-trash-o\"></i>',\n"
                        + " b.denominacion,a.codigo,a.asunto,a.mensaje,a.codigoexpediente,\n"
                        + " to_char(a.fechacreacion,'DD/MM/YYYY HH24:MI:SS') fechacreacion  from documento a\n"
                        + " inner join tipodocumento b on a.idtipodocumento=b.idtipodocumento\n"
                        + " where \n"
                        + "a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and a.idusuariocreacion=" + oDocumentoBE1.getIdusuariocreacion();
                sql += " order by a.fechacreacion desc";
                System.out.println("sql 1:" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setEdit(rs.getString(1));
                    oDocumentoBE.setDel(rs.getString(2));
                    oDocumentoBE.setTipodocumento(rs.getString("denominacion"));
                    oDocumentoBE.setCodigo(rs.getString("codigo"));
                    oDocumentoBE.setAsunto(rs.getString("asunto"));
                    oDocumentoBE.setMensaje(rs.getString("mensaje"));
                    oDocumentoBE.setCodigoexpediente(rs.getInt("codigoexpediente"));
                    oDocumentoBE.setFecha_envio(rs.getString("fechacreacion"));

                    listaDocumentoBE.add(oDocumentoBE);
                }
            }
            if (oDocumentoBE1.getIndOpSp() == 2) {
                sql = " SELECT iddocumento,tipodocumento,asunto,mensaje,prioridad,bindrespuesta,diasrespuesta,bindllegadausuario,idareacioncreacion,idusuariocreacion,fechacreacion,idexpediente,codigoexpediente,estado FROM documento WHERE iddocumento=? and estado=true";
                pst = cn.prepareStatement(sql);
                pst.setInt(1, oDocumentoBE1.getIddocumento());
                rs = pst.executeQuery();

                while (rs.next()) {
                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setEdit(rs.getString(1));
                    oDocumentoBE.setDel(rs.getString(2));
                    oDocumentoBE.setIddocumento(rs.getInt("iddocumento"));
                    oDocumentoBE.setIdtipodocumento(rs.getInt("idtipodocumento"));
                    oDocumentoBE.setAsunto(rs.getString("asunto"));
                    oDocumentoBE.setMensaje(rs.getString("mensaje"));
                    oDocumentoBE.setPrioridad(rs.getInt("prioridad"));
                    oDocumentoBE.setBindrespuesta(rs.getBoolean("bindrespuesta"));
                    oDocumentoBE.setDiasrespuesta(rs.getInt("diasrespuesta"));
                    oDocumentoBE.setBindllegadausuario(rs.getBoolean("bindllegadausuario"));
                    oDocumentoBE.setIdareacioncreacion(rs.getInt("idareacioncreacion"));
                    oDocumentoBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
                    oDocumentoBE.setFechacreacion(rs.getDate("fechacreacion"));
                    oDocumentoBE.setIdexpediente(rs.getInt("idexpediente"));
                    oDocumentoBE.setCodigoexpediente(rs.getInt("codigoexpediente"));
                    oDocumentoBE.setEstado(rs.getBoolean("estado"));
                    listaDocumentoBE.add(oDocumentoBE);
                }
            }

            if (oDocumentoBE1.getIndOpSp() == 3) {
                sql = "select a.idrecepcioninterna,c.denominacion area,d.nombres||' '||d.apellidos ||' '||d.usuario remitente, b.codigo,b.asunto\n"
                        + ",to_char(a.fecharecepcion,'DD/MM/YYYY HH24:MI:SS') fechaenvio\n"
                        + "\n"
                        + "from recepcioninterna a\n"
                        + "inner join documento b on a.iddocumento=b.iddocumento\n"
                        + "inner join area c on a.idarea_proviene=c.idarea\n"
                        + "inner join usuario d on a.idusuarioenvia=d.idusuario\n"
                        + "where \n"
                        + "a.idarea_destino=" + oDocumentoBE1.getIdareadestino() + "\n"
                        + "and a.bindderivado=false\n"
                        + "and a.estado=true\n"
                        + "and a.estado=true\n"
                        + "and a.estado=true";

                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setIdrecepcioninterna(rs.getInt("idrecepcioninterna"));
                    oDocumentoBE.setArea_proviene(rs.getString("area"));
                    oDocumentoBE.setRemitente(rs.getString("remitente"));
                    oDocumentoBE.setCodigo_documento(rs.getString("codigo"));
                    oDocumentoBE.setAsunto(rs.getString("asunto"));
                    oDocumentoBE.setFecha_envio(rs.getString("fechaenvio"));
                    listaDocumentoBE.add(oDocumentoBE);
                }
            }

            if (oDocumentoBE1.getIndOpSp() == 4) {
                sql = "select iddocumento,codigo from documento where codigo ilike '%" + oDocumentoBE1.getCodigo() + "%' and estado=true limit 5;";

                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setIddocumento(rs.getInt("iddocumento"));
                    oDocumentoBE.setCodigo(rs.getString("codigo"));

                    listaDocumentoBE.add(oDocumentoBE);
                }
            }

            if (oDocumentoBE1.getIndOpSp() == 5) {
                sql = "SELECT '<i style=\"cursor:pointer;\" onclick=\"addreferencia_regDocumento('||a.iddocumento||','''||a.codigo||''')\" class=\"fa fa-plus-circle\"></i>',\n"
                        + " '<i style=\"cursor:pointer;\" onclick=\"show_regDocumento('||a.iddocumento||')\" class=\"fa fa-eye\"></i>',\n"
                        + "a.iddocumento,b.denominacion,c.nombres||' '|| c.apellidos usuario,a.codigo,a.asunto,a.mensaje,a.codigoexpediente,\n"
                        + "to_char(a.fechacreacion,'DD/MM/YYYY HH24:MI:SS') fechacreacion  from documento a\n"
                        + "inner join tipodocumento b on a.idtipodocumento=b.idtipodocumento\n"
                        + "inner join usuario c on a.idusuariocreacion=c.idusuario\n"
                        + "where \n"
                        + "a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and a.idtipodocumento = case when 0=" + oDocumentoBE1.getIdtipodocumento() + " then a.idtipodocumento else " + oDocumentoBE1.getIdtipodocumento() + " end \n"
                        + "and a.idareacioncreacion = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then a.idareacioncreacion else " + oDocumentoBE1.getIdareacioncreacion() + " end \n"
                        + "and a.idusuariocreacion = case when 0=" + oDocumentoBE1.getIdusuariocreacion() + " then a.idusuariocreacion else " + oDocumentoBE1.getIdusuariocreacion() + " end \n"
                        + " and a.codigo ||' '|| a.asunto||' '|| a.mensaje ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getAsunto() + "'  then '' else '" + oDocumentoBE1.getAsunto() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " or to_tsvector(a.codigo ||' '|| a.asunto||' '|| a.mensaje)@@ plainto_tsquery('" + oDocumentoBE1.getAsunto() + "')";

                if (oDocumentoBE1.getFecha_inicio().length() > 0 || oDocumentoBE1.getFecha_fin().length() > 0) {
                    sql += "and a.fechacreacion between '" + oDocumentoBE1.getFecha_inicio() + "' and '" + oDocumentoBE1.getFecha_fin() + "'";
                }
                sql += " order by a.fechacreacion desc limit 20";

                System.out.println("sql 5:" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setEdit(rs.getString(1));
                    oDocumentoBE.setDel(rs.getString(2));
                    oDocumentoBE.setIddocumento(rs.getInt("iddocumento"));
                    oDocumentoBE.setUsuario(rs.getString("usuario"));
                    oDocumentoBE.setTipodocumento(rs.getString("denominacion"));
                    oDocumentoBE.setCodigo(rs.getString("codigo"));
                    oDocumentoBE.setAsunto(rs.getString("asunto"));
                    oDocumentoBE.setMensaje(rs.getString("mensaje"));
                    oDocumentoBE.setCodigoexpediente(rs.getInt("codigoexpediente"));
                    oDocumentoBE.setFecha_envio(rs.getString("fechacreacion"));

                    listaDocumentoBE.add(oDocumentoBE);
                }
            }

            if (oDocumentoBE1.getIndOpSp() == 6) {
                sql = "select b.iddocumento, b.codigo, b.asunto from documentomensaje a inner join documento b "
                        + "on a.iddocumento=b.iddocumento where a.estado=true and b.estado=true and a.idmensaje="
                        + oDocumentoBE1.getIddocumento();

                System.out.println("sql Documento DA listar registros 6 :" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setIddocumento(rs.getInt("iddocumento"));
                    oDocumentoBE.setCodigo(rs.getString("codigo"));
                    oDocumentoBE.setAsunto(rs.getString("asunto"));

                    listaDocumentoBE.add(oDocumentoBE);
                }
            }

            if (oDocumentoBE1.getIndOpSp() == 7) {
                sql = "SELECT '<i style=\"cursor:pointer;\" onclick=\"addreferencia_documento('||a.iddocumento||','''||a.codigo||''')\" class=\"fa fa-plus-circle\"></i>',\n"
                        + " '<i style=\"cursor:pointer;\" onclick=\"show_document('||a.iddocumento||')\" class=\"fa fa-eye\"></i>',\n"
                        + "a.iddocumento,b.denominacion,c.nombres||' '|| c.apellidos usuario,a.codigo,a.asunto,a.mensaje,a.codigoexpediente,\n"
                        + "to_char(a.fechacreacion,'DD/MM/YYYY HH24:MI:SS') fechacreacion  from documento a\n"
                        + "inner join tipodocumento b on a.idtipodocumento=b.idtipodocumento\n"
                        + "inner join usuario c on a.idusuariocreacion=c.idusuario\n"
                        + "where \n"
                        + "a.estado=true\n"
                        + "and b.estado=true\n"
                        + "and a.idtipodocumento = case when 0=" + oDocumentoBE1.getIdtipodocumento() + " then a.idtipodocumento else " + oDocumentoBE1.getIdtipodocumento() + " end \n"
                        + "and a.idareacioncreacion = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then a.idareacioncreacion else " + oDocumentoBE1.getIdareacioncreacion() + " end \n"
                        + "and a.idusuariocreacion = case when 0=" + oDocumentoBE1.getIdusuariocreacion() + " then a.idusuariocreacion else " + oDocumentoBE1.getIdusuariocreacion() + " end \n"
                        + " and a.codigo ||' '|| a.asunto||' '|| a.mensaje ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getAsunto() + "'  then '' else '" + oDocumentoBE1.getAsunto() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " or to_tsvector(a.codigo ||' '|| a.asunto||' '|| a.mensaje)@@ plainto_tsquery('" + oDocumentoBE1.getAsunto() + "')";

                if (oDocumentoBE1.getFecha_inicio().length() > 0 || oDocumentoBE1.getFecha_fin().length() > 0) {
                    sql += "and a.fechacreacion between '" + oDocumentoBE1.getFecha_inicio() + "' and '" + oDocumentoBE1.getFecha_fin() + "'";
                }
                sql += " order by a.fechacreacion desc";

                System.out.println("sql 5:" + sql);
                pst = cn.prepareStatement(sql);
                rs = pst.executeQuery();

                while (rs.next()) {
                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setEdit(rs.getString(1));
                    oDocumentoBE.setDel(rs.getString(2));
                    oDocumentoBE.setIddocumento(rs.getInt("iddocumento"));
                    oDocumentoBE.setUsuario(rs.getString("usuario"));
                    oDocumentoBE.setTipodocumento(rs.getString("denominacion"));
                    oDocumentoBE.setCodigo(rs.getString("codigo"));
                    oDocumentoBE.setAsunto(rs.getString("asunto"));
                    oDocumentoBE.setMensaje(rs.getString("mensaje"));
                    oDocumentoBE.setCodigoexpediente(rs.getInt("codigoexpediente"));
                    oDocumentoBE.setFecha_envio(rs.getString("fechacreacion"));

                    listaDocumentoBE.add(oDocumentoBE);
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
            oDocumentoBE1 = null;
        }
        return listaDocumentoBE;
    }

    ArrayList<DocumentoBE> listaDocumentoBE = null;

    public JQObjectBE listarJQRegistroDocumentoBE(DocumentoBE oDocumentoBE1) throws SQLException {

        JQObjectBE ojqbjectBE = new JQObjectBE();
        JQgridUtil oJQgridUtil = new JQgridUtil();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;

        try {
            listaDocumentoBE = new ArrayList<DocumentoBE>();
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);
            String sql = "";
            String sql_calc_cant_rows = "";

            if (oDocumentoBE1.getIndOpSp() == 1) {

                /*Calculando la paginacion*/
                sql_calc_cant_rows = "select count(a.idrecepcioninterna) total\n"
                    
                        + "from recepcioninterna a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "left join expediente e on b.idexpediente=e.idexpediente\n"
                        + "inner join area c on a.idarea_proviene=c.idarea\n"
                        + "inner join usuario d on a.idusuarioenvia=d.idusuario\n"
                        + "where \n"
                        + "a.bindentregado=false and\n"
                        + "a.idarea_destino = case when 0=" + oDocumentoBE1.getIdareadestino() + " then  a.idarea_destino else " + oDocumentoBE1.getIdareadestino() + " end\n"
                        + "and a.idarea_proviene = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then  a.idarea_proviene else " + oDocumentoBE1.getIdareacioncreacion() + " end\n"
                        + " and /*(*/ b.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getAsunto() + "'  then '' else '" + oDocumentoBE1.getAsunto() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " --or to_tsvector(b.asunto)@@ plainto_tsquery('" + oDocumentoBE1.getAsunto() + "') )\n"
                        + "and a.idarea_proviene = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then  a.idarea_proviene else " + oDocumentoBE1.getIdareacioncreacion() + " end\n"
                        + "and a.idusuarioenvia = case when 0=" + oDocumentoBE1.getIdremitente() + " then  a.idusuarioenvia else " + oDocumentoBE1.getIdremitente() + " end\n"
                        + "and (\n"
                        + "	(select array_to_string(array_agg(documento.codigo), ', ')\n"
                        + "	from documentomensaje \n"
                        + "	inner join documento  on documentomensaje.iddocumento=documento.iddocumento \n"
                        + "	where \n"
                        + "	documentomensaje.estado=true \n"
                        + "	and documento.estado=true \n"
                        + "	and documentomensaje.idmensaje=b.idmensaje)\n"
                        + "	ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getCodigo_documento() + "'  then '' else '" + oDocumentoBE1.getCodigo_documento() + "' end, ' '),' '),' ','%')||'%' \n"
                        + ")";

                if (oDocumentoBE1.getFecha_inicio().length() > 0 || oDocumentoBE1.getFecha_fin().length() > 0) {
                    sql_calc_cant_rows += "and (a.fecharegistro between '" + oDocumentoBE1.getFecha_inicio() + " 00:00' and '" + oDocumentoBE1.getFecha_fin() + " 23:59')";
                }
                sql_calc_cant_rows += " and a.bindderivado=false\n";

                if (oDocumentoBE1.getCodigoexpediente() != 0) {
                    sql_calc_cant_rows += " and e.codigo =  " + oDocumentoBE1.getCodigoexpediente() + "\n";
                }
                sql_calc_cant_rows += " and a.estado=true\n"
                        + " and a.estado=true\n"
                        + " and a.estado=true\n";

                System.out.println("listarJQRegistroDocumentoBE 1:" + sql_calc_cant_rows);
                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oDocumentoBE1);

                /*Calculando la paginacion*/
                sql = "select a.idrecepcioninterna,a.idmensaje,b.idareacioncreacion,b.idusuariocreacion,c.denominacion area,d.nombres||' '||d.apellidos ||' '||d.usuario remitente, '' codigo,b.asunto\n"
                        + ",to_char(a.fecharegistro,'DD/MM/YYYY HH24:MI:SS') fechaenvio,\n"
                        + "e.idexpediente,e.codigo codigoexpediente\n"
                        + "\n"
                        + "from recepcioninterna a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "left join expediente e on b.idexpediente=e.idexpediente\n"
                        + "inner join area c on a.idarea_proviene=c.idarea\n"
                        + "inner join usuario d on a.idusuarioenvia=d.idusuario\n"
                        + "where \n"
                        + "a.bindentregado=false and\n"
                        + "a.idarea_destino = case when 0=" + oDocumentoBE1.getIdareadestino() + " then  a.idarea_destino else " + oDocumentoBE1.getIdareadestino() + " end\n"
                        + "and a.idarea_proviene = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then  a.idarea_proviene else " + oDocumentoBE1.getIdareacioncreacion() + " end\n"
                        + " and /*(*/ b.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getAsunto() + "'  then '' else '" + oDocumentoBE1.getAsunto() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " --or to_tsvector(b.asunto)@@ plainto_tsquery('" + oDocumentoBE1.getAsunto() + "') )\n"
                        + "and a.idarea_proviene = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then  a.idarea_proviene else " + oDocumentoBE1.getIdareacioncreacion() + " end\n"
                        + "and a.idusuarioenvia = case when 0=" + oDocumentoBE1.getIdremitente() + " then  a.idusuarioenvia else " + oDocumentoBE1.getIdremitente() + " end\n"
                        + "and (\n"
                        + "	(select array_to_string(array_agg(documento.codigo), ', ')\n"
                        + "	from documentomensaje \n"
                        + "	inner join documento  on documentomensaje.iddocumento=documento.iddocumento \n"
                        + "	where \n"
                        + "	documentomensaje.estado=true \n"
                        + "	and documento.estado=true \n"
                        + "	and documentomensaje.idmensaje=b.idmensaje)\n"
                        + "	ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getCodigo_documento() + "'  then '' else '" + oDocumentoBE1.getCodigo_documento() + "' end, ' '),' '),' ','%')||'%' \n"
                        + ")";

                if (oDocumentoBE1.getFecha_inicio().length() > 0 || oDocumentoBE1.getFecha_fin().length() > 0) {
                    sql += "and (a.fecharegistro between '" + oDocumentoBE1.getFecha_inicio() + " 00:00' and '" + oDocumentoBE1.getFecha_fin() + " 23:59')";
                }
                sql += " and a.bindderivado=false\n";

                if (oDocumentoBE1.getCodigoexpediente() != 0) {
                    sql += " and e.codigo =  " + oDocumentoBE1.getCodigoexpediente() + "\n";
                }
                sql += " and a.estado=true\n"
                        + " and a.estado=true\n"
                        + " and a.estado=true\n"
                        + " ORDER BY fechaenvio DESC\n"
                        + " limit " + oDocumentoBE1.getRows() + " offset " + oDocumentoBE1.getStart();

                System.out.println("listarJQRegistroDocumentoBE 1:" + sql);

                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {

                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setIdrecepcioninterna(rs.getInt("idrecepcioninterna"));
                    oDocumentoBE.setIdmensaje(rs.getInt("idmensaje"));
                    oDocumentoBE.setIdareacioncreacion(rs.getInt("idareacioncreacion"));
                    oDocumentoBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
                    oDocumentoBE.setArea_proviene(rs.getString("area"));
                    oDocumentoBE.setRemitente(rs.getString("remitente"));
                    oDocumentoBE.setCodigo_documento(rs.getString("codigo"));
                    oDocumentoBE.setAsunto(rs.getString("asunto"));
                    oDocumentoBE.setFecha_envio(rs.getString("fechaenvio"));
                    oDocumentoBE.setIdexpediente(rs.getInt("idexpediente"));
                    oDocumentoBE.setCodigoexpediente(rs.getInt("codigoexpediente"));
                    listaDocumentoBE.add(oDocumentoBE);
                }
                ojqbjectBE.setPage(oDocumentoBE1.getPage());
                ojqbjectBE.setTotal(oDocumentoBE1.getTotal_pages());
                ojqbjectBE.setRecords(oDocumentoBE1.getTotal());
                ojqbjectBE.setRows(listaDocumentoBE);
            }

            if (oDocumentoBE1.getIndOpSp() == 2) {

                /*Calculando la paginacion*/
                sql_calc_cant_rows = "select count(a.idrecepcioninterna) total\n"
                        + "\n"
                        + "from recepcioninterna a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "left join expediente e on b.idexpediente=e.idexpediente\n"
                        + "inner join area c on a.idarea_proviene=c.idarea\n"
                        + "inner join usuario d on a.idusuarioenvia=d.idusuario\n"
                        + "where \n"
                        + "a.bindentregado=true and\n"
                        + "a.idarea_destino = case when 0=" + oDocumentoBE1.getIdareadestino() + " then  a.idarea_destino else " + oDocumentoBE1.getIdareadestino() + " end\n"
                        + "and a.idarea_proviene = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then  a.idarea_proviene else " + oDocumentoBE1.getIdareacioncreacion() + " end\n"
                        + " and ( b.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getAsunto() + "'  then '' else '" + oDocumentoBE1.getAsunto() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " or to_tsvector(b.asunto)@@ plainto_tsquery('" + oDocumentoBE1.getAsunto() + "') )"
                        + "and a.idarea_proviene = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then  a.idarea_proviene else " + oDocumentoBE1.getIdareacioncreacion() + " end\n"
                        + "and a.idusuarioenvia = case when 0=" + oDocumentoBE1.getIdremitente() + " then  a.idusuarioenvia else " + oDocumentoBE1.getIdremitente() + " end\n"
                        + "and (\n"
                        + "	(select array_to_string(array_agg(documento.codigo), ', ')\n"
                        + "	from documentomensaje \n"
                        + "	inner join documento  on documentomensaje.iddocumento=documento.iddocumento \n"
                        + "	where \n"
                        + "	documentomensaje.estado=true \n"
                        + "	and documento.estado=true \n"
                        + "	and documentomensaje.idmensaje=b.idmensaje)\n"
                        + "	ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getCodigo_documento() + "'  then '' else '" + oDocumentoBE1.getCodigo_documento() + "' end, ' '),' '),' ','%')||'%' \n"
                        + ")";
                if (oDocumentoBE1.getFecha_inicio().length() > 0 || oDocumentoBE1.getFecha_fin().length() > 0) {
                    sql += "and (a.fecharegistro between '" + oDocumentoBE1.getFecha_inicio() + " 00:00' and '" + oDocumentoBE1.getFecha_fin() + "23:59')";
                }
                sql += " \n";

                if (oDocumentoBE1.getCodigoexpediente() != 0) {
                    sql += " and e.codigo =  " + oDocumentoBE1.getCodigoexpediente() + "\n";
                }
                sql += " and a.estado=true\n"
                        + " and a.estado=true\n"
                        + " and a.estado=true";

                //System.out.println("listarJQRegistroDocumentoBE 1:" + sql_calc_cant_rows);
                oJQgridUtil.calcPagination(cn, rs, pst, sql_calc_cant_rows, oDocumentoBE1);

                /*Calculando la paginacion*/
                sql = "select a.idrecepcioninterna,a.idmensaje,b.idareacioncreacion,b.idusuariocreacion,c.denominacion area,d.nombres||' '||d.apellidos ||' '||d.usuario remitente, '' codigo,b.asunto\n"
                        + ",to_char(a.fecharegistro,'DD/MM/YYYY HH24:MI:SS') fechaenvio,\n"
                        + "e.idexpediente,e.codigo codigoexpediente,to_char(a.fechaderivacion,'DD/MM/YYYY HH24:MI:SS') fechaderivacion,b.idmensaje\n"
                        + "\n"
                        + "from recepcioninterna a\n"
                        + "inner join mensaje b on a.idmensaje=b.idmensaje\n"
                        + "left join expediente e on b.idexpediente=e.idexpediente\n"
                        + "inner join area c on a.idarea_proviene=c.idarea\n"
                        + "inner join usuario d on a.idusuarioenvia=d.idusuario\n"
                        + "where \n"
                        + "a.bindentregado=true and\n"
                        + "a.idarea_destino = case when 0=" + oDocumentoBE1.getIdareadestino() + " then  a.idarea_destino else " + oDocumentoBE1.getIdareadestino() + " end\n"
                        + "and a.idarea_proviene = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then  a.idarea_proviene else " + oDocumentoBE1.getIdareacioncreacion() + " end\n"
                        + " and ( b.asunto ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getAsunto() + "'  then '' else '" + oDocumentoBE1.getAsunto() + "' end, ' '),' '),' ','%')||'%' \n"
                        + " or to_tsvector(b.asunto)@@ plainto_tsquery('" + oDocumentoBE1.getAsunto() + "') )"
                        + "and a.idarea_proviene = case when 0=" + oDocumentoBE1.getIdareacioncreacion() + " then  a.idarea_proviene else " + oDocumentoBE1.getIdareacioncreacion() + " end\n"
                        + "and a.idusuarioenvia = case when 0=" + oDocumentoBE1.getIdremitente() + " then  a.idusuarioenvia else " + oDocumentoBE1.getIdremitente() + " end\n"
                        + "and (\n"
                        + "	(select array_to_string(array_agg(documento.codigo), ', ')\n"
                        + "	from documentomensaje \n"
                        + "	inner join documento  on documentomensaje.iddocumento=documento.iddocumento \n"
                        + "	where \n"
                        + "	documentomensaje.estado=true \n"
                        + "	and documento.estado=true \n"
                        + "	and documentomensaje.idmensaje=b.idmensaje)\n"
                        + "	ilike '%'||replace(rtrim(ltrim( case when ''='" + oDocumentoBE1.getCodigo_documento() + "'  then '' else '" + oDocumentoBE1.getCodigo_documento() + "' end, ' '),' '),' ','%')||'%' \n"
                        + ")";

                if (oDocumentoBE1.getFecha_inicio().length() > 0 || oDocumentoBE1.getFecha_fin().length() > 0) {
                    sql += "and (a.fecharegistro between '" + oDocumentoBE1.getFecha_inicio() + " 00:00' and '" + oDocumentoBE1.getFecha_fin() + " 23:59')";
                }
                sql += " \n";

                if (oDocumentoBE1.getCodigoexpediente() != 0) {
                    sql += " and e.codigo =  " + oDocumentoBE1.getCodigoexpediente() + "\n";
                }
                sql += " and a.estado=true\n"
                        + " and a.estado=true\n"
                        + " and a.estado=true"
                        + " ORDER BY fechaenvio DESC\n"
                        + " limit " + oDocumentoBE1.getRows() + " offset " + oDocumentoBE1.getStart();

                System.out.println("listarJQRegistroDocumentoBE 2:" + sql);

                pst = cn.prepareStatement(sql);
                // pst.setInt(1, oExpedienteBE1.getIdexpediente());
                rs = pst.executeQuery();

                while (rs.next()) {

                    DocumentoBE oDocumentoBE = new DocumentoBE();
                    oDocumentoBE.setIdrecepcioninterna(rs.getInt("idrecepcioninterna"));
                    oDocumentoBE.setIdmensaje(rs.getInt("idmensaje"));
                    oDocumentoBE.setIdareacioncreacion(rs.getInt("idareacioncreacion"));
                    oDocumentoBE.setIdusuariocreacion(rs.getInt("idusuariocreacion"));
                    oDocumentoBE.setArea_proviene(rs.getString("area"));
                    oDocumentoBE.setRemitente(rs.getString("remitente"));
                    oDocumentoBE.setCodigo_documento(rs.getString("codigo"));
                    oDocumentoBE.setAsunto(rs.getString("asunto"));
                    oDocumentoBE.setFecha_envio(rs.getString("fechaenvio"));
                    oDocumentoBE.setIdexpediente(rs.getInt("idexpediente"));
                    oDocumentoBE.setCodigoexpediente(rs.getInt("codigoexpediente"));
                    oDocumentoBE.setFechaderivacion(rs.getString("fechaderivacion"));
                    oDocumentoBE.setIdmensaje(rs.getInt("idmensaje"));
                    listaDocumentoBE.add(oDocumentoBE);
                }
                ojqbjectBE.setPage(oDocumentoBE1.getPage());
                ojqbjectBE.setTotal(oDocumentoBE1.getTotal_pages());
                ojqbjectBE.setRecords(oDocumentoBE1.getTotal());
                ojqbjectBE.setRows(listaDocumentoBE);
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
            oDocumentoBE1 = null;
        }

        return ojqbjectBE;
    }

    public int insertarRegistrosDocumentoBE(ArrayList<DocumentoBE> oListaDocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (DocumentoBE oDocumentoBE : oListaDocumentoBE) {
                cs = cn.prepareCall("{call uspInsertarDocumento(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oDocumentoBE.getIdtipodocumento());
                cs.setString(2, oDocumentoBE.getAsunto());
                cs.setString(3, oDocumentoBE.getMensaje());
                cs.setInt(4, oDocumentoBE.getPrioridad());
                cs.setBoolean(5, oDocumentoBE.isBindrespuesta());
                cs.setInt(6, oDocumentoBE.getDiasrespuesta());
                cs.setBoolean(7, oDocumentoBE.isBindllegadausuario());
                cs.setInt(8, oDocumentoBE.getIdareacioncreacion());
                cs.setInt(9, oDocumentoBE.getIdusuariocreacion());
                Date fechacreacion = new Date(oDocumentoBE.getFechacreacion().getTime());
                cs.setDate(10, fechacreacion);
                cs.setInt(11, oDocumentoBE.getIdexpediente());
                cs.setInt(12, oDocumentoBE.getCodigoexpediente());
                cs.setBoolean(13, oDocumentoBE.isEstado());
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

    public int insertarDocumentoBE(DocumentoBE oDocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspInsertarDocumento_2(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oDocumentoBE.getIdtipodocumento());
            cs.setString(2, oDocumentoBE.getCodigo());
            cs.setString(3, oDocumentoBE.getAsunto());
            cs.setString(4, oDocumentoBE.getMensaje());
            cs.setInt(5, oDocumentoBE.getPrioridad());
            cs.setBoolean(6, oDocumentoBE.isBindrespuesta());
            cs.setInt(7, oDocumentoBE.getDiasrespuesta());
            cs.setBoolean(8, oDocumentoBE.isBindllegadausuario());
            cs.setInt(9, oDocumentoBE.getIdareacioncreacion());
            cs.setInt(10, oDocumentoBE.getIdusuariocreacion());
            Date fechacreacion = new Date(oDocumentoBE.getFechacreacion().getTime());
            cs.setDate(11, fechacreacion);
            cs.setInt(12, oDocumentoBE.getIdexpediente());
            cs.setInt(13, oDocumentoBE.getCodigoexpediente());
            cs.setBoolean(14, oDocumentoBE.isEstado());
            cs.setString(15, oDocumentoBE.getFechaderivacion());
            cs.registerOutParameter(16, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(16);
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

    public int actualizarDocumentoBE(DocumentoBE oDocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspActualizarDocumento(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oDocumentoBE.getIddocumento());
            cs.setInt(2, oDocumentoBE.getIdtipodocumento());
            cs.setString(3, oDocumentoBE.getAsunto());
            cs.setString(4, oDocumentoBE.getMensaje());
            cs.setInt(5, oDocumentoBE.getPrioridad());
            cs.setBoolean(6, oDocumentoBE.isBindrespuesta());
            cs.setInt(7, oDocumentoBE.getDiasrespuesta());
            cs.setBoolean(8, oDocumentoBE.isBindllegadausuario());
            cs.setInt(9, oDocumentoBE.getIdareacioncreacion());
            cs.setInt(10, oDocumentoBE.getIdusuariocreacion());
            Date fechacreacion = new Date(oDocumentoBE.getFechacreacion().getTime());
            cs.setDate(11, fechacreacion);
            cs.setInt(12, oDocumentoBE.getIdexpediente());
            cs.setInt(13, oDocumentoBE.getCodigoexpediente());
            cs.setBoolean(14, oDocumentoBE.isEstado());
            cs.registerOutParameter(14, java.sql.Types.INTEGER);
            cs.executeUpdate();
            resultado = cs.getInt(14);
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

    public int actualizarRegistrosDocumentoBE(ArrayList<DocumentoBE> oListaDocumentos) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            for (DocumentoBE oDocumentoBE : oListaDocumentos) {
                cs = cn.prepareCall("{call uspentregaDocumento(?,?,?,?,?,?,?,?)}");
                cs.setInt(1, oDocumentoBE.getIdrecepcioninterna());
                cs.setInt(2, oDocumentoBE.getIdmensaje());
                cs.setInt(3, oDocumentoBE.getIdusuariocreacion());
                cs.setInt(4, oDocumentoBE.getIdusuariorecepciona());
                cs.setInt(5, oDocumentoBE.getIdareadestino());
                cs.setInt(6, oDocumentoBE.getIdareaproviene());
                cs.setString(7, oDocumentoBE.getFecha_envio());
                cs.registerOutParameter(8, java.sql.Types.INTEGER);
                cs.executeUpdate();
                resultado = cs.getInt(8);
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

    public int eliminarDocumentoBE(DocumentoBE oDocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspEliminarDocumento(?)}");
            cs.setInt(1, oDocumentoBE.getIddocumento());
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

    public int derivarDocumentoBE(DocumentoBE oDocumentoBE) throws SQLException {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;
        try {
            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);

            cn.setAutoCommit(false);

            cs = cn.prepareCall("{call uspderivardocumento(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            cs.setInt(1, oDocumentoBE.getIdtipodocumento());
            cs.setString(2, oDocumentoBE.getAsunto());
            cs.setString(3, oDocumentoBE.getMensaje());
            cs.setInt(4, oDocumentoBE.getPrioridad());
            cs.setBoolean(5, oDocumentoBE.isBindrespuesta());
            cs.setInt(6, oDocumentoBE.getDiasrespuesta());
            cs.setBoolean(7, oDocumentoBE.isBindllegadausuario());
            cs.setInt(8, oDocumentoBE.getIdareacioncreacion());
            cs.setInt(9, oDocumentoBE.getIdusuariocreacion());
            Date fechacreacion = new Date(oDocumentoBE.getFechacreacion().getTime());
            cs.setDate(10, fechacreacion);
            cs.setInt(11, oDocumentoBE.getIdexpediente());
            cs.setInt(12, oDocumentoBE.getCodigoexpediente());
            cs.setBoolean(13, oDocumentoBE.isEstado());
            cs.setString(14, oDocumentoBE.getCodigo());
            cs.setInt(15, oDocumentoBE.getIdareadestino());
            cs.registerOutParameter(16, java.sql.Types.INTEGER);
            cs.execute();
            resultado = cs.getInt(16);
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

    public List listObjectDocumentoBE(DocumentoBE oDocumentoBE) throws SQLException {
        List list = new LinkedList();
        Connection cn = null;
        ResultSet rs = null;
        PreparedStatement pst = null;
        String sql = "";

        try {

            Class.forName(DriverConnection);
            cn = DriverManager.getConnection(cadenaConexion, user, password);
            cn.setAutoCommit(false);

            if (oDocumentoBE.getIndOpSp() == 1) {
                sql = " SELECT iddocumento,tipodocumento,asunto,mensaje,prioridad,bindrespuesta,diasrespuesta,bindllegadausuario,idareacioncreacion,idusuariocreacion,fechacreacion,idexpediente,codigoexpediente,estado FROM documento WHERE iddocumento=? and estado=true";
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }

            if (oDocumentoBE.getIndOpSp() == 2) {
                sql = "select a.codigo,b.nombres ||' '||b.apellidos usuario,c.denominacion,\n"
                        + "a.asunto,a.mensaje,to_char(a.fechacreacion,'DD/MM/YYYY HH24:MI:SS') from documento a\n"
                        + "inner join usuario b on a.idusuariocreacion=b.idusuario\n"
                        + "inner join area c on a.idareacioncreacion=c.idarea\n"
                        + "where iddocumento=" + oDocumentoBE.getIddocumento();
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6)};
                    list.add(obj);
                }

            }
            if (oDocumentoBE.getIndOpSp() == 3) {
                sql = "select b.iddocumento,b.codigo from referencia a \n"
                        + "inner join documento b on a.iddocumentoreferencia=b.iddocumento\n"
                        + "where a.iddocumento=" + oDocumentoBE.getIddocumento();
                pst = cn.prepareStatement(sql);
                //pst.setString(1, oInformacionBE.getCodigocliente());
                rs = pst.executeQuery();
                System.out.println("sql: " + sql);

                while (rs.next()) {
                    Object[] obj = {rs.getString(1), rs.getString(2)};
                    list.add(obj);
                }

            }
            if (oDocumentoBE.getIndOpSp() == 4) {
                sql = "select nombre,url from archivodocumento\n"
                        + "where documento=" + oDocumentoBE.getIddocumento();
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
            oDocumentoBE = null;
        }
        return list;
    }

}
