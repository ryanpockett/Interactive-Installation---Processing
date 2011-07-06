// Example by Tom Igoe 
// Creates a client that sends input to a server
int high = 160;
int low = 140;
boolean cleared = true;
boolean changed = false;
boolean[]soundCheck = new boolean [10];
int i = 0;

void lightData (float activeTargetDistance) {
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

void soundData (float activeTargetDistance) {
  if (activeTargetDistance < high && activeTargetDistance > low && !soundCheck[i]) {
      
      myClient.write("gain+");
      soundCheck[i] = true;
      //myClient.write("soundcheck["+i+"]:" + soundCheck[i]);
      high = high - 20;
      //myClient.write("high: " + high);
      low = low - 20;
      //myClient.write("low: " + low);
      i++;
      //myClient.write("i: " + i);
      
      
  } else if(activeTargetDistance > high+20 && i > 0){
    if (soundCheck[i-1]){
       i--; 
       //myClient.write("i: " + i);
       myClient.write("gain-");
       soundCheck[i] = false;
       //myClient.write("soundcheck["+i+"]:" + soundCheck[i]);
       high = high + 20;
       //myClient.write("high: " + high);
       low = low + 20;
       //myClient.write("low: " + low);
         
      
    }
  }
}
