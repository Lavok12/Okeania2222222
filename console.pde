import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import javax.tools.JavaCompiler;
import javax.tools.StandardJavaFileManager;
import javax.tools.ToolProvider;
import javax.tools.JavaFileObject;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Arrays;


public static void runCodeAndPrintOutput(String code, PApplet parent) {
  try {
    // Создание временной директории и файла
    Path tempDir = Files.createTempDirectory("javacode");
    Path sourceFilePath = tempDir.resolve("TempCode.java");
    Files.write(sourceFilePath, code.getBytes());

    File sourceFile = sourceFilePath.toFile();

    // Компиляция временного файла
    JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
    StandardJavaFileManager fileManager = compiler.getStandardFileManager(null, null, null);
    Iterable<? extends JavaFileObject> compilationUnits = fileManager.getJavaFileObjects(sourceFile);
    boolean compilationSuccess = compiler.getTask(null, fileManager, null, Arrays.asList("-d", tempDir.toString()), null, compilationUnits).call();
    fileManager.close();

    if (!compilationSuccess) {
      System.err.println("Compilation failed.");
      return;
    }

    // Загрузка скомпилированного класса и вызов методов
    URLClassLoader classLoader = URLClassLoader.newInstance(new URL[]{ tempDir.toUri().toURL() });
    Class<?> compiledClass = Class.forName("tempcode.TempCode", true, classLoader);
    Object instance = compiledClass.getDeclaredConstructor(PApplet.class).newInstance(parent);

    Method setupMethod = compiledClass.getMethod("setup");
    setupMethod.invoke(instance);

    // Удаление временной директории и файлов
    deleteRecursively(tempDir.toFile());
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

// Утилитный метод для удаления временной директории и всех файлов в ней
private static void deleteRecursively(File file) throws IOException {
  if (file.isDirectory()) {
    for (File subFile : file.listFiles()) {
      deleteRecursively(subFile);
    }
  }
  Files.delete(file.toPath());
}

void consoleCompiled(String c) {
  String code = "package tempcode;\n" +
    "import processing.core.PApplet;\n" +
    "public class TempCode {\n" +
    "  PApplet parent;\n" +
    "  public TempCode(PApplet parent) {\n" +
    "    this.parent = parent;\n" +
    "  }\n" +
    "  public void setup() { try {\n" +
    c +
    "  } catch (Exception e) {e.printStackTrace(); }}\n" +
    "}";


  try {
    runCodeAndPrintOutput(code, this);
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

public Console Console = new Console();

class Console {
  String consoleText = "";
  StringList terminal = new StringList();
  boolean enter = false;

  void handleKeyPressed(char key, int keyCode) {
    if (keyCode == 10) {
      //enter = true;
      addLineToTerminal(consoleText);
      consoleText = "";
    } else if (keyCode == 8) {
      if (consoleText.length() > 0) {
        consoleText = consoleText.substring(0, consoleText.length()-1);
      }
    } else if (keyCode != 16 && keyCode != 17 && keyCode != 18 && keyCode != 157) {
      consoleText += key;
    }
  }

  void addToTerminal(String text) {
    String[] parts = text.split("\\\n");
    int c = 0;
    for (String part : parts) {
      if (c > 0) {
        terminal.append(part);
      } else {
        String t;
        if (terminal.size() > 0) {
          t = terminal.get(terminal.size() - 1);
          terminal.remove(terminal.size() - 1);
        } else {
          t = "";
        }
        terminal.append(t + part);
      }
      c++;
    }
  }

  void addLineToTerminalS(String text) {
    String[] parts = text.split("\\\n");
    for (String part : parts) {
      terminal.append(part);
    }
  }
  void addLineToTerminal(String text) {
    addLineToTerminalS(text);
    consoleCompiled(text);
  }

  void display() {
    int smesh = 0;
    fill(255);
    textSize(18);
    for (int i = max(0, terminal.size() - 36); i < terminal.size(); i++) {
      text(terminal.get(i), 8, smesh + 18);
      smesh += 20;
    }
    if (consoleText.length() == 0) {
      if (millis() % 1000 < 500) {
        text("...", 8, smesh + 18);
      }
    } else {
      if (millis() % 1000 < 500) {
        text(consoleText, 8, smesh + 18);
      } else {
        text(consoleText + "...", 8, smesh + 18);
      }
    }
  }

  String getConsoleText() {
    return consoleText;
  }

  void clearConsoleText() {
    consoleText = "";
  }
}

void console() {
}

void compilation(String text) {
  String[] parts = text.split(" ");
  if (parts[0].equals("createEntity")) {
    try {
      /*float x = parseCoordinate(parts[2], player.PX);
       float y = parseCoordinate(parts[3], player.PY);*/      float x = 0, y = 0;

      if (parts[1].equals("player")) {
        entity.add(new player(x, y));
      } else if (parts[1].equals("fish")) {
        entity.add(new fish(x, y));
      } else {
        Console.addLineToTerminalS("Entity non found");
      }

      entity_o();
    }
    catch (Exception e) {
      Console.addLineToTerminalS("invalid command");
      e.printStackTrace();
    }
  } else {
    Console.addLineToTerminalS("invalid command");
  }
}

private float parseCoordinate(String coord, float playerPY) {
  if (coord.charAt(0) == '~') {
    String c = coord.substring(1);
    return Float.parseFloat(c) + playerPY;
  } else {
    return Float.parseFloat(coord);
  }
}
