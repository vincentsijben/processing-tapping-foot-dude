/*
 Beats Per Minute
 
 Press 'i' to toggle the info window.
 Press 0 in the active window to 'reset' the timer
 Todo: Press 't' to go into tap mode. Tap on the beat to get the BPM right.
 
 */

class BPM {
  float bpm;
  float triggerValue;
  float triggerNorm;
  float beatCount;
  boolean showInfo;

  //helper variables to only run functions once until they reset
  boolean doOnce;
  float lastBeatCount;
  int frameCounter;
  int lastFrame;

  //we use these variables to be able to 'reset' the time whenever we want.
  float millis_runtime;
  float millis_start;

  //helper booleans that turn true every n beats.
  boolean every_2;
  boolean every_4;
  boolean every_8;
  boolean every_16;

  //helper booleans that turn true every n beats for 1 frame.
  boolean every_2_once;
  boolean every_4_once;
  boolean every_8_once;
  boolean every_16_once;

  BPM(float bpmTemp) {
    bpm = bpmTemp;
    triggerValue = 0;
    triggerNorm = 0;
    beatCount = 0;
    showInfo = false;

    doOnce = false;
    lastBeatCount = 0;
    frameCounter = 0;
    lastFrame = 0;

    millis_start = millis();

    every_2 = false;
    every_4 = false;
    every_8 = false;
    every_16 = false;

    every_2_once = false;
    every_4_once = false;
    every_8_once = false;
    every_16_once = false;
  }

  void run() {
    millis_runtime = millis()-millis_start;
    triggerValue = 60/bpm*1000;
    triggerNorm = millis_runtime%triggerValue/triggerValue;
    beatCount = millis_runtime/triggerValue;
    frameCounter++;

    checkBeatPeriods();

    if (showInfo) showInfo();

    checkKeyPresses();
  }

  void checkBeatPeriods() {
    if (beatCount>1) { //skip the first beat where all of these booleans would be true
      every_2 = int(beatCount)%2==0;
      every_4 = int(beatCount)%4==0;
      every_8 = int(beatCount)%8==0;
      every_16 = int(beatCount)%16==0;
    }

    //after every second beat, check if 2, 4, 8 or 16 beats are passed
    //if so, set the corresponding 'once' boolean to true for a 1 frame period
    if (every_2 && doOnce == false) {
      doOnce = true;
      lastBeatCount = int(beatCount);
      lastFrame = frameCounter;

      every_2_once = every_2;
      every_4_once = every_4;
      every_8_once = every_8;
      every_16_once = every_16;
    }

    //flip the 'once' booleans immediately after one frame
    if (frameCounter != lastFrame) {
      every_2_once = false;
      every_4_once = false;
      every_8_once = false;
      every_16_once = false;
    }
    //reset the mechanism after one beat
    if (int(lastBeatCount) != int(beatCount)) doOnce = false;
  }

  void showInfo() {
    //processing doesn't like transparancy in 3D
    //see https://www.reddit.com/r/processing/comments/59r0le/problems_with_transparency_in_3d/
    pushStyle();
    noStroke();
    fill(255, 100);
    rect(0, 0, 200, 140);
    fill(0);
    textSize(20);
    text("BPM: " + bpm, 10, 20);
    text("triggerValue: " + floor(triggerValue), 10, 40);
    text("beatCount: " + floor(beatCount), 10, 60);
    text("triggerNorm: " + nf(triggerNorm, 0, 3), 10, 80);
    text("frameRate: " + nf(frameRate, 0, 2), 10, 100);

    textAlign(CENTER, CENTER);
    textSize(10);

    fill(0);
    text("2nd", 40, 115);
    if (every_2) fill(0);
    else fill(255);
    ellipse(40, 130, 10, 10);

    fill(0);
    text("4th", 80, 115);
    if (!every_4) fill(255);
    ellipse(80, 130, 10, 10);

    fill(0);
    text("8th", 120, 115);
    if (!every_8) fill(255);
    ellipse(120, 130, 10, 10);

    fill(0);
    text("16th", 160, 115);
    if (!every_16) fill(255);
    ellipse(160, 130, 10, 10);

    popStyle();
  }

  void checkKeyPresses() {
    if (keyPressed) {
      if (key == '0') millis_start = millis();
      if (key == 'i') {
        keyPressed = false; //don't allow the key to be 'longpressed'
        showInfo = !showInfo;
      }
    }
  }
}
