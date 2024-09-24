%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"
    void yyerror(const char *s);
    int yylex();
    int yywrap();
%}

%token IDENTIFIER CONSTANT STRING_LITERAL EQ_OP CHAR INT LONG FLOAT DOUBLE CONST VOID IF ELSE WHILE FOR RETURN

%start program
%%

program : external_declaration | program external_declaration ;

external_declaration : function_definition | declaration ;

function_definition : declaration_specifiers declarator declaration_list compound_statement | declaration_specifiers declarator compound_statement ;

compound_statement : '{' statement_list '}' | '{' declaration_list '}' | '{' declaration_list statement_list '}' ;

primary_expression : IDENTIFIER | CONSTANT | STRING_LITERAL ;

postfix_expression : primary_expression | postfix_expression '(' argument_expression_list ')' | postfix_expression '.' IDENTIFIER ;

argument_expression_list : assignment_expression | argument_expression_list ',' assignment_expression ;

multiplicative_expression : postfix_expression | multiplicative_expression '*' postfix_expression | multiplicative_expression '/' postfix_expression | multiplicative_expression '%' postfix_expression ;

additive_expression : multiplicative_expression | additive_expression '+' multiplicative_expression | additive_expression '-' multiplicative_expression ;

shift_expression: additive_expression ;

relational_expression: shift_expression | relational_expression '<' shift_expression | relational_expression '>' shift_expression ;

equality_expression : relational_expression | equality_expression EQ_OP relational_expression;

assignment_expression : equality_expression | postfix_expression assignment_operator assignment_expression ;

assignment_operator : '=' ;

expression : assignment_expression | expression ',' assignment_expression ;

declaration : declaration_specifiers ';' | declaration_specifiers init_declarator_list ';' ;

declaration_specifiers : type_specifier | type_specifier declaration_specifiers ;

init_declarator_list : init_declarator | init_declarator_list ',' init_declarator ;

init_declarator : declarator | declarator '=' initializer ;

type_specifier : VOID | CHAR | INT | LONG | FLOAT | DOUBLE ;

declarator : direct_declarator ;

direct_declarator : IDENTIFIER | '(' declarator ')' | direct_declarator '(' parameter_type_list ')' | direct_declarator '(' identifier_list ')' | direct_declarator '(' ')' ;

parameter_type_list : parameter_list ;

parameter_list : parameter_declaration | parameter_list ',' parameter_declaration ;

parameter_declaration : declaration_specifiers declarator | declaration_specifiers ;

identifier_list : IDENTIFIER | identifier_list ',' IDENTIFIER ;

initializer : assignment_expression | '{' initializer_list '}' | '{' initializer_list ',' '}' ;

initializer_list : initializer | initializer_list ',' initializer ;

statement : compound_statement | expression_statement | selection_statement | iteration_statement | jump_statement ;

declaration_list : declaration | declaration_list declaration ;

statement_list : statement | statement_list statement ;

expression_statement : ';' | expression ';' ;

selection_statement : IF '(' expression ')' statement ELSE statement ;

iteration_statement : WHILE '(' expression ')' statement | FOR '(' expression_statement expression_statement expression ')' statement ;

jump_statement : RETURN ';' | RETURN expression ';' ;

%%

int main() {
    yyparse();
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}