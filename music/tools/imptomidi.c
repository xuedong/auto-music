/********************* CONVERSION A MIDI DE UN FICHERO ******************/
/*********************     DE NOTACION IMPLICITA       ******************/
/************************ PEDRO CRUZ, Marzo 1997 ************************/

/* #include <dos.h> */
#include <stdio.h>
#include <math.h>
#define MAXVIA 64


int
main(void)
{
  FILE *pf1, *pf2;
  char fichero1[MAXVIA];
  char fichero2[MAXVIA];
  char final;
  int i, j, k, datos, datos_byte1, datos_byte2, datos_byte3, datos_byte4;
  int instrumento, numero_nota, silencio;
  int tempo, tempo_byte1, tempo_byte2, tempo_byte3;
  double tempo1, tempo2;
  long int tempo3;


  struct duraciones        /*** Codificaci¢n midi de las duraciones     ***/
   { 		           /*** de nota usadas en la notaci¢n impl¡cita ***/
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


  for (j=0; j<=500; j++)   /*** Inizializaci¢n del vector partitura   ***/
			   /*** Es la £nica forma de que funcione m s ***/
			   /*** de una vez el programa. *****************/
     {
      partitura[j].nota=0;
      partitura[j].duracion1= 0x14;
      partitura[j].duracion2= 0x14;
     }

  printf("Nombre del fichero con notaci¢n impl¡cita (IMP/SYN): ");
  gets(fichero1);
  if (*fichero1 == '\0')  /* no se ha escrito ning£n nombre */
	return (0);

  printf("Nombre del fichero MIDI: ");
  gets(fichero2);
  if (*fichero2 == '\0')  /* no se ha escrito ning£n nombre */
	return (0);

  printf("N£mero de instrumento (1-128) \n En la Sound Blaster es aconsejable 2 para Scott Joplin\n y 73 para Bach y Gregoriano: ");
  scanf("%d", &instrumento);

  printf("Tempo (1-250) \n Para las composiciones es aconsejable: \n Gregoriano = 60 \n Scott Joplin = 80 (lentas) ¢ 100 (r pidas) \n Bach = 50 (lentas) u 80 (r pidas): ");
  scanf("%d", &tempo); /*** N§ de negras por minuto ***/

  tempo1 = (60.0/tempo)*1000000.0;   /*** N§ de microsegundos por negra ***/
  tempo2 = ceil(tempo1);          /*** Redondeo ***/
  tempo3 = tempo2;                /*** Se pasa a long int (4 bytes) ***/

  tempo_byte1 = (tempo3 & 0x00FF0000)/0xFFFF;/** Se extraen individualmente*/
  tempo_byte2 = (tempo3 & 0x0000FF00)/0xFF;  /** con m scaras los 3 bytes **/
  tempo_byte3 = tempo3 & 0x000000FF;         /** que codifican el tempo ****/


  pf1 = fopen(fichero1, "r");

  pf2 = fopen(fichero2, "wb");



  i = 0;

  while (!feof(pf1))   /***** BUCLE DE LECTURA DE NOTAS *****/
    {
     fscanf(pf1, "%c", &final);
     if (final != 0x0A) fseek(pf1, -1, SEEK_CUR);

     if ((final != 0x0A) && (partitura[i-1].duracion2 != 0x0A))
       {
	 fscanf(pf1, "%d%c%c", &partitura[i].nota, &partitura[i].duracion1, &partitura[i].duracion2);

	 /* if (partitura[i].duracion2 != 0x0A) */ i += 1;
       }

    }

  fclose(pf1);

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



  fclose(pf2);

  return(0);
}
