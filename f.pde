HashMap<Integer, Boolean> keyreg = new HashMap<Integer, Boolean>();

void keyPressed() {
  keyreg.put(keyCode, true);
  println(keyCode);
  if (event == "game") {
    handleKeyEvents();
  }
}

void keyReleased() {
  keyreg.put(keyCode, false);
}

void handleKeyEvents() {
  if (keyPressedToggle(99)) toggleDebugMode();
  if (console) {
    handleConsoleInput();
  } else {
    handleGameInput();
  }
}

void toggleDebugMode() {
  debug = !debug;
  console = false;
}

void handleConsoleInput() {
  if (keyPressedToggle(100)) toggleConsole();
  Console.handleKeyPressed(key, keyCode);
}

void handleGameInput() {
  if (keyPressedToggle(100)) toggleConsole();
  if (keyPressedToggle(69)) toggleInventory();
  if (inventory) return;

  handleItemPickup();
  handleSlotSelection();
  handleEntitySpawning();
  handleSpecialActions();
}

boolean keyPressedToggle(int key) {
  return keyreg.get(key) != null && keyreg.get(key);
}

void toggleConsole() {
  console = !console;
  debug = false;
}

void toggleInventory() {
  inventory = !inventory;
  inventorySlotSelection = null;
}

void handleItemPickup() {
  if (keyPressedToggle(70) && nearestItem != null) {
    entity.remove(nearestItem);
    entity_o();
    addItem(nearestItem.i, inv, invG);
    nearestItem.dead = true;
    nearestItem = null;
  }
}

void handleSlotSelection() {
  if (keyPressedToggle(48)) slotSelection = inv.inv[9][0];
  for (int i = 0; i < 9; i++) {
    if (keyPressedToggle(49 + i)) slotSelection = inv.inv[i][0];
  }
}

void handleEntitySpawning() {
  if (keyPressedToggle(134)) spawnEntity("demon");
  if (keyPressedToggle(135)) spawnEntity("moonFish");
  if (keyPressedToggle(136)) spawnEntity("seaLump");
  if (keyPressedToggle(137)) spawnEntity("jellyfish");
  if (keyPressedToggle(93)) spawnEntity("demon2");
  if (keyPressedToggle(128)) spawnEntity("fish");
  if (keyPressedToggle(132)) spawnEntituItem("item", new bob(), player);
  if (keyPressedToggle(130)) spawnBarrel();
  if (keyPressedToggle(71)) dropSelectedItem();
  if (keyPressedToggle(131)) structure.add(new grass(player.PX, player.PY - 0.57));
  if (keyPressedToggle(133)) addItem(new bob(), inv, invG);
  if (keyPressedToggle(91)) addItem(new lightSaber(), inv, invG);
  if (keyPressedToggle(86))
  if (player.inTransport == null) {
    player.checkTransport();
  } else {
    if (player.inTransport.checkExit(player)) player.inTransport = null;
  }
}

void spawnEntity(String type) {
  if (!online || host) {
    entity c = null;
    if (type == "demon") c = new demon(player.PX, player.PY);
    else if (type == "moonFish") c = new moonFish(player.PX, player.PY);
    else if (type == "seaLump") c = new seaLump(player.PX, player.PY);
    else if (type == "jellyfish") c = new jellyfish(player.PX, player.PY);
    else if (type == "demon2") c = new demon2(player.PX, player.PY);
    else if (type == "fish") c = new fish(player.PX, player.PY);
    entity.add(c);
    entity_o();
  } else {
    user.addEntity(type, player.PX, player.PY);
  }
}

void spawnEntituItem(String type, item i, player player) {
  if (!online || host) {
    entity c;
    entity.add(c = new itemEntity(player.PX, player.PY, i));
    c.inTransport = player.inTransport;
  } else {
    //user.addEntity(type, player.PX, player.PY, i.name);
  }
  entity_o();
}

void spawnBarrel() {
  entity c = new barrel(player.PX, player.PY);
  c.SY = 0.01;
  entity.add(c);
  entity_o();
}

void dropSelectedItem() {
  if (slotSelection != null && slotSelection.item != null) {
    spawnEntituItem(slotSelection.item.tag, slotSelection.item, player);
    slotSelection.item = null;
    entity_o();
  }
}

void handleSpecialActions() {
  if (keyPressedToggle(129)) teleportPlayerToCursor();
}

void teleportPlayerToCursor() {
  player.PX = (moux / zoom + camX) / 2;
  player.PY = (mouy / zoom + camY + 328) / 2;
}

int r(float num) {
  return round(num);
}
int rand(int randMin, int randMax) {
  return round(random(randMin, randMax));
}

void setText(String txt, float xPos, float yPos, float size) {
  textSize(size);
  text(txt, disW2 + xPos, disH2 - yPos);
}
void setAlign(int x, int y) {
  if (x == 0 && y == 0) {
    textAlign(CENTER, CENTER);
  } else if (x == -1 && y == 0) {
    textAlign(LEFT, CENTER);
  } else if (x == 1 && y == 0) {
    textAlign(RIGHT, CENTER);
  } else if (x == 0 && y == -1) {
    textAlign(CENTER, LEFT);
  } else if (x == -1 && y == -1) {
    textAlign(LEFT, LEFT);
  } else if (x == 1 && y == -1) {
    textAlign(RIGHT, LEFT);
  } else if (x == 0 && y == 1) {
    textAlign(CENTER, RIGHT);
  } else if (x == -1 && y == 1) {
    textAlign(LEFT, RIGHT);
  } else if (x == 1 && y == 1) {
    textAlign(RIGHT, RIGHT);
  }
}
void setTextWH(String txt, float xPos, float yPos, float size, float w, float h) {
  textSize(size);
  text(txt, disW2 + xPos, disH2 - yPos, w, h);
}
void clr(float red, float green, float blue) {
  noFill();
  fill(red, green, blue);
}
void clro(float red, float green, float blue, float alpha) {
  noFill();
  fill(red, green, blue, alpha);
}
void setBlock(float xPos, float yPos, float xSize, float ySize) {
  rect(disW2 + xPos - xSize/2, disH2 - yPos - ySize/2, xSize, ySize);
}
void setBlock2(float xPos, float yPos, float xSize, float ySize, float k) {
  rect(disW2 + xPos - xSize/2, disH2 - yPos - ySize/2, xSize, ySize, k);
}
void setRotateBlock(float xPos, float yPos, float xSize, float ySize, float Rotate) {
  pushMatrix();
  translate (disW2+xPos, disH2-yPos);
  rotate(Rotate);
  setBlock(-disW2, disH2, xSize, ySize);
  popMatrix();
}
void setEps(float xPos, float yPos, float xSize, float ySize) {
  ellipse(disW2 + xPos, disH2 - yPos, xSize, ySize);
}
void setRotateEps(float xPos, float yPos, float xSize, float ySize, float Rotate) {
  pushMatrix();
  translate (disW2+xPos, disH2-yPos);
  rotate(Rotate);
  setEps(-disW2, disH2, xSize, ySize);
  popMatrix();
}
void setLine(float xPos, float yPos, float xPos2, float yPos2) {
  line(disW2 + xPos, disH2 - yPos, disW2 + xPos2, disH2 - yPos2);
}
void setImage(PImage fImage, float xPos, float yPos, float xSize, float ySize) {
  image(fImage, disW2 + xPos - xSize/2, disH2 - yPos - ySize/2, xSize, ySize);
}
void setImageW(PImage fImage, float xPos, float yPos, float xSize) {
  float ySize = xSize/fImage.width*fImage.height;
  image(fImage, (disW2 + xPos - xSize/2), (disH2 - yPos - ySize/2), xSize, ySize);
}
void setImageH(PImage fImage, float xPos, float yPos, float ySize) {
  float xSize = ySize/fImage.height*fImage.width;
  image(fImage, (disW2 + xPos - xSize/2), (disH2 - yPos - ySize/2), xSize, ySize);
}
void setRotateImage(PImage fImage, float xPos, float yPos, float xSize, float ySize, float Rotate) {
  pushMatrix();
  translate (disW2+xPos, disH2-yPos);
  rotate(Rotate);
  setImage(fImage, -disW2, disH2, xSize, ySize);
  popMatrix();
}
boolean tap(float xPos, float yPos, float xSize, float ySize) {
  if (((moux>xPos-xSize/2)&&(moux<xPos+xSize/2))&&((mouy>yPos-ySize/2)&&(mouy<yPos+ySize/2))) {
    return true;
  } else {
    return false;
  }
}
boolean tapPos(float xPos, float yPos, float xSize, float ySize, float mx, float my) {
  if (((mx>xPos-xSize/2)&&(mx<xPos+xSize/2))&&((my>yPos-ySize/2)&&(my<yPos+ySize/2))) {
    return true;
  } else {
    return false;
  }
}
float leng(float X1, float Y1) {
  return sqrt(X1*X1+Y1*Y1);
}



void saveMass(String[] num1, String num2) {
  JSONObject save;
  save = new JSONObject();
  save.setInt("q", num1.length);
  for (int ii = 0; ii < num1.length; ii++) {
    save.setString(""+ii, num1[ii]);
  }
  saveJSONObject(save, num2);
}
String[] loadMass(String num1) {
  String num2[];
  JSONObject save;
  try {
    // Загружает сохранение
    save = loadJSONObject(num1);
    int ii = save.getInt("q");
    num2 = new String[ii];
    for (int i = 0; i < ii; i++) {
      num2[i] = save.getString(""+i);
    }
    return num2;
  }
  catch(Exception e) {
    num2 = new String[1];
    num2[0] = "#";
  }
  return num2;
}

float jSmooth(float n1, float n2, float n3) {
  return (n1*n3+n2)/(n3+1);
}
float xrot(float x, float a, float r) {
  return x+sin(a)*r;
}
float yrot(float y, float a, float r) {
  return y+cos(a)*r;
}
//ArrayList<Pparticles> Pparticle = new ArrayList<Pparticles>();


/*
float dfix(float x) {
 return x/fix;
 }
 
 float touchX(int id) {
 for (int i = 0; i < touches.length; i++) {
 if (touches[i].id == id) {
 return touches[i].x - disW/2;
 }
 }
 return 0;
 }
 float touchY(int id) {
 for (int i = 0; i < touches.length; i++) {
 if (touches[i].id == id) {
 return -touches[i].y + disH/2;
 }
 }
 return 0;
 }
 Boolean touchP(int id) {
 for (int i = 0; i < touches.length; i++) {
 if (touches[i].id == id) {
 return true;
 }
 }
 return false;
 }
/*int touchLast() {
 return touches.length;
 }
 Boolean touchTap(float xPos, float yPos, float xSize, float ySize, int id) {
 if (((touchX(id)>xPos-xSize/2)&&(touchX(id)<xPos+xSize/2))&&((touchY(id)>yPos-ySize/2)&&(touchY(id)<yPos+ySize/2))) {
 return true;
 } else {
 return false;
 }
 }
 
 
 void savePGraphics(PGraphics pg, String filename) {
 pg.save(filename);
 }
 
 PGraphics loadPGraphics(String filename) {
 PGraphics pg = createGraphics(1, 1);  // Создайте PGraphics для загрузки
 pg.beginDraw();
 pg.background(255);  // Установите фон PGraphics
 pg.endDraw();
 PImage img = loadImage(filename);
 pg = createGraphics(img.width, img.height);  // Создайте новый PGraphics с правильными размерами
 pg.beginDraw();
 pg.image(img, 0, 0);  // Нарисуйте изображение на PGraphics
 pg.endDraw();
 return pg;
 }*/


void writeToFile(String filename, String content) {
  filename = "data\\"+filename;
  PrintWriter output = createWriter(filename);
  output.println(content);
  output.flush();  // Writes the remaining data to the file
  output.close();  // Finishes the file
  println("write:", content.length());
}

String readFromFile(String filename) {
  if (new File(dataPath(filename)).exists()) {
    String[] lines = loadStrings(filename);
    String content = join(lines, "\n");
    println("load:", content.length());
    return content;
  } else {
    println("File " + filename + " does not exist.");
    return null;
  }
}


String getGraphicsCardInfo() {
  String result = "";
  try {
    Process process = Runtime.getRuntime().exec("lspci | grep VGA");
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    String line;
    while ((line = reader.readLine()) != null) {
      result += line;
    }
    reader.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  return result;
}

String getMemoryInfo() {
  String result = "";
  try {
    Process process = Runtime.getRuntime().exec("free -h");
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    String line;
    while ((line = reader.readLine()) != null) {
      if (line.contains("Mem:")) {
        result = line;
        break;
      }
    }
    reader.close();
  }
  catch (IOException e) {
    e.printStackTrace();
  }
  return result;
}
Object ret(Object c) {
  return c;
}










float camZ(float x) {
  return x*zoom;
}
float camX(float x) {
  if (debug) {
    if (mousePressed) {
      if (mouseButton == CENTER) {
        return (x-camX)*zoom+moux;
      }
    }
  }
  return (x-camX)*zoom;
}
float camY(float x) {
  if (debug) {
    if (mousePressed) {
      if (mouseButton == CENTER) {
        return (x-camY)*zoom+mouy;
      }
    }
  }
  return (x-camY)*zoom;
}
float posX(float x) {
  return x * 2;
}
float posY(float x) {
  return x * 2 - 328;
}
float AposX(float x) {
  return x / 2;
}
float AposY(float x) {
  return (x + 328)/2;
}




class LGraphics {
  PGraphics pg;

  float disH, disW;
  float disH2, disW2;

  float M;

  LGraphics(float w, float h, float mp) {
    pg = createGraphics(round(w*mp), round(h*mp), P2D);

    disW = w;
    disH = h;

    disW2 = disW/2;
    disH2 = disH/2;

    M = mp;
  }
  void setText(String txt, float xPos, float yPos, float size) {
    size = max(1, size);
    size = min(100000, size);
    pg.textSize(size*M);
    pg.text(txt, (disW2 + xPos)*M, (disH2 - yPos)*M);
  }
  void setAlign(int x, int y) {
    if (x == 0 && y == 0) {
      pg.textAlign(CENTER, CENTER);
    } else if (x == -1 && y == 0) {
      pg.textAlign(LEFT, CENTER);
    } else if (x == 1 && y == 0) {
      pg.textAlign(RIGHT, CENTER);
    } else if (x == 0 && y == -1) {
      pg.textAlign(CENTER, LEFT);
    } else if (x == -1 && y == -1) {
      pg.textAlign(LEFT, LEFT);
    } else if (x == 1 && y == -1) {
      pg.textAlign(RIGHT, LEFT);
    } else if (x == 0 && y == 1) {
      pg.textAlign(CENTER, RIGHT);
    } else if (x == -1 && y == 1) {
      pg.textAlign(LEFT, RIGHT);
    } else if (x == 1 && y == 1) {
      pg.textAlign(RIGHT, RIGHT);
    }
  }
  void setTextWH(String txt, float xPos, float yPos, float size, float w, float h) {
    pg.textSize(size*M);
    pg.text(txt, (disW2 + xPos)*M, (disH2 - yPos), w*M, h*M);
  }
  void fill(float red) {
    pg.noFill();
    pg.fill(red);
  }
  void fill(float red, float a) {
    pg.noFill();
    pg.fill(red, a);
  }
  void fill(float red, float green, float blue) {
    pg.noFill();
    pg.fill(red, green, blue);
  }
  void fill(float red, float green, float blue, float alpha) {
    pg.noFill();
    pg.fill(red, green, blue, alpha);
  }

  void bg(float red) {
    pg.background(red);
  }
  void bg(float red, float green, float blue) {
    pg.background(red, green, blue);
  }

  void setTint(float n1, float n2, float n3, float n4) {
    pg.tint(n1, n2, n3, n4);
  }
  void setTint(float n1, float n2, float n3) {
    pg.tint(n1, n2, n3);
  }
  void setTint(float n1, float n2) {
    pg.tint(n1, n2);
  }
  void setTint(float n1) {
    pg.tint(n1);
  }
  void noTint() {
    pg.tint(255, 255, 255, 255);
  }

  void rect(float xPos, float yPos, float xSize, float ySize) {
    pg.rect(xPos*M, yPos*M, xSize*M, ySize*M);
  }
  void setBlock(float xPos, float yPos, float xSize, float ySize) {
    pg.rect((disW2 + xPos - xSize/2)*M, (disH2 - yPos - ySize/2)*M, xSize*M, ySize*M);
  }
  void setBlock(float xPos, float yPos, float xSize, float ySize, float k) {
    pg.rect((disW2 + xPos - xSize/2)*M, (disH2 - yPos - ySize/2)*M, xSize*M, ySize*M, k*M);
  }
  void setPolygon(float[][] angles, float xPos, float yPos, float mpx, float mpy) {
    pg.beginShape();
    for (float angle[] : angles) {
      float x = angle[0];
      float y = angle[1];
      pg.vertex((disW2 + x*mpx + xPos)*M, (disH2 - y*mpy - yPos)*M);
    }
    pg.endShape(CLOSE);
  }
  void setRotateBlock(float xPos, float yPos, float xSize, float ySize, float Rotate) {
    pg.pushMatrix();
    pg.translate ((disW2+xPos)*M, (disH2-yPos)*M);
    pg.rotate(Rotate);
    setBlock(-disW2, disH2, xSize, ySize);
    pg.popMatrix();
  }
  void setEps(float xPos, float yPos, float xSize, float ySize) {
    pg.ellipse((disW2 + xPos)*M, (disH2 - yPos)*M, xSize*M, ySize*M);
  }
  void setRotateEps(float xPos, float yPos, float xSize, float ySize, float Rotate) {
    pg.pushMatrix();
    pg.translate ((disW2+xPos)*M, (disH2-yPos)*M);
    pg.rotate(Rotate);
    setEps(-disW2, disH2, xSize, ySize);
    pg.popMatrix();
  }
  void setLine(float xPos, float yPos, float xPos2, float yPos2) {
    pg.line((disW2 + xPos)*M, (disH2 - yPos)*M, (disW2 + xPos2)*M, (disH2 - yPos2)*M);
  }
  void setLine(float xPos, float yPos, float xPos2, float yPos2, float w, float r, float g, float b) {
    pg.stroke(r, g, b);
    pg.strokeWeight(w*M);
    pg.line((disW2 + xPos)*M, (disH2 - yPos)*M, (disW2 + xPos2)*M, (disH2 - yPos2)*M);
    pg.noStroke();
  }
  void setImage(PImage fImage, float xPos, float yPos, float xSize, float ySize) {
    if (fImage != null) {
      pg.image(fImage, (disW2 + xPos - xSize/2)*M, (disH2 - yPos - ySize/2)*M, xSize*M, ySize*M);
    } else {
      pg.fill(0);
      pg.rect((disW2 + xPos - xSize/2)*M, (disH2 - yPos - ySize/2)*M, xSize*M, ySize*M);
    }
  }
  void setImage(PImage fImage, float xPos, float yPos, float xSize) {
    float ySize = xSize/fImage.width*fImage.height;
    pg.image(fImage, (disW2 + xPos - xSize/2)*M, (disH2 - yPos - ySize/2)*M, xSize*M, ySize*M);
  }
  void setRotateImage(PImage fImage, float xPos, float yPos, float xSize, float ySize, float Rotate) {
    pg.pushMatrix();
    pg.translate((disW2+xPos)*M, (disH2-yPos)*M);
    pg.rotate(Rotate);
    setImage(fImage, -disW2, disH2, xSize, ySize);
    pg.popMatrix();
  }
  void beginDraw() {
    pg.beginDraw();
  }
  void endDraw() {
    pg.endDraw();
  }

  PImage getPI() {
    return pg;
  }
}

LGraphics generateBg(float x, float y, float z) {
  LGraphics r = new LGraphics(x, y, z);
  r.beginDraw();
  r.pg.noStroke();
  r.fill(200);
  r.setBlock(0, 0, x, y);
  r.endDraw();
  return r;
}


class Image {
  PImage img;
  PImage imgR;
  
  Image(PImage img) {
    this.img = img;
    this.imgR = createMirroredImage(img);
  }
  
  PImage createMirroredImage(PImage img) {
    PImage mirrored = createImage(img.width, img.height, ARGB);
    img.loadPixels();
    mirrored.loadPixels();
    
    for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {
        int originalIndex = x + y * img.width;
        int mirroredIndex = (img.width - 1 - x) + y * img.width;
        mirrored.pixels[mirroredIndex] = img.pixels[originalIndex];
      }
    }
    
    mirrored.updatePixels();
    return mirrored;
  }
}
