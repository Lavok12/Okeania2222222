Boolean freeCell(inventory... c) {
  for (int i = 0; i < c.length; i++) {
    if (c[i].freeCell()) {
      return true;
    }
  }
  return false;
}
Boolean addItem(item d, inventory... c) {
  for (int i = 0; i < c.length; i++) {
    if (c[i].freeCell()) {
      c[i].addItem(d);
      return true;
    }
  }
  entity.add(new itemEntity(player.PX, player.PY, d));
  entity_o();
  return false;
}
class inventory {
  Boolean freeCell() {
    for (int y = sy-1; y >= 0; y--) {
      for (int x = 0; x < sx; x++) {
        if (inv[x][y].item == null) {
          return true;
        }
      }
    }
    return false;
  }
  void addItem(item i) {
    for (int y = sy-1; y >= 0; y--) {
      for (int x = 0; x < sx; x++) {
        if (inv[x][y].item == null) {
          inv[x][y].item = i;
          return;
        }
      }
    }
  }
  partInventory inv[][];
  int sx, sy;
  inventory(int sx, int sy) {
    inv = new partInventory[sx][sy];
    this.sx = sx;
    this.sy = sy;
    for (int x = 0; x < sx; x++) {
      for (int y = 0; y < sy; y++) {
        inv[x][y] = new partInventory(null, x, y, sx, sy);
      }
    }
  }
  void renderBg(float PX, float PY, float size) {
    lg.fill(20, 160);
    lg.setBlock(PX, PY, sx*(size+10)+10, sy*(size+10)+10, 10);
  }
  void render(float PX, float PY, float size) {
    float lx = PX-sx*(size+10)/2+size/2+5;
    float ly = PY-sy*(size+10)/2+size/2+5;

    for (int x = 0; x < sx; x++) {
      for (int y = 0; y < sy; y++) {
        inv[x][y].render(lx+x*(size+10), ly+y*(size+10), size);
      }
    }
  }
  partInventory tapDetect(float PX, float PY, float size) {
    float lx = PX-sx*(size+10)/2+size/2+5;
    float ly = PY-sy*(size+10)/2+size/2+5;

    for (int x = 0; x < sx; x++) {
      for (int y = 0; y < sy; y++) {
        if (tap(lx+x*(size+10), ly+y*(size+10), size+10, size+10)) {
          return inv[x][y];
        }
      }
    }
    return null;
  }
}
void renderItemInfo(item item, float posX, float posY) {
  lg.fill(50,200,50, 120);
  lg.setEps(posX, posY, 30, 30);
  
  lg.setAlign(0, 0);
  lg.fill(0, 180);
  lg.setBlock(posX+240, posY, 360, 260, 30);
  lg.fill(200);
  lg.setText(item.name, posX+240, posY+120, 35);
  lg.fill(160);
  lg.setText(item.tag, posX+240, posY+90, 20);

  lg.fill(40);
  lg.setBlock(posX+240, posY-100, 200, 40, 10);
  lg.fill(200);
  lg.setText("Выбросить", posX+240, posY-100+5, 25);
  lg.fill(40);
  lg.setBlock(posX+240, posY-100+50, 200, 40, 10);
  lg.fill(200);
  lg.setText("Съесть", posX+240, posY-100+50+5, 25);
  lg.fill(40);
  lg.setBlock(posX+240, posY-100+100, 200, 40, 10);
  lg.fill(200);
  lg.setText("РЕЗНЯ", posX+240, posY-100+100+5, 25);

  item.render(posX+240-130, posY+80, 70);
}
class partInventory {
  item item;
  int x, y, sx, sy;
  partInventory(item type, int x, int y, int sx, int sy) {
    this.item = type;
    this.x = x;
    this.y = y;
    this.sx = sx;
    this.sy = sy;
  }
  void itemRender(float PX, float PY, float size) {
    item.render(PX, PY, size*0.95);
  }
  void render(float PX, float PY, float size) {
    lg.fill(200, 50);
    lg.setBlock(PX, PY, size, size, 10);
    if (item != null && this != inventorySlotSelection) {
      itemRender(PX, PY, size*0.95);
    }
  }
  void selectRender(float PX, float PY, float size) {
    lg.pg.stroke(10, 200, 10);
    lg.pg.strokeWeight(4*fix);
    lg.fill(0, 0);
    lg.setBlock(
      PX+x*(size+10)-(size/2+5)-(int(sx/2)-1)*(size+10)
      ,
      PY+y*(size+10)
      , size, size, 10);
    lg.pg.noStroke();
  }
}
