void gameRender() {
  lg.beginDraw();
  lg.pg.noStroke();
  lg.pg.clear();
  lg.endDraw();

  GameRenderFlagLightMap(); // Контроллер флага освещения
  GameRenderUpdateEffectMaps(); // Отрисовка карт эффектов
  GameRenderUpdateTransportMap();
  
  lg.beginDraw();
  GameRenderSky(); // Отрисовка неба
  GameRenderWaterLayer1(); // Отрисовка первого слоя воды
  GameRenderObjects(); // Отрисовка игровых объектов
  GameRenderOnline(); // Отрисовка онлайн-игроков
  GameRenderWaterLayer2(); // Отрисовка второго слоя воды
  lg.endDraw();

  GameRenderCreateLightMap(); // Создание карты освещения

  lg.beginDraw();
  GameRenderDisplayEffects(); // Отрисовка эффектов
  GameRenderWaterDrops();
  GameRenderUnderWaterDrops();
  GameRenderStats(); // Отрисовка статистики игрока
  GameRenderInventory(); // Отрисовка инвентаря
  debugRender(); // Отрисовка отладочной информации
  lg.endDraw();

  GameUpdateDisplay(); // Обновление отображения
}

void GameRenderObjects() {
  for (structure e : coral_o) {
    e.render();
  }
  particlesSystem.update();
  world.render();
  for (structure e : backStructure_o) {
    e.render();
  }

  for (entity e : entity_o) {
    if (e.inTransport == null) {
      if (e != player) {
        e.render();
      }
    }
  }
  player.renderTransport();
  for (entity e : entity_o) {
    if (e.inTransport != null && e.inTransport == player.inTransport) {
      if (e != player) {
        e.render();
      }
    }
  }
  player.render();

  if (online && host) {
    for (gameHost.ClientInfo c : gameHost.clients) {
      c.userPlayer.render();
    }
  }
  if (online && !host) {
    for (player c : playersServerList) {
      c.render();
    }
  }
  for (structure e : structure_o) {
    e.render();
  }
}
void GameRenderCreateLightMap() {
  if (!debug) {
    if (FLAG_LIGHTMAP) {
      lightMap.begin();

      float delta = 1-(_waterPhase-0.09)*2.62;
      if (delta > 0) {
        lightMap.map.fill(50, 90, 120, 100*delta);
        lightMap.map.setPolygon(waterPartsLowPoly, camX(posX(0)), camY(posY(-0.5)), camZ(1), camZ(1));
      }
      lightMap.map.fill(0, balanceH1*160.0);
      lightMap.map.setBlock(0, 0, 10000, 10000);

      world.renderLight();
      lightMap.map.pg.noStroke();
      lightMap.blur();

      for (structure e : coral_o) {
        e.lightRender();
      }
      for (entity e : entity_o) {
        e.lightRender();
      }
      particlesSystem.renderLight();

      lightMap.blur2();
      lightMap.end();
    }
  }
}
void GameRenderWaterDrops() {
  if (_waterDropsPhase != 0 && _waterDropsPhase != 1) {
    lg.fill(100,150,200,_waterDropsPhase*120);
    lg.setBlock(0,0,2000,2000);
    blur.set("power", 50.0*fix*(_waterDropsPhase*1));
    blur.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(blur);
    blur.set("power", 30.0*fix*(_waterDropsPhase*1));
    blur.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(blur);
    lg.pg.tint(100,130,200,_waterDropsPhase*128);
    lg.setImage(waterEffect, 0, _waterDropsPhase*100-50, lg.disW, lg.disH+100);
    lg.setImage(waterEffect, 0, _waterDropsPhase*200-100+300, lg.disW*((1-_waterDropsPhase)/10.0+1)*1.3+500, lg.disH*1.3+100);
    lg.setImage(waterEffect, 0, _waterDropsPhase*300-100-300, lg.disW*((1-_waterDropsPhase)/10.0+1)*1.6-1000, lg.disH*1.6+100);
    
    blur.set("power", 10.0*fix*(_waterDropsPhase*1));
    blur.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(blur);
    lg.pg.noTint();
  }
}
void GameRenderUnderWaterDrops() {
  if (_underWaterDropsPhase != 0 && _underWaterDropsPhase != 1) {
    lg.fill(40,80,120,_underWaterDropsPhase*200);
    lg.setBlock(0,0,2000,2000);
    blur.set("power", 100.0*fix*(_underWaterDropsPhase*1));
    blur.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(blur);
    blur.set("power", 60.0*fix*(_underWaterDropsPhase*1));
    blur.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(blur);
    blur.set("power", 30.0*fix*(_underWaterDropsPhase*1));
    blur.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(blur);
    lg.pg.noTint();
  }
}
void GameRenderDisplayEffects() {
  if (!debug) {
    lightMap.use();
  }
  if (_waterPhase > 0.091) {
    blur2.set("power", 100.0*fix*(_waterPhase-0.09));
    blur2.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(blur2);
    blur2.set("power", 60.0*fix*(_waterPhase-0.09));
    blur2.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    lg.pg.filter(blur2);
  }

  discoloration.set("power", 1.0-balanceH1/3.0);
  discoloration.set("dis", lg.pg.width*1.0, lg.pg.height*1.0);
  lg.pg.filter(discoloration);

  vignette(balanceH1*0.82, 3.3-balanceH1);
  vignette(balanceH1, 5.0-balanceH1);

  if (_waterPhase > 0.1) {
    blur.set("power", lg.pg.width/900.0 * (_waterPhase-0.1));
    blur.set("del", 0.5);
    blur.set("dis", lg.pg.width*1.0, lg.pg.height*1.0);
    lg.pg.filter(blur);
  }
}

void GameRenderInventory() {
  if (!inventory) {
    _inventoryPhase = max(0.0, _inventoryPhase-0.04);
  } else {
    _inventoryPhase = min(1.0, _inventoryPhase+0.04);
  }
  if (_inventoryPhase > 0.0) {
    blur.set("power", lg.pg.width/80.0 * _inventoryPhase);
    blur.set("del", 0.5);
    blur.set("dis", lg.pg.width*1.0, lg.pg.height*1.0);
    lg.pg.filter(blur);

    blur.set("power", lg.pg.width/160.0 * _inventoryPhase);
    blur.set("del", 0.5);
    blur.set("dis", lg.pg.width*1.0, lg.pg.height*1.0);
    lg.pg.filter(blur);

    blur.set("power", lg.pg.width/320.0 * _inventoryPhase);
    blur.set("del", 0.5);
    blur.set("dis", lg.pg.width*1.0, lg.pg.height*1.0);
    lg.pg.filter(blur);

    lg.fill(0, 160*_inventoryPhase);
    lg.setBlock(0, 0, lg.disW, lg.disH);
  }
  if (inventory) {
    invG.renderBg(0, 0, 80);
    invG.render(0, 0, 80);
  }
  inv.renderBg(0, -lg.disH2+60, 80);
  inv.render(0, -lg.disH2+60, 80);

  slotSelection.selectRender(0, -lg.disH2+60, 80);

  if (itemInfo != null) {
    renderItemInfo(itemInfo.item, itemInfoPosX, itemInfoPosY);
  }
  if (FLAG_INVENTORY_ITEM_RENDER) {
    inventorySlotSelection.itemRender(moux, mouy, 80);
  }
  lg.pg.noStroke();
}

void GameRenderStats() {
  if (true) {
    lg.fill(10);
    lg.setBlock(-lg.disW2+190, lg.disH2-62, 300, 48, 10);
    lg.fill(50, 20, 20);
    lg.setBlock(-lg.disW2+190, lg.disH2-62, 300-8, 48-8, 10-0.5);
    float delta = (player.HP+5)/(player.MaxHP+5);
    lg.fill(200, 80, 80);
    lg.setBlock(-lg.disW2+190+(delta-1)/2.0*300.0, lg.disH2-62, 300*delta-8, 48-8, 10-0.5);
    lg.fill(255);
    lg.pg.textAlign(0, 0);
    lg.setText(str(round(player.HP)), -lg.disW2+190-4, lg.disH2-62-8, 30);
  }
  if (true) {
    lg.fill(10);
    lg.setBlock(-lg.disW2+190, lg.disH2-62-70, 300, 48, 10);
    lg.fill(20, 50, 50);
    lg.setBlock(-lg.disW2+190, lg.disH2-62-70, 300-8, 48-8, 10-0.5);
    float delta = (player.MaxO2+5)/(player.AbcoluteMaxO2+5);
    lg.fill(60, 120, 120);
    lg.setBlock(-lg.disW2+190+(delta-1)/2.0*300.0, lg.disH2-62-70, 300*delta-8, 48-8, 10-0.5);
    float delta2 = (player.O2+5)/(player.AbcoluteMaxO2+5);
    lg.fill(80, 200, 200);
    lg.setBlock(-lg.disW2+190+(delta2-1)/2.0*300.0, lg.disH2-62-70, 300*delta2-8, 48-8, 10-0.5);
    lg.fill(255);
    lg.pg.textAlign(0, 0);
    lg.setText(str(round(player.O2)), -lg.disW2+190-4, lg.disH2-62-8-70, 30);
  }
}

void GameUpdateDisplay() {
  tint(255, 225);
  image(lg.pg, 0, 0, width, height);
  noTint();
}

void GameRenderWaterLayer1() {
  waterBG.set("iTime", frameCount/20.0);
  waterBG.set("zoom", 2/camZ(0.5)+0.5);
  waterBG.set("cam", 0., 0.);
  waterBG.set("iResolution", (float)lg.pg.width, (float)lg.pg.height);
  lg.pg.shader(waterBG);

  lg.setPolygon(waterParts, camX(posX(0)), camY(posY(0)), camZ(1), camZ(1));
  lg.pg.resetShader();

  lg.fill(50, 90, 120, 60);
  lg.setPolygon(waterParts, camX(posX(0)), camY(posY(0.05)), camZ(1), camZ(1.3));

  lg.fill(30, 60, 90, 100);
  lg.setPolygon(waterParts, camX(posX(0)), camY(posY(0)), camZ(1), camZ(1));

  if (player.PY < 0) {
    _darkPhase = _darkPhase*0.98+max(0, min(1.0, -player.PY/400.0))*0.02;
  } else {
    _darkPhase *= 0.98;
  }
  balanceH1 = _darkPhase;
  balanceH1 = pow(balanceH1, 0.5);
}

void GameRenderWaterLayer2() {
  if (nearestItem != null) {
    lg.fill(255, 200);
    lg.setEps(camX(posX(nearestItem.PX)), camY(posY(nearestItem.PY)), camZ(0.4), camZ(0.4));
  }

  if (_waterPhase > 0.1) {
    lg.fill(8*2.55, 36*2.55, 65*2.55, (_waterPhase-0.1)*230);
    lg.setBlock(0, 0, lg.disW, lg.disH);
  }

  water.set("iTime", frameCount/100.0);
  water.set("Alpha", _waterPhase*(balanceH1/2.0+1));
  water.set("Balance", 1500.0);
  water.set("tm", (PImage)transportMap.pg);

  lg.endDraw();
  water.set("texture1", lg.pg);
  lg.beginDraw();

  water.set("iResolution", (float)lg.pg.width, (float)lg.pg.height);
  lg.pg.shader(water);

  lg.setPolygon(waterParts, camX(posX(0)), camY(posY(0)), camZ(1), camZ(1));
  lg.pg.resetShader();
}


void GameRenderSky() {
  lg.bg(30+30*_GlobalLighting, 60+60*_GlobalLighting, 95+95*_GlobalLighting);

  lg.setTint(255, 130-130*_GlobalLighting);
  lg.setImage(spaceIMG.pg, 0, 0, lg.disW, lg.disH);
  lg.noTint();
  lg.setTint(255, 175-80*_GlobalLighting);
  lg.setImage(nebulaIMG.pg, 0, 0, lg.disW, lg.disH);

  lg.setImage(glowIMG.pg, 0, 0, lg.disW, lg.disH);
  lg.noTint();

  moonPosX = sin(_GlobalTime/700.0-2)*1300;
  moonPosY = cos(_GlobalTime/700.0-2)*500;

  if (_DayPhase > 0) {
    float a = -_DayPhaseCos/2.0+1;
    float r = sin(_GlobalTime/733.0+5)*80.0;
    float r2 = cos(_GlobalTime/733.0+5)*80.0;

    if (r2 >= 0) {
      lg.fill(200, 50, 60, 255);
      lg.setEps(-_DayPhaseCos*1300+sin(a)*r, _DayPhase*400+cos(a)*r, 45-r2/80.0*7, 45-r2/80.0*7);
    }

    lg.fill(200, 200, 60, 255);
    lg.setEps(-_DayPhaseCos*1300, _DayPhase*400, 85, 85);

    if (r2 < 0) {
      lg.fill(200, 50, 60, 255);
      lg.setEps(-_DayPhaseCos*1300+sin(a)*r, _DayPhase*400+cos(a)*r, 45, 45);
    }
  }
  lg.fill(150-_DayPhase*15, 150+_DayPhase*25, 150+_DayPhase*50, 255);
  lg.setEps(moonPosX, moonPosY, 40, 40);
}

void GameRenderUpdateEffectMaps() {
  if (frameCount % 2 == 0) {
    nebulaIMG.render();
  }
  if (frameCount % 6 == 0) {
    spaceIMG.render();
    glowIMG.render();
  }
}

void GameRenderFlagLightMap() {
  FLAG_LIGHTMAP = false;
  if (frameCount % 2 == 0) {
    lightMap.begin();
    lightMap.base();
    lightMap.end();
    FLAG_LIGHTMAP = true;
  }
}

void GameRenderOnline() {
  if (online) {
    player.renderName();
    if (host) {
      for (gameHost.ClientInfo c : gameHost.clients) {
        c.userPlayer.renderName();
      }
    } else {
      for (player c : playersServerList) {
        c.renderName();
      }
    }
  }
}

void GameRenderUpdateTransportMap() {
  transportMap.beginDraw();
  transportMap.pg.clear();
  transportMap.bg(0);
  transportMap.pg.noStroke();
  
  if (player.inTransport != null) {
    player.inTransport.inTransportMap();
  }
  
  transportMap.endDraw();
}
