print_episodes_all(Names, W, I):-
    format(atom(Out_file), '../MetagolD/polygons/raw/~w_~d_episodes.pl', [W, I]),
    tell(Out_file),
    gen_episodes(Names, W, I),
    told.

print_episodes_all(Names, W):-
    format(atom(Out_file), '../MetagolD/polygons/raw/~w_episodes.pl', [W]),
    tell(Out_file),
    gen_episodes(Names, W),
    told.

print_episodes_all_nodup(Names, W):-
    format(atom(Out_file), '../MetagolD/polygons/raw/~w_episodes.pl', [W]),
    tell(Out_file),
    gen_episodes_nodup(Names, W),
    told.

gen_episodes([], _):-
    true.
gen_episodes([N | Ns], W):-
    gen_episode(N, W),
    writeln(''),
    gen_episodes(Ns, W).

gen_episodes_nodup([], _):-
    true.
gen_episodes_nodup([N | Ns], W):-
    gen_episode_nodup(N, W),
    writeln(''),
    gen_episodes_nodup(Ns, W).

gen_episodes([], _, _):-
    true.
gen_episodes([N | Ns], W, I):-
    gen_episode(N, W, I),
    writeln(''),
    gen_episodes(Ns, W, I).

gen_episode(Name, W):-
    % format(atom(Poly_file), '../../results/~w_bk.pl', [W]),
    format(atom(Label_file), '../MetagolD/polygons/raw/~w_label.pl', [W]),
    write('episode('),
    write(Name),
    writeln(','),
    evaluate_all_labels(Name, Poly_file, Label_file, Pos, Neg),
    writeln('\t['),
    print_episodes(Name, Pos),
    writeln('\t],'),
    writeln('\t['),
    print_episodes(Name, Neg),
    writeln('\t]'),
    writeln('       ).').

gen_episode_nodup(Name, W):-
    % format(atom(Poly_file), '../../results/~w_bk.pl', [W]),
    format(atom(Label_file), '../MetagolD/polygons/raw/~w_label.pl', [W]),
    write('episode('),
    write(Name),
    writeln(','),
    evaluate_all_labels_nodup(Name, Poly_file, Label_file, Pos, Neg),
    writeln('\t['),
    print_episodes(Name, Pos),
    writeln('\t],'),
    writeln('\t['),
    print_episodes(Name, Neg),
    writeln('\t]'),
    writeln('       ).').

gen_episode(Name, W, I):-
    format(atom(Poly_file), '../../results/~w_~d_R.pl', [W, I]),
    format(atom(Label_file), '../MetagolD/polygons/raw/~w_~d_label.pl', [W, I]),
    write('episode('),
    write(Name),
    writeln(','),
    evaluate_all_labels(Name, Poly_file, Label_file, Pos, Neg),
    writeln('\t['),
    print_episodes(Name, Pos),
    writeln('\t],'),
    writeln('\t['),
    print_episodes(Name, Neg),
    writeln('\t]'),
    writeln('       ).').

evaluate_all_labels(Name, Poly_file, Label_file, Pos, Neg):-
    unload_file('./labeler.pl'),
    % [Poly_file],
    [Label_file],
    atomic_concat(not_, Name, Neg_name),
    % findall(P, (polygon(P, _), call(Name, P)), Pos_),
    findall(P, (call(Name, P)), Pos_),
    % duplicate poss
    duplicate_examples(Pos_, Pos, 4, []),
    % findall(P, (polygon(P, _), call(Neg_name, P)), Neg_),
    findall(P, (call(Neg_name, P)), Neg_),
    % duplicate negs
    duplicate_examples(Neg_, Neg, 4, []),
    % unload_file(Poly_file),
    unload_file(Label_file),
    ['./labeler.pl'].

evaluate_all_labels_nodup(Name, Poly_file, Label_file, Pos, Neg):-
    unload_file('./labeler.pl'),
    % [Poly_file],
    [Label_file],
    atomic_concat(not_, Name, Neg_name),
    % findall(P, (polygon(P, _), call(Name, P)), Pos_),
    findall(P, (call(Name, P)), Pos),
    % findall(P, (polygon(P, _), call(Neg_name, P)), Neg_),
    findall(P, (call(Neg_name, P)), Neg),
    % unload_file(Poly_file),
    unload_file(Label_file),
    ['./labeler.pl'].


duplicate_examples([], Return, _, Return).
duplicate_examples([E | Es], Return, N, Temp):-
    dup_n_times(E, Dup_E, N, []),
    append(Temp, Dup_E, Temp_1),
    duplicate_examples(Es, Return, N, Temp_1).

dup_n_times(_, Return, -1, Temp):-
    reverse(Temp, [], Return), !.
dup_n_times(E, Dup_E, N, Temp):-
    concat(E, '_', E_),
    concat(E_, N, EN),
    append(Temp, [EN], Temp_1),
    N1 is N - 1,
    dup_n_times(E, Dup_E, N1, Temp_1).

print_episodes(Name, [Obj | []]):-
    write('\t ['),
    write(Name),
    write(', '),
    write(Obj),
    writeln(']'),
    !.
print_episodes(_, []):-
    writeln(''),
    !.
print_episodes(Name, [Obj | Objs]):-
    write('\t ['),
    write(Name),
    write(', '),
    write(Obj),
    writeln('],'),
    print_episodes(Name, Objs).
