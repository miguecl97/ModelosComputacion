.SUFFIXES:
.PHONY: r, run, arn

cxxflags := -ll
ldflagsc :=
precomp := lex
compilador := gcc 

run: oddshecker 6enero.txt
o: oddshecker

oddshecker: oddshecker

%: %.l
	lex $<
	gcc lex.yy.c -o oddshecker -ll


clean:
	rm -rf *_exe *.dSYM *~ *.o \#* *.c
