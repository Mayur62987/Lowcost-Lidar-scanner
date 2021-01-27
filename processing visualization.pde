import processing.serial.*;

Serial scanserial;
int serialPortNumber = 0;
float angle = 6.5f;
float angleIncrement = 0;
float xOffset = 3.0;
float xOffsetIncrement = 0;
float yOffset = 152.0f;
float yOffsetIncrement = 0;
float scale = 2.6f;
float scaleIncrement = 0;
ArrayList<PVector> vectors;
int LPI = 0;
int LPC = 0;
PrintWriter output;


void setup() {
  size(1000, 1000, P3D); //size of 3d plot created
  colorMode(RGB, 255, 255, 255); //
  noSmooth();
  vectors = new ArrayList<PVector>();
  String[] serialPorts = Serial.list(); //check for available serial ports 
  String serialPort = serialPorts[serialPortNumber];
  println("Using serial port \"" + serialPort + "\"");
  println("To use a different serial port, change serialPortNumber:");
  printArray(serialPorts);
  scanserial = new Serial(this, serialPort, 115200); //baudrate used by the arduino program
  output = createWriter("pos.txt");
}

void draw() {
  String input = scanserial.readStringUntil(10);
  if (input != null) {
    String[] components = split(input, ' ');
    if (components.length == 3) {
      vectors.add(new PVector(float(components[0]), float(components[1]), float(components[2])));
      output.println((float(components[0]) + " " + float(components[1]) + " " + float(components[2])));
    }
  }
  background(255);
  translate(width/2, height/2, -50);
  rotateY(angle);
  int size = vectors.size();
  for (int index = 0; index < size; index++) {
    PVector v = vectors.get(index);
    if (index == size - 1) {
      // draw red line to show recently added LIDAR scan point
      if (index == LPI) {
        LPC++;
      } else {
        LPI = index;
        LPC = 0;
      }
      if (LPC < 10) {
        stroke(0, 255, 0);
        line(xOffset, yOffset, 0, v.x * scale + xOffset, -v.z * scale + yOffset, -v.y * scale);
      }
    }
    stroke(0, 0, 0);
    point(v.x * scale + xOffset, -v.z * scale + yOffset, -v.y * scale);
  }
  angle += angleIncrement;
  xOffset += xOffsetIncrement;
  yOffset += yOffsetIncrement;
  scale += scaleIncrement;
}

void keyPressed() {
  if (key == 'q') {
    // zoom in
    scaleIncrement = 0.02f;
  } else if (key == 'z') {
    // zoom out
    scaleIncrement = -0.02f;
  } else if (key == 'a') {
    // move left
    xOffsetIncrement = -1f;
  } else if (key == 'd') {
    // move right
    xOffsetIncrement = 1f;
  } else if (key == 'w') {
    // move up
    yOffsetIncrement = -1f;
  } else if (key == 's') {
    // move down
    yOffsetIncrement = 1f;
  } else if (key =='c') {
    // erase all points
    vectors.clear();
  }
  else if (key == 'm'){
   output.flush();
   output.close();
  } else if (key == CODED) {
    if (keyCode == LEFT) {
      // rotate left
      angleIncrement = -0.015f;
    } else if (keyCode == RIGHT) {
      // rotate right
      angleIncrement = 0.015f;
    }
  }
}

void keyReleased() {
  if (key == 'q') {
    scaleIncrement = 0f;
  } else if (key == 'z') {
    scaleIncrement = 0f;
  } else if (key == 'a') {
    xOffsetIncrement = 0f;
  } else if (key == 'd') {
    xOffsetIncrement = 0f;
  } else if (key == 'w') {
    yOffsetIncrement = 0f;
  } else if (key == 's') {
    yOffsetIncrement = 0f;
  } else if (key == CODED) {
    if (keyCode == LEFT) {
      angleIncrement = 0f;
    } else if (keyCode == RIGHT) {
      angleIncrement = 0f;
    }
  }
