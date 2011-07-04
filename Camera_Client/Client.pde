// Example by Tom Igoe 
// Creates a client that sends input to a server

boolean cleared = true;
boolean changed = false;

void sendData () {
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
