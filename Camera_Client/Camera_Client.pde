
//\\//\\//\\//\\ Virtual Mine Field //\\//\\//\\//\\//\\//\\//
//\\// To Track Movement and Measure Distance in Sapce \\//\\/
//\\// Blob Detection + Frame Differencing \\//\\//\\//\\/\\//
//\\// By Rob Saunders and Petra Gemeinboeck \\//\\//\\///\\//
//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//\\//

import processing.net.*; 
Client myClient; 
int clicks;

import blobDetection.*;

// check the library website: 
// http://www.v3ga.net/processing/BlobDetection/

import processing.video.*;

//to access camera, check: http://processing.org/reference/libraries/video/index.html

PImage backgroundImage;

Capture capture;
PImage currentFrame;
PImage differenceFrame;
PImage blobFrame;
boolean newFrame = false;

BlobDetection blobDetector;

int numTargets;
Target[] targets = new Target[100];

Target currentTarget = null;
boolean draggingTarget = false;
float draggingTargetX = 0;
float draggingTargetY = 0;
/////luminance threshold; change this parameter depending on your lighting condition
float lumThreshold = 0.3;


void setup() {
  size(640, 480);
  //video capture
  capture = new Capture(this, width, height);
  backgroundImage = new PImage(width, height);

  //to substract (static) background
  currentFrame = new PImage(width, height);
  differenceFrame = new PImage(width, height);

  //for blob detection; blobs are contiguous areas
  blobFrame = new PImage(width/4, height/4);
  blobDetector = new BlobDetection(blobFrame.width, blobFrame.height);
  //the blobs we are looking for are white (rather than black)
  blobDetector.setPosDiscrimination(true);
  //thresholds the image to greyscale and anything >60% white will be considered part of a blob (based on luminance)
  blobDetector.setThreshold(lumThreshold);

  //creates first target in target array in center of screen; numTargets++ increments variable by 1 after an instance has been created 
  // t index 0
  //targets[numTargets++] = new Target(width/2, height/2, 120, 60);
  
    myClient = new Client(this, "10.0.0.9", 10001); 
  // Say hello
  myClient.write("iMac is connected.");
}

// if any key is pressed save the current video frame as background image (to be subtracted)
void keyPressed() {
  backgroundImage.copy(currentFrame, 0, 0, currentFrame.width, currentFrame.height, 0, 0, backgroundImage.width, backgroundImage.height);
}

// event called whenever new camera frame is ready
void captureEvent(Capture capture) {
  capture.read();
  // copies current capture into currentFrame (PImage)
  currentFrame.copy(capture, 0, 0, capture.width, capture.height, 0, 0, currentFrame.width, currentFrame.height);
  // copies background image into differenceFrame (PImage)
  differenceFrame.copy(backgroundImage, 0, 0, width, height, 0, 0, width, height);
  // subtracts currentFrame from differenceFrame (the copy of the background)
  differenceFrame.blend(currentFrame, 0, 0, width, height, 0, 0, width, height, DIFFERENCE);
  // copies differenceFrame to the blobFrame (lower resolution image for efficiency)
  blobFrame.copy(differenceFrame, 0, 0, differenceFrame.width, differenceFrame.height, 0, 0, blobFrame.width, blobFrame.height);
  // to smoothen edges of blobs (connects small blobs)
  blobFrame.filter(BLUR, 2);
  // load blobFrame pixels into pixel buffer
  blobFrame.loadPixels();
  // now a new frame is ready to be processed
  newFrame = true;
}

void draw() {
  if (newFrame) {
    updateBlobs();
    float activeTargetDistance = updateTargets();
    //////// to display the difference frame
    image(differenceFrame, 0, 0, width, height);
    //////// to display the current frame
    //image(differenceFrame, 0, 0, width, height);
    drawTargets();
    drawBlobs();
    lightData(activeTargetDistance);
    soundData(activeTargetDistance);
    newFrame = false;
  }
}

// the following five functions find the closest target to the blobs 

// this is where the blob detection happens 
void updateBlobs() {
  // get the blobs
  blobDetector.computeBlobs(blobFrame.pixels);
}

// update all of the targets
float updateTargets() {

  for (int n = 0; n < numTargets; n++) {
    updateTarget(targets[n]);
  }

  Target activeTarget = null;
  float activeTargetBlobDistance = width*width;
  for (int n = 0; n < numTargets; n++) {
    if (targets[n].closestBlobDistance < activeTargetBlobDistance) {
      activeTarget = targets[n];
      activeTargetBlobDistance = activeTarget.closestBlobDistance;
    }
  }
  if (activeTarget != null) {
    activeTarget.active = true;
    //if you want to know the distance from blob to currently active target, 
    //get it here: e.g. float distance2map = activeTarget.closestBlobDistance;
    //println(activeTarget.closestBlobDistance);
    return activeTarget.closestBlobDistance;
    } else {
      return 0;
    }
}

// finds closest overlapping blob to given target
void updateTarget(Target target) {
  target.active = false;
  target.closestBlob = null;
  target.closestBlobDistance = width*width;
  // get the number of blobs detected
  int N = blobDetector.getBlobNb();
  // loop through all the blobs to check each blob against all targets
  for (int n = 0; n < N; n++) {
    Blob blob = blobDetector.getBlob(n);
    // check to make sure that blob exists (it's a library thing)
    if (blob != null) {
      float distance = distanceFromTargetToBlob(target, blob);
      if (distance < target.closestBlobDistance) {
        // updates target with closest blob just found
        target.closestBlob = blob;
        // updates target with closest distance of blob just found
        target.closestBlobDistance = distance;
      }
    }
  }
}

float distanceFromTargetToBlob(Target target, Blob blob) {
  float closestDistanceToBlob = width*width;
  int M = blob.getEdgeNb();
  //loops through all the points of given blob
  for (int m = 0; m < M; m++) {
    EdgeVertex a = blob.getEdgeVertexA(m);
    if (a != null) {
      //checks distance from target to blob point
      float distance = distanceFromTargetToPoint(target, a.x*width, a.y*height);
      //checks if distance of point to target is less than closest distance found so far and updates closest distance
      if (distance < closestDistanceToBlob) closestDistanceToBlob = distance;
    }
  }
  return closestDistanceToBlob;
}

// find distance from target to a given point inside target area
float distanceFromTargetToPoint(Target target, float x, float y) {
  float distance = width*width;
  if (target.inside(x, y))
    distance = dist(x, y, target.x, target.y);
  return distance;
}

void drawTargets() {
  for (int n = 0; n < numTargets; n++) {
    Target t = targets[n];
    int grn = 0;
    if (t.active) grn = 255;
    noFill();
    strokeWeight(3);
    ellipseMode(CENTER);
    stroke(255, grn, 0);
    ellipse(t.x, t.y, t.w/3, t.h/3);
    stroke(255, grn, 0, 127);
    ellipse(t.x, t.y, 2*t.w/3, 2*t.h/3);
    stroke(255, grn, 0, 63);
    ellipse(t.x, t.y, t.w, t.h);
  }
}



void drawBlobs() {
  noFill();
  strokeWeight(3);
  stroke(0, 255, 0);
  int N = blobDetector.getBlobNb();
  for (int n = 0; n < N; n++) {
    Blob blob = blobDetector.getBlob(n);
    if (blob != null) {
      //point(blob.x*width, blob.y*height);
      int M = blob.getEdgeNb();
      for (int m = 0; m < M; m++) {
        EdgeVertex a = blob.getEdgeVertexA(m);
        EdgeVertex b = blob.getEdgeVertexB(m);
        if (a != null && b != null) line(a.x*width, a.y*height, b.x*width, b.y*height);
      }
    }
  }
}


