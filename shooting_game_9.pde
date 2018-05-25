int SIZE_X = 600;
int SIZE_Y = 700;
color BLACK;
color LIGHTGRAY;
color DARKGRAY;
color RED;
color GREEN;
color BLUE;
color CYAN;
color YELLOW;
color WHITE;

boolean GAME_OVER = false;
boolean PRINT_GAME_OVER = true;
boolean TIME_CNT = false;
int NUMBER_OF_BALLS = 30;
int NUMBER_OF_BULLETS = 30;
int KINDS_OF_ITEMS = 3;
int SCORE = 0;
float MAX_CNT = 1800;
float ITEM_DROP_PER = 4;
int item_effect = 0;
int cnt = 0;

// ---------- class Balls ----------
class Balls {
  float x;
  float y;
  float dx;
  float dy;
  float efficacy_2;
  float r;
  int score = 10;
  boolean isRunning;
  boolean effected_2;
  float colorTimer;
  float colorTimerMax;

  // ---- constructor ----
  Balls() {
    r = 20;
    efficacy_2 = 2.5;
    isRunning = false;
    effected_2 = false;
    colorTimerMax = random(30, 120);
  }

  // ---- method setIsRunning ----
  void setIsRunning() {
    x = random(r, SIZE_X - r);
    y = -r;
    dx = random(-3, 3);
    dy = random(2, 4);
    isRunning = true;
    effected_2 = false;
    colorTimer = 0;
  }

  // ---- method resetIsRunning ----
  void resetIsRunning() {
    isRunning = false;
    y = -r;
  }
  
  void effect_2(){
    dx /= efficacy_2;
    dy /= efficacy_2;
    effected_2 = true;
    println("ball's dx / efficacy");
  }

  // ---- method move ----
  void move() {
    x = x + dx;
    if (x < r) {
      x = r;
      dx = -dx;
    }
    else if (SIZE_X < x + r) {
      x = SIZE_X - r;
      dx = -dx;  
    }

    y = y + dy;
    if (SIZE_Y + r < y) {
      resetIsRunning();
    }
  }

  // ---- method draw ----
  void draw() {
    fill(LIGHTGRAY);
    ellipse(x, y, r, r);
    fill(DARKGRAY);
    ellipse(x, y, r - 8, r - 8);
    
    if(colorTimer < (colorTimerMax / 2))
      fill(RED);
    else
      fill(BLUE);
    ellipse(x, y, 3, 3);
    if (colorTimerMax <= colorTimer)
      colorTimer = 0;
    else
      colorTimer++;
  }
}

// declearing the array of the class Balls
// but the constructor is not called here
Balls[] ball = new Balls[NUMBER_OF_BALLS];  

class Bullets{
  float r;
  float x;
  float dx;
  float y;
  float dy;
  float speed;
  float efficacy_1;
  float efficacy_2;
  boolean isShooting;
  boolean effected_2;
  
  Bullets(){
    r = 2;
    efficacy_1 = 0.05;
    efficacy_2 = 2.5;
    isShooting = false;
    effected_2 = false;
  }
  
  void setIsShooting(int i){
    x = ball[i].x;
    y = ball[i].y + ball[i].r;
    speed = random(4.5, 5.5);
    dx = cos(atan2(y - penta.y, penta.x - x)) * speed;
    dy = -sin(atan2(y - penta.y, penta.x - x)) * speed;
    isShooting = true;
  }
  
  void resetIsShooting(){
    y = -r;
    isShooting = false;
    effected_2 = false;
  }
  
  void effect_1(){
    dx += efficacy_1;
  }
  
  void effect_2(){
    dx /= efficacy_2;
    dy /= efficacy_2;
    effected_2 = true;
    //println("bullet's dx / efficacy");
  }

  void move(){
    x += dx;
    y += dy;
    if (SIZE_Y + r < y) {
      resetIsShooting();
    }
  }

  void draw(){
    fill(YELLOW);
    ellipse(x, y, r, r);
  }
}

// declearing the array of the class Bullets
// but the constructor is not called here
Bullets[] bullet = new Bullets[NUMBER_OF_BULLETS];

class Items{
  float i_width;
  float i_height;
  float x;
  float dx;
  float y;
  float dy;
  int kind;
  boolean isDropping;
  
  Items(){
    i_width = 18;
    i_height = 18;
    dx = 0;
    x = -100;
    y = 0;
    isDropping = false;
  }
  
  void setIsDropping(int i){
    x = ball[i].x;
    y = ball[i].y + 10;
    dy = random(2, 3);
    kind = int(random(0, KINDS_OF_ITEMS));
    isDropping = true;
  }
  
  void resetIsDropping(){
    y = -100;
    isDropping = false;
  }
  
  void effect(){
    if(kind == 0){
      penta.life++;
      //println("penta's life++");
    }
    else if (kind == 1){
      item_effect = 1; //effect bullet
    }
    else{
      item_effect = 2; //penta's wall is made
      //println("item_effect = 2");
    }
  }
  
  void move(){
    x += dx;
    y += dy;
    if (SIZE_Y + i_height / 2 < y){
      resetIsDropping();
    }
  }
  
  void draw(){
    if(kind == 0) //effect: recover life
      fill(BLUE);
    else if(kind == 1) //effect: bullets
      fill(YELLOW);
    else
      fill(GREEN); //effect: penta wall
    rectMode(CENTER);
    rect(x, y, i_width, i_height);
  }
}

// declearing the array of the class Items
// but the constructor is not called here
Items[] item = new Items[NUMBER_OF_BALLS];

// ---------- class Airplane ----------
class Airplane {
  float x;
  float y;
  float dx;
  float wall_range;
  int r;
  int w;
  int life;
  boolean toRight;
  boolean toLeft;

  // ---- constructor ----
  Airplane() {
    x = 300;
    y = 680;
    dx = 4;
    wall_range = 200;
    r = 15;
    w = 20;
    life = 0;
    toRight = false;
    toLeft = false;
  }

  // ---- method setToRight ----
  void setToRight() {
    toRight = true;
    toLeft = false;
  }

  // ---- method setToLeft ----
  void setToLeft() {
    toRight = false;
    toLeft = true;
  }

  // ---- method resetToRight ----
  void resetToRight() {
    toRight = false;
  }

  // ---- method resetToLeft ----
  void resetToLeft() {
    toLeft = false;
  }

  // ---- method move ----
  void move() {
    if (toRight) {
      x = x + dx;
      if (SIZE_X - w <= x) {
        x = SIZE_X - w;
      }
    }
    else if (toLeft) {
      x = x - dx;
      if (x <= w) {
        x = w;
      }
    }
  }

  // ---- method draw ----
  void draw() {
    fill(LIGHTGRAY);
    noStroke();
    beginShape();
      vertex(x, y - 18);
      vertex(x - 15, y - 7);
      vertex(x - w, y + 15);
      vertex(x + w, y + 15);
      vertex(x + 15, y - 7);
    endShape(CLOSE);
    fill (GREEN);
    ellipse(x, y, r, r);
  }
  
  void draw_effect(){
    noFill();
    strokeWeight(5);
    stroke(GREEN);
    ellipse(penta.x, penta.y, penta.wall_range, penta.wall_range);
  }
}

Airplane penta = new Airplane();  // the constructor is called

// ---------- class Missile ----------
class Missile {
  float x;  float dy;
  int r;
  boolean isRunning;

  // ---- constructor ----
  Missile() {
    dy = 20;
    r = 22;
    isRunning = false;
  }

  // ---- method setIsRunning ----
  void setIsRunning() {
    x = penta.x;
    y = penta.y - 10;
    isRunning = true;
  }

  // ---- method resetIsRunning ----
  void resetIsRunning() {
    isRunning = false;
    y = -600;
  }

  // ---- method move ----
  void move() {
    if(isRunning)
      y = y - dy;
    if(y < - 5)
      resetIsRunning();
  }

  // ---- method draw ----
  void draw() {
    fill(CYAN);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 1, 1);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 1, 1);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 1, 1);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 1, 1);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 1, 1);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 1, 1);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 2, 2);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 2, 2);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 2, 2);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 2, 2);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 2, 2);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 3, 3);
    ellipse(random(x - 25, x + 25), random(y - 20, y + 20), 3, 3);
  }
}

Missile missile = new Missile();  // the constructor is called

class Gages{
  float max_length;
  float g_length;
  float g_width;
  float x_space;
  float y_space;
  
  Gages(){
    max_length = SIZE_X / 3;
    g_length = max_length;
    g_width = SIZE_Y / 50;
    x_space = 10;
    y_space = 20;
  }
  
  void cul(){
    g_length = max_length * ((MAX_CNT - cnt) / MAX_CNT);
  }
  
  void draw(){
    textSize(30);
    fill(WHITE);
    textAlign(LEFT, LEFT);
    text("SPARE LIFE: " + penta.life, 10, 35);
    
    if(item_effect!= 0){ 
      rectMode(CORNERS);
      noFill();
      if(item_effect == 1){
        stroke(YELLOW);
      }
      else{
        stroke(GREEN);
      }
      strokeWeight(1);
      rect((SIZE_X - max_length) - x_space, y_space, SIZE_X - x_space, g_width + y_space); 
      rectMode(CORNERS);
      if(item_effect == 1){
        fill(YELLOW);
      }
      else{
        fill(GREEN);
      }
      noStroke();
      rect((SIZE_X - g_length) - x_space, y_space, SIZE_X - x_space, g_width + y_space);
    }
  }
  
  void gameover(){
    textSize(60);
    fill(WHITE);
    textAlign(CENTER, CENTER);
    text("Game over!!", SIZE_X / 2, SIZE_Y / 2);
    textSize(25);
    textAlign(RIGHT, RIGHT);
    text("Score: " + SCORE, SIZE_X - 70, SIZE_Y - 110);
    text("Press R to restart.",SIZE_X - 70, SIZE_Y - 70);
  }
}

 // the constructor is called
Gages gage = new Gages();

// ---------- method settings ----------
void settings(){
  size(SIZE_X, SIZE_Y);
  noSmooth();
}

// ---------- method setup ----------
void setup(){
  colorMode(RGB);
  BLACK = color(0, 0, 0);
  LIGHTGRAY = color(225, 225, 225);
  DARKGRAY = color(100, 100, 100);
  RED = color(255, 30, 30);
  GREEN = color(10, 130, 10);
  BLUE = color(140, 140, 255);
  CYAN = color(200, 255, 255);
  YELLOW = color(255, 241, 15);
  WHITE = color(255, 255, 255);
  background(BLACK);
  noStroke();
  frameRate(60);
  ellipseMode(RADIUS);

  for (int i = 0; i < NUMBER_OF_BALLS; i++) {
    ball[i] = new Balls();  // the constructor is called
    item[i] = new Items();
  }
  for (int i = 0; i < NUMBER_OF_BULLETS; i++) {
    bullet[i] = new Bullets();  // the constructor is called
  }
}

void initialize(){
  GAME_OVER = false;
  PRINT_GAME_OVER = true;
  TIME_CNT = false;
  item_effect = 0;
  cnt = 0;
  missile.isRunning = false;
  for (int i = 0; i < NUMBER_OF_BALLS; i++) {
    ball[i] = new Balls();  // the constructor is called
    item[i] = new Items();
  }
  for (int i = 0; i < NUMBER_OF_BULLETS; i++) {
    bullet[i] = new Bullets();  // the constructor is called
  }  
}

// ---------- method draw ----------
void draw(){
  background(BLACK);
  
  if(!GAME_OVER)
    penta.move();
    
  if(missile.isRunning){
    if(!GAME_OVER){
      missile.move();
    }
    missile.draw();
  }
  
  int i;
  
  for (i = 0; i < NUMBER_OF_BALLS; i++) {
    if (!ball[i].isRunning && !GAME_OVER){
      if (9985 < random(0, 10000)){
        ball[i].setIsRunning();
      }
    }
  
    if (ball[i].isRunning) {
      if(!GAME_OVER){
        if((item_effect == 2) && (ball[i].effected_2 == false) && dist(penta.x, penta.y, ball[i].x, ball[i].y) < penta.wall_range){
          ball[i].effect_2();
        } 
        ball[i].move();
      }
      ball[i].draw();

      if(missile.isRunning == true && dist(missile.x, missile.y, ball[i].x, ball[i].y) < (missile.r + ball[i].r)){
        if(1 > int(random(0, ITEM_DROP_PER)) && (item_effect == 0) && !item[i].isDropping){ 
          item[i].setIsDropping(i);  
        }
        ball[i].resetIsRunning();
        missile.resetIsRunning();
        SCORE = SCORE + ball[i].score;
        println("SCORE:", SCORE);
      }
      if(dist(penta.x, penta.y, ball[i].x, ball[i].y) < (penta.r + ball[i].r)){
        if(penta.life== 0){
          GAME_OVER = true;
        }       
        else{
          penta.life--;
          ball[i].resetIsRunning();
        }
      }
    }
    
    if(item[i].isDropping == true) {
      if(!GAME_OVER){
        item[i].move();
      }
      item[i].draw();    
    
      if(((penta.x + penta.r > item[i].x - item[i].i_width / 2) && (penta.x - penta.r < item[i].x + item[i].i_width / 2)) && (penta.y - penta.r < item[i].y + item[i].i_height / 2)){
        if(item_effect == 0){
          item[i].effect();
        }
        item[i].resetIsDropping();
      }   
    }
    
    if((!bullet[i].isShooting) && (ball[i].isRunning == true) && (ball[i].y <= SIZE_Y / 4)){
      if (9950 < random(0, 10000) && !GAME_OVER) {
        bullet[i].setIsShooting(i);
      }
    }    
 
    if (bullet[i].isShooting) {
      if(!GAME_OVER){
        if(item_effect == 1){
          bullet[i].effect_1();
        }
        if((item_effect == 2) && (bullet[i].effected_2 == false) && dist(penta.x, penta.y, bullet[i].x, bullet[i].y) < penta.wall_range){
          bullet[i].effect_2();
        }
        bullet[i].move();
      }
      bullet[i].draw();
    }
    
    if(dist(penta.x, penta.y, bullet[i].x, bullet[i].y) < (penta.r + bullet[i].r)){
      if(penta.life == 0){
        GAME_OVER = true;
      }
      else{           
        penta.life--;
        bullet[i].resetIsShooting();
      }
    }        
  }
  
  if(item_effect == 2){
    penta.draw_effect();
  }
  
  penta.draw();
  
  if((GAME_OVER) && (PRINT_GAME_OVER)){
    println("GAME OVER!!!");
    PRINT_GAME_OVER = false;
  }
  
  if(!(item_effect == 0) && TIME_CNT == false)
    TIME_CNT = true;
  
  if(TIME_CNT == true && !GAME_OVER){
    cnt++;
    if(cnt >= MAX_CNT){
      item_effect = 0;
      TIME_CNT = false;
      cnt = 0;
    }
  }
  if(!GAME_OVER){
    gage.cul();  
  }
  gage.draw();
  
  if(GAME_OVER == true){
    gage.gameover();
  }
}

// ---------- method keyPressed ----------
void keyPressed() {
  if((key == 'r' || key == 'R') && GAME_OVER == true){
    initialize();
  }
  if (key == 'q') {
    exit();
  }
  if (key == 'z') {
    frameRate(300);
  }
  if (keyCode == RIGHT) {
    penta.setToRight();
  }
  if (keyCode == LEFT) {
    penta.setToLeft();
  }
  if(key == ' ')
    if((!GAME_OVER) && (!missile.isRunning))
      missile.setIsRunning();
}

// ---------- method keyPeleased ----------
void keyReleased() {
  if (key == 'z') {
    frameRate(60);
  }
    if (keyCode == RIGHT) {
      penta.resetToRight();
  }
  if (keyCode == LEFT) {
    penta.resetToLeft();
  }
}
