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

all: $(sort $(patsubst %.c,%,$(wildcard *-main.c)) $(patsubst %.cpp,%,$(wildcard *-main.cpp)))

demo1-main: demo1-main.cpp.o demo1-lex.cpp.o demo1-parse.cpp.o
demo1-main.cpp.o: demo1-main.cpp demo1-lex.hpp demo1-parse.hpp
demo1-lex.cpp.o: demo1-lex.cpp demo1-lex.hpp demo1-parse.hpp
demo1-parse.cpp.o: demo1-parse.cpp demo1-parse.hpp demo1-lex.hpp

demo2-main: demo2-main.c.o demo2-lex.c.o demo2-parse.c.o
demo2-main.c.o: demo2-main.c demo2-lex.h demo2-parse.h
demo2-lex.c.o: demo2-lex.c demo2-lex.h demo2-parse.h
demo2-parse.c.o: demo2-parse.c demo2-parse.h demo2-lex.h

demo3-main: demo3-main.cpp.o demo3-lex.cpp.o demo3-parse.cpp.o
demo3-main.cpp.o: demo3-main.cpp demo3-lex.hpp demo3-parse.hpp
demo3-lex.cpp.o: demo3-lex.cpp demo3-lex.hpp demo3-parse.hpp
demo3-parse.cpp.o: demo3-parse.cpp demo3-parse.hpp demo3-lex.hpp

clean:
	rm -f *-main *.o
distclean: clean
	rm -f *-lex.[ch]pp *-parse.[ch]pp
	rm -f *-lex.[ch] *-parse.[ch]
