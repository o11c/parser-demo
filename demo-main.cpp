#include "demo-lex.hpp"
#include "demo-parse.hpp"

int main()
{
    yyscan_t scanner;
    demolex_init(&scanner);
    demoparse(scanner);
    demolex_destroy(scanner);
}
