/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.system;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import mph.tramitedoc.security.Cripto;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.JDOMException;
import org.jdom2.input.SAXBuilder;
import org.jdom2.output.XMLOutputter;




public class XMLConfiguration {
     public boolean saveXmlParametrosSystem(String url) {
       // Cripto cripto=new Cripto();

        Element root = new Element("cronos");

        root.setAttribute("sistema", "Geosolution");
        //nodos hijos mayores
        Element servidor = new Element("servidor");
        Element cliente = new Element("cliente");
        Element otroServidor = new Element("otro_servidor");
        Element otros = new Element("otros");
        Element path = new Element("path");

        //servidor
        Element itemDriver = new Element("driver");
        itemDriver.setText(ParametrosSystem.getDriverPostgres());
        servidor.addContent(itemDriver);

        Element itemUrl = new Element("url");
        itemUrl.setText(ParametrosSystem.getUrlPostgres());
        servidor.addContent(itemUrl);

        Element itemIpServidor = new Element("ip_servidor");
        itemIpServidor.setText(ParametrosSystem.getIpServidor());
        servidor.addContent(itemIpServidor);

        Element itemNombreDB = new Element("db");
        itemNombreDB.setText(ParametrosSystem.getBaseDatos());
        servidor.addContent(itemNombreDB);

        Element itemNombrePcServidor = new Element("nombre_servidor");
        itemNombrePcServidor.setText(ParametrosSystem.getNombrePcServidor());
        servidor.addContent(itemNombrePcServidor);

        Element itemPuerto = new Element("puerto");
        itemPuerto.setText(ParametrosSystem.getPuertoPostgres());
        servidor.addContent(itemPuerto);

        Element itemUsuario = new Element("usuario");
        itemUsuario.setText(ParametrosSystem.getUsuarioPostgres());
        servidor.addContent(itemUsuario);

        Element itemPassword = new Element("password");
        itemPassword.setText(ParametrosSystem.getPasswordPostgres());
        servidor.addContent(itemPassword);

        Element itemNickCronos = new Element("nick");
        itemNickCronos.setText(ParametrosSystem.getNickSistema());
        servidor.addContent(itemNickCronos);

        //cliente
        Element itemIpCliente = new Element("ip_cliente");
        itemIpCliente.setText(ParametrosSystem.getNombrePcCliente());
        cliente.addContent(itemIpCliente);

        Element itemNombrePcCliente = new Element("nombre_cliente");
        itemNombrePcCliente.setText(ParametrosSystem.getNombrePcCliente());
        cliente.addContent(itemNombrePcCliente);

        //otro servidor
        Element itemIpOtroServidor = new Element("otro_ip_servidor");
        itemIpOtroServidor.setText(ParametrosSystem.getOtroIpServidor());
        otroServidor.addContent(itemIpOtroServidor);

        Element itemOtroPuerto = new Element("otro_puerto");
        itemOtroPuerto.setText(ParametrosSystem.getOtroPuertoPostgres());
        otroServidor.addContent(itemOtroPuerto);

        Element itemOtroDB = new Element("otro_db");
        itemOtroDB.setText(ParametrosSystem.getOtroDB());
        otroServidor.addContent(itemOtroDB);

        //otros
        Element itemEsServidor = new Element("es_servidor");
        itemEsServidor.setText(ParametrosSystem.getEsServidor());
        otros.addContent(itemEsServidor);

        Element itemOcurrioInterrupcion = new Element("interrupcion");
        itemOcurrioInterrupcion.setText(ParametrosSystem.getInterrupcion());
        otros.addContent(itemOcurrioInterrupcion);

        Element itemHoraCierrePlanilla = new Element("hora_cierre_planilla");
        itemHoraCierrePlanilla.setText(ParametrosSystem.getHoraCierrePlanilla());
        otros.addContent(itemHoraCierrePlanilla);

        Element itemEsAuotorizadoCopia = new Element("es_autorizado_backup");
        itemEsAuotorizadoCopia.setText(ParametrosSystem.getEsAutorizado());
        otros.addContent(itemEsAuotorizadoCopia);

        //path
        Element itemPathReporte = new Element("path_reporte");
        itemPathReporte.setText(ParametrosSystem.getPathReport());
        path.addContent(itemPathReporte);

        Element itemPathPgDump = new Element("path_pg_dump");
        itemPathPgDump.setText(ParametrosSystem.getPathPgDumpPostgres());
        path.addContent(itemPathPgDump);

        Element itemPathBackup = new Element("path_backup");
        itemPathBackup.setText(ParametrosSystem.getPathBackup());
        path.addContent(itemPathBackup);
        
         Element itemEditorGeo = new Element("editor_geo");
        itemEditorGeo.setText(ParametrosSystem.getTxtEditorLayer());
        path.addContent(itemEditorGeo);

        //agregamos al root
        root.addContent(servidor);
        root.addContent(cliente);
        root.addContent(otroServidor);
        root.addContent(otros);
        root.addContent(path);

        // Realizamos lo mismo con los elementos restantes
        XMLOutputter outputter = new XMLOutputter();
        try {
            System.out.println("url save"+url);
            outputter.output(new Document(root), new FileOutputStream(url+"/config.xml"));
            return true;
        } catch (Exception e) {
            System.out.println("error: "+e.getMessage());
            return false;
        }
    }

    public boolean readXmlParametrosSystem(String path) {
        File file = new File(path+"/config.xml");
        SAXBuilder sAXBuilder = new SAXBuilder();
        if (file.exists()) {
            Cripto cripto=new Cripto();
            try {
                Document documento = sAXBuilder.build(file);
                Element root = documento.getRootElement();
                /**------------------servidor---------------------------*/
                Element nodoServidor = root.getChild("servidor");
                //hijos
                ParametrosSystem.setDriverPostgres(nodoServidor.getChild("driver").getText());
                ParametrosSystem.setUrlPostgres(nodoServidor.getChild("url").getText());
                ParametrosSystem.setIpServidor(nodoServidor.getChild("ip_servidor").getText());
                ParametrosSystem.setBaseDatos(nodoServidor.getChild("db").getText());
                ParametrosSystem.setNombrePcServidor(nodoServidor.getChild("nombre_servidor").getText());
                ParametrosSystem.setPuertoPostgres(nodoServidor.getChild("puerto").getText());
                ParametrosSystem.setUsuarioPostgres(nodoServidor.getChild("usuario").getText());
                ParametrosSystem.setPasswordPostgres(nodoServidor.getChild("password").getText());
                ParametrosSystem.setNickSistema(nodoServidor.getChild("nick").getText());
                

                /**------------------ciente---------------------------*/
                 Element nodoCliente = root.getChild("cliente");
                //hijos
                ParametrosSystem.setIpCliente(nodoCliente.getChild("ip_cliente").getText());
                ParametrosSystem.setNombrePcCliente(nodoCliente.getChild("nombre_cliente").getText());

                /**------------------otro servidor---------------------------*/
                 Element nodoOtrosServidor = root.getChild("otro_servidor");
                //hijos
                ParametrosSystem.setOtroIpServidor(nodoOtrosServidor.getChild("otro_ip_servidor").getText());
                ParametrosSystem.setOtroPuertoPostgres(nodoOtrosServidor.getChild("otro_puerto").getText());
                ParametrosSystem.setOtroDB(nodoOtrosServidor.getChild("otro_db").getText());

                /**------------------otros---------------------------*/
                   Element nodoOtros = root.getChild("otros");
                //hijos
                ParametrosSystem.setEsServidor(nodoOtros.getChild("es_servidor").getText());
                ParametrosSystem.setInterrupcion(nodoOtros.getChild("interrupcion").getText());
                ParametrosSystem.setHoraCierrePlanilla(nodoOtros.getChild("hora_cierre_planilla").getText());
                ParametrosSystem.setEsAutorizado(nodoOtros.getChild("es_autorizado_backup").getText());
                /**------------------otros---------------------------*/
                 Element nodoPath = root.getChild("path");
                //hijos
                ParametrosSystem.setPathReport(nodoPath.getChild("path_reporte").getText());
                ParametrosSystem.setPathPgDumpPostgres(nodoPath.getChild("path_pg_dump").getText());
                ParametrosSystem.setPathBackup(nodoPath.getChild("path_backup").getText());
                ParametrosSystem.setTxtEditorLayer(nodoPath.getChild("editor_geo").getText());

                return true;
            } catch (JDOMException ex) {
                Logger.getLogger(XMLConfiguration.class.getName()).log(Level.SEVERE, null, ex);
                return false;
            } catch (IOException ex) {
                Logger.getLogger(XMLConfiguration.class.getName()).log(Level.SEVERE, null, ex);
                return false;
            }
        } else {
            return false;
        }
    }
    public boolean existeXml() {
        File file = new File("config.xml");
        if (file.exists()) {
           return true;
        } else {
            return false;
        }
    }
}
