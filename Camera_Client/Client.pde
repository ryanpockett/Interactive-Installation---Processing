// Example by Tom Igoe 
// Creates a client that sends input to a server

boolean cleared = true;
boolean changed = false;
boolean[]soundCheck = new boolean [4];

void lightData () {
  float activeTargetDistance = updateTargets();
  if (activeTargetDistance < 20 && activeTargetDistance > 0 && !changed) {
    cleared = false;
    changed = true;
    myClient.write("change");
  }else if (activeTargetDistance > 20 && !cleared){
   myClient.write("cleared");
   cleared = true;
   changed = false;
  } 
}

void soundData () {
  
  float activeTargetDistance = updateTargets();
  int i = 0;
  //soundCheck[i] = false;
  if (activeTargetDistance < 60 && activeTargetDistance > 50 && !soundCheck[i]) {
      
      myClient.write("gain+");
      soundCheck[i] = true;    
      
  } else if (activeTargetDistance > 59 && soundCheck[i]){
    
   myClient.write("gain-");
   soundCheck[i] = false; 
   
  } 
}
