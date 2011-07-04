import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;

void getSounds(){
  
  Client thisClient = myServer.available();
  
  
  if (thisClient !=null) {
    String whatClientSaid = thisClient.readString();
    if(whatClientSaid !=null) {
    
    if (whatClientSaid.equals("gain+")){
      println("reached gain+");
      gain = gain + 80;
      player.shiftGain(-40, gain, 2000);
      
    }else if (whatClientSaid.equals("gain-")){
      println("reached gain-");
      
     player.shiftGain(gain, -40 , 2000);
      gain = gain - 80;
    }
    
  } 
  }
  
}
