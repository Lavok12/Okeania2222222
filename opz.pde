void entity_o() {
  entity_o.clear();
  for (entity e : entity) {
    if (abs(posX(e.PX)-camX) < max(MIN_DISTANCE_O, DISTANCE_O/zoom)) {
      if (abs(posY(e.PY)-camY) < max(MIN_DISTANCE_O, DISTANCE_O/zoom)) {
        entity_o.add(e);
        continue;
      }
    }
    if (online && host) {
      for (gameHost.ClientInfo c : gameHost.clients) {
        if (abs(posX(e.PX)-posX(c.userPlayer.PX)) < max(MIN_DISTANCE_O, DISTANCE_O/c.zoom)) {
          if (abs(posY(e.PY)-posY(c.userPlayer.PY)) < max(MIN_DISTANCE_O, DISTANCE_O/c.zoom)) {
            entity_o.add(e);
            continue;
          }
        }
      }
    }
  }
  itemEntity_o.clear();
  for (entity e : entity) {
    if (e instanceof itemEntity) {
      if (abs(posX(e.PX)-camX) < NEAR_ITEM_DISTANCE) {
        if (abs(posY(e.PY)-camY) < NEAR_ITEM_DISTANCE) {
          itemEntity_o.add((itemEntity)e);
          continue;
        }
      }
    }
  }
}
void backStructure_o() {
  backStructure_o.clear();
  for (structure e : backStructure) {
    if (abs(posX(e.PX)-camX) < (1500/zoom+6)) {
      if (abs(posY(e.PY)-camY) < (1000/zoom+6)) {
        backStructure_o.add(e);
      }
    }
  }
}

void structure_o() {
  structure_o.clear();
  for (structure e : structure) {
    if (abs(posX(e.PX)-camX) < (1500/zoom+14)) {
      if (abs(posY(e.PY)-camY) < (1000/zoom+14)) {
        structure_o.add(e);
      }
    }
  }
  coral_o.clear();
  for (structure e : coral) {
    if (abs(posX(e.PX)-camX) < (1500/zoom+14)) {
      if (abs(posY(e.PY)-camY) < (1000/zoom+14)) {
        coral_o.add(e);
      }
    }
  }
}
