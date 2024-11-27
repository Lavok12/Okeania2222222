PImage startSceneBG;
PImage startSceneBlack;
PImage startSceneNoise;
PImage startSceneTitan;
PImage startSceneLp;

PShader SSE1;
PShader SSE3;
PShader SSE4;

float startSceneTimer = -5000;
float SST1 = -1, SST2 = 0, SST3 = 0;

ArrayList<localParticles> localParticles = new ArrayList<localParticles>();
ArrayList<localParticles2> localParticles2 = new ArrayList<localParticles2>();

Image startSceneShyp;

void startSceneLoad() {
  startSceneBG = loadImage("StartScene/StartSceneBG.jpg");
  startSceneBlack = loadImage("StartScene/black.png");
  startSceneNoise = loadImage("StartScene/noise.jpg");
  startSceneTitan = loadImage("StartScene/titan.png");
  startSceneLp = loadImage("StartScene/lp.png");

  startSceneShyp = new Image(loadImage("StartScene/shyp.png"));

  SSE1 = loadShader("StartScene/SSE1.glsl");
  SSE3 = loadShader("StartScene/SSE3.glsl");
  SSE4 = loadShader("StartScene/SSE4.glsl");

  startSceneTimer = -1;
  SST1 = -1;
  SST1 = 3;
  SST2 = 0;
  SST3 = 0;
}

void startSceneRender() {
  startSceneTimer++;

  lg.beginDraw();
  lg.pg.noStroke();
  lg.pg.clear();

  lg.bg(0);
  lg.setTint(60, 100, 150, 140);
  lg.setImage(startSceneBG, 0, 0, lg.disW, lg.disW);
  lg.noTint();

  lg.pg.tint(50, 60);
  lg.setImage(startSceneNoise, random(-200, 200), random(-200, 200), lg.disW*2, lg.disH*2);
  lg.noTint();


  if (SST3 == 0) {
    lg.pg.tint(80, 110, 130);
    localParticles.add(new localParticles(-300, random(-10, 10)));
  }

  lg.pg.tint(90, 110, 130);
  lg.setTint(60, 90, 120, 30);
  for (int i = 0; i < localParticles2.size(); i++) {
    localParticles2.get(i).update();
  }

  if (startSceneTimer-500 > 200 && !(startSceneTimer-500 >= 1900)) {
    SST1 = ((startSceneTimer-200-500)/300.0+3);
  }
  if (startSceneTimer-500 >= 0) {
    SST2 = min(startSceneTimer-500, 1900);
  }
  if (startSceneTimer-500 >= 1900) {
    SST2 = 2000 - (startSceneTimer-500-1900)*8;

    SST1 /= 1.01;
    SST3++;
  }

  for (float j = 2.0; j >= 1.0; j--) {
    lg.pg.tint((70-j*15)*0.7, (90-j*18)*0.7, (110-j*20)*0.7);
    float DX = -1200-1650+sqrt(SST2)*25;
    float DY = 150-j*10;
    float DA = (1.9+0.3-j*0.2+0.2);
    float size = 200;
    for (int i = 0; i < 14; i++) {
      size = (200-i*5.0-j*10);
      size *= 1.9;
      lg.setRotateImage(startSceneShyp.imgR, DX+sin(DA)*size/2.2, DY+cos(DA)*size/2.2, size, size, DA);
      DX += sin(DA)*size*0.65;
      DY += cos(DA)*size*0.65;
      DA -= ((i/5.0/(j/5.0+1))/SST1/1.2)*1.8;
    }
  }
  
  for (int i = 0; i < localParticles.size(); i++) {
    localParticles.get(i).update();
    if (localParticles.get(i).time <= 0) {
      localParticles.remove(i);
      i--;
    }
  }

  lg.endDraw();

  SSE4.set("power", lg.pg.width/330.3);
  SSE4.set("del", 1);
  SSE4.set("dis", (float)lg.pg.width, (float)lg.pg.height);
  lg.pg.filter(SSE4);

  lg.beginDraw();

  if (startSceneTimer == 0) {
    for (int ii = 0; ii < 100; ii++) {
      localParticles2.add(new localParticles2(random(-3000, 30000), random(-3000, 3000)));
    }
    for (int ii = 0; ii < 100; ii++) {
      localParticles.add(new localParticles(-300, random(-10, 10)));
      for (int i = 0; i < localParticles.size(); i++) {
        localParticles.get(i).update();
        if (localParticles.get(i).time <= 0) {
          localParticles.remove(i);
          i--;
        }
      }
    }
  }

  lg.pg.tint(90, 110, 130);
  lg.setRotateImage(startSceneTitan, -SST3*9, -24, 700, 700, SST3/250.0);

  SSE4.set("power", lg.pg.width/1100.5);
  SSE4.set("del", 1);
  SSE4.set("dis", (float)lg.pg.width, (float)lg.pg.height);
  lg.pg.filter(SSE4);

  for (float j = 1; j >= 0.0; j--) {
    lg.pg.tint((90-j*15)*0.7, (110-j*18)*0.7, (130-j*20)*0.7);
    float DX = -1200-1650+sqrt(SST2)*25;
    float DY = -500+j*10;
    float DA = 1.06-0.3+j*0.2-0.2;
    float size = 200;
    for (int i = 0; i < 14; i++) {
      size = (200-i*5.0-j*10);
      size *= 1.9;
      lg.setRotateImage(startSceneShyp.img, DX+sin(DA)*size/2.2, DY+cos(DA)*size/2.2, size, size, DA);
      DX += sin(DA)*size*0.65;
      DY += cos(DA)*size*0.65;
      DA += ((i/5.0/(j/5.0+1))/SST1)*1.8;
    }
  }

  if (SST3 > 0) {
    lg.endDraw();

    SSE4.set("power", lg.pg.width/3000.3*SST3/5.0);
    SSE4.set("del", 1);
    SSE4.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(SSE4);

    SSE4.set("power", lg.pg.width/1700.5*SST3/5.0);
    SSE4.set("del", 1);
    SSE4.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(SSE4);

    lg.beginDraw();
  }
  lg.setTint(60, 100, 150, 100);
  lg.setImage(startSceneBG, 0, 0, lg.disW, lg.disW);

  lg.noTint();

  SSE1.set("resolution", float(lg.pg.width), float(lg.pg.height));
  SSE1.set("time", frameCount/71.43);
  SSE1.set("screenTex", lg.pg);

  lg.pg.filter(SSE1);

  lg.setImage(startSceneBlack, 0, 0, lg.disW*3.8, lg.disH*3.8);

  if (SST3 > 60) {
    lg.fill(0, (SST3-60)*3);
    lg.setBlock(0, 0, 10000, 10000);
  }

  if (startSceneTimer < 128) {
    lg.fill(0, 255-startSceneTimer*2.0);
    lg.setBlock(0, 0, 10000, 10000);
  }
  lg.endDraw();

  image(lg.pg, 0, 0, width, height);

  SSE3.set("l", 0);
  SSE3.set("resolution", (float)width, (float)height);
  filter(SSE3);

  SSE3.set("l", 4);
  SSE3.set("resolution", (float)width, (float)height);
  filter(SSE3);
}

class localParticles {
  float PX, PY;
  float time = 100;

  localParticles(float PX, float PY) {
    this.PX = PX;
    this.PY = PY;
  }
  void update() {
    PX -= random(4, 7);
    PY -= random(-3, 3)+(PY/30.0);
    time--;
    lg.setImage(startSceneLp, PX, PY-20, time/10.0*1.3, time/10.0*1.3);
  }
}

class localParticles2 {
  float PX, PY;
  float Z = random(3, 5);

  localParticles2(float PX, float PY) {
    this.PX = PX;
    this.PY = PY;
  }
  void update() {
    PX -= random(4, 7);
    lg.setImage(startSceneLp, PX/Z, PY/Z, 300/Z, 300/Z);
    if (PX/Z < -1500) {
      PX += 30000;
    }
  }
}
