 //Incluimos librerias necesarias
#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

//Definimos constantes
#define MAX_TIME 85
#define DHT11PIN 7
#define ATTEMPTS 5

//Definimos un vector global
int dht11_val[5]={0,0,0,0,0};

/////////////////////////////////////////////////////////////
//Funcion principal para leer los valores del sensor.
int dht11_read_val(){
 uint8_t lststate=HIGH;
 uint8_t counter=0;
 uint8_t j=0,i;
 for(i=0;i<5;i++){
  dht11_val[i]=0;
 }
 pinMode(DHT11PIN,OUTPUT);
 digitalWrite(DHT11PIN,LOW);
 delay(18);
 digitalWrite(DHT11PIN,HIGH);
 delayMicroseconds(40);
 pinMode(DHT11PIN,INPUT);
 for(i=0;i<MAX_TIME;i++){
  counter=0;
  while(digitalRead(DHT11PIN)==lststate){
   counter++;
   delayMicroseconds(1);
   if(counter==255){
    break;
   }
  }
  lststate=digitalRead(DHT11PIN);
  if(counter==255){
   break;
  }
  //Las 3 primeras transiciones son ignoradas
  if((i>=4)&&(i%2==0)){
   dht11_val[j/8]<<=1;
   if(counter>16){
    dht11_val[j/8]|=1;
   }
   j++;
  }
 }

 // Hacemos una suma de comprobacion para ver si el dato es correcto. Si es asi, lo mostramos
 if((j>=40)&&(dht11_val[4]==((dht11_val[0]+dht11_val[1]+dht11_val[2]+dht11_val[3])& 0xFF))){
  printf("%d.%d,%d.%d\n",dht11_val[0],dht11_val[1],dht11_val[2],dht11_val[3]);
  return 1;
 }else{
  return 0;
 }
}

////////////////////////////////////////////////////////////////
//Empieza nuestro programa principal.
int main(void){
 //Establecemos el numero de intentos que vamos a realizar
 //la constante ATTEMPTS esta definida arriba
 int attempts=ATTEMPTS;

 //Si la libreria wiringPi, ve el GPIO no esta listo, salimos de la aplicacion
 if(wiringPiSetup()==-1){
  exit(1);
 }

 while(attempts){
  //Intentamos leer el valor del gpio, llamando a la funcion
int success = dht11_read_val();

  //Si leemos con exito, salimos del while, y se acaba el programa
  if (success){
   break;
  }

  //Si no lee con exito, restamos 1, al numero de intentos
  attempts--;

  //Esperamos medio segundo antes del siguiente intento.
  delay(500);
 }
 return 0;
}
