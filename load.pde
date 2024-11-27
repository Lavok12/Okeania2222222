PShader water, blur, space, waterBG, nebula, rays, waveStars, discoloration, lightMapShader, blur2, oldNoise;
PShader textureShader;

PImage textT;

Image fish;
Image demonPart;
Image demon2Part1;
Image demon2Part2;

Image moonFish;
Image seaLump;
Image jellyfish, jellyfish1;
Image lightSaber;

Image item1;
Image item2;
Image item3;
Image item4;
Image item5;

PImage grass, coralImage1, coralFlowerImage1, coralFlowerImage1_1, grassBg1, backStructure1, plantLamp, circleGlow, picka;
PImage treeList;
PImage tree1;
PImage tree2;
PImage tree3;

PImage blackList;
PImage black1;
PImage black2;
PImage black3;
PImage black4;

space spaceIMG;
nebula nebulaIMG;
glow glowIMG;
rays raysIMG;
lightMap lightMap;

PImage vignette;
PImage waterEffect;

PImage texture1, texture2, texture3;

void loadEffectMaps() {
  spaceIMG = new space(width/2, height/2);
  nebulaIMG = new nebula(width/4, height/4);
  glowIMG = new glow(width/4, height/4);
  raysIMG = new rays(width/2, height/2);
  lightMap = new lightMap();
}
void loadWorld() {
  world.load();
}

void loadStructures() {
  coral = loadStructureData("data/export/str.JSON");
  backStructure = loadBackStructureData("data/export/bkstr.JSON");
}

void loadEntities() {
  entity.add(player);
}

void loadTextures() {
  textT = loadImage("trash/images/blueGrass.jpg");
  texture1 = loadImage("trash/images/sand.jpg");
  texture2 = loadImage("trash/images/blueGrass.jpg");
  texture3 = loadImage("trash/images/lava.jpg");
  
  vignette = loadImage("Images/Effects/black.png");
  waterEffect = loadImage("Images/Effects/water.png");
}

void loadShaders() {
  oldNoise = loadShader("Shaders/oldNoise.glsl");
  water = loadShader("Shaders/water.glsl");
  blur = loadShader("Shaders/blur.glsl");
  blur2 = loadShader("Shaders/blur2.glsl");
  discoloration = loadShader("Shaders/discoloration.glsl");
  space = loadShader("Shaders/space.glsl");
  waterBG = loadShader("Shaders/waterBG.glsl");
  nebula = loadShader("Shaders/nebula.glsl");
  rays = loadShader("Shaders/rays.glsl");
  waveStars = loadShader("Shaders/waveStars.glsl");
  textureShader = loadShader("Shaders/textureShader/textureShader.glsl");
  lightMapShader = loadShader("Shaders/lightMap.glsl");
}

void loadEntityImages() {
  fish = new Image(loadImage("Images/Entity/Fish/fish1.png"));
  demonPart = new Image(loadImage("Images/Entity/Demon/demonPart.png"));
  moonFish = new Image(loadImage("Images/Entity/Fish/moonFish.png"));
  seaLump = new Image(loadImage("Images/Entity/Fish/seaLump.png"));
  jellyfish = new Image(loadImage("Images/Entity/Fish/jellyfish.png"));
  jellyfish1 = new Image(loadImage("Images/Entity/Fish/jellyfish1.png"));
  demon2Part1 = new Image(loadImage("Images/Entity/Demon/demon2_1.png"));
  demon2Part2 = new Image(loadImage("Images/Entity/Demon/demon2_2.png"));
}

void loadStructureImages() {
  coralImage1 = loadImage("Images/Structure/coralImage1.png");
  coralFlowerImage1 = loadImage("Images/Structure/coralFlowerImage1.png");
  coralFlowerImage1_1 = loadImage("Images/Structure/coralFlowerImage1_1.png");
  plantLamp = loadImage("Images/Structure/plantLamp.png");
  picka = loadImage("Images/Structure/picka.png");

  grassBg1 = loadImage("Images/Structure/grassBg1.png");
  backStructure1 = loadImage("Images/Structure/backStructure1.png");

  grass = loadImage("Trash/Images/grass0.png");
  
  treeList = loadImage("Images/Structure/treeList.png");
  tree1 = treeList.get(0, 0, 1000, 1000);
  tree2 = treeList.get(1000, 0, 1000, 1000);
  tree3 = treeList.get(2000, 0, 1000, 1000);

  blackList = loadImage("Images/Structure/blackSmokersList.png");
  black1 = blackList.get(0, 0, 300, 300);
  black2 = blackList.get(300, 0, 300, 300);
  black3 = blackList.get(0, 300, 300, 300);
  black4 = blackList.get(300, 300, 300, 300);

  circleGlow = loadImage("Trash/Images/lp.png");

  lightSaber = new Image(loadImage("Images/Items/lightSaber.png"));
  item1 = new Image(loadImage("Images/Items/item1.png"));
  item2 = new Image(loadImage("Images/Items/item2.png"));
  item3 = new Image(loadImage("Images/Items/item3.png"));
  item4 = new Image(loadImage("Images/Items/item4.png"));
  item5 = new Image(loadImage("Images/Items/item5.png"));

  // Загрузка в список itemsImages
  itemsImages.put("bob", fish);
  itemsImages.put("lightSaber", lightSaber);
  itemsImages.put("item1", item1);
  itemsImages.put("item2", item2);
  itemsImages.put("item3", item3);
  itemsImages.put("item4", item4);
  itemsImages.put("item5", item5);
}

ArrayList<structure> loadStructureData(String filename) {
  ArrayList<structure> structures = new ArrayList<structure>();
  JSONArray jsonArray = loadJSONArray(filename);
  if (jsonArray != null) {
    for (int i = 0; i < jsonArray.size(); i++) {
      JSONObject jsonStructure = jsonArray.getJSONObject(i);
      float PX = jsonStructure.getFloat("PX");
      float PY = jsonStructure.getFloat("PY");
      float rotate = jsonStructure.getFloat("rotate");
      float sizeX = jsonStructure.getFloat("sizeX");
      float sizeY = jsonStructure.getFloat("sizeY");

      structure s = null;

      if (jsonStructure.getString("type").equals("null") == false) {
        if (jsonStructure.getString("type").equals("coral")) {
          s = new coral(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("coralFlower")) {
          s = new coralFlower(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("coralFlower1")) {
          s = new coralFlower1(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("grassBg1")) {
          s = new grassBg1(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("picka")) {
          s = new picka(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("plantLamp")) {
          s = new plantLamp(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("tree1")) {
          s = new tree1(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("tree2")) {
          s = new tree2(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("tree3")) {
          s = new tree3(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        } else if (jsonStructure.getString("type").equals("blackSmokers")) {
          s = new blackSmokers(AposX(PX), AposY(PY), sizeX, sizeY, 0);
          ((blackSmokers)s).type = (int)rotate;
        }
      }
      structures.add(s);
    }
  }
  println("S", structures.size());
  return structures;
}
ArrayList<structure> loadBackStructureData(String filename) {
  ArrayList<structure> structures = new ArrayList<structure>();
  JSONArray jsonArray = loadJSONArray(filename);
  if (jsonArray != null) {
    for (int i = 0; i < jsonArray.size(); i++) {
      JSONObject jsonStructure = jsonArray.getJSONObject(i);
      float PX = jsonStructure.getFloat("PX");
      float PY = jsonStructure.getFloat("PY");
      float rotate = jsonStructure.getFloat("rotate");
      float sizeX = jsonStructure.getFloat("sizeX");
      float sizeY = jsonStructure.getFloat("sizeY");

      structure s = null;

      if (jsonStructure.getString("type").equals("null") == false) {
        if (jsonStructure.getString("type").equals("detailPart")) {
          s = new detailPart(AposX(PX), AposY(PY), sizeX, sizeY, rotate);
        }
      }

      if (sizeX > 0.6) {
        structures.add(s);
      }
    }
  }
  println("S", structures.size());
  return structures;
}


// строчка номер 5000 
