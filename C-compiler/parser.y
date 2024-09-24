%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #include<ctype.h>
    #include"lex.yy.c"


    void yyerror(const char *s);
    int yylex();
    int yywrap();
    void add(char);
    void insert_type();
    int search(char *);
    void insert_type();

    struct dataType {
        char * id_name;
        char * data_type;
        char * type;
        int line_no;
    } symbol_table[40];

    int cnt=0;
    int q;
    char type[10];
    extern int cntn;
%}

%union { struct var_name { 
			char name[100]; 
			struct node* nd;
		} nd_obj;}


%token<nd_obj> IDENTIFIER CONSTANT STRING_LITERAL EQ_OP CHAR INT LONG FLOAT DOUBLE CONST VOID IF ELSE WHILE FOR INCLUDE RETURN MAIN


%start program
%%

program : headers | main;

headers: headers headers main| INCLUDE { add('H');};

main : INT MAIN '(' ')' compound_statement;

compound_statement : '{' statement_list '}' | '{' declaration_list '}' | '{' declaration_list statement_list '}' ;

primary_expression : IDENTIFIER | CONSTANT { add('C'); } | STRING_LITERAL ;

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

type_specifier : VOID { insert_type(); } | CHAR { insert_type(); } | INT { insert_type(); } | LONG { insert_type(); } | FLOAT { insert_type(); } | DOUBLE { insert_type(); } ;

declarator : direct_declarator ;

direct_declarator : IDENTIFIER { add('V'); } | '(' declarator ')' | direct_declarator '(' parameter_type_list ')' | direct_declarator '(' identifier_list ')' | direct_declarator '(' ')' ;

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

selection_statement : IF { add('K'); } '(' expression ')' statement ELSE { add('K'); } statement ;

iteration_statement : WHILE { add('K'); } '(' expression ')' statement | FOR { add('K'); } '(' expression_statement expression_statement expression ')' statement ;

jump_statement : RETURN { add('K'); } ';' | RETURN { add('K'); } expression ';' ;

%%

int main() {
    yyparse();

    printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
	printf("_______________________________________\n\n");
	int i=0;
	for(i=0; i<cnt; i++) {
		printf("%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_no);
	}
	for(i=0;i<cnt;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
	}
	printf("\n\n");
}

void yyerror(const char* msg) {
    fprintf(stderr, "%s\n", msg);
}

int search(char *type) {
	int i;
	for(i=cnt-1; i>=0; i--) {
		if(strcmp(symbol_table[i].id_name, type)==0) {
			return -1;
			break;
		}
	}
	return 0;
}

void add(char c) {
  q=search(yytext);
  if(!q) {
    if(c == 'H') {
			symbol_table[cnt].id_name=strdup(yytext);
			symbol_table[cnt].data_type=strdup(type);
			symbol_table[cnt].line_no=cntn;
			symbol_table[cnt].type=strdup("Header");
			cnt++;
		}
		else if(c == 'K') {
			symbol_table[cnt].id_name=strdup(yytext);
			symbol_table[cnt].data_type=strdup("N/A");
			symbol_table[cnt].line_no=cntn;
			symbol_table[cnt].type=strdup("Keyword\t");
			cnt++;
		}
		else if(c == 'V') {
			symbol_table[cnt].id_name=strdup(yytext);
			symbol_table[cnt].data_type=strdup(type);
			symbol_table[cnt].line_no=cntn;
			symbol_table[cnt].type=strdup("Variable");
			cnt++;
		}
		else if(c == 'C') {
			symbol_table[cnt].id_name=strdup(yytext);
			symbol_table[cnt].data_type=strdup("CONST");
			symbol_table[cnt].line_no=cntn;
			symbol_table[cnt].type=strdup("Constant");
			cnt++;
		}
		else if(c == 'F') {
			symbol_table[cnt].id_name=strdup(yytext);
			symbol_table[cnt].data_type=strdup(type);
			symbol_table[cnt].line_no=cntn;
			symbol_table[cnt].type=strdup("Function");
			cnt++;
		}
	}
}

void insert_type() {
	strcpy(type, yytext);
}
