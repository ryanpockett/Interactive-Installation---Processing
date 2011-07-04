// creating, dragging and resizing targets

//checks if mouse has been pressed INSIDE a target, if true then sets dragging boolean true and stores relative position b/w mouse and target
void mousePressed() {
  // this is just to make sure that currentTarget equals null
  currentTarget = null;
  for (int n = 0; n < numTargets; n++) {
    if (targets[n].inside(mouseX, mouseY)) {
      currentTarget = targets[n];
      draggingTarget = true;
      draggingTargetX = mouseX - currentTarget.x;   //offset: relative distance you need to maintain b/w mouse position and target center
      draggingTargetY = mouseY - currentTarget.y;
    }
  }
  // mouse is not INSIDE existing target, we create a new target
  if (currentTarget == null) {
    currentTarget = new Target(mouseX, mouseY, 4, 4);
    // add new target to target array
    targets[numTargets++] = currentTarget;
    draggingTarget = false;
  }
}

void mouseDragged() {
  if (currentTarget == null) return;
  if (draggingTarget) {                                // if dragging an existing Target
    currentTarget.x = mouseX - draggingTargetX; // - offset
    currentTarget.y = mouseY - draggingTargetY;
  } 
  else {                                               // if target is not dragged (draggingTarget = false) then new target is resized
    currentTarget.w = abs(mouseX - currentTarget.x)*2;
    currentTarget.h = abs(mouseY - currentTarget.y)*2;
  }
}

void mouseReleased() {
  currentTarget = null;
  draggingTarget = false;
}
