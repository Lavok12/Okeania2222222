
class world {
  ArrayList<worldPart> worldPart = new ArrayList<worldPart>(10);
  ArrayList<worldPart> worldRender = new ArrayList<worldPart>(10);

  void load() {
    int start = millis();
    worldPart.clear();
    String filePath = dataPath("export/export.json");

    File file = new File(filePath);

    println("map loading" + " | " + (millis()-start));
    if (file.exists()) {
      println("file.exists" + " | " + (millis()-start));
      JSONObject load = loadJSONObject("data/export/export.json");
      int count = load.getInt("globalCount");
      println("polygons: "+count + " | " + (millis()-start));
      for (int i = 0; i < count; i++) {
        JSONObject local = load.getJSONObject(""+(i+1));
        worldPart c;
        worldPart.add(c = new worldPart(local.getInt("PX"), local.getInt("PY")));
        int localCount = local.getInt("count") + 1;
        print("lc: "+localCount + " i: "+i+" / ");

        JSONObject points = local.getJSONObject("points");
        for (int j = 0; j < localCount; j++) {
          JSONObject point = points.getJSONObject(""+j);
          if (c != null) {
            if (point == null) {
              println();
              println("point == null");
            }
            c.points.add(point.getFloat("pointX"));
            c.points.add(point.getFloat("pointY"));
          }
        }
      }
    }
    println("end" + " | " + (millis()-start));
  }
  void optimization() {
    worldRender.clear();
    for (worldPart f : worldPart) {
      if (leng(f.PX*100-camX, f.PY*100-camY) < 2300/zoom+100) {
        worldRender.add(f);
      }
      if (online && host) {
        for (gameHost.ClientInfo c : gameHost.clients) {
          if (leng(f.PX*100-posX(c.userPlayer.PX), f.PY*100-posY(c.userPlayer.PY)) < 2300/c.zoom+100) {
            worldRender.add(f);
          }
        }
      }
    }
  }
  void renderLight() {
    for (worldPart f : worldRender) {
      f.renderLight();
    }
  }
  void render() {
    lg.pg.resetShader();
    textureShader.set("dis", (float)lg.pg.width, (float)lg.pg.height);
    textureShader.set("fix", fix);
    textureShader.set("zoom", zoom);
    textureShader.set("cam", camX, camY);
    textureShader.set("texture1", texture1);
    textureShader.set("texture2", texture2);
    textureShader.set("texture3", texture3);

    lg.pg.shader(textureShader);
    for (worldPart f : worldRender) {
      if (leng(f.PX*100-camX, f.PY*100-camY) < 1400/zoom+100) {
        f.render(1);
      }
    }
    lg.pg.resetShader();
  }
  void renderHitbox() {
    for (worldPart f : worldRender) {
      if (leng(f.PX*100-camX, f.PY*100-camY) < 1400/zoom+100) {
        f.renderHitbox(1);
      }
    }
  }
}

class worldPart {
  int PX, PY;
  worldPart(int PX, int PY) {
    this.PX = PX;
    this.PY = PY;
  }
  ArrayList<Float> points = new ArrayList<Float>();

  float f[][];
  void render() {
    render(1);
  }
  void render(float r) {
    if (f == null || f.length * 2 < points.size()) {
      f = new float[points.size()/2][2];
    }
    int a = 0;
    for (int i = 0; i < points.size(); i+=2) {
      f[a][0] = points.get(i);
      f[a][1] = points.get(i+1);
      a++;
    }
    lg.fill(255+200-200*r);
    lg.setPolygon(f, camX(0), camY(0), camZ(1), camZ(1));
  }
  void renderLight() {
    if (f == null || f.length * 2 < points.size()) {
      f = new float[points.size()/2][2];
    }
    int a = 0;
    for (int i = 0; i < points.size(); i+=2) {
      f[a][0] = points.get(i);
      f[a][1] = points.get(i+1);
      a++;
    }
    lightMap.map.fill(0);
    lightMap.map.setPolygon(f, camX(0), camY(0), camZ(1), camZ(1));
  }
  void renderHitbox(float r) {
    if (f == null || f.length * 2 < points.size()) {
      f = new float[points.size()/2][2];
    }
    int a = 0;
    for (int i = 0; i < points.size(); i+=2) {
      f[a][0] = points.get(i);
      f[a][1] = points.get(i+1);
      a++;
    }
    lg.fill(200, 100, 100, 50);
    lg.pg.stroke(200, 100, 100);
    lg.pg.strokeWeight(3);
    lg.setPolygon(f, camX(0), camY(0), camZ(1), camZ(1));
    lg.pg.noStroke();
  }
  void renderGrass() {
  }
}

float ray(float x, float y, float sx, float sy) {
  float minR = Float.MAX_VALUE;
  float r = -1;
  for (worldPart p : world.worldRender) {
    float worldPosX = p.PX*100;
    float worldPosY = p.PY*100;

    /*if (leng((x)-worldPosX, ((y)-worldPosY)) > minR+50*1.45) {
      continue;
    }

    if (sx < 0 && (x) < worldPosX-50) {
      continue;
    }
    if (sx > 0 && (x) > worldPosX+50) {
      continue;
    }
    if (sy < 0 && (y) < worldPosY-50) {
      continue;
    }
    if (sy > 0 && (y) > worldPosY+50) {
      continue;
    }*/
    float partX, partY, partX2, partY2;
    for (int i = 0; i < p.points.size(); i+=2) {
      partX = p.points.get(i);
      partY = p.points.get(i+1);
      partX2 = p.points.get((i+2)%p.points.size());
      partY2 = p.points.get((i+3)%p.points.size());

      r = raySegmentIntersect(posX(x), posY(y), sx, sy, partX, partY, partX2, partY2);
      if (r > -1.0) {
        minR = min(r, minR);
      }
    }
  }
  if (minR == Float.MAX_VALUE) {
    return -1;
  }

  return minR;
}


float raySegmentIntersect(float fx, float fy, float sx, float sy, float x1, float y1, float x2, float y2) {
  // Направление луча
  PVector rayDir = new PVector(sx - fx, sy - fy);
  rayDir.normalize(); // Нормализуем направление луча

  // Начальная позиция луча
  PVector rayOrigin = new PVector(fx, fy);

  // Векторы отрезка
  PVector segmentStart = new PVector(x1, y1);
  PVector segmentEnd = new PVector(x2, y2);
  PVector segmentDir = PVector.sub(segmentEnd, segmentStart);

  // Проверка на параллельность
  float cross = rayDir.x * segmentDir.y - rayDir.y * segmentDir.x;
  if (abs(cross) < 0.00001) {
    // Луч и отрезок параллельны
    return -1;
  }

  // Векторы от начала отрезка до начала луча
  PVector diff = PVector.sub(rayOrigin, segmentStart);

  // Вычисляем параметры луча и отрезка
  float t1 = (diff.x * segmentDir.y - diff.y * segmentDir.x) / cross;
  float t2 = (diff.x * rayDir.y - diff.y * rayDir.x) / cross;

  // t1 - параметр для луча, должен быть >= 0 (луч бесконечный, но в одном направлении)
  // t2 - параметр для отрезка, должен быть между 0 и 1 (отрезок ограничен)
  if (t1 >= 0 && t2 >= 0 && t2 <= 1) {
    // Пересечение найдено
    return t1 * rayDir.mag(); // Возвращаем расстояние до точки пересечения
  }

  // Пересечения нет
  return -1;
}
