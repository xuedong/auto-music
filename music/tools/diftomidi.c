/********************* CONVERSION A MIDI DE UN FICHERO ******************/
/*********************     DE NOTACION DIFERENCIAL     ******************/
/*********************** PEDRO CRUZ, Septiembre 1997 ********************/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#define MAXVIA 64


int
main(void)
{
  FILE *pf1, *pf2;
  char fichero1[MAXVIA];
  char fichero2[MAXVIA];
  char final,inicio;
  int i, j, k, datos, datos_byte1, datos_byte2, datos_byte3, datos_byte4;
  int instrumento, numero_nota, silencio, nota_inicial, numero_aleatorio;
  int silence, comienzo, nota_negativa, estilo;
  int tempo, tempo_byte1, tempo_byte2, tempo_byte3;
  double tempo1, tempo2;
  long int tempo3;


  struct duraciones        /*** Codificaci¢n midi de las duraciones     ***/
   { 		           /*** de nota usadas en la notaci¢n diferencial**/
       char duracion1;
       char duracion2;
       int byte1;
       int byte2;

   } duracion[] = { {' ',' ',0,0},{'r','l',134,78},{'r','p',133,80},
     {'r','m',132,88},{'r',' ',131,96},{'b','l',131,36},{'b','p',130,104},
     {'b','m',130,44},{'b','t',129,32},{'b',' ',129,112},{'n','l',129,82},
     {'n','p',129,52},{'n','m',129,22},{'n','t',80,0},{'n',' ',120,0},
     {'c','l',97,0},{'c','p',90,0},{'c','m',67,0},{'c','t',40,0},
     {'c',' ',60,0},{'s','p',37,0},{'s','t',20,0},{'s',' ',30,0},
     {'f','t',10,0},{'f',' ',15,0},{'u',' ',8,0} };


  struct notas {

	    int nota;
	    char duracion1;
	    char duracion2;

	   } partitura[500];


  for (j=0; j<=50; j++)   /*** Inizializaci¢n del vector partitura   ***/
			   /*** Es la £nica forma de que funcione m s ***/
			   /*** de una vez el programa. *****************/
     {
      partitura[j].nota=0;
      partitura[j].duracion1= 0x14;
      partitura[j].duracion2= 0x14;
     }


  srand(1);      /* Para generar un número aleatorio con el que obtener del
		    histograma la nota inicial */

  numero_aleatorio= rand() % 100; /* Genero un número aleatorio de 0 a 99 */



  printf("Nombre del fichero con notaci¢n diferencial (DIF): ");
  gets(fichero1);
  if (*fichero1 == '\0')  /* no se ha escrito ning£n nombre */
	return (0);

  printf("Nombre del fichero MIDI: ");
  gets(fichero2);
  if (*fichero2 == '\0')  /* no se ha escrito ning£n nombre */
	return (0);

  printf("Nota inicial (0 para que la ponga el programa): ");
  scanf("%d", &nota_inicial);

  if (nota_inicial==0)
  {
   printf("Estilo musical (Grego=1; Bach=2; Joplin=3): ");
   scanf("%d", &estilo);
  }

  printf("N£mero de instrumento (1-128) \n 1 para Scott Joplin\n 53 para Gregoriano y 49 o 74 para Bach: ");
  scanf("%d", &instrumento);

  printf("Tempo (1-250) \n Para las composiciones es aconsejable: \n Gregoriano = 60 \n Scott Joplin = 80 (lentas) ¢ 100 (r pidas) \n Bach = 60 (lentas) u 80 (r pidas): ");
  scanf("%d", &tempo); /*** N§ de negras por minuto ***/

  tempo1 = (60.0/tempo)*1000000.0;   /*** N§ de microsegundos por negra ***/
  tempo2 = ceil(tempo1);          /*** Redondeo ***/
  tempo3 = tempo2;                /*** Se pasa a long int (4 bytes) ***/

  tempo_byte1 = (tempo3 & 0x00FF0000)/0xFFFF;/** Se extraen individualmente*/
  tempo_byte2 = (tempo3 & 0x0000FF00)/0xFF;  /** con m scaras los 3 bytes **/
  tempo_byte3 = tempo3 & 0x000000FF;         /** que codifican el tempo ****/


  pf1 = fopen(fichero1, "r");

  pf2 = fopen(fichero2, "wb");


  if (nota_inicial==0)
   {
    if(estilo==1)  /* Gregoriano */
    {
     if(numero_aleatorio<15) nota_inicial=22;
     else if(numero_aleatorio<24) nota_inicial=19;
     else if(numero_aleatorio<50) nota_inicial=20;
     else if(numero_aleatorio<58) nota_inicial=15;
     else if(numero_aleatorio<66) nota_inicial=27;
     else if(numero_aleatorio<79) nota_inicial=24;
     else if(numero_aleatorio<97) nota_inicial=17;
     else if(numero_aleatorio<98) nota_inicial=26;
     else if(numero_aleatorio<99) nota_inicial=12;
     else if(numero_aleatorio<100) nota_inicial=29;
    }
    else if(estilo==2) /* J.S. Bach */
    {
     if(numero_aleatorio<8) nota_inicial=21;
     else if(numero_aleatorio<20) nota_inicial=24;
     else if(numero_aleatorio<23) nota_inicial=14;
     else if(numero_aleatorio<24) nota_inicial=32;
     else if(numero_aleatorio<31) nota_inicial=28;
     else if(numero_aleatorio<41) nota_inicial=22;
     else if(numero_aleatorio<48) nota_inicial=26;
     else if(numero_aleatorio<49) nota_inicial=10;
     else if(numero_aleatorio<61) nota_inicial=17;
     else if(numero_aleatorio<66) nota_inicial=25;
     else if(numero_aleatorio<68) nota_inicial=31;
     else if(numero_aleatorio<77) nota_inicial=19;
     else if(numero_aleatorio<78) nota_inicial=9;
     else if(numero_aleatorio<81) nota_inicial=16;
     else if(numero_aleatorio<86) nota_inicial=29;
     else if(numero_aleatorio<91) nota_inicial=12;
     else if(numero_aleatorio<94) nota_inicial=27;
     else if(numero_aleatorio<95) nota_inicial=18;
     else if(numero_aleatorio<96) nota_inicial=20;
     else if(numero_aleatorio<98) nota_inicial=23;
     else if(numero_aleatorio<100) nota_inicial=33;
    }
    else if(estilo==3) /* S. Joplin */
    {
     if(numero_aleatorio<8) nota_inicial=17;
     else if(numero_aleatorio<19) nota_inicial=19;
     else if(numero_aleatorio<25) nota_inicial=24;
     else if(numero_aleatorio<33) nota_inicial=20;
     else if(numero_aleatorio<47) nota_inicial=22;
     else if(numero_aleatorio<51) nota_inicial=23;
     else if(numero_aleatorio<54) nota_inicial=37;
     else if(numero_aleatorio<61) nota_inicial=27;
     else if(numero_aleatorio<62) nota_inicial=16;
     else if(numero_aleatorio<63) nota_inicial=28;
     else if(numero_aleatorio<65) nota_inicial=15;
     else if(numero_aleatorio<75) nota_inicial=25;
     else if(numero_aleatorio<80) nota_inicial=29;
     else if(numero_aleatorio<83) nota_inicial=18;
     else if(numero_aleatorio<86) nota_inicial=12;
     else if(numero_aleatorio<88) nota_inicial=30;
     else if(numero_aleatorio<89) nota_inicial=6;
     else if(numero_aleatorio<90) nota_inicial=26;
     else if(numero_aleatorio<91) nota_inicial=10;
     else if(numero_aleatorio<92) nota_inicial=32;
     else if(numero_aleatorio<95) nota_inicial=34;
     else if(numero_aleatorio<99) nota_inicial=13;
     else if(numero_aleatorio<100) nota_inicial=11;
    }
   }

  printf("El n§ aleatorio es: %d\n",numero_aleatorio);
  printf("La nota inicial es: %d\n",nota_inicial);


/******* LEO VECTOR NOTAS CODIF. DIFERENCIAL *******/

  i=0;


     fscanf(pf1, "%c%c%c", &inicio, &partitura[i].duracion1, &partitura[i].duracion2);

     partitura[i].nota=inicio;

     if (inicio=='S')
      {
       partitura[i].nota= nota_inicial; /*Poner aqu¡ el n£mero aleatorio (Do4 ahora)*/
      }
      else if(inicio!='S')
      {
       fseek(pf1,0L,SEEK_SET);
       fscanf(pf1, "%d%c%c", &inicio, &partitura[i].duracion1, &partitura[i].duracion2);
       partitura[i].nota=inicio;
      }

      i+=1;

/* Para cuando comienza con un silencio */

    if(inicio==99)    /* ahora vendr  una S */
    {
     fscanf(pf1, "%c%c%c", &inicio, &partitura[i].duracion1, &partitura[i].duracion2);

     partitura[i].nota=inicio;

     if (inicio=='S')
      {
       partitura[i].nota= nota_inicial; /*Poner aqu¡ el n£mero aleatorio (Do4 ahora)*/
      }
     i+=1;
    }

/* FIN Para cuando comienza con un silencio */



  while (!feof(pf1))   /***** BUCLE DE LECTURA DE NOTAS *****/
    {
     fscanf(pf1, "%c", &final);

     if (final != 0x0A)  fseek(pf1, -1, SEEK_CUR);


     if ((final != 0x0A) && (partitura[i-1].duracion2 != 0x0A))
       {
	 fscanf(pf1, "%d%c%c", &partitura[i].nota, &partitura[i].duracion1, &partitura[i].duracion2);

	 /* if (partitura[i].duracion2 != 0x0A) */ i += 1;
       }

    }

/******* FIN LEO VECTOR NOTAS CODIF. DIFERENCIAL *******/


/******* CONVIERTO DIFERENCIAL A IMPLICITA *********/

  silence=1;
  comienzo=1;
  nota_negativa=0;

  if(partitura[0].nota==99)
  {
   partitura[0].nota=0;
   comienzo=2;
  }

  for(j=comienzo;j<i;j++)
  {
   if(partitura[j].nota!=99)
   {
    if(silence==1)
    {
     partitura[j].nota=partitura[j-silence].nota + partitura[j].nota;
     if(partitura[j].nota<0)
     {
      nota_negativa=1;
      printf("Nota negativa. Repetir proceso con otra nota de comienzo\n");
     }
    }
    else
    {
     partitura[j].nota=partitura[j-silence].nota + partitura[j].nota;
     silence=1;
     if(partitura[j].nota<0)
     {
      nota_negativa=1;
      printf("Nota negativa. Repetir proceso con otra nota de comienzo\n");
     }
    }
   }
   else
    {
     partitura[j].nota=0;
     silence=silence+1;
    }
  }

/******* FIN CONVIERTO DIFERENCIAL A IMPLICITA *********/

 if(nota_negativa==0)
 {
  for(j=0;j<i;j++)
  {
   printf("%d%c%c", partitura[j].nota, partitura[j].duracion1, partitura[j].duracion2);
  }
 }




  /**************** ESCRIBO CABECERA DEL FICHERO MIDI **********************/

  putc(77,pf2); putc(84,pf2) ; putc(104,pf2); putc(100,pf2); putc(0,pf2);
  putc(0,pf2); putc(0,pf2); putc(6,pf2); putc(0,pf2); putc(1,pf2);
  putc(0,pf2); putc(2,pf2); putc(0,pf2); putc(120,pf2);



  /************************* ESCRIBO PISTA MAESTRA *************************/

  putc(77,pf2); putc(84,pf2); putc(114,pf2); putc(107,pf2); putc(0,pf2);
  putc(0,pf2); putc(0,pf2); putc(25,pf2); putc(0,pf2); putc(255,pf2);
  putc(88,pf2); putc(4,pf2); putc(4,pf2); putc(2,pf2); putc(24,pf2);
  putc(8,pf2); putc(0,pf2); putc(255,pf2); putc(89,pf2);
  putc(2,pf2); putc(0,pf2); putc(0,pf2); putc(0,pf2); putc(255,pf2);
  putc(81,pf2); putc(3,pf2);

  /*** tempo ***/ putc(tempo_byte1,pf2); putc(tempo_byte2,pf2);
		  putc(tempo_byte3,pf2);

  putc(0,pf2); putc(255,pf2); putc(47,pf2); putc(0,pf2);



  /********************* ESCRIBO PISTA DE MUSICA ***************************/

  putc(77,pf2); putc(84,pf2); putc(114,pf2); putc(107,pf2);

  /*** longitud inicial de datos ***/ putc(0,pf2); putc(0,pf2);
				    putc(0,pf2); putc(0,pf2);
  /*** fin long. inicial datos ***/
  /*** Rellenar luego cuando se conozca la longitud de los datos ***/

  putc(0,pf2); putc(255,pf2); putc(33,pf2); putc(1,pf2); putc(0,pf2);
  putc(0,pf2); putc(192,pf2);

  /** instrumento **/ putc(instrumento,pf2);


  datos = 0;
  silencio = 0;

  for (j=0; j<i; j++)  /***** BUCLE DE ESCRITURA DE NOTAS *****/
    {

     if (partitura[j].nota == 0)  /** Un Silencio **/
      {
       if (j != (i-1)) /* No hace nada si el silencio es la £ltima nota */
	{
	 if (partitura[j-1].nota == 0) /* La nota anterior es un silencio */
	   {
	    /* Como ya hay un t. inicio nota on pondr‚ una nota sin */
	    /* volumen y con duracion = 0 (= primer silencio) */
	    putc(144,pf2); datos += 1; /* Nota on */
	    putc(43,pf2); datos += 1; /* Nota mi5 */
	    putc(0,pf2); datos += 1; /* Volumen = 0 */
	    putc(0,pf2); datos += 1; /* Duracion 0 */
	    putc(128,pf2); datos += 1; /* Nota off */
	    putc(43,pf2); datos += 1;
	    putc(127,pf2); datos += 1;
	   }


	 silencio = 1;

	 /** Se escribe el tiempo de inicio de la nota on */
	 k = 0;
	 if (partitura[j].duracion2 == 0x0A) partitura[j].duracion2 = ' ';
	 while ((partitura[j].duracion1 != duracion[k].duracion1)
	       || (partitura[j].duracion2 != duracion[k].duracion2)) k+=1;

	 putc(duracion[k].byte1,pf2); datos += 1; /* Tiempo inicio nota on */
	 if (duracion[k].byte2 != 0)
	   { putc(duracion[k].byte2,pf2);         /* Continua t. inicio */
	     datos += 1;
	   }
	 /** Fin escritura tiempo de inicio de la nota on */
	}

      }else
	  {
	   if (silencio == 0)
	    {
	      putc(0,pf2); /** Tiempo inicio nota on = 0 **/
	      datos += 1;
	    }else
	      {
	       silencio = 0; /* No escribe nada porque ya lo ha hecho antes */
	      }

	   putc(144,pf2); /* Nota on */
	   datos += 1;

	   numero_nota = partitura[j].nota + 45;
	   putc(numero_nota,pf2);
	   datos += 1;

	   putc(100,pf2); /* Velocidad pulsaci¢n nota = 100 */
	   datos += 1;

	   /** Se escribe el tiempo de inicio de la nota off */
	   k = 0;
	   if (partitura[j].duracion2 == 0x0A)
	     {
	      partitura[j].duracion2 = ' ';
	     }

	   while ((partitura[j].duracion1 != duracion[k].duracion1) || (partitura[j].duracion2 != duracion[k].duracion2)) k+=1;

	   putc(duracion[k].byte1,pf2); datos += 1; /* Tiempo inicio nota off */
	   if (duracion[k].byte2 != 0)
	     { putc(duracion[k].byte2,pf2);         /* Continua t. inicio */
	       datos += 1;
	     }
	   /** Fin escritura tiempo de inicio de la nota off */

	   putc(128,pf2); /* Nota off */
	   datos += 1;

	   putc(numero_nota,pf2); /* Nota que se apaga (la actual)*/
	   datos += 1;

	   putc(127,pf2); /* Velocidad con que se apaga = 127 (la m xima) */
	   datos += 1;
	  }
     }

  /** Fin de pista **/
  putc(0,pf2); putc(255,pf2); putc(47,pf2); putc(0,pf2);

  datos = datos + 12; /* Hay que sumarle los 8 bytes que hay entre */
		      /* la longitud de los datos y las notas y los */
		      /* 4 bytes del final de pista */


  datos_byte1 = (datos & 0xFF000000)/0xFFFFFF;/* Se extraen individualmente*/
  datos_byte2 = (datos & 0x00FF0000)/0xFFFF;  /** con m scaras los 4 bytes*/
  datos_byte3 = (datos & 0x0000FF00)/0xFF;    /** que codifican el n§ de */
  datos_byte4 = datos & 0x000000FF;         /**datos de la pista de m£sica**/

  fseek(pf2,51,SEEK_SET);  /** Se rellenan los 4 bytes que representan **/
			   /** el n§ de datos de la pista de m£sica *****/
  putc(datos_byte1,pf2); putc(datos_byte2,pf2); putc(datos_byte3,pf2);
  putc(datos_byte4,pf2);


  fclose(pf1);
  fclose(pf2);


  return(0);
}
