import processing.core.*;
import java.util.*;
import java.net.*;
import java.io.*;
import java.nio.*;
import java.time.*;
import java.text.*;
import javax.tools.*;
import java.lang.*;
import processing.net.*;

// Основные переменные состояния и настройки
String event = "load", event2 = "0";
float disH, disW, disH2, disW2;
float moux, mouy, pmoux, pmouy;
float zoom = 0.1, targetZoom = 8.0;
float camX = 0, camY = 0.002;
float cameraSpeed = 25;
Boolean debug = false, console = false;
float fix;

int frameRateSetting = 60;
LGraphics lg;

LGraphics transportMap;

world world = new world();
PApplet papplet;

HashMap<String, Image> itemsImages = new HashMap<>();
HashMap<String, item> itemsMap = new HashMap<>();

// Метод инициализации программы
void setup() {
  initializeKeyRegistry();
  papplet = this;

  noiseSeed(rand(0, 255000));
  frameRate(frameRateSetting);

  fullScreen(P2D);

  setDisplayDimensions();
  noStroke();

  lg = new LGraphics(2000, disH / fix, fix);
  transportMap = new LGraphics(2000, disH / fix, fix/3);
  
  background(0);

  initializeWorld();

  if (online) {
    onlineStart();
  }
}

// Метод для инициализации основных параметров мира
void initializeWorld() {
  thread("base");
  entity_o();
}

void setDisplayDimensions() {
  disW = width;
  disH = height;
  disW2 = disW / 2;
  disH2 = disH / 2;
  fix = disW / 2000;
}

// Метод инициализации реестра клавиш
void initializeKeyRegistry() {
  for (int i = 0; i < 300; i++) {
    keyreg.put(i, false);
  }
}

// Основной поток инициализации базового состояния игры
void base() {
  event2 = "Загрузка";
  loadWorld();

  loadAssets();
  initializeNetworking();

  event = "game";
  gameStart();
}

// Метод загрузки всех игровых ассетов
void loadAssets() {
  loadStructures();
  loadEntities();
  loadTextures();
  loadShaders();
  loadEntityImages();
  loadStructureImages();
  loadEffectMaps();
  startSceneLoad();
}

// Метод инициализации сетевой игры
void initializeNetworking() {
  if (online && host) {
    gameHost.create();
  } else if (online) {
    user.connect();
  }
  event2 = "Запуск сетевой игры";
  if (online) onlineStart();
}

// Обработка нажатия клавиш мыши
void mousePressed() {
  calculateMousePosition();

  if (event.equals("game")) {
    gameTap();
  }
}

// Обработка прокрутки колесика мыши для масштабирования
void mouseWheel(MouseEvent event) {
  calculateMousePosition();
  targetZoom *= event.getCount() > 0 ? 1 / 1.11 : 1.11;
}

// Расчет положения мыши
void calculateMousePosition() {
  moux = (mouseX - disW2) * (lg.disW / disW);
  mouy = (-mouseY + disH2) * (lg.disH / disH);
  pmoux = (pmouseX - disW2) * (lg.disW / disW);
  pmouy = (-pmouseY + disH2) * (lg.disH / disH);
}

// Основной цикл отрисовки
void draw() {
  background(0, 0, 0);

  calculateMousePosition();
  handleNetworkConnection();

  renderState();
}

// Проверка и обработка сетевого подключения
void handleNetworkConnection() {
  if (event.equals("connected") || event.equals("game")) {
    event = online && !host && !user.connect ? "connected" : "game";
  }
}

// Обновление состояния игры
void updateGame() {
  gameUpdate();
  if (frameCount % 6 == 0 && online && !host && user.connect) {
    user.update();
  }
}

// Отрисовка игрового состояния
void renderGame() {
  gameRender();
  if (frameCount % 6 == 0 && online && host) {
    gameHost.update();
  }
  if (debug) debug();
  if (console) renderConsole();
}

// Рендер консоли и отладочной информации
void renderConsole() {
  fill(0, 128);
  setBlock(0, 0, width, height);
  Console.display();
}

// Основная функция отрисовки состояния игры
void renderState() {
  switch (event) {
  case "game":
    updateGame();
    renderGame();
    break;
  case "load":
    renderLoading();
    break;
  case "menu":
    menuRender();
    break;
  case "startScene":
    startSceneRender();
    break;
  case "connected":
    renderConnected();
    break;
  }
}

// Рендер экрана загрузки
void renderLoading() {
  background(0);
  fill(255);
  textAlign(CENTER, CENTER);
  setText(event2, 0, 0, 50);
}

// Рендер экрана состояния "Connected"
void renderConnected() {
  background(10);
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(50);
  text("Connected", width / 2, height / 2);
}
