gameHost gameHost = new gameHost();
user user = new user();

boolean online = !true;
boolean host = !true;
String ip = "26.40.83.250";
int port = 12345;
//String name = "bobik" + int(random(0, Integer.MAX_VALUE));
String name = "Lavok";

ArrayList<player> playersServerList = new ArrayList<player>();

void onlineStart() {
  player.userName = name;
}
class user {
  Client client;
  String token = "localToken" + int(random(0, Integer.MAX_VALUE));
  boolean connect = false;
  String name = "bobik" + int(random(0, Integer.MAX_VALUE));

  user() {
  }

  void addEntity(String name, float posX, float posY) {
    client.write("add"+","+token + "," + name + "," + posX + "," + posY + "$");
  }
  void addEntity(String name, float posX, float posY, String item) {
    client.write("add"+","+token + "," + name + "," + posX + "," + posY + "," + item + "$");
  }
  boolean connect() {
    try {
      client = new Client(papplet, ip, port);
      if (client.active()) {
        client.write("upd"+","+token + "," + name + "," + System.currentTimeMillis() + "$");
        println("Connected to server");
        connect = true;
        return true;
      } else {
        connect = false;
        println("Failed to connect to server");
        return false;
      }
    }
    catch (Exception e) {
      println("Failed to connect to server. Error: " + e.getMessage());
      connect = false;
      return false;
    }
  }

  void update() {
    try {
      if (client != null && client.active()) {
        String message = client.readString();
        if (message != null) {
          updateClient(splitTokens(message, "$")[0]);

          client.write("upd"+","
            +token+","
            +System.currentTimeMillis()+","
            +player.PX+","
            +player.PY+","
            +player.SX+","
            +player.SX+","
            +name+","
            +zoom
            +"$");
        }
      } else {
        println("Client not connected, cannot send update.");
        connect = false;
      }
    }
    catch (Exception e) {
    }
  }
}


class gameHost {
  Server server;
  ArrayList<ClientInfo> clients = new ArrayList<ClientInfo>();
  int thisPort = port;
  boolean active = false;

  gameHost() {
  }

  void create() {
    try {
      server = new Server(papplet, port);
      println("Server started on port " + thisPort);
      active = true;
    }
    catch (Exception e) {
      e.printStackTrace();
      println("Server error \nPort: " + thisPort);
      active = false;
    }
  }

  void update() {
    try {
      Client client;
    wl:
      while ((client = server.available()) != null) {
        String message = client.readString();
        if (message != null) {
          println("?" + message);
          String[] answers = splitTokens(message, "$");
          for (int i = 0; i < answers.length; i++) {
            String[] ms = splitTokens(answers[i], ",");

            if (ms[0].equals("upd")) {
              for (ClientInfo c : clients) {
                if (c.token.equals(ms[1])) {
                  c.lastUpdate = millis();

                  c.userPlayer.PX = float(ms[3]);
                  c.userPlayer.PY = float(ms[4]);
                  c.userPlayer.SX = float(ms[5]);
                  c.userPlayer.SY = float(ms[6]);
                  c.userPlayer.userName = ms[7];
                  c.zoom = float(ms[8]);

                  break wl;
                }
              }
              println("Client connected: " + client.ip());
              clients.add(new ClientInfo(ms[1], "", client));
              clients.get(clients.size() - 1).lastUpdate = millis();
              clients.get(clients.size() - 1).userPlayer = new player(0, 10000);
            } else if (ms[0].equals("add")) {
              if (ms[2].equals("demon")) {
                entity.add(new demon(float(ms[3]), float(ms[4])));
                entity_o();
              } else if (ms[2].equals("moonFish")) {
                entity.add(new moonFish(float(ms[3]), float(ms[4])));
                entity_o();
              } else if (ms[2].equals("fish")) {
                entity.add(new fish(float(ms[3]), float(ms[4])));
                entity_o();
              } else if (ms[2].equals("barrel")) {
                entity.add(new barrel(float(ms[3]), float(ms[4])));
                entity_o();
              } else if (ms[2].equals("seaLump")) {
                entity.add(new seaLump(float(ms[3]), float(ms[4])));
                entity_o();
              } else if (ms[2].equals("item")) {
                user.addEntity("item", float(ms[3]), float(ms[4]), ms[5]);
                entity_o();
              }
            }
          }
        }
      }

      clients.removeIf(clientInfo -> clientInfo.lastUpdate+5000 < millis());
    }
    catch (Exception e) {
      println("ошибка");
    }
    String str = "";
    str += "_GlobalTime"+","+_GlobalTime+"#";
    str += "player"+","+player.PX+","+player.PY+","+player.SX+","+player.SY+","+name+","+"host";
    str += "#";
    for (gameHost.ClientInfo d : gameHost.clients) {
      str += "player"+","+d.userPlayer.PX+","+d.userPlayer.PY+","+d.userPlayer.SX+","+d.userPlayer.SY+","+d.userPlayer.userName+","+d.token;
      str += "#";
    }
    for (entity e : entity_o) {
      if (e == player) {
        continue;
      }
      str += "entity";
      str += ",";
      str += e.PX;
      str += ",";
      str += e.PY;
      str += ",";
      str += e.SX;
      str += ",";
      str += e.SY;
      str += ",";
      str += e.size;
      str += ",";
      str += e.rotate;
      str += ",";
      str += e.COLOR_R;
      str += ",";
      str += e.COLOR_G;
      str += ",";
      str += e.COLOR_B;
      str += ",";
      str += e.COLOR_T;
      str += ",";
      if (e instanceof itemEntity) {
        str += "item";
        str += ",";
        str += ((itemEntity)e).i.tag;
      } else if (e instanceof moonFish) {
        str += "moonFish";
      } else if (e instanceof fish) {
        str += "fish";
      } else if (e instanceof demon) {
        str += "demon";
      } else if (e instanceof barrel) {
        str += "barrel";
      } else if (e instanceof seaLump) {
        str += "seaLump";
      } else {
        str += "none";
      }
      str += "#";
    }
    for (ClientInfo c : clients) {
      c.client.write(str);
      println(str);
    }
  }

  void info() {
    textSize(20);
    if (active) {
      int c = 0;
      String text = "active";
      fill(0);
      rect(10, 10 + c, textWidth(text) + 10, 25);
      fill(255);
      textAlign(1, 0);
      text(text, 15, 28 + c);

      for (ClientInfo i : clients) {
        c += 30;

        text = i.token + "@" + i.lastUpdate;
        fill(0);
        rect(10, 10 + c, textWidth(text) + 10, 25);
        fill(255);
        textAlign(1, 0);
        text(text, 15, 28 + c);
      }
    } else {
      String text = "inactive";
      fill(0);
      rect(10, 10, textWidth(text) + 10, 25);
      fill(255);
      textAlign(1, 0);
      text(text, 15, 28);
    }
  }

  class ClientInfo {
    float zoom = 0;
    String token = "";
    boolean connected = true;
    int lastUpdate = -1;
    Client client;
    player userPlayer = null;

    ClientInfo(String token, String name, Client client) {
      this.token = token;
      this.lastUpdate = millis();
      this.client = client;
    }
  }
}

void updateClient(String message) {
  try {
    playersServerList.clear();
    entity.clear();
    entity.add(player);

    String pls[] = splitTokens(message, "#");
    for (int i = 0; i < pls.length; i++) {
      String pls2[] = splitTokens(pls[i], ",");
      if (pls2[0].equals("player")) {
        if (!user.token.equals(pls2[6])) {
          playersServerList.add(new player(float(pls2[1]), float(pls2[2])));
          playersServerList.get(playersServerList.size()-1).SX = float(pls2[3]);
          playersServerList.get(playersServerList.size()-1).SX = float(pls2[4]);
          playersServerList.get(playersServerList.size()-1).userName = pls2[5];
        }
      } else if (pls2[0].equals("_GlobalTime")) {
        _GlobalTime = float(pls2[1]);
      } else if (pls2[0].equals("entity")) {
        entity h = null;
        printArray(pls2);
        if (pls2[11].equals("item")) {
          entity.add(new itemEntity(float(pls2[1]), float(pls2[2]), returnItem(pls2[12])));
        } else if (pls2[11].equals("moonFish")) {
          entity.add(h = new moonFish(float(pls2[1]), float(pls2[2])));
        } else if (pls2[11].equals("seaLump")) {
          entity.add(h = new seaLump(float(pls2[1]), float(pls2[2])));
        } else if (pls2[11].equals("fish")) {
          entity.add(h = new fish(float(pls2[1]), float(pls2[2])));
        } else if (pls2[11].equals("demon")) {
          entity.add(h = new demon(float(pls2[1]), float(pls2[2])));
        } else if (pls2[11].equals("barrel")) {
          entity.add(h = new barrel(float(pls2[1]), float(pls2[2])));
        } else {
        }
        if (h != null) {
          entity.get(entity.size()-1).SX = float(pls2[3]);
          entity.get(entity.size()-1).SY = float(pls2[4]);
          entity.get(entity.size()-1).size = float(pls2[5]);
          entity.get(entity.size()-1).rotate = float(pls2[6]);
          entity.get(entity.size()-1).COLOR_R = float(pls2[7]);
          entity.get(entity.size()-1).COLOR_G = float(pls2[8]);
          entity.get(entity.size()-1).COLOR_B = float(pls2[9]);
          entity.get(entity.size()-1).COLOR_T = float(pls2[10]);
          entity_o();
        }
      }
    }
  }
  catch (Exception e) {
    println(e.getMessage());
  }
}

item returnItem(String name) {
  if (name.equals("bob")) {
    return new bob();
  }
  return null;
}
