
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	
	#include "datatype.h"
	
	extern void yyerror(char *);
	int errors = 0;
	extern int yylineno;
	char str[100];     // to store error messge
        char *data_type;  // to store data type
        int tempVarId=0; // Variable count for intermiadte code gen;
        int tempLaId=0;
        char var[5];     // T1, T2 .........etc 
        char numG[10];  // used in converstion floating to string
        struct IR {
	char inst[100];
        } IR_TABLE[999];
        
        int counter=0;
        char tempstr[10]; //
        char booExp[100];
        char lastlbl[10]; // last true or flase for logical op
        char lbl_t[10]; // for true stmt boolean exp true
        char lbl_f[10]; // for false stmt boolean exp false
        char tt[4],ff[4]; // for if stmt true and false;
        char begin[4],lastlooplbl[4];
        char * gen_newTempVar()
        {
           char num[4];
           strcpy(var,"T");
           sprintf(num, "%d", tempVarId);
           tempVarId++;
           strcat(var,num);
           return var;
         
        }
        char * gen_newLabel()
        {
           char num[4];
           strcpy(var,"L");
           sprintf(num, "%d", tempLaId);
           tempLaId++;
           strcat(var,num);
           return var;
          
        }
	
	
	
	

%}


%union 
{
	int intVal;
        float fVal;
        char *charVal;
	char *id;
        char *exprVal;
	struct cslabel *lbl;
};

%start PROGRAM
%type <exprVal> expr
%type <lbl> conditions
%token  <intVal> NUMBER
%token  <fVal> FNUMBER
%token  <charVal> CHARVAL 
%token  <id> 	  IDENTIFIER
%token  <lbl>     WHILE IF

%token ASSIGNOP
%token _DECLARE  _MAIN 
%token DO DONE INTEGER FLOAT CHAR BOOL
%token FI THEN  ELSE AND OR OB CB


%nonassoc IFY


%left '=' NE_
%left '<' '>' LE_ GE_ 
%left '+' '-'
%left '*' '/'
%left '(' ')'
%nonassoc IFX

%%

PROGRAM :  _DECLARE 	
			    declaration_list {  }
	        _MAIN '{'
				commands 
	       '}'			         {  } 


;


declaration_list : dec_seq   declaration		
     ;

dec_seq:  
|  dec_seq   declaration		  
;


declaration: 
	id_type id_seq IDENTIFIER ';' { } 
| { yyerror("Undeclared Identifier"); } id_seq IDENTIFIER ';' 
| id_type id_seq IDENTIFIER { yyerror("Missing ';'"); }
;


id_seq: 
| id_seq IDENTIFIER ',' 	    { }
;

id_type: INTEGER   {}
| CHAR             {  }
| FLOAT             {  }
| BOOL              {  }
;


commands:     
|  commands command ';' 
;

log_op: AND { strcpy(lastlbl, lbl_t); strcat(lastlbl,":");}
| OR { strcpy(lastlbl, lbl_f);strcat(lastlbl,":");}
;

command: 
|  IDENTIFIER ASSIGNOP expr 	{  strcpy(str, $1); strcat(str, " = "); strcat(str, $3); strcat(IR_TABLE[counter++].inst, str); }
|  IDENTIFIER ASSIGNOP          { yyerror("Syntax Error"); }
|  IDENTIFIER expr				{ yyerror("Syntax Error"); }

|  ifstat
|  WHILE              			{  strcpy(begin,gen_newLabel()); strcpy(lastlooplbl,begin); strcat(lastlooplbl,": ");  strcpy(str,lastlooplbl); strcat(IR_TABLE[counter++].inst, str);      } 
	'(' conditions ')'			            {   } 
   '{' 	{ strcpy(str, tt); strcat(str,": "); strcat(IR_TABLE[counter++].inst, str);}			
	commands { strcpy(str," GOTO "); strcat(str,lastlooplbl); strcat(IR_TABLE[counter++].inst, str); }
   '}'  	                    {    strcpy(lastlbl,"");  strcpy(lastlooplbl,""); strcpy(str, ff); strcat(str,": "); strcat(IR_TABLE[counter++].inst,str);}

;

conditions: expr { $$ = (label *)gen_label();strcpy(str,lastlbl);    strcat(str," IF "); strcat(str,booExp); strcat(str," "); strcat(str," GOTO "); $$->t=gen_newLabel();strcpy(tt,$$->t); strcpy(lbl_t,$$->t);strcat(str,$$->t); strcat(IR_TABLE[counter++].inst, str);
strcpy(str,"GOTO "); $$->f=gen_newLabel(); strcpy(ff,$$->f); strcpy(lbl_t,$$->t);strcat(str,$$->f);strcat(IR_TABLE[counter++].inst, str); }
| expr {strcpy(str,lastlbl); strcat(str," IF "); strcat(str,booExp); strcat(str," "); strcat(str,"GOTO "); strcpy(lbl_t,gen_newLabel());strcpy(tt,lbl_t); strcat(str,lbl_t); strcat(IR_TABLE[counter++].inst, str); strcpy(str," GOTO "); strcpy(lbl_f,gen_newLabel());strcpy(ff,lbl_f); strcat(str,lbl_f); strcat(IR_TABLE[counter++].inst, str); } log_op conditions { }
;



ifstat: IF '(' conditions ')'     {  strcpy(lastlbl,""); }
	THEN       {  strcpy(str, tt); strcat(str,": "); strcat(IR_TABLE[counter++].inst, str);}
		   commands {  }
	ELSE       { strcpy(str, ff); strcat(str,": "); strcat(IR_TABLE[counter++].inst, str); }
		   commands {  }
	FI
;



expr:  expr '+' expr		{ $$=gen_newTempVar();	 strcpy(str, $$); strcat(str, " = "); if(strcmp($$,$1) == 0){ strcat(str,tempstr);} else {strcat(str, $1);} strcat(str, " + "); if(strcmp($$,$3) == 0){ strcat(str,tempstr);} else {strcat(str, $3);} strcat(IR_TABLE[counter++].inst, str);  strcpy(tempstr,$$);}
|  expr '-' expr		{ $$=gen_newTempVar(); strcpy(str, $$); strcat(str, " = ");if(strcmp($$,$1) == 0){ strcat(str,tempstr);} else {strcat(str, $1);} strcat(str, " - "); if(strcmp($$,$3) == 0){ strcat(str,tempstr);} else {strcat(str, $3);} strcat(IR_TABLE[counter++].inst, str);  strcpy(tempstr,$$);}
|  expr '*' expr		{ $$=gen_newTempVar();  strcpy(str, $$); strcat(str, " = "); if(strcmp($$,$1) == 0){ strcat(str,tempstr);} else {strcat(str, $1);} strcat(str, " * "); if(strcmp($$,$3) == 0){ strcat(str,tempstr);} else {strcat(str, $3);}  strcat(IR_TABLE[counter++].inst, str);  strcpy(tempstr,$$);}
|  expr '/' expr		{ $$=gen_newTempVar();  strcpy(str, $$); strcat(str, " = "); if(strcmp($$,$1) == 0){ strcat(str,tempstr);} else {strcat(str, $1);} strcat(str, " / "); if(strcmp($$,$3) == 0){ strcat(str,tempstr);} else {strcat(str, $3);} strcat(IR_TABLE[counter++].inst, str);  strcpy(tempstr,$$);}
|  expr '>' expr		{  strcpy(booExp, $1); strcat(booExp, " > "); strcat(booExp, $3);    		}
|  expr '<' expr		{   strcpy(booExp, $1); strcat(booExp, " < "); strcat(booExp, $3);   		}
|  expr '=' expr		{   strcpy(booExp, $1); strcat(booExp, " == "); strcat(booExp, $3);    		}
|  expr LE_ expr        {    strcpy(booExp, $1); strcat(booExp, " >= "); strcat(booExp, $3);   		}
|  expr GE_ expr        { 	strcpy(booExp, $1); strcpy(booExp, " <= "); strcat(booExp, $3);		}
|  expr NE_ expr		{  strcpy(booExp, $1); strcat(booExp, " != "); strcat(booExp, $3);			}
|  OB expr CB            { }
| FNUMBER                       {  sprintf(numG, "%f", $1); $$=numG; }
| CHARVAL                       {  $$=$1;}
|  IDENTIFIER			{   $$=$1;}
|  NUMBER			{  sprintf(numG, "%d", $1); $$=numG; }
;
	

%%


int main(int argc, char * argv[]) {
	extern FILE *yyin;
	yyin = fopen(argv[1], "r");
	yyparse();
	int i=0;
	if(!errors) {
		
                for(i=0;i<counter;i++)
                    {
                     printf("\n%s",IR_TABLE[i].inst);
                    }
                
		printf("\n\n---------------------------------\n\n");
	}
	else {
		
		printf("---Check Errors And Recompile---\n");
		
	}
	
	printf("\n\n");	
}


/*Error Reporting Block*/
void yyerror(char *error) {
	printf("yyerror[%d]: %s @ Line No - %d\n", ++errors, error, yylineno);
}
