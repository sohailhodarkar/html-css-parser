%{
    #include <iostream>
    #include <cstdio>
    #include <cstring>
    #include "html_css.tab.h"
    using namespace std;
%}

%option noyywrap

%{
    bool fileIsCSS = true;                                      // flag to determine if tokens other than tags are to be recognized
%}


%%


"document.write("[^)]+")"					;
"<!DOCTYPE html"[^>]*">"                                        { fileIsCSS = false; 
                                                                  return DOCTYPE_TAG; 
                                                                }
"<"[a-zA-Z]+([ ]*[^/=>]+("="\"[^\"]*\")?)*[ ]*"/>"              { int spaceIndex = string(yytext).find_first_of(" \t\n");
                                                                  if(spaceIndex == -1)
                                                                    yylval.sval = strdup(&(string(yytext).substr(1, string(yytext).length() - 3))[0]);
                                                                  else
								    yylval.sval = strdup(&(string(yytext).substr(1, spaceIndex - 1))[0]);
								  cout << yylval.sval << " SELF CLOSING" << endl;
                                                                  return SELF_CLOSING_TAG; 
                                                                }
"</"[^>]*">"                                                    { int spaceIndex = string(yytext).find_first_of(" \t\n");
                                                                  if(spaceIndex == -1)
                                                                    yylval.sval = strdup(&(string(yytext).substr(2, string(yytext).length() - 3))[0]);
                                                                  else
								    yylval.sval = strdup(&(string(yytext).substr(1, spaceIndex - 1))[0]);
								  cout << yylval.sval << " CLOSING" << endl;
                                                                  return CLOSING_TAG; 
                                                                }
"<"[a-zA-Z]+([ ]*[^/=>]+("="\"[^\"]*\")?)*[ ]*">"               { int spaceIndex = string(yytext).find_first_of(" \t\n");
								  if(spaceIndex == -1)
                                                                    yylval.sval = strdup(&(string(yytext).substr(1, string(yytext).length() - 2))[0]);
                                                                  else
								    yylval.sval = strdup(&(string(yytext).substr(1, spaceIndex - 1))[0]);
							          if((strcmp(yylval.sval, "link") == 0) || (strcmp(yylval.sval, "meta") == 0))
							          {
								  	cout << yylval.sval << " SELF CLOSING" << endl;
								  	return SELF_CLOSING_TAG;
								  }
								  cout << yylval.sval << " OPENING" << endl;
                                                                  return OPENING_TAG; 
                                                                }
.                                                               ;


%%