float G = 0.008;

class entity {
  float rotate = 0;
  Boolean reverse = false;
  Boolean dead = false;
  int isCollision = 0;
  hitbox hitbox;
  float PX = 0, PY = 0, SX = 0, SY = 0;
  float size = 1;
  float COLOR_R = 255.0;
  float COLOR_G = 255.0;
  float COLOR_B = 255.0;
  float COLOR_T = 0.0;
  
  transport inTransport = null;

  float flip = 0;

  entity(float PX, float PY) {
    this.PX = PX;
    this.PY = PY;
  }
  void hitboxRender() {
    if (hitbox != null) {
      hitbox.render();
    }
    lg.fill(200, 50, 50);
    float rot = atan2(SX, SY);
    float l = leng(SX, SY)*200;
    lg.setRotateBlock(camX(posX(PX))+sin(rot)*l/2.0, camY(posY(PY))+cos(rot)*l/2.0, 4, l, rot);
  }
  void backHitboxOptimization() {
    if (hitbox != null) {
      hitbox.optimization();
    }
  }
  void hitboxOptimization() {
    backHitboxOptimization();
  }

  void move() {
    if (inTransport == null) {
      backMove(true);
    } else {
      backMove(false);
      if (hitbox != null) {
        inTransport.inTransportCollision(hitbox);
      }
    }
  }
  void backMove(Boolean cl) {
    if (hitbox != null) {
      float S_X = SX;
      float S_Y = SY;
      float m = max(abs(S_X), abs(S_Y));

      for (; m > 0; m -= hitbox.size/4) {
        if (S_X > 0) {
          PX += min(hitbox.size/4, S_X);
          S_X = max(0, S_X - hitbox.size/4);
        } else if (S_X < 0) {
          PX += max(-hitbox.size/4, S_X);
          S_X = min(0, S_X + hitbox.size/4);
        }
        if (S_Y > 0) {
          PY += min(hitbox.size/4, S_Y);
          S_Y = max(0, S_Y - hitbox.size/4);
        } else if (S_Y < 0) {
          PY += max(-hitbox.size/4, S_Y);
          S_Y = min(0, S_Y + hitbox.size/4);
        }

        //m -= hitbox.size;
        if (cl) {
          hitbox.collision();
        }
      }
    } else {
      PX += SX;
      PY += SY;
    }
  }
  void backGravity() {
    SY -= G;
  }
  void gravity() {
    if (PY > -0.21 || inTransport != null) {
      backGravity();
    }
  }
  void friction(float x1, float x2) {
    if (PY >= -0.21) {
      SX = SX*x1;
      //SY = SY*x1;
    } else {
      SX = SX*x2;
      SY = SY*x2;
    }
  }
  void update() {
  }
  void render() {
  }
  void lightRender() {
  }
}
class moonFish extends entity {
  float phase = random(0, 1000);
  float phase2 = random(0, 1000);

  moonFish(float PX, float PY) {
    super(PX, PY);
    size = random(3.6, 5.6);
    hitbox = new hitbox(this, size);
    COLOR_R += random(-50, 50);
    COLOR_G += random(-50, 50);
    COLOR_B += random(-50, 50);
  }
  void update() {
    phase += random(0.98, 1.02)/10.0;
    phase2 += random(0.1, 1.0)/10.0+sin(phase/0.60)/10.0;

    if (PY < 0) {
      SX += sin(phase2/90.0-phase/600)/(400)*sin(phase/82.0)*0.4;
      SY += cos(phase/80.0+phase2/800.0)/(400)*sin(phase2/90.0)*0.1;
    }
    if (PY > -2) {
      SY -= 0.001;
    }
  }
  void render() {
    lg.pg.tint(COLOR_R, COLOR_G, COLOR_B);
    if (PY < 0) {
      if (SX < 0) {
        flip = 0;
      } else if (SX > 0) {
        flip = 1;
      }
    }
    lg.setRotateImage(flip==0?moonFish.imgR:moonFish.img, camX(posX(PX)), camY(posY(PY)), camZ(size*2.5), camZ(size*2.5), sin(phase/15.0/size)*0.14);
    lg.pg.noTint();
  }
}
class demon2 extends entity {
  float phase = random(0, 1000);
  float phase2 = random(0, 1000);
  hitbox hitboxes[] = new hitbox[5];

  demon2(float PX, float PY) {
    super(PX, PY);
    size = random(14.0, 16.9);
    COLOR_R += random(-50, 0);
    COLOR_G += random(-50, 0);
    COLOR_B += random(-50, 0);

    for (int i = 0; i < 5; i++) {
      hitboxes[i] = new hitbox(this, size/3.0, (-1.0+i*0.5)/3.0*size, 0.2);
    }
  }
  void hitboxRender() {
    for (int i = 0; i < 5; i++) {
      hitboxes[i].render();
    }
  }
  void hitboxOptimization() {
    for (int i = 0; i < 5; i++) {
      hitboxes[i].optimization();
    }
  }
  void collision() {
    for (int i = 0; i < 5; i++) {
      hitboxes[i].collision();
    }
  }
  void update() {
    phase += random(0.98, 1.02)/50.0;
    phase2 += random(0.1, 1.0)/50.0+sin(phase/0.60)/50.0;

    if (PY < 0) {
      SX += sin(phase2/90.0-phase/600)/(400)*sin(phase/82.0)*2;
      SY += cos(phase/80.0+phase2/800.0)/(400)*sin(phase2/90.0)*0.5;
    }
    if (PY > -2) {
      SY -= 0.001;
    }
    collision();
  }
  void render() {
    lg.pg.tint(COLOR_R, COLOR_G, COLOR_B);
    if (PY < 0) {
      if (SX < 0) {
        flip = 1;
      } else if (SX > 0) {
        flip = 0;
      }
    }
    lg.setRotateImage(flip==1?demon2Part1.imgR:demon2Part1.img, camX(posX(PX)), camY(posY(PY)), camZ(size*2.5), camZ(size*2.5), 0);
    lg.setRotateImage(flip==1?demon2Part2.imgR:demon2Part2.img, camX(posX(PX+(flip==0?0.26:-0.26)*size)), camY(posY(PY-0.035*size)), camZ(size*1.35), camZ(size*1.35),
      (sin(phase*1.0)*0.2+0.2)*-(flip*2-1));

    lg.pg.noTint();
  }
  void lightRender() {
    lightMap.map.setTint(200, 190);
    lightMap.map.setRotateImage(flip==1?demon2Part1.imgR:demon2Part1.img, camX(posX(PX)), camY(posY(PY)), camZ(size*2.7), camZ(size*3.1), 0);
    lightMap.map.setRotateImage(flip==1?demon2Part2.imgR:demon2Part2.img, camX(posX(PX+(flip==0?0.26:-0.26)*size)), camY(posY(PY-0.035*size)), camZ(size*1.55), camZ(size*1.55),
      (sin(phase*1.0)*0.2+0.2)*-(flip*2-1));

    lightMap.map.noTint();
  }
}
class seaLump extends entity {
  float phase = random(0, 1000);
  float phase2 = random(0, 1000);

  seaLump(float PX, float PY) {
    super(PX, PY);
    size = random(0.7, 1.0);
    hitbox = new hitbox(this, size);
    COLOR_R += random(-50, 50);
    COLOR_G += random(-50, 50);
    COLOR_B += random(-50, 50);
  }
  void update() {
    phase += random(0.98, 1.02)/50.0;
    phase2 += random(0.1, 1.0)/50.0+sin(phase/0.60)/50.0;

    if (PY < 0) {
      SX += sin(phase2/90.0-phase/600)/(400)*sin(phase/82.0)*0.1;
      SY += cos(phase/80.0+phase2/800.0)/(400)*sin(phase2/90.0)*0.1;
    }
    if (PY > -2) {
      SY -= 0.001;
    }
  }
  void render() {
    lg.pg.tint(COLOR_R, COLOR_G, COLOR_B);
    if (PY < 0) {
      if (SX < 0) {
        flip = 1;
      } else if (SX > 0) {
        flip = 0;
      }
    }
    lg.setRotateImage(flip==0?seaLump.imgR:seaLump.img, camX(posX(PX)), camY(posY(PY)), camZ(size*2.5), camZ(size*2.5), sin(phase/15.0/size)*0.14);
    lg.pg.noTint();
  }
  void lightRender() {
    lightMap.map.fill(180, 245, 255, 120);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)), camZ(size*4.2), camZ(size*4.2));
    lightMap.map.fill(180, 245, 255);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)), camZ(size*3.2), camZ(size*3.2));
  }
}
class jellyfish extends entity {
  float phase = random(0, 1000);
  float phase2 = random(0, 1000);

  jellyfish(float PX, float PY) {
    super(PX, PY);
    size = random(1.1, 2.2);
    hitbox = new hitbox(this, size);
    COLOR_R += random(-50, 50);
    COLOR_G += random(-50, 50);
    COLOR_B += random(-50, 50);
  }
  void update() {
    phase += random(0.98, 1.02)/50.0;
    phase2 += random(0.1, 1.0)/50.0+sin(phase/0.60)/50.0;

    SY += sin(phase2/4.0)/8000.0;
    SX += sin(phase/4.0)/20000.0;
  }
  void render() {
    lg.pg.tint(COLOR_R, COLOR_G, COLOR_B);
    if (PY < 0) {
      if (SX < 0) {
        flip = 1;
      } else if (SX > 0) {
        flip = 0;
      }
    }
    float deltaY = size/3.0*sin(phase/2.0);
    lg.setImage(jellyfish.img, camX(posX(PX)), camY(posY(PY)), camZ(size*2.3), camZ(size*2.3+deltaY));
    lg.setImage(jellyfish.img, camX(posX(PX)), camY(posY(PY)), camZ(size*2.5), camZ(size*2.5+deltaY));

    for (int ii = 0; ii < 5; ii++) {
      float fx = 0, fy = 0;
      float afx = 0, afy = 0;
      for (int i = 0; i < 8; i++) {
        float A = sin(phase/4.0+i-ii*1.2)/2.0+cos(phase/3.7/2.0+ii*1.2)/3.0;
        fx = sin(A+PI)*size/9.0;
        fy = cos(A+PI)*size/9.0;
        lg.setRotateImage(jellyfish1.img, camX(posX(PX+fx+afx)), camY(posY(PY-size/3.0-deltaY/8.0+fy+size/12.0+afy)), camZ(size*0.5), camZ(size*0.5), A);
        afx += sin(A+PI)*size*0.22;
        afy += cos(A+PI)*size*0.22;
      }
    }

    lg.pg.noTint();
  }
  void lightRender() {
    lightMap.map.fill(180, 245, 255, 80);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)), camZ(size*4.2), camZ(size*4.2));
    lightMap.map.fill(180, 245, 255, 80);
    lightMap.map.setEps(camX(posX(PX)), camY(posY(PY)), camZ(size*3.2), camZ(size*3.2));
  }
}

class fish extends entity {
  float phase = random(0, 1000);
  float phase2 = random(0, 1000);

  int type = rand(0, 7);

  fish(float PX, float PY) {
    super(PX, PY);
    size = random(0.8, 1.2);
    hitbox = new hitbox(this, size);
    COLOR_R += random(-50, 50);
    COLOR_G += random(-50, 50);
    COLOR_B += random(-50, 50);
  }
  void update() {
    phase += random(0.98, 1.02);
    phase2 += random(0.1, 1.0)+sin(phase/0.60);

    if (PY < 0) {
      SX += sin(phase2/90.0-phase/600)/(400)*sin(phase/82.0);
      SY += cos(phase/80.0+phase2/800.0)/(400)*sin(phase2/90.0);
    }
    if (leng(player.PX-PX, player.PY-PY) < 4) {
      float a = atan2(player.PX-PX, player.PY-PY);
      SX -= sin(a)/1200;
      SY -= cos(a)/1200;
      if (leng(player.PX-PX, player.PY-PY) < 8) {
        SX -= sin(a)/1200;
        SY -= cos(a)/1200;
      }
    }
    if (PY > -2) {
      SY -= 0.001;
    }
  }
  void render() {
    lg.pg.tint(COLOR_R, COLOR_G, COLOR_B);
    if (PY < 0) {
      if (SX < 0) {
        flip = 0;
      } else if (SX > 0) {
        flip = 1;
      }
    }
    lg.setRotateImage(flip==0?fish.img:fish.imgR, camX(posX(PX)), camY(posY(PY)), camZ(size*2), camZ(size*2), sin(phase/15.0/size)*0.14);
    lg.pg.noTint();
  }
}
class demon extends entity {
  float phase = random(0, 1000);
  float phase2 = random(0, 1000);

  int type = rand(0, 7);

  int s = 15;
  float sq = 5;

  float parts[][] = new float[s][4];

  float dx = 0, dy = 0;

  demon(float PX, float PY) {
    super(PX, PY);
    size = random(2.5, 3.5);
    hitbox = new hitbox(this, size);

    COLOR_R += random(-50, 50);
    COLOR_G += random(-50, 50);
    COLOR_B += random(-50, 50);

    for (int i = 0; i < s; i++) {
      parts[i][0] = PX;
      parts[i][1] = PY;
      parts[i][2] = size-i*(size/3.0)/sq;
    }
  }
  void update() {

    entity target = player;

    phase += random(0.98, 1.02);
    phase2 += random(0.1, 1.0)+sin(phase/0.60);

    if (PY < 0) {
      SX += sin(phase2/90.0-phase/600)/(400)*sin(phase/82.0)*4.0;
      SY += cos(phase/80.0+phase2/800.0)/(400)*sin(phase2/90.0)*4.0;
    }
    if (leng(target.PX-PX, target.PY-PY) < 28) {
      float a = atan2(target.PX-PX, target.PY-PY);
      SX += sin(a)/600*max(0, sin(phase/152.0)*4.0);
      SY += cos(a)/600*max(0, sin(phase/152.0)*4.0);
      if (leng(target.PX-PX, target.PY-PY) < 14) {
        SX += sin(a)/260*max(0, sin(phase/152.0)*4.0);
        SY += cos(a)/260*max(0, sin(phase/152.0)*4.0);
      }
    }
    SY -= 0.001;

    float A = atan2(PX-parts[0][0], PY-parts[0][1]);
    float L = leng(PX-parts[0][0], PY-parts[0][1]);

    float LL = L+0.2 - (size + parts[0][2])/4.0;

    parts[0][3] = A+PI;

    if (LL > 0.0) {
      parts[0][0] += sin(A)*LL*2;
      parts[0][1] += cos(A)*LL*2;
    }
    for (int i = 1; i < s; i++) {
      A = atan2(parts[i][0]-parts[i-1][0], parts[i][1]-parts[i-1][1]);
      L = leng(parts[i][0]-parts[i-1][0], parts[i][1]-parts[i-1][1]);

      LL = L+0.2 - (parts[i-1][2] + parts[i][2])/4.0;
      if (LL > 0) {
        parts[i][0] -= sin(A)*LL;
        parts[i][1] -= cos(A)*LL;
        parts[i][3] = A;
      }
    }
  }
  void render() {
    lg.pg.tint(COLOR_R, COLOR_G, COLOR_B);
    if (PY < 0) {
      if (SX < 0) {
        flip = 0;
      } else if (SX > 0) {
        flip = 1;
      }
    }

    for (int i = s-1; i >= 0; i--) {
      lg.setRotateImage(demonPart.img, camX(posX(parts[i][0])), camY(posY(parts[i][1])), camZ(parts[i][2]*1.8), camZ(parts[i][2]*1.8), parts[i][3]+PI);
    }

    dx = dx*0.92+SX*0.08;
    dy = dy*0.92+SY*0.08;

    rotate = atan2(dx, dy);

    lg.setRotateImage(demonPart.img, camX(posX(PX)), camY(posY(PY)), camZ(size*1.8), camZ(size*1.8), rotate);
    lg.fill(180, 30, 20);
    lg.setEps(camX(posX(PX+sin(rotate)*0.7)), camY(posY(PY+cos(rotate)*0.7)), camZ(size*0.27), camZ(size*0.27));

    lg.pg.noTint();
  }
  void lightRender() {
    lightMap.map.fill(255, 100, 100, 100);
    lightMap.map.setEps(camX(posX(PX+sin(rotate)*0.7)), camY(posY(PY+cos(rotate)*0.7)), camZ(size*1.2), camZ(size*1.2));
    lightMap.map.fill(255, 100, 100);
    lightMap.map.setEps(camX(posX(PX+sin(rotate)*0.7)), camY(posY(PY+cos(rotate)*0.7)), camZ(size*0.7), camZ(size*0.7));
  }
}
