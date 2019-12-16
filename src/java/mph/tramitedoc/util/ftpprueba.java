/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.util;

import java.io.IOException;
import java.net.Socket;
import mph.tramitedoc.security.Cripto;

/**
 *
 * @author Erik
 */
public class ftpprueba {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException, Exception {
        
        Cripto oCripto = new Cripto();
        System.out.println(""+oCripto.Desencriptar("5k93/mmHC4gSv9qcpZqkgo2KURnWIdg48zMKj0IN/ZWQ+CdIHp4eAuqZsyLqxrcgjzJsop0qLQs\\="));
    }
    
}
