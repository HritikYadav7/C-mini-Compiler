digit			[0-9]
alpha			[a-zA-Z_]

%{
#include <stdio.h>
#include "y.tab.h"
int cntn=0;

void count();
int comment();
%}

%%
"/*"			{ comment(); }
"char"          { strcpy(yylval.nd_obj.name, yytext); count(); return (CHAR); }
"const"         { strcpy(yylval.nd_obj.name, yytext); count(); return (CONST); }
"double"        { strcpy(yylval.nd_obj.name, yytext); count(); return (DOUBLE); }
"else"          { strcpy(yylval.nd_obj.name, yytext); count(); return (ELSE); }
"main"          { strcpy(yylval.nd_obj.name, yytext); count(); return (MAIN); }
"float"         { strcpy(yylval.nd_obj.name, yytext); count(); return (FLOAT); }
"for"           { strcpy(yylval.nd_obj.name, yytext); count(); return (FOR); }
"if"            { strcpy(yylval.nd_obj.name, yytext); count(); return (IF); }
"int"           { strcpy(yylval.nd_obj.name, yytext); count(); return (INT); }
"long"          { strcpy(yylval.nd_obj.name, yytext); count(); return (LONG); }
"return"        { strcpy(yylval.nd_obj.name, yytext); count(); return (RETURN); }
"void"          { strcpy(yylval.nd_obj.name, yytext); count(); return (VOID); }
"while"         { strcpy(yylval.nd_obj.name, yytext); count(); return (WHILE); }
^"#include"[ ]*<.+\.h> { strcpy(yylval.nd_obj.name, yytext); count(); return (INCLUDE); }
{alpha}({alpha}|{digit})* { strcpy(yylval.nd_obj.name, yytext); count(); return (IDENTIFIER); }
{digit}+        { strcpy(yylval.nd_obj.name, yytext); count(); return (CONSTANT); }
L?\"(\\.|[^\\"])*\" { strcpy(yylval.nd_obj.name, yytext); count(); return (STRING_LITERAL); }
"=="            { strcpy(yylval.nd_obj.name, yytext); count(); return (EQ_OP); }
";"             { strcpy(yylval.nd_obj.name, yytext); count(); return (';'); }
("{"|"<%")      { strcpy(yylval.nd_obj.name, yytext); count(); return ('{'); }
("}"|"%>")      { strcpy(yylval.nd_obj.name, yytext); count(); return ('}'); }
","             { strcpy(yylval.nd_obj.name, yytext); count(); return (','); }
":"             { strcpy(yylval.nd_obj.name, yytext); count(); return (':'); }
"="             { strcpy(yylval.nd_obj.name, yytext); count(); return ('='); }
"("             { strcpy(yylval.nd_obj.name, yytext); count(); return ('('); }
")"             { strcpy(yylval.nd_obj.name, yytext); count(); return (')'); }
"."             { strcpy(yylval.nd_obj.name, yytext); count(); return ('.'); }
"&"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('&'); }
"!"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('!'); }
"~"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('~'); }
"-"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('-'); }
"+"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('+'); }
"*"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('*'); }
"/"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('/'); }
"%"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('%'); }
"<"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('<'); }
">"             { strcpy(yylval.nd_obj.name, yytext); count(); return ('>'); }
[\n]			{ count(); cntn++; }
[ \t\v\f]		{ count();}
.				{ printf("character not recognized"); }

%%

int yywrap()
{
	return 1;
}

int comment()
{
	char c, c1;

loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}


int column = 0;

void count()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	ECHO;
}