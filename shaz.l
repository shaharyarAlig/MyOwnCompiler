
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
	static void comment(void);
	extern YYSTYPE yylval;
	extern int yywrap(void);
	extern int yylineno;
%}

%%
"/*"                                    { comment(); }
"//".*                                    { /* consume //-comment */ }
"main(void)"            {       return(_MAIN); }
"int"     		{	return(INTEGER);   }
"char"     		{	return(CHAR);   }
"float"     		{	return(FLOAT);   }
"bool"     		{	return(BOOL);   }
"="      		{ 	return(ASSIGNOP);  }




"declare"  		{	return(_DECLARE);  }


"while"   		{	return(WHILE);     }
"do"	  		{	return(DO);	       }
"done"    		{   return(DONE);	   }

"if"	  		{  return(IF);         }
"then"    		{  return(THEN);       }
"else"    		{  return(ELSE);       }
"fi"      		{  return(FI);         }

"&&"                    {  return(AND);        }
"||"                    {  return(OR);         }
"<="      		{  return(LE_);        }
">="			{  return(GE_);		   }
"!="                    {  return(NE_);        }

"'"[a-zA-z0-9]"'"       { yylval.charVal = (char *) strdup(yytext); return (CHARVAL); }
[0-9]*"."[0-9]+         { yylval.fVal = atof(yytext);  return (FNUMBER); }
[0-9]*    		{	yylval.intVal = atoi(yytext); return(NUMBER); }
[a-z]+    		{  yylval.id = (char *) strdup(yytext); return(IDENTIFIER); }


[-()<>=+*/;{}.,]	{ return *yytext; }

[\n]		    {   yylineno++;        }
[ \t]

%%

int yywrap(void) {
	return 1;
}

static void comment(void)
{
    int c;

    while ((c = input()) != 0)
        if (c == '*')
        {
            while ((c = input()) == '*')
                ;

            if (c == '/')
                return;

            if (c == 0)
                break;
        }
    yyerror("unterminated comment");
}

