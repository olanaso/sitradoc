/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.util;

/**
 *
 * @author Erik
 */
public class PruebaCipher {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
       Blowfish oBlowfish=new Blowfish(Parameter.password_key);
        System.out.println(""+oBlowfish.decrypt("3e7459951de763139d425e653854f01ee7711ec42e7ed0c2"));
        System.out.println(""+oBlowfish.decrypt("cfc0ad1bdb9a8f1e614dc37261dcf29923f37e108000e18f"));
    }
    
}
