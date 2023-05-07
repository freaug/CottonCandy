class Particle {
  PVector pos;
  PVector offset;

  float speeds[] = {0.01, 0.0075, 0.005, 0.0025};
  float waits[] = {1000, 2500, 5000, 7500};

  float prob;
  float dirProb;
  float colorProb;

  int speedWaits;

  boolean notInRange = false;

  float lifespan;
  float halfLife;

  float r; //size of orb
  float rGrowth;
  float d; //distance from center
  float adjust;
  float zoff;
  float theta;
  float speed;

  int dir;

  long currentMillis;
  long previousMillis;

  Particle(float _r, float _d) {
    offset = new PVector(width/2, height/2);

    while (!notInRange) {
      pos = new PVector(random(width), random(height));
      pos.add(offset);
      float d = PVector.dist(pos, offset);
      if (d <= 250) {
        notInRange = true;
      }
    }

    r = _r;
    d = _d;
    theta = radians(random(0, 360));
    dirProb = random(0, 1);
    colorProb = random(0, 1);
    speedWaits = floor(random(0, 4));
    lifespan = random(15, 20);
    halfLife = lifespan*0.5;
  }

  void update() {
    currentMillis = millis();
    // Polar to Cartesian conversion
    pos.x = d * cos(theta);
    pos.y = d * sin(theta);

    // Draw an ellipse at x,y
    if (dirProb > 0.5) {
      dir = -1;
    } else {
      dir = 1;
    }

    // Increment the angle
    theta += speeds[speedWaits] * dir;
    // Increment the radius
    if (currentMillis - previousMillis > waits[speedWaits]) { //pause need to relate to the speed it moves
      previousMillis = currentMillis;
      prob = random(0, 1);
      adjust = random(0.01, 0.05);
    }
    if (prob >0.5) {
      d += adjust;
    } else {
      d -= adjust;
    }

    lifespan -= 0.1;

    if (lifespan >= halfLife) {
      rGrowth +=0.05;
    } else {
      rGrowth -=0.05;
    }


    if (prob >0.5) {
      zoff += 0.001;
    } else {
      zoff -= 0.001;
    }
  }

  void show() {
    color c;

    if (colorProb > 0.3) {
      c = 0; //should be same as back ground color
    } else {
      c = video.get(int(pos.x+offset.x), int(pos.y+offset.y));
    }

    show.beginDraw();
    show.pushMatrix();
    show.noStroke();
    show.fill(c, lifespan);
    show.ellipse(pos.x+offset.x, pos.y+offset.y, r+rGrowth, r+rGrowth);
    show.popMatrix();
    show.endDraw();
  }

  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
