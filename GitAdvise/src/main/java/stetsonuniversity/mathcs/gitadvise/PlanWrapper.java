package stetsonuniversity.mathcs.gitadvise;

import java.util.Map;
import java.io.InputStream;

import alice.tuprolog.*;
import alice.tuprolog.lib.*;
import alice.tuprolog.event.*;

public class PlanWrapper {
    public static void main(String[] args) throws Exception {
        testPlanner("gitplanner2.pl");
    }
    public static void testPlanner(String planFile) throws Exception {
        Prolog engine = new Prolog();
        InputStream planFileStream = PlanWrapper.class.getClassLoader().getResourceAsStream(planFile);
        Theory theory = new Theory(planFileStream);
        engine.setTheory(theory);
    }
}

