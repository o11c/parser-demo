/* vim: set filetype=yacc: */
%define api.pure full
%locations
%name-prefix "demo2"
%param {yyscan_t yyscanner}

%code requires {
// break the cyclic dependency between scanner and parser headers
typedef void *yyscan_t;
}
%{
#include <stdio.h>
#include <string.h>

#include "demo2-lex.h"
%}

%code {
void yyerror(YYLTYPE *, yyscan_t, const char *msg);
}

%token NEWLINE
%token <c> CHAR

%type <s> chars
%type <s> line

%union
{
    char c;
    char *s;
}

%%

lines
: line
{
    printf("line: %s\n", $1);
}
| lines line
{
    printf("line: %s\n", $2);
}
;

line
: NEWLINE
{
    $$ = strdup("");
}
| chars NEWLINE
;

chars
: CHAR
{
    $$ = (char *)malloc(2);
    $$[0] = $1;
    $$[1] = '\0';
}
| chars CHAR
{
    size_t len = strlen($1);
    $$ = (char *)realloc($1, len + 2);
    $$[len] = $2;
    $$[len + 1] = '\0';
}
;

%%

void yyerror(YYLTYPE *unused1, yyscan_t unused2, const char *msg)
{
    (void)unused1;
    (void)unused2;
    fprintf(stderr, "%s\n", msg);
    abort();
}
