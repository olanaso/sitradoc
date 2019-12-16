/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Random;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * @author Erik
 */
public class NameUNIQUE {

    public String geneNameUNIQUE(MultipartFile mpf) {
        Random rand = new Random();
        int n = rand.nextInt(1000) + 1;
        int n2 = rand.nextInt(100) + 1;
        int n3 = rand.nextInt(10) + 1;
        DateFormat df = new SimpleDateFormat("dd-MM-yyyy:HH:mm:ss");
        Calendar calobj = Calendar.getInstance();
        String _filename = df.format(calobj.getTime());
        _filename = _filename.replaceAll(":", "").replaceAll("-", "");
        int _fileExtensionIndex = mpf.getOriginalFilename().lastIndexOf('.');
        System.out.println("" + mpf.getName());
        String _fileExtension = mpf.getOriginalFilename().substring(_fileExtensionIndex + 1);
        _filename = _filename + "_" + n + "" + n2 + "" + n3 + "." + _fileExtension;
        return _filename;
    }

}
