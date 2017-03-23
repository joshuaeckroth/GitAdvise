
import java.util.Map;

import org.jpl7.JPL;
import org.jpl7.Query;
import org.jpl7.Term;

class PlanWrapper {
    public static void main(String[] args) {
		Query.hasSolution("use_module(library(jpl))"); // only because we call e.g. jpl_pl_syntax/1 below
		Term swi = Query.oneSolution("current_prolog_flag(version_data,Swi)").get("Swi");
		System.out.println("swipl.version = " + swi.arg(1) + "." + swi.arg(2) + "." + swi.arg(3));
		System.out.println("swipl.syntax = " + Query.oneSolution("jpl_pl_syntax(Syntax)").get("Syntax"));
		System.out.println("swipl.home = " + Query.oneSolution("current_prolog_flag(home,Home)").get("Home").name());
		System.out.println("jpl.jar = " + JPL.version_string());
		System.out.println("jpl.dll = " + org.jpl7.fli.Prolog.get_c_lib_version());
		System.out.println("jpl.pl = " + Query.oneSolution("jpl_pl_lib_version(V)").get("V").name());
		//
		String t1 = "consult('gitplanner.pl')";
		System.out.println(t1 + " " + (Query.hasSolution(t1) ? "succeeded" : "failed"));
		//
		String t2 = "findplanexternal([state('prolog/PlanWrapper.py', modifiedInWorkspace), state('prolog/a.txt', addedToIndex), state('prolog/a.txt', index-workspace-match), state('prolog/gitplanner.pl', modifiedInWorkspace), state('prolog/b.txt', untracked), state('prolog/tmp/', untracked)], [state('prolog/PlanWrapper.py', modifiedInWorkspace), state('prolog/a.txt', committed), state('prolog/gitplanner.pl', modifiedInWorkspace), state('prolog/b.txt', committed), state('prolog/tmp/', untracked)], FinalRepo, FinalActions, FinalExplanations)";
		System.out.println(t2 + " is " + (Query.hasSolution(t2) ? "provable" : "not provable"));
		//
		Map<String, Term>[] ss4 = Query.allSolutions(t2);
		System.out.println("all solutions of " + t2);
		for (int i = 0; i < ss4.length; i++) {
			System.out.println("FinalActions = " + ss4[i].get("FinalActions"));
		}
        
    }
}

