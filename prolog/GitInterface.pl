gitStatus(Status) :-
	git(['status','--porcelain', '-z'], [output(Output)]),
	read_term_from_codes(Output, Status, []). 
