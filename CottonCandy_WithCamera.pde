import processing.video.*;

Capture cam;
PGraphics video, show;
long currentMillis, previousMillis;

int offset = 4;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(720, 720);
  video = createGraphics(720, 720);
  show = createGraphics(720, 720);

  colorMode(HSB, 255);

  cam = new Capture(this, 180, 180);
  cam.start();
  cam.read();
  videoToGraphics();
  background(0);
  smooth();
}

void draw() {
  fill(0, 5);
  rect(0,0,width, height);
  currentMillis = millis();
  if (cam.available()&&currentMillis - previousMillis >10) {
    previousMillis = currentMillis;
    cam.read();
    videoToGraphics();
  }

  if (particles.size() < 250) {
    particles.add(new Particle(random(0.1, 2), random(25, 250)));
  }
  if (particles.size() > 250) {
    particles.remove(0);
  }
  for (int i = 0; i < particles.size(); i++) {
    Particle particle = particles.get(i);
    if (particle.isDead()) {
      particles.remove(i);
    }
    particle.show();
    particle.update();
  }
  
  pushMatrix();
  scale(-1,1);
  image(show, -width, 0);
  popMatrix();
}

void videoToGraphics() {
  video.beginDraw();
  for (int x = 0; x < cam.width; x++) {
    for (int y = 0; y < cam.height; y++) {
      color c = cam.get(x, y);
      float hue = hue(c);
      float cHue = map(hue, 0, 255, 0, 20);
      float saturation = saturation(c);
      float cSaturation = map(saturation, 0, 255, 200, 225);
      float brightness = brightness(c);
      float cBrightness = map(brightness, 0, 255, 100, 200);

      video.pushMatrix();
      video.noStroke();
      video.fill(cHue, cSaturation, cBrightness);
      video.rect(x * offset, y * offset, offset, offset);
      video.popMatrix();
    }
  }
  video.endDraw();
}
