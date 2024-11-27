player player = new player(-135, -0.1);
ArrayList<entity> entity = new ArrayList<entity>();
ArrayList<entity> entity_o = new ArrayList<entity>();
ArrayList<itemEntity> itemEntity_o = new ArrayList<itemEntity>();

ArrayList<structure> structure = new ArrayList<structure>();
ArrayList<structure> structure_o = new ArrayList<structure>();

ArrayList<structure> backStructure = new ArrayList<structure>();
ArrayList<structure> backStructure_o = new ArrayList<structure>();

ArrayList<structure> coral = new ArrayList<structure>();
ArrayList<structure> coral_o = new ArrayList<structure>();

float DISTANCE_O = 1900;
float MIN_DISTANCE_O = 120;
float NEAR_ITEM_DISTANCE = 10;
float PICK_UP_DISTANCE = 1.2;

inventory inv = new inventory(10, 1);
inventory invG = new inventory(10, 6);
partInventory slotSelection = inv.inv[0][0];
partInventory inventorySlotSelection = null;
partInventory itemInfo = null;
float itemInfoPosX = 0;
float itemInfoPosY = 0;

Boolean inventory = false;

float _inventoryPhase = 0.0;
float _darkPhase = 0.0;
float _waterPhase = 0.9;

itemEntity nearestItem = null;

Boolean FLAG_INVENTORY_ITEM_RENDER = false;
Boolean FLAG_LIGHTMAP = false;

float _GlobalTime = 0;
float _DayPhase = 0;
float _waterDropsPhase = 0;
float _underWaterDropsPhase = 0;

float _DayPhaseCos = 0;
float _GlobalLighting = 0;

float moonPosX;
float moonPosY;

particlesSystem particlesSystem = new particlesSystem();

float[][] waterParts = new float[104][2];
float[][] waterPartsLowPoly = new float[54][2];

float balanceH1 = 0;

void gameStart() {
  addItem(new item1(), inv, invG);
  addItem(new item2(), inv, invG);
  addItem(new item3(), inv, invG);
  addItem(new item4(), inv, invG);
  addItem(new item5(), inv, invG);
}
void gameTap() {
  GameTapInventory(); // Обновление состояния инвентаря при нажатии
}
void gameUpdate() {
  GameUpdateObjects(); // Обновление объектов в игре
  GameUpdateDynamicLoad(); // Динамическая загрузка объектов
  GameUpdateNearestItem(); // Обновление информации о ближайшем предмете для взаимодействия
  GameUpdateCamera(); // Обновление позиции и масштаба камеры
  GameUpdateWaterPhase(); // Обновление прозрачности воды
  GameUpdateWaterDrops(); // Обновить капли
  GameUpdateInventory(); // Обновление состояния инвентаря и управления предметами
  GameUpdateDayPhase(); // Обновление фазы дня
  GameUpdateGlobalLightningPower(); // Обновление силы фонового освещения в игре
  GameUpdatePlayerUsingItem(); // Обновление используемого предмета
}


void GameUpdateObjects() {
  if (!online || host) {
    for (entity e : entity_o) {
      if (e != player) {
        e.update();
      }
    }
  }
  player.update();

  if (online && host) {
    for (gameHost.ClientInfo c : gameHost.clients) {
      c.userPlayer.move();
      c.userPlayer.gravity();
      c.userPlayer.friction(0.8, 0.95);
    }
  }
  if (online && !host) {
    for (player c : playersServerList) {
      c.move();
      c.gravity();
      c.friction(0.8, 0.95);
    }
  }

  for (entity e : entity_o) {
    e.move();
    e.gravity();
    e.friction(0.8, 0.95);
  }
  for (structure e : structure_o) {
    e.animation();
  }
}

void GameUpdateNearestItem() {
  if (frameCount % 6 == 0) {
    float l = Float.MAX_VALUE;
    for (itemEntity x : itemEntity_o) {
      float lc = leng(player.PX-x.PX, player.PY-x.PY);
      if (lc < l) {
        l = lc;
        nearestItem = x;
      }
    }
    if (l <= PICK_UP_DISTANCE == false) {
      nearestItem = null;
    }
  }
}

void GameUpdateDynamicLoad() {
  if (frameCount % 6 == 0) {
    if (online && !host) {
      for (player c : playersServerList) {
        c.hitboxOptimization();
      }
    }
    if (online && host) {
      for (gameHost.ClientInfo c : gameHost.clients) {
        c.userPlayer.hitboxOptimization();
      }
    }
    for (entity e : entity_o) {
      e.hitboxOptimization();
    }
  }

  if (frameCount % 30 == 0) {
    entity_o();
    structure_o();
    backStructure_o();
  }
  if (frameCount % 20 == 0) {
    world.optimization();
  }
}

void GameUpdateCamera() {
  zoom = zoom * 0.85 + targetZoom*0.15;
  camX = camX * 0.95 + posX(player.PX) * 0.05;
  camY = camY * 0.95 + posY(player.PY) * 0.05;
}

void GameUpdateWaterPhase() {
  if (player.PY > -0.21) {
    _waterPhase = max(0.09, _waterPhase-0.01);
  } else {
    _waterPhase = min(0.5, _waterPhase+0.01);
  }
}

void GameUpdateWaterDrops() {
  if (player.underwater) {
    _waterDropsPhase = 1;
  } else {
    _waterDropsPhase = max(0, _waterDropsPhase-0.015);
  }
  
  if (!player.underwater) {
    _underWaterDropsPhase = 1;
  } else {
    _underWaterDropsPhase = max(0, _underWaterDropsPhase-0.008);
  }
}
void GameUpdateGlobalLightningPower() {
  _GlobalLighting = _DayPhase+0.2;

  if (_GlobalLighting < 0) {
    _GlobalLighting *= 2.0;
    _GlobalLighting = max(_GlobalLighting, -1.0);
  } else {
    _GlobalLighting /= 1.2;
  }
  if (frameCount % 2 == 0) {
    waterPartsUpdate();
  }
}

void GameUpdateDayPhase() {
  _GlobalTime+=0.1;
  _DayPhase = sin(_GlobalTime/500.0);
  _DayPhaseCos = cos(_GlobalTime/500.0);
}
void GameUpdatePlayerUsingItem() {
  player.useItem = slotSelection.item;
}
void GameUpdateInventory() {
  FLAG_INVENTORY_ITEM_RENDER = false;

  if (inventory) {
    if (inventorySlotSelection != null) {
      if (mousePressed) {
        FLAG_INVENTORY_ITEM_RENDER = true;
      } else {
        partInventory lc = null;
        {
          lc = inv.tapDetect(0, -lg.disH2+60, 80);
          if (lc != null) {
            if (lc.item != null) {
            }
          }
          if (lc == null) {
            lc = invG.tapDetect(0, 0, 80);
            if (lc != null) {
              if (lc.item != null) {
              }
            }
          }
        }
      part:
        {
          if (lc == null) {
            //entity.add(new itemEntity(player.PX, player.PY, inventorySlotSelection.item));
            spawnEntituItem(inventorySlotSelection.item.tag, inventorySlotSelection.item, player);
            entity_o();
            inventorySlotSelection.item = null;
            break part;
          }
          if (lc.item == null) {
            lc.item = inventorySlotSelection.item;
            inventorySlotSelection.item = null;
            break part;
          } else {
            item i = lc.item;
            lc.item = inventorySlotSelection.item;
            inventorySlotSelection.item = i;
            break part;
          }
        }
        inventorySlotSelection = null;
      }
    }
  } else {
    itemInfo = null;
  }
}


void GameTapInventory() {
  if (!inventory) {
    partInventory lc = inv.tapDetect(0, -lg.disH2+60, 80);
    if (lc != null) {
      slotSelection = lc;
      return;
    }
  } else {
    if (mouseButton == LEFT) {
      itemInfo = null;
      partInventory lc = inv.tapDetect(0, -lg.disH2+60, 80);
      if (lc != null) {
        if (lc.item != null) {
          inventorySlotSelection = lc;
          return;
        }
      }
      lc = invG.tapDetect(0, 0, 80);
      if (lc != null) {
        if (lc.item != null) {
          inventorySlotSelection = lc;
          return;
        }
      }
    } else if (mouseButton == RIGHT) {
      itemInfoPosX = moux;
      itemInfoPosY = mouy;

      partInventory lc = inv.tapDetect(0, -lg.disH2+60, 80);
      if (lc != null) {
        if (lc.item != null) {
          itemInfo = lc;
          return;
        }
      }
      lc = invG.tapDetect(0, 0, 80);
      if (lc != null) {
        if (lc.item != null) {
          itemInfo = lc;
          return;
        }
      }
      itemInfo = null;
    }
  }
}
void waterPartsUpdate() {
  float deltaX = +camX;

  waterParts[0][0] = (-1200)/zoom+deltaX;
  waterParts[0][1] = -2000;
  waterParts[1][0] = (-1200)/zoom+deltaX;
  waterParts[1][1] = 0;

  waterPartsLowPoly[0][0] = (-1200)/zoom+deltaX;
  waterPartsLowPoly[0][1] = -2000;
  waterPartsLowPoly[1][0] = (-1200)/zoom+deltaX;
  waterPartsLowPoly[1][1] = 0;

  int di, di2;
  if (camY(posY(0)) > lg.disH2+100) {
    for (int i = 0; i < 100; i++) {
      di = i+2;
      waterParts[di][0] = (-1200+di*24)/zoom+deltaX;
      waterParts[di][1] = 0;
    }
  } else {
    for (int i = 0; i < 100; i++) {
      di = i+2;
      waterParts[di][0] = (-1200+di*24)/zoom+deltaX;
      waterParts[di][1] = sin(waterParts[di][0]/1.0-frameCount/12.0/3.0)*0.1;
      waterParts[di][1] += sin(waterParts[di][0]*2.2+frameCount/8.0/3.0)*0.1;
      waterParts[di][1] -= abs(sin(waterParts[di][0]*2.9-frameCount/12.0/3.0)*0.062);
      waterParts[di][1] -= abs(sin(waterParts[di][0]*2.4+frameCount/16.0/3.0)*0.062);

      if (i%2==0) {
        di2 = i%2+2;
        waterPartsLowPoly[di2][0] = waterParts[di][0];
        waterPartsLowPoly[di2][1] = waterParts[di][1];
      }
    }
  }
  waterPartsLowPoly[52][0] = (1200)/zoom+deltaX;
  waterPartsLowPoly[52][1] = 0;
  waterParts[103][0] = (1200)/zoom+deltaX;
  waterParts[103][1] = -2000;

  waterParts[102][0] = (1200)/zoom+deltaX;
  waterParts[102][1] = 0;
  waterParts[103][0] = (1200)/zoom+deltaX;
  waterParts[103][1] = -2000;
}
