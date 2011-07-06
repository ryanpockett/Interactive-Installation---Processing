import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
AudioPlayer player2;

void getSounds(Client thisClient, String whatClientSaid){
  
  if (thisClient !=null) {
    
    if (thisClient.ip().equals(computer[activeLight])){
      
      if(whatClientSaid !=null) {
    
        if (whatClientSaid.equals("gain+")){
          // println("reached gain+");
          gain = gain + 20;
          player.shiftGain(gain-20, gain, 2000);
      
        }else if (whatClientSaid.equals("gain-")){
          //println("reached gain-");
          player.shiftGain(gain, gain-20 , 2000);
          gain = gain - 20;
        
        }
      } 
    }
  } 
}
