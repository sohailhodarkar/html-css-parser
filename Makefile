html_css: html_css.y html_css.l
	bison -d html_css.y
	flex html_css.l
	g++ -std=c++11 html_css.tab.c lex.yy.c -o html_css_parser
