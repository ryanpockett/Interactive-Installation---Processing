import processing.net.*;
import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

int port = 10001;       
Server myServer;        

 int x = 0;
 int y = 0;
 int gain = -40;
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
  
  //Minim
  minim = new Minim(this);
  player = minim.loadFile("Radiata_Intense.mp3");
  player2 = minim.loadFile("Corona_Radiata.wav");
  player.loop();
  player.setGain(gain);
  player2.play();
  //END Minim
  
 system[0] = 12;
 system[1] = 10;
 system[2] = 8;
 
 computer[0] = "10.0.0.9";
 computer[1] = "10.0.0.12";
 computer[2] = "10.0.0.12";
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
  if (thisClient !=null) {
      String clientCommands = thisClient.readString();
      if (clientCommands != null) {
        String[] commands = split(trim(clientCommands), '\n');
        int commandIndex;
        for (commandIndex = 0; commandIndex < commands.length; commandIndex++) {
          doCommand(thisClient, commands[commandIndex]);
        }

      }
  }
}


void doCommand(Client thisClient, String command) {
  checkLights(thisClient, command);
  getSounds(thisClient, command);
  endGame(thisClient, command);
}
  

void endGame(Client thisClient, String whatClientSaid) {
if (thisClient !=null) {
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

void stop() {
  player.close();
  player2.close();
  minim.stop();
  super.stop();
}
