.DEFAULT_GOAL = all

CC = gcc
CFLAGS = -g -O2
CXX = g++
CXXFLAGS = -g -O2
CPPFLAGS =
LDFLAGS =
LDLIBS =
FLEX = flex
BISON = bison

WARNINGS = -Wall -Wextra
CFLAGS += ${WARNINGS}
CXXFLAGS += ${WARNINGS}

override CXXFLAGS += -std=c++0x

# GNU make allows pattern rules to work like this, but not normal rules
%.h %.c : %.l
	${FLEX} --header-file=$*.h -o $*.c $<
%.h %.c : %.y
	${BISON} --defines=$*.h -o $*.c $<
%.hpp %.cpp : %.lpp
	${FLEX} --header-file=$*.hpp -o $*.cpp $<
%.hpp %.cpp : %.ypp
	${BISON} --defines=$*.hpp -o $*.cpp $<

%.c.o : %.c
	${CC} ${CFLAGS} ${CPPFLAGS} -c -o $@ $<
% : %.c.o
	${CC} ${LDFLAGS} $^ ${LDLIBS} -o $@
%.cpp.o : %.cpp
	${CXX} ${CXXFLAGS} ${CPPFLAGS} -c -o $@ $<
% : %.cpp.o
	${CXX} ${LDFLAGS} $^ ${LDLIBS} -o $@

all: demo1-main demo2-main

demo1-main: demo1-main.cpp.o demo1-lex.cpp.o demo1-parse.cpp.o
demo1-main.cpp.o: demo1-main.cpp demo1-lex.hpp demo1-parse.hpp
demo1-lex.cpp.o: demo1-lex.cpp demo1-lex.hpp demo1-parse.hpp
demo1-parse.cpp.o: demo1-parse.cpp demo1-parse.hpp demo1-lex.hpp

demo2-main: demo2-main.c.o demo2-lex.c.o demo2-parse.c.o
demo2-main.c.o: demo2-main.c demo2-lex.h demo2-parse.h
demo2-lex.c.o: demo2-lex.c demo2-lex.h demo2-parse.h
demo2-parse.c.o: demo2-parse.c demo2-parse.h demo2-lex.h

clean:
	rm -f demo1-main demo2-main *.o
distclean: clean
	rm -f demo1-lex.[ch]pp demo1-parse.[ch]pp
	rm -f demo2-lex.[ch] demo2-parse.[ch]
