import processing.opengl.*;
//color[] pallete = {#f64231, #f64231, #a8c8b9, #f64231, #a8c8b9};
//color[] pallete = {#f64231,#f64231, #a8c8b9,#f64231, #a8c8b9,#efe7d5};
color[] pallete = {#f64231,#f64231, #a8c8b9,#f64231, #a8c8b9};
int sw = 8;
int snow_num = 30;

float[] snowX = new float[snow_num];
float[] snowY = new float[snow_num];
float[] snowXS = new float[snow_num];
float[] snowYS = new float[snow_num];
float[] snowS = new float[snow_num];

int duration = 20;
int imgNum = 11;
PImage[] imgs = new PImage[imgNum];

void setup() {
  //size(640, 360, OPENGL);
  //size(1280, 720, OPENGL);
  fullScreen(OPENGL);
  noCursor();
  strokeCap(ROUND);
  colorMode(HSB, 360, 100, 100, 100);
  rectMode(CENTER);
  frameRate(1);
  
  for (int i = 0; i < imgNum; i++) {
    imgs[i] = loadImage("img" + i+".png");
  }
  

}

int seed = 0;
void draw() {
  //seed = int(frameCount/duration);
  //randomSeed(seed);
  //randomSeed(int(frameCount / 8 / (height / 9) / 4));
  
  if(frameCount % duration == 0){
    drawCells();
  }

  
  // background(200);  
  //print(mouseX);
}

void mouseClicked(){
  seed ++;
}


void setupSnow() {
  for (int i = 0; i < snow_num; i++) {
    snowX[i] = random(width);
    snowY[i] = random(height);
    snowS[i] = random(8) + 4;
    snowXS[i] = -random(2);
    snowYS[i] = random(2) + 0.8;
  }
}

void drawSnow() {
  noStroke();
  fill(#efe7d5);
  for (int i = 0; i < snow_num; i++) {
    randomSeed(frameCount *i);
    snowX[i] += snowXS[i];
    snowY[i] += snowYS[i];
    circle(snowX[i], snowY[i], snowS[i]);
    
    if (snowY[i] > height+20 ) {
      snowX[i] = random(width);
      snowY[i] = -20;      
      snowXS[i] = -random(2);
      snowYS[i] = random(2) + 0.2;
      snowS[i] = random(8) + 4;
    }
    
    if (snowX[i] < -snowS[i] ) {
      snowX[i] = width + 20;
    }
    
  }
}


void drawCells() {

  //int step_num = 16;
  translate(0,-height/9);
  int step_num = 16;
  float step = width / step_num;

  boolean[][] cells = new boolean[step_num][step_num];
  for (int j = 0; j < step_num; j++) {
    for (int i = 0; i < step_num; i++) {
      cells[j][i] = false;
    }
  }
  for (int j = 0; j < step_num; j++) {
    for (int i = 0; i < step_num; i++) {
      int cellSizeMax = int(random(1, step_num / 2));
      for (int cellSize = cellSizeMax; cellSize > 0; cellSize--) {
        boolean isAlready = false;
        for (int l = j; l < j + cellSize; l++) {
          for (int k = i; k < i + cellSize; k++) {
            int l_ = constrain(l, 0, step_num - 1);
            int k_ = constrain(k, 0, step_num - 1);
            if (cells[l_][k_] == true) {
              isAlready = true;
            }
          }
        }
        if (isAlready == false) {
          float wc = step * cellSize;
          float hc = step * cellSize;
          float x = step * i;
          float y = step * j;
          if (x + wc > width) {
            wc = width - x;
          }
          if (y + hc > width) {
            hc = width - y;
          }
          int n = int(random(1000) + i + j * step_num) % pallete.length;
          fill(pallete[n]);
          stroke(#efe7d5);
          //stroke(#000000);
          strokeWeight(sw);

          pushMatrix();
          translate(x + wc / 2, y + hc / 2);
          rect(0, 0, wc, hc);
          
          
          int cn = int(random(1000) + i + j * step_num);
          //if(cn % 4 == 0){
          //  snow();
          //}else if(cn % 4 == 1){
          //  star(0, 0, 18); 
          //}else if(cn % 4 == 2){
          //  circle(0,0,20);
          //}else if(cn % 4 == 3){
          //}
          //fill(#ffffff);
          //rect(0,0,cellSize*4,cellSize*4);
          //text(cellSize,0,0);
          
          if(cellSize > 1){
            image(imgs[cn%imgNum], -60, -60);
          }else{

          }
          
          

          popMatrix();

          
          for (int l = j; l < j + cellSize; l++) {
            for (int k = i; k < i + cellSize; k++) {
              int l_ = constrain(l, 0, step_num - 1);
              int k_ = constrain(k, 0, step_num - 1);
              cells[l_][k_] = true;
            }
          }
        }
      }
    }
  }
}






void star(float x, float y, float radius) {
  float angle = TWO_PI / 5;
  float halfAngle = angle/2.0;
  stroke(#efe7d5);
  rotate(radians(55));
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius/2;
    sy = y + sin(a+halfAngle) * radius/2;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void snow(){
  strokeWeight(4);
  line(-10, 0, 10, 0);
  rotate(radians(60));
  line(-10, 0, 10, 0);
  rotate(radians(60));
  line(-10, 0, 10, 0);
}
