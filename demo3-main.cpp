#include "demo3-lex.hpp"
#include "demo3-parse.hpp"

int main()
{
    yyscan_t scanner;
    demo3lex_init(&scanner);
    demo3pstate *parser = demo3pstate_new();
    while (true)
    {
        YYSTYPE lval;
        YYLTYPE lloc;
        int ch = demo3lex(&lval, &lloc, scanner);
        int status = demo3push_parse(parser, ch, &lval, &lloc);
        switch (status)
        {
        case 0:
            puts("accept");
            break;
        case 1:
            puts("abort");
            break;
        case 2:
            puts("no memory");
            break;
        case YYPUSH_MORE: // 4
            continue;
        default:
            puts("unknown");
            break;
        }
        if (status == 0)
            break;
        abort();
    }
    demo3pstate_delete(parser);
    demo3lex_destroy(scanner);
}
