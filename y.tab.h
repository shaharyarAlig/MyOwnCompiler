/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NUMBER = 258,
    FNUMBER = 259,
    CHARVAL = 260,
    IDENTIFIER = 261,
    WHILE = 262,
    IF = 263,
    ASSIGNOP = 264,
    _DECLARE = 265,
    _MAIN = 266,
    DO = 267,
    DONE = 268,
    INTEGER = 269,
    FLOAT = 270,
    CHAR = 271,
    BOOL = 272,
    FI = 273,
    THEN = 274,
    ELSE = 275,
    AND = 276,
    OR = 277,
    OB = 278,
    CB = 279,
    IFY = 280,
    NE_ = 281,
    LE_ = 282,
    GE_ = 283,
    IFX = 284
  };
#endif
/* Tokens.  */
#define NUMBER 258
#define FNUMBER 259
#define CHARVAL 260
#define IDENTIFIER 261
#define WHILE 262
#define IF 263
#define ASSIGNOP 264
#define _DECLARE 265
#define _MAIN 266
#define DO 267
#define DONE 268
#define INTEGER 269
#define FLOAT 270
#define CHAR 271
#define BOOL 272
#define FI 273
#define THEN 274
#define ELSE 275
#define AND 276
#define OR 277
#define OB 278
#define CB 279
#define IFY 280
#define NE_ 281
#define LE_ 282
#define GE_ 283
#define IFX 284

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 59 "shaz.y" /* yacc.c:1909  */

	int intVal;
        float fVal;
        char *charVal;
	char *id;
        char *exprVal;
	struct cslabel *lbl;

#line 121 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
