class structure {
  Boolean animation = false;
  float PX = 0;
  float PY = 0;
  int atimationPhase = rand(-1000, 1000);
  float sizeX;
  float sizeY;
  float rotate = 0;

  structure(float PX, float PY) {
    this.PX = PX;
    this.PY = PY;
  }
  structure(float PX, float PY, float rotate) {
    this.PX = PX;
    this.PY = PY;
    this.rotate = rotate;
  }
  structure(float PX, float PY, float sizeX, float sizeY) {
    this.PX = PX;
    this.PY = PY;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  structure(float PX, float PY, float sizeX, float sizeY, float rotate) {
    this.PX = PX;
    this.PY = PY;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.rotate = rotate;
  }
  void animation() {
    if (animation) {
      atimationPhase++;
    }
  }
  void render() {
  }
  void lightRender() {
  }
  void debugRender() {
  }
}

class coral extends structure {
  void c() {
  }
  coral(float PX, float PY) {
    super(PX, PY);
    c();
  }
  coral(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  coral(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  coral(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.setRotateImage(coralImage1, camX(posX(PX)), camY(posY(PY)), camZ(sizeX*1.5), camZ(sizeY*1.5), rotate);
  }
  void lightRender() {
    lightMap.map.fill(70, 255, 255, 60);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY-sizeY/4.0)), camZ(sizeX*2), camZ(sizeY*2));
  }
}

class coralFlower extends coral {
  void c() {
  }
  coralFlower(float PX, float PY) {
    super(PX, PY);
    c();
  }
  coralFlower(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  coralFlower(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  coralFlower(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    if (frameCount % 8 == 0) {
      if (rand(0, 8) == 0) {
        float A = random(0, TWO_PI);
        float L = random(1, 30);

        if (PY+cos(A)*L < -0.5) {
          particlesSystem.add(new blueGlow(posX(PX)+sin(A)*L, posY(PY)+cos(A)*L));
        }
      }
    }
    lg.setRotateImage(coralFlowerImage1, camX(posX(PX)), camY(posY(PY)), camZ(sizeX*1.5), camZ(sizeY*1.5), rotate);
  }
  void lightRender() {
    lightMap.map.fill(70, 255, 255, 90);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)), camZ(sizeX*2), camZ(sizeY*2));
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)), camZ(sizeX*2.5), camZ(sizeY*2.5));
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)), camZ(sizeX*3), camZ(sizeY*3));
    lightMap.map.fill(70, 255, 255, 40);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)), camZ(sizeX*5), camZ(sizeY*5));
  }
}
class coralFlower1 extends coral {
  void c() {
  }
  coralFlower1(float PX, float PY) {
    super(PX, PY);
    c();
  }
  coralFlower1(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  coralFlower1(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  coralFlower1(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.setRotateImage(coralFlowerImage1_1, camX(posX(PX)), camY(posY(PY)), camZ(sizeX*1.5), camZ(sizeY*1.5), rotate);
  }
  void lightRender() {
    lightMap.map.fill(70, 255, 255, 90);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY-sizeY/4.0)), camZ(sizeX*0.5), camZ(sizeY*1.5));
  }
}
class plantLamp extends coral {
  void c() {
  }
  plantLamp(float PX, float PY) {
    super(PX, PY);
    c();
  }
  plantLamp(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  plantLamp(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  plantLamp(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.setRotateImage(plantLamp, camX(posX(PX)), camY(posY(PY)+0.45*sizeY), camZ(sizeX*1), camZ(sizeY*1), rotate+PI);
  }
  void lightRender() {
    lightMap.map.fill(150, 255, 255, 150);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)+sizeY/1.36), camZ(sizeX*0.6), camZ(sizeY*0.6));
  }
}
class grassBg1 extends coral {
  void c() {
  }
  grassBg1(float PX, float PY) {
    super(PX, PY);
    c();
  }
  grassBg1(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  grassBg1(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  grassBg1(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.setRotateImage(grassBg1, camX(posX(PX)), camY(posY(PY)), camZ(sizeX*1.5), camZ(sizeY*1.5), rotate);
  }
  void lightRender() {
  }
}
class grass extends structure {
  private void construct() {
    animation = true;
  }
  grass(float PX, float PY) {
    super(PX, PY);
    construct();
  }
  grass(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    construct();
  }
  void render() {
    lg.fill(50, 200, 50);
    float rot = sin(atimationPhase/50.0)/4.0;
    lg.setRotateImage(grass, camX(posX(PX+sin(rot)*sizeX/2.06)), camY(posY(PY+cos(rot)*sizeY/2.06)), camZ(2.2)*sizeX, camZ(2.2)*sizeY, rot);
  }
  void debugRender() {
    lg.fill(200, 50, 50);
    float rot = sin(atimationPhase/50.0)/4.0;
    lg.setRotateBlock(camX(posX(PX+sin(rot)*sizeX/2.06)), camY(posY(PY+cos(rot)*sizeY/2.06)), 3, camZ(2.2)*sizeY, rot);
  }
}


class detailPart extends structure {

  void c() {
    rotate = random(0, TWO_PI);
  }
  detailPart(float PX, float PY) {
    super(PX, PY);
    c();
  }
  detailPart(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  detailPart(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  detailPart(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.fill(80, 120, 160);

    if (zoom < 19) {
      if (sizeX < 0.45) {
        return;
      }
      if (zoom < 16) {
        if (sizeX < 0.6) {
          return;
        }
        if (zoom < 14) {
          if (sizeX < 0.75) {
            return;
          }
          if (zoom < 12) {
            if (sizeX < 1.08) {
              return;
            }
            if (zoom < 7) {
              if (sizeX < 1.19) {
                return;
              }
            }
          }
        }
      }
    }
    if (zoom > 10) {
      lg.setRotateImage(backStructure1, camX(posX(PX)), camY(posY(PY)), camZ(sizeX*1.6), camZ(sizeY*1.6), rotate);
    } else {
      lg.setImage(backStructure1, camX(posX(PX)), camY(posY(PY)), camZ(sizeX*1.6), camZ(sizeY*1.6));
    }
  }
}

class tree1 extends structure {
  void c() {
  }
  tree1(float PX, float PY) {
    super(PX, PY);
    c();
  }
  tree1(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  tree1(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  tree1(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.fill(80, 120, 160);
    lg.setImage(tree1, camX(posX(PX)), camY(posY(PY)+0.45*sizeY), camZ(sizeX*1), camZ(sizeY*1));
  }
}
class tree2 extends structure {
  void c() {
  }
  tree2(float PX, float PY) {
    super(PX, PY);
    c();
  }
  tree2(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  tree2(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  tree2(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.fill(80, 120, 160);
    lg.setImage(tree2, camX(posX(PX)), camY(posY(PY)+0.45*sizeY), camZ(sizeX*1), camZ(sizeY*1));
  }
}
class tree3 extends structure {
  void c() {
  }
  tree3(float PX, float PY) {
    super(PX, PY);
    c();
  }
  tree3(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  tree3(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  tree3(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.fill(80, 120, 160);
    lg.setImage(tree3, camX(posX(PX)), camY(posY(PY)+0.45*sizeY), camZ(sizeX*1), camZ(sizeY*1));
  }
}
class picka extends structure {
  void c() {
  }
  picka(float PX, float PY) {
    super(PX, PY);
    c();
  }
  picka(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  picka(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  picka(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    lg.fill(80, 120, 160);
    lg.setImage(picka, camX(posX(PX)), camY(posY(PY)+0.45*sizeY), camZ(sizeX*1), camZ(sizeY*1));
  }
}
class blackSmokers extends structure {
  int type = 0;
  void c() {
  }
  blackSmokers(float PX, float PY) {
    super(PX, PY);
    c();
  }
  blackSmokers(float PX, float PY, float rotate) {
    super(PX, PY, rotate);
    c();
  }
  blackSmokers(float PX, float PY, float sizeX, float sizeY) {
    super(PX, PY, sizeX, sizeY);
    c();
  }
  blackSmokers(float PX, float PY, float sizeX, float sizeY, float rotate) {
    super(PX, PY, sizeX, sizeY, rotate);
    c();
  }
  void render() {
    PImage img = black1;
    switch(type) {
    case 0:
      img = black1;
    case 1:
      img = black2;
    case 2:
      img = black3;
    case 3:
      img = black4;
    }
    lg.setTint(190, 255);
    lg.setImage(img, camX(posX(PX)), camY(posY(PY)+0.45*sizeY), camZ(sizeX*1), camZ(sizeY*1));
    lg.noTint();
    if (frameCount % 2 == 0 && rand(0, 4) == 0) {
      particlesSystem.add(new blackSmokersParticle(posX(PX+random(-sizeX/4.0, sizeX/4.0)), posY(PY+sizeY*0.4), sizeX/2.2));
    }
  }
}
