.DEFAULT_GOAL = all

CXX = g++
CXXFLAGS = -g -O2
CPPFLAGS =
LDFLAGS =
LDLIBS =
FLEX = flex
BISON = bison

WARNINGS = -Wall -Wextra
CXXFLAGS += ${WARNINGS}

override CXXFLAGS += -std=c++0x

# GNU make allows pattern rules to work like this, but not normal rules
%.hpp %.cpp : %.lpp
	${FLEX} --header-file=$*.hpp -o $*.cpp $<
%.hpp %.cpp : %.ypp
	${BISON} --defines=$*.hpp -o $*.cpp $<

%.o : %.cpp
	${CXX} ${CXXFLAGS} ${CPPFLAGS} -c -o $@ $<
% : %.o
	${CXX} ${LDFLAGS} $^ ${LDLIBS} -o $@

all: demo-main

demo-main: demo-main.o demo-lex.o demo-parse.o
demo-main.o: demo-main.cpp demo-lex.hpp demo-parse.hpp
demo-lex.o: demo-lex.cpp demo-lex.hpp demo-parse.hpp
demo-parse.o: demo-parse.cpp demo-parse.hpp demo-lex.hpp

clean:
	rm -f demo-main *.o
distclean: clean
	rm -f demo-lex.[ch]pp demo-parse.[ch]pp
