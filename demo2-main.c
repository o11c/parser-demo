#include "demo2-lex.h"
#include "demo2-parse.h"

int main()
{
    yyscan_t scanner;
    demo2lex_init(&scanner);
    demo2parse(scanner);
    demo2lex_destroy(scanner);
    return 0;
}
