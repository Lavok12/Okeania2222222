PImage menuBG;
PImage menuBlack;
PImage rust;
PImage rust2;

PImage button1;
PImage button2;
PImage button3;

PImage noise;

PShader menuEffects, menuEffects2;

float B1A = 0;
float B2A = 0;
float B3A = 0;

void menuLoad() {
  menuBG = loadImage("Menu/bg.png");
  menuBlack = loadImage("Menu/black.png");
  menuEffects = loadShader("Menu/menuEffecs.glsl");
  menuEffects2 = loadShader("Menu/menuEffecs2.glsl");
  
  button1 = loadImage("Menu/button1.png");
  button2 = loadImage("Menu/button2.png");
  button3 = loadImage("Menu/button3.png");
  
  noise = loadImage("Menu/noise.jpg");
  
  rust = loadImage("Menu/rust.png");
  rust2 = loadImage("Menu/rust2.png");
}

void menuRender() {
  lg.beginDraw();
  lg.pg.noStroke();
  lg.pg.clear();
  
  lg.bg(0);
  lg.setTint(70,70,70);
  lg.setImage(menuBG, 0, 0, lg.disW, lg.disW);
  lg.noTint();
  
  for (int i = 0; i < 1500; i++) {
    lg.fill(random(0,255), random(5,10));
    lg.setBlock(random(-disW2-50, disW2+50), random(-disH2-50, disH2+50), random(5,25), random(5,25));
  }
  menuEffects2.set("resolution", float(lg.pg.width), float(lg.pg.height));
  menuEffects2.set("time", frameCount/33.27);
  menuEffects2.set("screenTex", lg.pg);
  
  lg.pg.filter(menuEffects2);
  
  lg.setTint(255, random(4,6));
  lg.setImage(noise, random(-500, 500), random(-500,500), random(50,6000), random(50,6000));
  lg.noTint();
  
  lg.setTint(30,50,60);
  setBImage(rust2, 0, 0, 710, 710);
  lg.noTint();
  
  lg.setTint(60,100,120);
  lg.setImage(rust2, 0, 0, 700, 700);
  lg.noTint();
  
  lg.setTint(60,100,120);
  setBImage(rust, -300, 300, 80, 80);
  setBImage(rust, -300, -300, 80, 80);
  setBImage(rust, 300, -300, 80, 80);
  setBImage(rust, 300, 300, 80, 80);
  lg.noTint();
  
  B1A = max(B1A-0.03,0);
  B2A = max(B2A-0.03,0);
  B3A = max(B3A-0.03,0);
  
  if (tap(0, 190, 600/1.3*(B1A*0.3+1), 200/1.3*(B1A*0.3+1))) {
    B1A = min(B1A+0.06,0.2);
  }
  if (tap(0, 0, 600/1.3*(B2A*0.3+1), 200/1.3*(B2A*0.3+1))) {
    B2A = min(B2A+0.06,0.2);
  }
  if (tap(0, -190, 600/1.3*(B3A*0.3+1), 200/1.3*(B3A*0.3+1))) {
    B3A = min(B3A+0.06,0.2);
  }
  
  lg.setTint(70/1.2/(B1A*3+1),100/1.2/(B1A*3+1),120/1.2/(B1A*3+1));
  setBImage(button1, 0, 190, 600/1.3*(B1A*0.3+1), 200/1.3*(B1A*0.3+1));
  
  lg.setTint(70/1.2/(B2A*3+1),100/1.2/(B2A*3+1),120/1.2/(B2A*3+1));
  setBImage(button2, 0, 0, 600/1.3*(B2A*0.3+1), 200/1.3*(B2A*0.3+1));
  
  lg.setTint(70/1.2/(B3A*3+1),100/1.2/(B3A*3+1),120/1.2/(B3A*3+1));
  setBImage(button3, 0, -190, 600/1.3*(B3A*0.3+1), 200/1.3*(B3A*0.3+1));
  lg.noTint();
  
  menuEffects2.set("resolution", float(lg.pg.width), float(lg.pg.height));
  menuEffects2.set("time", frameCount/91.43);
  menuEffects2.set("screenTex", lg.pg);
  
  lg.pg.filter(menuEffects2);
  
  menuEffects.set("resolution", float(lg.pg.width), float(lg.pg.height));
  menuEffects.set("time", frameCount/50.0);
  menuEffects.set("screenTex", lg.pg);
  
  lg.pg.filter(menuEffects);
  
  lg.setImage(menuBlack, 0, 0, lg.disW*4, lg.disH*4);
  
  lg.setTint(255, random(4,9));
  lg.setImage(noise, random(-500, 500), random(-500,500), 6000, 3000);
  lg.noTint();
  
  lg.endDraw();
  image(lg.pg, 0, 0, width, height);
}

void setBImage(PImage x1, float n1, float n2, float n3, float n4) {
  lg.fill(0,9);
  for (float i = 0; i <= 20.0; i+=2) {
    lg.setBlock(n1, n2, n3+i, n4+i);
  }
  lg.setImage(x1, n1, n2, n3, n4);
}
