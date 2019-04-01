/* Práctica LEX para la asignatura MC 2017/2018
	Autor: Miguel Ángel Cantarero López 
	
	TheOddShecker es un programa lex capaz de obtener
	las cuotas con mejor valor de diversos partidos de futbol,
	recibe un fichero en texto plano con la información y variación 
	de las cuotas de cara a un partido, y a partir de ahí saca las cuotas con 
	mayor valor para apostar, entiendiendo como valor la relación cuota-favorito
	que establece la casa de apuestas. En la memoria de la práctica se explica 
	a fondo este sistema.
	
*/
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>


double oddShecker(char **team, char **cuota);
void getOdds(char *str, double *firstodd, double *secondodd);

int i = 0;
char* equipos[2000];
char* cuotas[2000];


%}


alfabeto [a-zA-Z]
digito [0-9]
punto [\.]
espacio [' ']
cuota ({digito}+{punto}{digito}+)
palabra	({alfabeto}+)
nombre	({palabra}+{espacio}?{palabra}*)
equipo	(padl\">{nombre}<)
cambiocuota	 ({cuota}\[u\]{cuota})

%%

{equipo}				{equipos[i] = (char *) malloc(yyleng);
						 strcpy( equipos[i], yytext);
					}

{cambiocuota}		{cuotas[i] = (char *) malloc(yyleng);
						 strcpy( cuotas[i], yytext);
							i++;
						 }

.			{}

%%


int main (int argc, char *argv[]) {


	if (argc == 2) {
		yyin = fopen (argv[1], "rt");
		if (yyin == NULL) {
			printf ("El fichero %s no se puede abrir\n", argv[1]);
			exit (-1);
		}
	}else{ 
		printf( "Número argumentos incorrecto.\n ./ejecutable <ficheroentrada>.txt" );
		exit(-1);
		}


	printf(" TheOddShecker se dispone a analizar el archivo de MisMarcadores.com : \n");

	yylex();
	

	oddShecker(equipos, cuotas);
	
	for(int x = 0; x<=i ; ++x){
		free(equipos[x]);
		free(cuotas[x]);
}

	printf(" Mucha suerte y recuerde realizar un juego responsable(+18). \n");
}

//Funcion que obtiene las cuotas con valor

double oddShecker(char **team, char **cuota){
		double odd1 = 0;
		double odd2 = 0;

		for(int x = 0; x<i ; ++x){
			getOdds(cuota[x], &odd1, &odd2);
			char *name = team[x];
			if((odd2 - odd1 < 0.30) && odd2 < 2.20 && odd1 < 5.00 && (odd2 - odd1 > 0.04) && (name!= NULL)){
				printf("***Cambio de cuotas con valor detectado****\n En el partido que del : %s ,\n Cuota con valor inicial: %f ... Cuota con valor actual: %f \n", name, odd1, odd2 );
				if(odd2 >= 1.90){
					printf("El consejo del sistema es apostar a esa cuota junto al empate 1X o 2X \n\n");
				}else{
					printf("El consejo del sistema es apostar sólo a dicha cuota 1 o 2\n\n");
				}
			}
	}

}


// Función que pasa a double las cuotas almacenadas en un string str

void getOdds(char *str, double *firstodd, double *secondodd){
		
		char *odd1 = (char *) malloc(sizeof(char)*10);
		memcpy(odd1, str, 4);
		char *odd2 = (char *) malloc(sizeof(char)*10);
		memcpy(odd2, str + 7, 4);
		
		*firstodd = atof(odd1);
		*secondodd = atof(odd2);
		
		if(odd1 != NULL){
			free(odd1);
		}
		if(odd2 != NULL){
			free(odd2);
		}

}
