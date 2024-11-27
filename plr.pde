public class player extends entity {
  Boolean controleTransport = false;

  // Поля для здоровья и кислорода игрока
  float HP = 50;
  float MaxHP = 100;

  float O2 = 30;
  float MaxO2 = 60;
  float AbcoluteMaxO2 = 80;

  // Флаги состояния игрока
  Boolean underwater = false;
  String userName = "";

  // Предмет, который игрок использует
  item useItem = null;

  // Конструктор класса
  player(float PX, float PY) {
    super(PX, PY);
    hitbox = new hitbox(this, 2);
  }

  void move() {
    if (inTransport == null) {
      backMove(true);
    } else {
      backMove(false);
    }
  }
  // Метод обновления состояния игрока
  void update() {
    // Восстановление здоровья
    HP = min(MaxHP, HP + 0.1);

    // Проверка на подводное состояние
    underwater = PY <= -0.21;

    if (inTransport != null) {
      underwater = false;
      updateTransport();
    }
    // Обновление уровня кислорода в зависимости от состояния
    if (underwater) {
      O2 = max(0, O2 - (1 / 120.0));
      MaxO2 = max(20, MaxO2 - (1 / 250.0));
    } else {
      O2 = min(MaxO2, O2 + 1);
      MaxO2 = min(AbcoluteMaxO2, MaxO2 + (1 / 100.0));
    }

    // Переменные для перемещения игрока
    float dx = 0;
    float dy = 0;

    // Управление движением игрока
    if (!console) {
      if (keyreg.get(87)) { // W
        dy += 1;
      }
      if (keyreg.get(83)) { // S
        dy -= 1;
      }
      if (keyreg.get(68)) { // D
        dx += 1;
      }
      if (keyreg.get(65)) { // A
        dx -= 1;
      }
      if (keyreg.get(32)) { // Space
        if (!underwater && isCollision > 0) {
          SY = 0.15; // Прыжок
        }
      }
    }

    // Нормализация вектора движения
    float l = sqrt(sq(dx) + sq(dy));
    if (l > 0) {
      if (underwater) {
        SX += dx / l / 300;
        SY += dy / l / 300;
        O2 = max(0, O2 - (l / 60.0));
      } else {
        if (inTransport == null) {
          SX += dx / l / 50;
        } else {
          SX += dx / l / 120;
        }
      }
      rotate = atan2(SX, SY); // Угол поворота
    }

    // Определение направления движения
    reverse = SX < 0;
  }

  void checkTransport() {
    if (inTransport == null) {
      for (entity f : entity_o) {
        if (f instanceof transport) {
          if (leng(PX-f.PX, PY-f.PY) <= 0.8) {
            PX = f.PX;
            PY = f.PY;
            inTransport = (transport)f;
            break;
          }
        }
      }
    }
  }
  void updateTransport() {
    inTransport.updateTransport();
    backGravity();
    inTransport.inTransportCollision(hitbox);
  }
  void renderTransport() {
    if (inTransport != null) {
      inTransport.renderTransport();
    }
  }

  // Метод для отрисовки игрока
  void render() {

    lg.fill(255, 240, 230); // Цвет игрока
    lg.setEps(camX(posX(PX)), camY(posY(PY)), camZ(2), camZ(2)); // Установка позиции

    // Отрисовка предмета, если он есть
    if (useItem != null) {
      float itemOffsetX = reverse ? -0.7f : 0.7f;
      float itemOffsetY = PY > 0 ? 0 : cos(rotate);
      useItem.renderItem(camX(posX(PX) + itemOffsetX), camY(posY(PY) + itemOffsetY), camZ(1.6), reverse);
    }
  }
  // Метод для отрисовки света
  void lightRender() {
    if (player.inTransport != null) {
      player.inTransport.renderLightTransport();
    }
    if (useItem != null) {
      useItem.lightRender(camX(posX(PX)), camY(posY(PY)), camZ(1.0));
    }
  }
  // Метод для отрисовки имени игрока
  void renderName() {
    lg.fill(200); // Цвет имени
    lg.setAlign(0, 0); // Выравнивание текста
    lg.setText(userName, camX(posX(PX)), camY(posY(PY + 0.5f)) + 20, 30);
  }
}
