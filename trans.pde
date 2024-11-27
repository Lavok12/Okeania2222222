class transport extends entity {
  protected int hitboxSize;
  transport(float PX, float PY) {
    super(PX, PY);
  }
  void collision() {
  }
  Boolean checkExit(player player) {
    if (leng(player.PX-PX, player.PY-(PY-1)) < 1.0) {
      return true;
    }
    return false;
  }
  void move() {
    float S_X = SX;
    float S_Y = SY;
    float m = max(abs(S_X), abs(S_Y));

    for (; m > 0; m -= hitboxSize/4) {
      if (S_X > 0) {
        PX += min(hitboxSize/4, S_X);
        S_X = max(0, S_X - hitboxSize/4);
      } else if (S_X < 0) {
        PX += max(-hitboxSize/4, S_X);
        S_X = min(0, S_X + hitboxSize/4);
      }
      if (S_Y > 0) {
        PY += min(hitboxSize/4, S_Y);
        S_Y = max(0, S_Y - hitboxSize/4);
      } else if (S_Y < 0) {
        PY += max(-hitboxSize/4, S_Y);
        S_Y = min(0, S_Y + hitboxSize/4);
      }
      //m -= hitboxSize;
      collision();
    }
  }
  void inTransportMap() {
    transportMap.setBlock(camX(posX(PX)), camY(posY(PY)), camZ(16), camZ(5));
  }
  void updateTransport() {
  }
  void renderTransport() {
    lg.fill(180);
    lg.setBlock(camX(posX(PX)), camY(posY(PY)), camZ(16), camZ(5));
    lg.fill(190, 50, 50);
    lg.setBlock(camX(posX(PX)), camY(posY(PY-1)), camZ(1), camZ(0.5));
  }
  void renderLightTransport() {
    lightMap.map.fill(255);
    lightMap.map.setBlock(camX(posX(PX)), camY(posY(PY)), camZ(16), camZ(5));
  }
  void inTransportCollision(hitbox thitbox) {
    float size = thitbox.size;
    if (thitbox.entity.PY < PY+0.5+size/4-1.7) {
      thitbox.entity.PY = PY+0.5+size/4-1.7;
      thitbox.entity.SY = SY - 0.0001;
    }
    if (thitbox.entity.PY > PY-0.5-size/4+1.7) {
      thitbox.entity.PY = PY-0.5-size/4+1.7;
      thitbox.entity.SY = SY - 0.0001;
    }
    if (thitbox.entity.PX < PX-4+size/4) {
      thitbox.entity.PX = PX-4+size/4;
      thitbox.entity.SX = SX + 0.0001;
    }
    if (thitbox.entity.PX > PX+4-size/4) {
      thitbox.entity.PX = PX+4-size/4;
      thitbox.entity.SX = SX - 0.0001;
    }
  }
}
class barrel extends transport {
  hitbox hitboxes[] = new hitbox[3];
  barrel(float PX, float PY) {
    super(PX, PY);
    hitboxSize = 8;
    for (int i = 0; i < 3; i++) {
      hitboxes[i] = new hitbox(this, hitboxSize, -3+i*3, 0);
    }
  }
  void render() {
    lg.fill(200);
    lg.setEps(camX(posX(PX-3)), camY(posY(PY)), camZ(8), camZ(8));
    lg.setEps(camX(posX(PX)), camY(posY(PY)), camZ(8), camZ(8));
    lg.setEps(camX(posX(PX+3)), camY(posY(PY)), camZ(8), camZ(8));
    lg.fill(200, 120, 50);
    lg.setBlock(camX(posX(PX-1.5)), camY(posY(PY)), camZ(1), camZ(6.25));
    lg.setBlock(camX(posX(PX+1.5)), camY(posY(PY)), camZ(1), camZ(6.25));
    lg.fill(100, 150, 200);
    lg.setEps(camX(posX(PX-3)), camY(posY(PY)), camZ(4), camZ(4));
    lg.setEps(camX(posX(PX+3)), camY(posY(PY)), camZ(4), camZ(4));
    
    lg.fill(150);
    lg.setEps(camX(posX(PX)), camY(posY(PY)), camZ(4), camZ(4));
    lg.fill(200,50,50);
    lg.setEps(camX(posX(PX)), camY(posY(PY)), camZ(2), camZ(2));
  }
  void hitboxRender() {
    for (int i = 0; i < 3; i++) {
      hitboxes[i].render();
    }
  }
  void hitboxOptimization() {
    for (int i = 0; i < 3; i++) {
      hitboxes[i].optimization();
    }
  }
  void collision() {
    for (int i = 0; i < 3; i++) {
      hitboxes[i].collision();
    }
  }
}
