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
public class Calculadora {

    private int a = 5, b = 7;

    public int getA() {
        return a;
    }

    public void setA(int a) {
        this.a = a;
    }

    public int getB() {
        return b;
    }

    public void setB(int b) {
        this.b = b;
    }

    public int suma(int _a, int _b) {
        return a + b;
    }

    public int resta(int _a, int _b) {
        return _a - _b;
    }

    public int divicion(int _a, int _b) {
        return _a / b;
    }

    public int divicion2(int _a, int _b) {
        return _a / _b;
    }

}
