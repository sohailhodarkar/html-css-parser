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


"<!DOCTYPE html"[^>]*">"                                        { fileIsCSS = false; 
                                                                  return DOCTYPE_TAG; 
                                                                }
"<"[^ />]*([ ]*[^/=>]+("="\"[^\"]*\")?)*[ ]*"/>"                   { int spaceIndex = string(yytext).find_first_of(' ');
                                                                  if(spaceIndex == -1)
                                                                  {
                                                                    yylval.sval = strdup(&(string(yytext).substr(1, string(yytext).length() - 3))[0]);
                                                                  }
                                                                  else
                                                                  {
                                                                    yylval.sval = strdup(&(string(yytext).substr(1, spaceIndex - 1))[0]);
                                                                  }
                                                                  return SELF_CLOSING_TAG; 
                                                                }
"</"[^>]*">"                                                    { int spaceIndex = string(yytext).find_first_of(' ');
                                                                  if(spaceIndex == -1)
                                                                  {
                                                                    yylval.sval = strdup(&(string(yytext).substr(2, string(yytext).length() - 3))[0]);
                                                                  }
                                                                  else
                                                                  {
                                                                    yylval.sval = strdup(&(string(yytext).substr(1, spaceIndex - 1))[0]);
                                                                  }
                                                                  return CLOSING_TAG; 
                                                                }
"<"[^ />]*([ ]*[^/=>]+("="\"[^\"]*\")?)*[ ]*">"                    { int spaceIndex = string(yytext).find_first_of(' ');
                                                                  if(spaceIndex == -1)
                                                                  {
                                                                    yylval.sval = strdup(&(string(yytext).substr(1, string(yytext).length() - 2))[0]);
                                                                  }
                                                                  else
                                                                  {
                                                                    yylval.sval = strdup(&(string(yytext).substr(1, spaceIndex - 1))[0]);
                                                                  }
                                                                  return OPENING_TAG; 
                                                                }
"document.write("[^)]*")";					;
.                                                               ;


%%