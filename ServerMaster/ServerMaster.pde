import processing.net.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int port = 10001;       
Server myServer;        

 int x = 0;
 int y = 0;
 int activeLight = 0;
 int[] system = new int[3];
 String[] computer = new String[3];
 boolean firstLight = false;
 
 boolean[] endGame = new boolean[3];

void setup()
{
  size(400, 400);
  background(0);
  myServer = new Server(this, port);
  
  //Arduino
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(12, Arduino.OUTPUT);
  arduino.pinMode(11, Arduino.OUTPUT);
  arduino.pinMode(10, Arduino.OUTPUT);
  arduino.pinMode(9, Arduino.OUTPUT);
  arduino.pinMode(8, Arduino.OUTPUT);
  arduino.pinMode(7, Arduino.OUTPUT);
  //END Arduino
  
 system[0] = 12;
 system[1] = 10;
 system[2] = 8;
 
 computer[0] = "10.0.0.82";
 computer[1] = "10.0.0.6";
 computer[2] = "10.0.0.7";
}

void draw(){
  if (!firstLight){
    delay(2000);
    println("First Light Activated");
    lightON();
    firstLight = true;
  }
  // Get the next available client
  Client thisClient = myServer.available();

  // If the client is not null, and says something, display what it said
  if (thisClient !=null) {
    
    String whatClientSaid = thisClient.readString();
    println(thisClient.ip() + ": " + whatClientSaid);
    
    if (thisClient.ip().equals(computer[activeLight])){
    //String whatClientSaid = thisClient.readString();
      if (whatClientSaid != null) {
        println(thisClient.ip() + ": " + whatClientSaid);
         if (whatClientSaid.equals("change")){
           println("Changed lights for" + thisClient.ip());
          changeLights();
          //Sets active IP to True in the endGame array when target is occupied
          for (int i=0; i<3; i++){
            if(thisClient.ip().equals(computer[i])){
              endGame[i] = true;
              println("End Game activated for " + thisClient.ip());
            }
          }
        }
        
      } 
    } 
    if(whatClientSaid !=null) {
      if(whatClientSaid.equals("change")){
          for (int i=0; i<3; i++){
            if(thisClient.ip().equals(computer[i])){
              endGame[i] = true;
              println("End Game activated for " + thisClient.ip());
            }
          }
      }
      if (whatClientSaid.equals("cleared")){
          //Sets active IP to False in the endGame array when target clears
          for (int i=0; i<3; i++){
            if(thisClient.ip().equals(computer[i])){
              endGame[i] = false;
              println("End Game deactived for " + thisClient.ip());
            }
          }
        }
    }
  }
  
  endGame();
}

void endGame() {
  if (endGame[0] && endGame[1] && endGame[2]){
   println("WINNER WINNER CHICKEN DINNER");
  lightOFF();
  
  for (int i=0; i<3; i++){
    endGame[i] = false;
  }
  
  activeLight = 0;
  firstLight = false;
  
  } 
}
