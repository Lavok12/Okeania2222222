FloatList frameRates = new FloatList();

int c;
void debug() {
  fill(255);
  textSize(12);
  textAlign(LEFT, UP);
  
  c = 12;

  addDebug("millis", millis(), TAB, "frames:", frameCount);
  addDebug("fps:", z(frameRate));
  addDebug("playerX:", z(player.PX), TAB, "playerY:", z(player.PY));
  addDebug("DplayerX:", z(posX(player.PX)), TAB, "DplayerY:", z(posY(player.PY)));

  addDebug("playerHP:", z(posX(player.HP)), TAB, "playerMaxHP:", z(posY(player.MaxHP)));
  addDebug("playerO2:", z(posX(player.HP)), TAB, "playerMaxO2:", z(posY(player.MaxHP)), TAB, "playerAbcoluteMaxO2:", z(posY(player.AbcoluteMaxO2)));

  addDebug("speedX:", z(player.SX, 2), TAB, "speedY:", z(player.SY, 2));
  addDebug("cameraX:", z(camX), TAB, "cameraY:", z(camY), TAB, "zoom:", z(zoom), TAB, "targetZoom:", z(targetZoom));
  addDebug("mousePosX:", z(moux), TAB, "mousePosY:", z(mouy));
  addDebug("mouseWorldX:", z((moux/zoom+camX)/2), TAB, "mouseWorldY:", z((mouy/zoom+camY+328)/2));
  addDebug("worldParts:", world.worldPart.size(), TAB, "loaded:", world.worldRender.size());
  addDebug("entitiesCount:", entity.size(), TAB, "loaded:", entity_o.size());
  addDebug("structuresCount:", structure.size(), TAB, "loaded:", structure_o.size());
  addDebug("staticStructuresCount:", coral.size(), TAB, "loaded:", coral_o.size());
  addDebug("backStructuresCount:", backStructure.size(), TAB, "loaded:", backStructure_o.size());

  addDebug("itemsCount:", itemEntity_o.size());
  addDebug("particlesCount:", particlesSystem.particles.size());

  addDebug();
  addDebug("spaceIMG:", TAB, "width:", spaceIMG.pg.width, TAB, "height:", spaceIMG.pg.height);
  addDebug("nebulaIMG:", TAB, "width:", nebulaIMG.pg.width, TAB, "height:", nebulaIMG.pg.height);
  addDebug("glowIMG:", TAB, "width:", glowIMG.pg.width, TAB, "height:", glowIMG.pg.height);
  addDebug("raysIMG:", TAB, "width:", raysIMG.pg.width, TAB, "height:", raysIMG.pg.height);
  addDebug("_waterPhase:", _waterPhase, TAB, "_inventoryPhase:", _inventoryPhase, TAB, "_darkPhase:", _darkPhase, TAB, "waterDropsPhase:", _waterDropsPhase, TAB, "underWaterDropsPhase:" , _underWaterDropsPhase);
  addDebug("_GlobalTime:", z(_GlobalTime), TAB, "_DayPhase:", z(_DayPhase), TAB, "_DayPhaseCos:", z(_DayPhaseCos), TAB, "_GlobalLighting:", z(_GlobalLighting));

  addDebug("CONST:", TAB, "G:", G, TAB, "DISTANCE_O:", DISTANCE_O, TAB, "MIN_DISTANCE_O:", MIN_DISTANCE_O, TAB, "cameraSpeed:", cameraSpeed, TAB, "NEAR_ITEM_DISTANCE:", NEAR_ITEM_DISTANCE);
  addDebug("PICK_UP_DISTANCE:", PICK_UP_DISTANCE);
  addDebug();

  long totalMemory = Runtime.getRuntime().totalMemory();
  long freeMemory = Runtime.getRuntime().freeMemory();
  long usedMemory = totalMemory - freeMemory;
  addDebug("totalMemory:", totalMemory/1024/1024+"MB", TAB, "freeMemory:", freeMemory/1024/1024+"MB", TAB, "memoryUsage:", usedMemory/1024/1024+"MB");
  addDebug("osName:", System.getProperty("os.name"), TAB, "osVersion:", System.getProperty("os.version"), TAB, "osArch:", System.getProperty("os.arch"));
  addDebug("javaVersion:", System.getProperty("java.version"), TAB, "javaVendor:", System.getProperty("java.vendor"));
  addDebug("processors:", Runtime.getRuntime().availableProcessors());

  addDebug("screenWidth:", displayWidth, TAB, "screenHeight:", displayHeight);
  addDebug("sketchWidth:", width, TAB, "sketchHeight:", height);
  addDebug("LGraphicsWidth:", lg.disW, TAB, "LGraphicsHeight:", TAB, lg.disH, "LGraphicsFix", fix);
  addDebug("LGraphicsRealWidth:", lg.pg.width, TAB, "LGraphicsRealHeight:", TAB, lg.pg.height);

  addDebug("javaVersion:", System.getProperty("java.version"), TAB, "javaArch:", System.getProperty("sun.arch.data.model"));
  addDebug("userLanguage:", Locale.getDefault().getLanguage());
  Date currentDate = new Date();
  addDebug("currentTime:", currentDate.toString());

  addDebug("");
  addDebug("online: ", online, TAB, "host: ", host);
  if (online) {
    if (host) {
      addDebug("");
      addDebug("clients: ", gameHost.clients.size());
    } else {
      addDebug("connect: ", user.connect);
      addDebug("playersCount: ", playersServerList.size()+1);
    }
  }
  addDebug("");

  if (frameCount % 12 == 0) {
    frameRates.append(z(frameRate));
  }
  if (frameRates.size() > 120) {
    frameRates.remove(0);
  }

  addDebug("framerate:");
  addDebug("                                                                                                                            ");
  addDebug("                                                                                                                            ");
  addDebug("                                                                                                                            ");
  addDebug("                                                                                                                            ");
  addDebug("                                                                                                                            ");
  addDebug("                                                                                                                            ");
  addDebug("                                                                                                                            ");

  for (int i = 0; i < frameRates.size(); i++) {
    fill(230-frameRates.get(i)*3, 50+frameRates.get(i)*3, 50);
    rect(11+i*2, c-6-frameRates.get(i), 4, frameRates.get(i));
  }
}
void addDebug(Object... args) {
  c += 12;
  String text = "";
  for (int i = 0; i < args.length; i++) {
    text += "  "+args[i];
  }
  fill(0, 100);
  rect(0, c-9, textWidth(text)+15, 12);
  fill(0);
  text(text, 11+1, c);
  text(text, 11-1, c);
  text(text, 11, c+1);
  text(text, 11, c-1);
  fill(255);
  text(text, 11, c);
}

float z(float z) {
  return round(z*10.0)/10.0;
}
float z(float z, float x) {
  return round(z*pow(10, x))/pow(10, x);
}


void debugRender() {
  if (debug) {
    world.renderHitbox();
    for (structure e : structure_o) {
      e.debugRender();
    }
    if (online && host) {
      for (gameHost.ClientInfo c : gameHost.clients) {
        c.userPlayer.hitboxRender();
      }
    }
    if (online && !host) {
      for (player c : playersServerList) {
        c.hitboxRender();
      }
    }
    for (entity e : entity_o) {
      e.hitboxRender();
    }
    lg.fill(0, 0);
    lg.pg.stroke(50, 200, 200);
    lg.pg.strokeWeight(4);
    lg.setBlock(camX(camX), camY(camY), camZ(max(MIN_DISTANCE_O, DISTANCE_O)*2/zoom), camZ(max(MIN_DISTANCE_O, DISTANCE_O)*2/zoom));

    lg.fill(0, 0);
    lg.pg.stroke(200, 200, 50);
    lg.pg.strokeWeight(4);
    lg.setBlock(camX(posX(player.PX)), camY(posY(player.PY)), camZ(NEAR_ITEM_DISTANCE*2), camZ(NEAR_ITEM_DISTANCE*2));

    lg.pg.stroke(200, 50, 200);
    lg.pg.strokeWeight(2);
    lg.setBlock(camX(camX), camY(camY), camZ(MIN_DISTANCE_O*2), camZ(MIN_DISTANCE_O*2));

    lg.pg.stroke(50, 200, 50);
    lg.pg.strokeWeight(2);
    lg.setBlock(camX(camX), camY(camY), camZ(1500/zoom)*2, camZ(1000/zoom)*2);

    lg.pg.noStroke();
  }
}
