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
 computer[1] = "10.0.0.88";
 computer[2] = "10.0.0.89";
}

void draw()
{
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
        changeLights();
      }
    }
    } 
  } 
}
