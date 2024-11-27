public static class LineCollisionResult {
  public PVector closestPoint;
  public float distance;

  public LineCollisionResult(PVector closestPoint, float distance) {
    this.closestPoint = closestPoint;
    this.distance = distance;
  }
}

public static LineCollisionResult findClosestPointOnSegment(PVector point, PVector lineStart, PVector lineEnd) {
  PVector lineVec = PVector.sub(lineEnd, lineStart);
  PVector pointVec = PVector.sub(point, lineStart);
  float lineLength = lineVec.mag();
  lineVec.normalize();

  float projectionLength = pointVec.dot(lineVec);
  projectionLength = PApplet.constrain(projectionLength, 0, lineLength);

  PVector closestPoint = PVector.add(lineStart, PVector.mult(lineVec, projectionLength));
  float distance = PVector.dist(point, closestPoint);

  return new LineCollisionResult(closestPoint, distance);
}

class line {
  PVector x1, x2;
  line(PVector x1, PVector x2) {
    this.x1 = x1;
    this.x2 = x2;
  }
}
class hitbox {
  ArrayList<line> lines = new ArrayList<line>();
  
  entity entity;
  float size = 0;
  float SX = 0;
  float SY = 0;
  
  void collision() {
    collision(entity.PX+SX, entity.PY+SY);
  }
  void collision(float PX, float PY) {
    entity.isCollision = max(0, entity.isCollision-1);
    for (line l : lines) {
      LineCollisionResult res = findClosestPointOnSegment(new PVector(posX(PX), posY(PY)), l.x1, l.x2);
      if (res.distance < size/2) {
        entity.isCollision = 4;
        float rx = res.closestPoint.x;
        float ry = res.closestPoint.y;
        
        rx -= posX(PX);
        ry -= posY(PY);
        float d = leng(rx, ry);
        
        rx /= d;
        ry /= d;
        
        entity.PX -= rx*(size/2-d)/2;
        entity.PY -= ry*(size/2-d)/2;
        if (entity.PY < 0) {
          entity.SX -= rx*(size/2-d)/3;
          entity.SY -= ry*(size/2-d)/3;
        } else {
          if (abs(rx*(size/2-d)/4) > 0.08) {
            entity.SX -= rx*(size/2-d)/3;
          }
          entity.SY -= ry*(size/2-d)/3;
        }
      }
    }
  }
  hitbox(entity entity, float size) {
    this.entity = entity;
    this.size = size;
  }
  hitbox(entity entity, float size, float SX, float SY) {
    this.entity = entity;
    this.size = size;
    this.SX = SX;
    this.SY = SY;
  }
  void optimization() {
    float h1, h2, h3, h4;
    lines.clear();
    for (worldPart f : world.worldRender) {
      if (abs(posX(entity.PX+SX)-f.PX*100) < 70 && abs(posY(entity.PY+SY)-f.PY*100) < 73) {
        for (int i = 0; i < f.points.size(); i+=2) {
          h1 = f.points.get(i);
          h2 = f.points.get(i+1);
          h3 = f.points.get((i+2)%f.points.size());
          h4 = f.points.get((i+1+2)%f.points.size());

          if (leng((h1+h3)/2-posX(entity.PX+SX), ((h2+h4)/2-posY(entity.PY+SY))/1.5) < leng(h1-h3, h2-h4)/2+12+size/2) {
            lines.add(new line(new PVector(h1, h2), new PVector(h3, h4)));
          }
        }
      }
    }
  }
  void render() {
    render(entity.PX+SX, entity.PY+SY);
  }
  void render(float PX, float PY) {
    lg.fill(100, 200, 100, 50);
    lg.pg.stroke(100, 200, 100);
    lg.pg.strokeWeight(3);
    lg.setEps(camX(posX(PX)), camY(posY(PY)), camZ(size), camZ(size));
    lg.pg.noStroke();
  }
}
