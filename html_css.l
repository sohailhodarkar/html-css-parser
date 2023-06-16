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
    int insideBlock = 0;
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
                                                                  return SELF_CLOSING_TAG; 
                                                                }
"</"[^>]*">"                                                    { int spaceIndex = string(yytext).find_first_of(" \t\n");
                                                                  if(spaceIndex == -1)
                                                                    yylval.sval = strdup(&(string(yytext).substr(2, string(yytext).length() - 3))[0]);
                                                                  else
								    yylval.sval = strdup(&(string(yytext).substr(1, spaceIndex - 1))[0]);
                                                                  return CLOSING_TAG; 
                                                                }
"<"[a-zA-Z]+([ ]*[^/=>]+("="\"[^\"]*\")?)*[ ]*">"               { int spaceIndex = string(yytext).find_first_of(" \t\n");
								  if(spaceIndex == -1)
                                                                    yylval.sval = strdup(&(string(yytext).substr(1, string(yytext).length() - 2))[0]);
                                                                  else
								    yylval.sval = strdup(&(string(yytext).substr(1, spaceIndex - 1))[0]);
							          if((strcmp(yylval.sval, "link") == 0) || (strcmp(yylval.sval, "meta") == 0))
							          	return SELF_CLOSING_TAG;
                                                                  return OPENING_TAG; 
                                                                }
"@"[_a-zA-Z0-9 ]+("("[^)]*")")?					{ if(fileIsCSS)
								  {
									yylval.sval = strdup(yytext);
									return SELECTOR;
								  }
								}
".hasNoSvg img[src *= '.svg']"					{ if(fileIsCSS)
								  {
									yylval.sval = strdup(yytext);
									return SELECTOR;
								  }
								}
[-_a-zA-Z0-9\.(\[\])='\*\^#]+(":"[-_a-zA-Z0-9\.(\[\])='\*\^#]+)?([ ]*[>]?[ ]*[-_a-zA-Z0-9\.(\[\])='\*\^#]+)?("::"[-_a-zA-Z0-9\.(\[\])='\*\^#]+)?			{ if(fileIsCSS)
								  {
								    if(!insideBlock)
								    {
								    	yylval.sval = strdup(yytext);
								   	return SELECTOR;
								    }
								    else
								    {
									yylval.sval = strdup(yytext);
									return KEY;
								    }
								  }
								}
"::"[-_a-zA-Z0-9\.(\[\])=']+					{ if(fileIsCSS)
								  {
									yylval.sval = strdup(yytext);
									return SELECTOR;
								  }
								}
":"[^;<>:]+";"							{ if(fileIsCSS)
								  {
									yylval.sval = strdup(yytext);
									return VALUE;
								  }
								}
"/\*"[^\*]*"\*/"						;
"{"								{ if(fileIsCSS)
								  {
									insideBlock++;
									return LCURLY; 
								  }
								}
"}"								{ if(fileIsCSS)
								  {
									insideBlock--;
									return RCURLY; 
								  }
								}
","								{ if(fileIsCSS)
								  {
								    yylval.sval = strdup(yytext);
								    return COMMA;
								  }
								}
[ \t\n]								;
.                                                               ;


%%