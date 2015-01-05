#include "demo1-lex.hpp"
#include "demo1-parse.hpp"

int main()
{
    yyscan_t scanner;
    demo1lex_init(&scanner);
    demo1parse(scanner);
    demo1lex_destroy(scanner);
}
