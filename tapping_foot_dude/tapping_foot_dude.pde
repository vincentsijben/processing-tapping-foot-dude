//free svg from: https://www.svgrepo.com/svg/191/cool
//@https://github.com/vincentsijben

PShape dude;
PShape glasses, glassesTmp;
PShape foot, footTmp;

BPM bpm = new BPM(140);

void setup() {
  size(700, 700);
  background(200);
  shapeMode(CENTER);

  dude = loadShape("dude.svg");
  //hide the original glasses
  glassesTmp = dude.getChild("glasses");
  glassesTmp.setVisible(false);
  //hide the original foot
  footTmp = dude.getChild("foot");
  footTmp.setVisible(false);

  //exported these shapes by rightclicking the shapes in Illustrator
  glasses = loadShape("glasses.svg");
  foot = loadShape("foot.svg");
}

void draw() {
  background(240);
  bpm.run();
  bpm.showInfo = true;

  translate(width/2, height/2);
  shape(dude, 0, 0);

  float full_sine = map(bpm.triggerNorm, 0, 1, 0, TWO_PI);
  float s = map(sin(full_sine), -1, 1, 1, 2);

  //only scale the glasses, so we need pushMatrix and popMatrix
  pushMatrix();
  fill(0);
  translate(0, -125);
  scale(s);
  shape(glasses, 0, 0);
  popMatrix();

  if (int(bpm.beatCount)%4==3) { // start one beat before every fourth

    //we want the motion of a half sine (only the part from 0 -> 1 -> 0)
    //so we need to map triggerNorm from 0 to PI (instead of 0 to TWO_PI)
    float half_sine = map(bpm.triggerNorm, 0, 1, 0, PI);
    //we need 0 -> -10 -> 0 so we need to multiply by -10
    float t = sin(half_sine)*-10;
    translate(60, 225+t);
  } else {
    translate(60, 225);
  }
  shape(foot, 0, 0);
}
