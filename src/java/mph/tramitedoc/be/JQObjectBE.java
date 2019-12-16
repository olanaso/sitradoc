/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package mph.tramitedoc.be;

import java.util.ArrayList;

/**
 *
 * @author Erik
 */
public class JQObjectBE<T>{

    private Integer page;
    private Integer total;
    private Integer records;
    private ArrayList<T> rows;
   // private T objectGeneric;

    //private JQObjectBE T;
    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public Integer getRecords() {
        return records;
    }

    public void setRecords(Integer records) {
        this.records = records;
    }

 
    public ArrayList<T> getRows() {
        return rows;
    }

    public void setRows(ArrayList<T> rows) {
        this.rows = rows;
    }

   

}
