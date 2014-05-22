/*
  rfreceive.cpp
  by Sarrailh Remi
  Description : This code receives RF codes and trigger actions
*/

#include "RCSwitch.h"
#include <stdlib.h>
#include <stdio.h>

  RCSwitch mySwitch;
  int pin; //Pin of the RF receiver
  int codereceived; // Code received
  char buffer[200]; // Buffer for the command
  int dato;
  int salir;
  int main(int argc, char *argv[]) {
	  
	if(argc == 2) { //Verify if there is an argument
      pin = atoi(argv[1]); //Convert first argument to INT
//      printf("PIN SELECTED :%i\n",pin);
    }
  else {
    printf("No PIN Selected\n");
    printf("Usage: rfreceive PIN\n");
    printf("Example: rfreceive 0\n");
    exit(1);
  }

    if(wiringPiSetup() == -1) { //Initialize WiringPI
      printf("Wiring PI is not installed\n"); //If WiringPI is not installed give indications
      printf("You can install it with theses command:\n");
      printf("apt-get install git-core\n");
      printf("git clone git://git.drogon.net/wiringPi\n");
      printf("cd wiringPi\n"); 
      printf("git pull origin\n");
      printf("./build\n");
      exit(1);
    }

   mySwitch = RCSwitch(); //Settings RCSwitch (with first argument as pin)
   mySwitch.enableReceive(pin);
    dato = 0;
   salir =1;
   while(salir) { //se repite el ciclo hasta te tenga alguna lectura de datos
    if (mySwitch.available()) { //If Data is detected.
         //codereceived = mySwitch.getReceivedValue(); //Get data in decimal
          dato = mySwitch.getReceivedValue(); // obtener de datos de radio frecuencias
	  //printf("%i",mySwitch.getReceivedValue() );
	  if(dato > 0){ // si dato es mayor 0 no esta vacio, nota lo puse mayor a cero porque vivo en Costa Rica y no hay esas temperaturas.
	    printf("%i", dato );
	    salir = 0;
	 }
          //Want to execute something when a code is received ?
          //When 12345 is received this will execute program_to_execute for exemple)
          /*
          if (codereceived == 12345)
          {
            system("program_to_execute");
          }
          */
    }
  mySwitch.resetAvailable();
  }
}
