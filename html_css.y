%{
    #include <iostream>
    #include <cstdio>
    #include <cstring>
    using namespace std;
    extern int yylex();
    extern int yyparse();
    void yyerror(const char *message)
    {
        cout << "ERROR" << endl;
    }
%}

%union {
    int ival;
    char *sval;
}

%start prog
%token<sval> DOCTYPE_TAG
%token<sval> OPENING_TAG
%token<sval> SELF_CLOSING_TAG
%token<sval> CLOSING_TAG

%type<ival> html
%type<ival> tag
%type<ival> tag_list


%%

prog : html                                                 { cout << "HTML File Accepted. Deepest element is at level " << $1 << endl; exit(1); }
     ;

html : DOCTYPE_TAG OPENING_TAG tag_list CLOSING_TAG     { if(strcmp($2, $4))
                                                              { 
                                                                    cout << "HTML failed: " << $1 << " != " << $3 << endl;
                                                                    exit(-1);
                                                              }
                                                              else
                                                                $$ = $3 + 1; 
                                                            }
     ;

tag_list : tag_list tag                                     { $$ = max($1, $2); }
         |                                                  { $$ = 0; } 
         ;

tag : OPENING_TAG tag_list CLOSING_TAG                      { if(strcmp($1, $3))
                                                              { 
                                                                    cout << "HTML failed: " << $1 << " != " << $3 << endl;
                                                                    exit(-1);
                                                              }
                                                              else
                                                                $$ = $2 + 1; 
                                                            }
    | SELF_CLOSING_TAG                                      { $$ = 0; }
    ;

%%

int main()
{
    yyparse();
    return 0;
}