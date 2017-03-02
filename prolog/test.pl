% run as:
%
% swipl -s test.pl -t run_tests

:- use_module(library(test_cover)).

:- begin_tests(gitplanner).
:- [gitplanner].

test(findplan_simple, [nondet]) :-
    findplan([state('a.txt', untracked)],
             [state('a.txt', addedToIndex)],
             % desired final repo
             [state('a.txt', addedToIndex)],
             % desired final actions
             [['add', 'a.txt']]).

test(findplan_order_matters, [nondet]) :-
    findplan([state('a.txt', untracked),
              state('b.txt', untracked)],
             [state('a.txt', addedToIndex),
              state('b.txt', committed)],
             % desired final repo
             FinalRepo,
             % desired final actions
             [['add', 'b.txt'], ['commit'], ['add', 'a.txt']]),
    sort([state('a.txt', addedToIndex),
          state('b.txt', committed)],
         FinalRepoSet),
    sort(FinalRepo, FinalRepoSet).

test(findplan_prob1, [nondet]) :-
    findplan([state('a.txt', untracked)],
             [state('a.txt', committed)],
             [state('a.txt', committed)],
             [['add', 'a.txt'], ['commit']]).

test(findplan_prob2, [nondet]) :-
    findplan([state('a.txt', addedToIndex),
              state('b.txt', untracked)],
             [state('a.txt', untracked),
              state('b.txt', committed)],
             FinalRepo,
             [['reset', 'a.txt'], ['add', 'b.txt'], ['commit']]),
    sort([state('a.txt', untracked),
          state('b.txt', committed)],
         FinalRepoSet),
    sort(FinalRepo, FinalRepoSet).

test(findplan_prob3, [nondet]) :-
    findplan([state('b.txt', addedToIndex),
              state('a.txt', untracked)],
             [state('a.txt', untracked),
              state('b.txt', nostatus)],
             FinalRepo,
             [['reset-hard']]),
    sort([state('a.txt', untracked),
          state('b.txt', nostatus)],
         FinalRepoSet),
    sort(FinalRepo, FinalRepoSet).

test(findplan_prob4, [nondet]) :-
    findplan([state('a.txt', modifiedInWorkspace),
              state('b.txt', deletedInWorkspace)],
             [state('b.txt', deletedFromIndex),
              state('a.txt', committed)],
             FinalRepo,
             [['add', 'a.txt'], ['commit'], ['add', 'b.txt']]),
    sort([state('b.txt', deletedFromIndex),
          state('a.txt', committed)],
         FinalRepoSet),
    sort(FinalRepo, FinalRepoSet).

test(findplan_prob5, [nondet]) :-
    findplan([state('a.txt', updatedInIndex),
              state('b.txt', deletedInWorkspace),
              state('c.txt', untracked)],
             [state('a.txt', modifiedInWorkspace),
              state('b.txt', deletedFromIndex),
              state('c.txt', committed)],
             FinalRepo,
             [['reset', 'a.txt'], ['add', 'c.txt'], ['commit'], ['add', 'b.txt']]),
    sort([state('a.txt', modifiedInWorkspace),
          state('b.txt', deletedFromIndex),
          state('c.txt', committed)],
         FinalRepoSet),
    sort(FinalRepo, FinalRepoSet).

:- end_tests(gitplanner).


