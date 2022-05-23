package com.stripe.keithtest;

public class Dep2 {
    public static void run() {
        System.out.println("yo");
        Dep3.run();
    }
}
