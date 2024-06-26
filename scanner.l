%{
#include <stdio.h>
#include "parser.h"
#include "calc.h"
char buffer[200];
%}
%option header-file="scanner.h"
%option outfile="scanner.c"
%option yylineno
%option nounput
%option noinput

id {letra}({letra}|{dig})*
nro {entero}|{real}
entero {dig}+
real {entero}{exp}|{frac}{exp}?
exp [eE][+-]?{entero}
frac {entero}\.{entero}?|{entero}?\.{entero}
letra [a-zA-Z]
dig [0-9]
inval [[:punct:]]{-}[+\-*/=^)(]
invalID {letra}|{dig}|{inval}
invalNRO {letra}|{inval}|{nro}

%%
var                      		            return PR_VAR;
salir					                    return PR_SALIR;
{id}         				                { if((yylval.ID = getsym(yytext))){
                                                    return (yylval.ID->type);
                                            } else {
                                                    yylval.ID = malloc (sizeof (struct symrec)); 
                                                    yylval.ID->name = strdup(yytext); 
                                                    yylval.ID->type = ID;
                                                    return ID;
                                                }
                                            }
{id}+{inval}+{invalID}*		 	            {yylexers++; sprintf(buffer, "Error Lexico: ID invalido: %s", yytext); yyerror(buffer);}
{nro}		               		            {sscanf(yytext, "%lf", &yylval.NUM); return NUM;}
{real}({letra}|{inval})+{invalNRO}*	        {yylexers++; sprintf(buffer, "Error Lexico: Real invalido: %s", yytext); yyerror(buffer);}
{entero}({letra}|{inval})+{invalNRO}*	    {yylexers++; sprintf(buffer, "Error Lexico: Constante invalida: %s", yytext); yyerror(buffer);}
{inval}+				                    {yylexers++; sprintf(buffer, "Error Lexico: Cadena desconocida: %s", yytext); yyerror(buffer);}
\+					                        return MAS;
\+=					                        return MAS_IGUAL;
-					                        return MENOS;
-=					                        return MENOS_IGUAL;
\*					                        return POR;
\*=					                        return POR_IGUAL;
\/					                        return DIV;
\/=					                        return DIV_IGUAL;
\^					                        return POT;
=					                        return IGUAL;
\(					                        return PAR_IZQ;
\)					                        return PAR_DER;
\n					                        return NL;						
.|\s	                           	        ;

%%