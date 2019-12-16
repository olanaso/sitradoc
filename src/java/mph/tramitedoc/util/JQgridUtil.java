/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import mph.tramitedoc.be.BaseBE;
import mph.tramitedoc.da.BaseDA;

/**
 *
 * @author Erik
 */
public class JQgridUtil {

    public void calcPagination(Connection cn, ResultSet rs, PreparedStatement pst, String sql, BaseBE base) throws SQLException {
        pst = cn.prepareStatement(sql);
        rs = pst.executeQuery();

        while (rs.next()) {
            base.setTotal(rs.getInt(1));
        }

        if (base.getTotal() > 0) {
            double total_pages = Math.ceil(base.getTotal().doubleValue() / base.getRows().doubleValue());
            base.setTotal_pages((int) (total_pages));

        } else {
            base.setTotal_pages(0);
        }

        if (base.getPage() > base.getTotal_pages()) {
            base.setPage(base.getTotal_pages());

        }
        if (base.getPage() == 0) {
            base.setStart(base.getRows() * 1 - base.getRows());
        } else {
            base.setStart(base.getRows() * base.getPage() - base.getRows());
        }
        //base.setStart(base.getRows() * base.getPage() - base.getRows());
    }

}
