void changeLights() {
 lightOFF();
 activeLight = generateNumber();
 lightON();
 //delay(1000);
}

float generateRandom() {
  float r = random(0, 3);
  return (int)r; 
}

int generateNumber() {

 while (x == y){
   x = (int)generateRandom();
 }
 y = x;
  println("Activating Light: " + (int)y);
  return y;
}

void lightON() {
  arduino.digitalWrite(system[activeLight], Arduino.HIGH);
  delay(200);
  arduino.digitalWrite(system[activeLight], Arduino.LOW);
  delay(200);
}

void lightOFF() {
  arduino.digitalWrite(system[activeLight]-1, Arduino.HIGH);
  delay(200);
  arduino.digitalWrite(system[activeLight]-1, Arduino.LOW);
  delay(200);
}

void checkLights (Client thisClient, String whatClientSaid){
  
   if (thisClient !=null) {
    if (thisClient.ip().equals(computer[activeLight])){

      if (whatClientSaid != null) {
        
        println(thisClient.ip() + ": " + whatClientSaid);
        
         if (whatClientSaid.equals("change")){
           println("Changed lights for: " + thisClient.ip());
           player.shiftGain(gain, -40 , 2000);
          gain = -40;
          changeLights();
          
         }
      }
    }
   }
}
