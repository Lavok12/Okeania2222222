class particlesSystem {
  ArrayList<particles> particles = new ArrayList<particles>();

  void add(particles p) {
    particles.add(p);
  }

  void update() {
    particles p;
    for (int i = 0; i < particles.size(); i++) {
      p = particles.get(i);
      p.update();
      p.render();
      if (p.remove) {
        particles.remove(i);
        i--;
      }
    }
  }
  void renderLight() {
    for (particles p : particles) {
      p.renderLight();
    }
  }
}
class particles {
  float time = 0;
  Boolean remove = false;
  float PX, PY;
  float SX, SY;

  particles(float PX, float PY) {
    this.PX = PX;
    this.PY = PY;
  }
  void update() {
  }
  void render() {
  }
  void renderLight() {
  }
}

class blueGlow extends particles {
  float size = random(0.5, 0.7);
  float A = random(0, TWO_PI);

  blueGlow(float PX, float PY) {
    super(PX, PY);
    this.PX = PX;
    this.PY = PY;
  }
  void update() {
    A += random(-0.01, 0.01);
    SX += sin(A)/10000.0;
    SY += cos(A)/10000.0;
    PX += SX;
    PY += SY;

    SX /= 1.01;
    SY /= 1.01;

    time++;
    if (time > 400) {
      remove = true;
    }
    if (PY > -0.5) {
      remove = true;
    }
  }
  void render() {
    if (abs(camX(PX)) < 1100 && camY(PY) < disH2+100) {
      float d = 50;
      if (time < 50) {
        d = time;
      }
      if (time > 350) {
        d = 400-time;
      }
      lg.pg.tint(100, 170, 200, d*3.5);
      lg.setImage(circleGlow, camX(PX), camY(PY), camZ(size*1.3), camZ(size*1.3));
    }
    lg.noTint();
  }
  void renderLight() {
    if (abs(camX(PX)) < 1100 && camY(PY) < disH2+100) {
      float d = 50;
      if (time < 50) {
        d = time;
      }
      if (time > 350) {
        d = 400-time;
      }
      lightMap.map.fill(100, 170, 200, d*2.5);
      lightMap.map.setEps(camX(PX), camY(PY), camZ(size*2.5), camZ(size*2.5));
    }
  }
}
class blackSmokersParticle extends particles {
  float size = 0;

  blackSmokersParticle(float PX, float PY, float size) {
    super(PX, PY);
    this.PX = PX;
    this.PY = PY;
    this.size = size;
  }
  void update() {
    SY = 0.11;
    SX += random(-0.002,0.002);
    
    PX += SX;
    PY += SY;

    SX /= 1.01;
    SY /= 1.01;

    time++;
    if (time > 400) {
      remove = true;
    }
    if (PY > -0.5) {
      remove = true;
    }
    size += 0.01;
  }
  void render() {
    if (abs(camX(PX)) < 1100 && camY(PY) < disH2+100) {
      float d = 50;
      
      d = (400-time)/2.0;
      if (time < 20) {
        d = time*10;
      }
      
      lg.pg.tint(0, 0, 0, d);
      lg.setImage(circleGlow, camX(PX), camY(PY), camZ(size*1.3), camZ(size*1.3));
    }
    lg.noTint();
  }
  void renderLight() {
    if (abs(camX(PX)) < 1100 && camY(PY) < disH2+100) {
      float d = 50;
      if (time < 50) {
        d = time;
      }
      if (time > 350) {
        d = 400-time;
      }
      lightMap.map.fill(0, 0, 0, d/2.5);
      lightMap.map.setEps(camX(PX), camY(PY), camZ(size*2.5), camZ(size*2.5));
    }
  }
}
