class itemEntity extends entity {
  item i;
  itemEntity(float PX, float PY) {
    super(PX, PY);
    this.i = null;
    hitbox = new hitbox(this, 1);
  }
  itemEntity(float PX, float PY, item i) {
    super(PX, PY);
    this.i = i;
    hitbox = new hitbox(this, 1);
  }
  void update() {
    if (i != null) {
      if (PY < 0 && inTransport == null) {
        SY -= (i.mass-1.0)/15.0;
      }
    }
  }
  void render() {
    if (i != null) {
      i.render(camX(posX(PX)), camY(posY(PY)), camZ(1.5*i.size));
    } else {
      lg.fill(50);
      lg.setEps(camX(posX(PX)), camY(posY(PY)), camZ(1), camZ(1));
    }
  }
  void lightRender() {
  }
}
class item {
  String name = "";
  float mass = 1.01;
  String tag = "";
  float size = 1;
  
  Image img;
  item() {
    img = itemsImages.get(tag);
  }
  void render(float PX, float PY, float size) {
    if (img != null) {
      lg.setImage(img.img, PX, PY, size, size);
    }
  }
  void renderItem(float PX, float PY, float size, Boolean r) {
    if (img != null) {
      lg.setImage(r?img.imgR:img.img, PX, PY, size, size);
    }
  }
  void lightRender(float PX, float PY, float size) {
  }
}
class bob extends item {
  bob() {
    name = "Fish";
    tag = "bob";
    img = itemsImages.get(tag);
  }
}
class lightSaber extends item {
  lightSaber() {
    name = "LightSaber";
    tag = "lightSaber";
    img = itemsImages.get(tag);
  }
  void renderItem(float PX, float PY, float size, Boolean r) {
    if (img != null) {
      lg.setRotateImage(r?img.imgR:img.img, PX+(r?-0.7:0.7)*zoom, PY+1.2*zoom, size*2, size*2, r?-0.4:0.4);
    }
  }
  void lightRender(float PX, float PY, float size) {
    lightMap.map.fill(255,100,120,80);
    lightMap.map.setEps(PX, PY, size*10, size*10);
    lightMap.map.setEps(PX, PY, size*6, size*6);
    lightMap.map.setEps(PX, PY, size*3, size*3);
    
    lightMap.map.fill(255,255);
    lightMap.map.setEps(PX, PY, size*10000, size*10000);
  }
}

class item1 extends item {
  item1() {
    name = "Axe";
    tag = "item1";
    img = itemsImages.get(tag);
  }
  void renderItem(float PX, float PY, float size, Boolean r) {
    if (img != null) {
      lg.setRotateImage(r?img.imgR:img.img, PX+(r?-0.7:0.7)*zoom, PY+0.5*zoom, size*2, size*2, r?-0.4:0.4);
    }
  }
}
class item2 extends item {
  item2() {
    size = 1.1;
    name = "item2";
    tag = "item2";
    img = itemsImages.get(tag);
  }
}
class item3 extends item {
  item3() {
    size = 1.3;
    name = "item3";
    tag = "item3";
    img = itemsImages.get(tag);
  }
}
class item4 extends item {
  item4() {
    size = 2;
    name = "item4";
    tag = "item4";
    img = itemsImages.get(tag);
  }
}
class item5 extends item {
  item5() {
    size = 10;
    name = "item5";
    tag = "item5";
    img = itemsImages.get(tag);
  }
}
