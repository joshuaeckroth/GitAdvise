% run as:
%
% pl -s test.pl -t run_tests

:- use_module(library(test_cover)).

:- begin_tests(gitplanner).
:- [gitplanner].

test(findplan_simple, [nondet]) :-
    findplan([state('a.txt', untracked)],
             [state('a.txt', added)],
             % desired final repo
             [state('a.txt', added)],
             % desired final actions
             [['add', 'a.txt']]).

test(findplan_order_matters, [nondet]) :-
    findplan([state('a.txt', untracked),
              state('b.txt', untracked)],
             [state('a.txt', added),
              state('b.txt',committed)],
             % desired final repo
             [state('a.txt', added),
              state('b.txt', committed)],
             % desired final actions
             [['add', 'b.txt'], ['commit'], ['add', 'a.txt']]).


:- end_tests(gitplanner).


