
% state(F, State), e.g., state('a.txt', untracked)

add(F, Repo, Actions, NewRepo, [['add',F]|Actions]) :-
    member(state(F, untracked), Repo),
    delete(Repo, state(F, untracked), Repo2),
    NewRepo = [state(F, added)|Repo2].

add(F, Repo, Actions, NewRepo, [['add',F]|Actions]) :-
    member(state(F, modified), Repo),
    delete(Repo, state(F, modified), Repo2),
    NewRepo = [state(F, added)|Repo2].

commitRepoUpdate([], Repo, Repo).
commitRepoUpdate([F|Files], Repo, NewRepo) :-
    delete(Repo, state(F, added), Repo2),
    Repo3 = [state(F, commited)|Repo2],
    commitRepoUpdate(Files, Repo3, NewRepo).

commit(Repo, Actions, NewRepo, [['commit']|Actions]) :-
    bagof(F, member(state(F, added), Repo), Files), % fails if finds nothing
    print('Files'), print(Files),
    commitRepoUpdate(Files, Repo, NewRepo).

reset(F, Repo, Actions, NewRepo, [['reset',F]|Actions]) :-
    member(state(F, added), Repo),
    delete(Repo, state(F, added), Repo2),
    NewRepo = [state(F, modified)|Repo2].

% put no-op first so it's preferred
findplan(_, Repo, Actions, Repo, Actions).

findplan(Files, Repo, Actions, FinalRepo, FinalActions) :-
    member(F, Files),
    print('here:'), print(F), nl,
    (add(F, Repo, Actions, NewRepo, NewActions);
     reset(F, Repo, Actions, NewRepo, NewActions)),
    delete(Files, F, Files2),
    findplan(Files2, NewRepo, NewActions, FinalRepo, FinalActions).

findplan(Files, Repo, Actions, FinalRepo, FinalActions) :-
    commit(Repo, Actions, NewRepo, NewActions),
    findplan(Files, NewRepo, NewActions, FinalRepo, FinalActions).

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
% findplan([state('a.txt', untracked), state('b.txt', untracked)], [state('a.txt', added), state('b.txt', commited)], FinalRepo, FinalActions).
findplan(Repo, Goal, FinalRepo, FinalActions) :-
    findall(F, member(state(F, _), Repo), Files),
    findplan(Files, Repo, [], FinalRepo, ReverseActions),
    goalsmet(FinalRepo, Goal),
    reverse(ReverseActions, FinalActions).


