
% git business

:- use_module(library(git)).



% SHA-1 handling

:- use_module(crypto).

fileState(F, Hash) :-
    file_sha1(F, Hash).



% state(F, State), e.g., state('a.txt', untracked)

add(F, Repo, Actions, Explanations, NewRepo, [['add',F]|Actions], [Expl|Explanations]) :-
    member(state(F, untracked), Repo),
    delete(Repo, state(F, untracked), Repo2),
    NewRepo = [state(F, addedToIndex)|Repo2],
    atomics_to_string(["Changes", F, "state from untracked to addedToIndex"], ' ', Expl).

add(F, Repo, Actions, Explanations, NewRepo, [['add',F]|Actions], ["No expl!"|Explanations]) :-
    member(state(F, modifiedInWorkspace), Repo),
    delete(Repo, state(F, modifiedInWorkspace), Repo2),
    NewRepo = [state(F, updatedInIndex)|Repo2].

add(F, Repo, Actions, Explanations, NewRepo, [['add',F]|Actions], ["No expl!"|Explanations]) :-
    member(state(F, deletedInWorkspace), Repo),
    delete(Repo, state(F, deletedInWorkspace), Repo2),
    NewRepo = [state(F, deletedFromIndex)|Repo2].


commitRepoUpdate([], Repo, Repo).
commitRepoUpdate([F|Files], Repo, NewRepo) :-
    member(state(F, addedToIndex), Repo),
    delete(Repo, state(F, addedToIndex), Repo2),
    Repo3 = [state(F, committed)|Repo2],
    commitRepoUpdate(Files, Repo3, NewRepo).
commitRepoUpdate([F|Files], Repo, NewRepo) :-
    member(state(F, updatedInIndex), Repo),
    delete(Repo, state(F, updatedInIndex), Repo2),
    Repo3 = [state(F, committed)|Repo2],
    commitRepoUpdate(Files, Repo3, NewRepo).

commit(Repo, Actions, Explanations, NewRepo, [['commit']|Actions], ["No expl!"|Explanations]) :-
    bagof(F, (member(state(F, addedToIndex), Repo);
              member(state(F, updatedInIndex), Repo)),
          Files),
    commitRepoUpdate(Files, Repo, NewRepo).

resetHardRepoUpdate([], Repo, Repo).
resetHardRepoUpdate([F|Files], Repo, NewRepo) :-
    member(state(F, addedToIndex), Repo),
    delete(Repo, state(F, addedToIndex), Repo2),
    Repo3 = [state(F, nostatus)|Repo2],
    resetHardRepoUpdate(Files, Repo3, NewRepo).
resetHardRepoUpdate([F|Files], Repo, NewRepo) :-
    member(state(F, updatedInIndex), Repo),
    delete(Repo, state(F, updatedInIndex), Repo2),
    Repo3 = [state(F, nostatus)|Repo2],
    resetHardRepoUpdate(Files, Repo3, NewRepo).
resetHardRepoUpdate([F|Files], Repo, NewRepo) :-
    member(state(F, deletedFromIndex), Repo),
    delete(Repo, state(F, deletedFromIndex), Repo2),
    Repo3 = [state(F, nostatus)|Repo2],
    resetHardRepoUpdate(Files, Repo3, NewRepo).

resetHard(Repo, Actions, Explanations, NewRepo, [['reset-hard']|Actions], ["No expl!"|Explanations]) :-
    bagof(F, (member(state(F, addedToIndex), Repo);
              member(state(F, updatedInIndex), Repo);
              member(state(F, deletedFromIndex), Repo)),
          Files),
    resetHardRepoUpdate(Files, Repo, NewRepo).

reset(F, Repo, Actions, Explanations, NewRepo, [['reset',F]|Actions], ["No expl!"|Explanations]) :-
    member(state(F, addedToIndex), Repo),
    delete(Repo, state(F, addedToIndex), Repo2),
    NewRepo = [state(F, untracked)|Repo2].

reset(F, Repo, Actions, Explanations, NewRepo, [['reset',F]|Actions], ["No expl!"|Explanations]) :-
    member(state(F, updatedInIndex), Repo),
    delete(Repo, state(F, updatedInIndex), Repo2),
    NewRepo = [state(F, modifiedInWorkspace)|Repo2].

reset(F, Repo, Actions, Explanations, NewRepo, [['reset',F]|Actions], ["No expl!"|Explanations]) :-
    member(state(F, deletedFromIndex), Repo),
    delete(Repo, state(F, deletedFromIndex), Repo2),
    NewRepo = [state(F, deletedInWorkspace)|Repo2].



% put no-op first so it's preferred
findplan(_, Repo, Actions, Explanations, Repo, Actions, Explanations).

findplan(Files, Repo, Actions, Explanations, FinalRepo, FinalActions, FinalExplanations) :-
    member(F, Files),
    (add(F, Repo, Actions, Explanations, NewRepo, NewActions, NewExplanations);
     reset(F, Repo, Actions, Explanations, NewRepo, NewActions, NewExplanations)),
    delete(Files, F, Files2),
    findplan(Files2, NewRepo, NewActions, NewExplanations, FinalRepo, FinalActions, FinalExplanations).

findplan(Files, Repo, Actions, Explanations, FinalRepo, FinalActions, FinalExplanations) :-
    (commit(Repo, Actions, Explanations, NewRepo, NewActions, NewExplanations);
     resetHard(Repo, Actions, Explanations, NewRepo, NewActions, NewExplanations)),
    findplan(Files, NewRepo, NewActions, NewExplanations, FinalRepo, FinalActions, FinalExplanations).

goalmetfile(F, Repo, Goal) :-
    member(state(F, State), Goal),
    member(state(F, State), Repo).

goalmetfiles([], _, _).
goalmetfiles([F|Files], Repo, Goal) :-
    goalmetfile(F, Repo, Goal),
    goalmetfiles(Files, Repo, Goal).

goalsmet(Repo, Goal) :-
    findall(F, member(state(F, _), Goal), Files),
    goalmetfiles(Files, Repo, Goal).

% example usage:
% findplan([state('a.txt', untracked)], [state('a.txt', added)], FinalRepo, FinalActions).
% findplan([state('a.txt', untracked), state('b.txt', untracked)], [state('a.txt', added), state('b.txt', committed)], FinalRepo, FinalActions).
findplan(Repo, Goal, FinalRepo, FinalActions, FinalExplanations) :-
    findall(F, member(state(F, _), Repo), Files),
    findplan(Files, Repo, [], [], FinalRepo, ReverseActions, ReverseExplanations),
    goalsmet(FinalRepo, Goal),
    reverse(ReverseActions, FinalActions),
    reverse(ReverseExplanations, FinalExplanations).

%call this when actually running the planner
findplanexternal(Repo, Goal, FinalRepo, FinalActions, FinalExplanations) :-
    findall(F, member(state(F, _), Repo), Files),
    findplan(Files, Repo, [], [], FinalRepo, ReverseActions, ReverseExplanations),
    goalsmet(FinalRepo, Goal),
    reverse(ReverseActions, FinalActions),
    reverse(ReverseExplanations, FinalExplanations),
    print(FinalActions),
    print(FinalExplanations),
    nl.

