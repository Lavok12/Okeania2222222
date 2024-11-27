class space {
  PGraphics pg;

  space(int w, int h) {
    pg = createGraphics(w, h, P2D);
  }
  void render() {
    space.set("iTime", frameCount/10000.0);
    space.set("iResolution", pg.width*1.0, pg.height*1.0);
    space.set("iMouse", 0.0, 0.0);
    pg.filter(space);

    blur.set("power", pg.width/600.0);
    blur.set("del;", 1.0);
    blur.set("dis", pg.width*1.0, pg.height*1.0);
    pg.filter(blur);
  }
}
class nebula {
  PGraphics pg;

  nebula(int w, int h) {
    pg = createGraphics(w, h, P2D);
  }
  void render() {
    nebula.set("time", frameCount/70.0);
    nebula.set("resolution", pg.width*1., pg.height*1.);
    pg.filter(nebula);
  }
}
class rays {
  PGraphics pg;

  rays(int w, int h) {
    pg = createGraphics(w, h, P2D);
  }
  void render() {
    rays.set("iTime", frameCount/100.0);
    rays.set("iResolution", pg.width*1., pg.height*1.);
    pg.filter(rays);
  }
}
class glow {
  PGraphics pg;

  glow(int w, int h) {
    pg = createGraphics(w, h, P2D);
  }
  void render() {
    pg.beginDraw();
    pg.clear();
    pg.noStroke();
    pg.fill(20, 40, 70, 9);
    for (float i = -50; i < height/10; i+=height/1000.0*6) {

      pg.rect(0, i, width, height);
    }
    pg.endDraw();

    blur.set("power", pg.width/200.0);
    blur.set("del;", 0.0);
    blur.set("dis", pg.width*1.0, pg.height*1.0);
    pg.filter(blur);
  }
}
void vignette(float power, float size) {
  lg.pg.tint(255, power*255);
  lg.setImage(vignette, 0, 0, lg.disW*size, lg.disH*size);
  lg.pg.noTint();
}

class lightMap {
  LGraphics map;
  
  lightMap() {
    map = new LGraphics(2000, disH/fix, fix/10.0);
    
    map.beginDraw();
    map.pg.noStroke();
    map.endDraw();
  }
  void clear() {
    map.beginDraw();
    
    map.bg(0);
    
    map.endDraw();
  }
  void begin() {
    map.beginDraw();
  }
  void end() {
    map.endDraw();
  }
  
  void base() {
    map.bg(150+110*_GlobalLighting);
  }
  void blur() {
    blur.set("power", map.pg.width/30.0);
    blur.set("del", 0.5);
    blur.set("dis", map.pg.width*1.0, map.pg.height*1.0);
    map.pg.filter(blur);
  }
  void blur2() {
    blur.set("power", map.pg.width/60.0);
    blur.set("del", 0.5);
    blur.set("dis", map.pg.width*1.0, map.pg.height*1.0);
    map.pg.filter(blur);
    
    blur.set("power", map.pg.width/120.0);
    blur.set("del", 0.5);
    blur.set("dis", map.pg.width*1.0, map.pg.height*1.0);
    map.pg.filter(blur);
  }
  void use() {
    lightMapShader.set("dis", lg.pg.width*1.0, lg.pg.height*1.0);
    lightMapShader.set("map", map.pg);
    lg.pg.filter(lightMapShader);
  }
}
