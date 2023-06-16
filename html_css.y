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
%token<sval> SELECTOR
%token<sval> KEY
%token<sval> VALUE
%token COMMA
%token LCURLY
%token RCURLY

%type<ival> html
%type<ival> tag
%type<ival> tag_list

%type css
%type selector_list
%type block_list
%type block
%type key_value_pairs
%type key_value_pair


%%

prog : html                                                 { cout << "HTML File Accepted. Deepest element is at level " << $1 << endl; exit(1); }
     | css					    	    { cout << "CSS Accepted" << endl; }
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

css : block_list
    ;

block_list : block_list block				
	   | block
	   ;

block : selector_list LCURLY key_value_pairs RCURLY	    
      ;

key_list : key_list COMMA KEY
         | KEY
         ;

key_value_pairs : key_value_pairs key_list LCURLY key_value_pairs RCURLY
		| key_list LCURLY key_value_pairs RCURLY
		| key_value_pairs key_value_pair	    
		| key_value_pair
		;

key_value_pair : KEY VALUE
	       ;

selector_list : selector_list COMMA SELECTOR		    
	      | SELECTOR		
	      ;


%%

int main()
{
    yyparse();
    return 0;
}