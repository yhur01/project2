import processing.serial.*;
import cc.arduino.*;

Arduino arduino;

import ddf.minim.*;
Minim minim;
AudioSample laser;

int val1 = 0;
int val2 = 0;

int R = 10;
int G = 8;

int LEDR = 2;
int LEDY = 4;
int LEDG = 6;

float moveX;
float moveY; 

int score;
int mode = 0;

int ballSize = 20;

int speed =1;

  boolean fire = false;
  boolean buttonDown = false;
   boolean strike = false;
   
 int gameOver = 0;
  
 //int startGame;
  int getRandomX()
  {
    return int(random(550));
  }
   
  int[] ballx = { getRandomX(), getRandomX(), getRandomX(), getRandomX(), getRandomX() };
  int[] bally = { 0, 0, 0, 0, 0 };
   
   PImage player;
   PImage enemy;
   PImage ring;
   PImage bg;
   PImage line1;
   
   boolean dead = false;
   
  void setup()
  {
   
    size (600, 600);
    
    imageMode(CENTER);
 
 player = loadImage("player.png");
 enemy = loadImage ("enemy.png");
 ring = loadImage("ring.png");
 bg = loadImage("bg.jpg");   
 line1 = loadImage("laser.png");
    
  
minim = new Minim(this);
  laser = minim.loadSample("laser.mp3", 3000);  
    
 arduino = new Arduino (this, Arduino.list()[0], 57600);

// arduino.pinMode(LEDR, Arduino.OUTPUT);
// arduino.pinMode(LEDY, Arduino.OUTPUT);
 //arduino.pinMode(LEDG, Arduino.OUTPUT);
 
 arduino.pinMode(R, Arduino.INPUT);
 arduino.pinMode(G, Arduino.INPUT);
     
  }
   
  void draw()
  {
   background(0);
   
   if(mode ==0){
   startScreen();  
   }else if (mode ==1){
     playGame();
   }
  }
  
  void startScreen(){
  
  textAlign(CENTER);
  
  textSize(18);
  text("YOUR MUSHROOM FARM ATTACKED BY BAD MUSHROOMS",300,200);
  
  text("PRESS RED BUTTON TO BEAT THEM UP WITH YOUR LASER SMOKE!", 300, 300);
  
  textSize(30);
  text("CLICK TO START",300,400);
}

  void playGame(){
   background (bg);
    fill(255);
    stroke (255);
    
     moveX = map(arduino.analogRead(3), 0, 1023, 0, 600);
     moveY = map(arduino.analogRead(5), 0 , 1023, 0 ,600);
 
    image(player, moveX, 550,100, 150);

    fill(0);
    textSize(20);
    textAlign(CORNER);
    text("Number of enemies killed: " + score, 10,25);
    
    ballFalling();
    
    if(fire)
    {
      cannon();
      fire = false;
    }
     
     for (int i=0; i<5; i++)
    {
      if(bally[i] >= 570){
     gameFinish(); 
      }
    }
    
     if (arduino.digitalRead(10) == 1) {
        fire();
    } 
    
    if (arduino.digitalRead(8) == 1){
   reset();
   dead= false;
    }
    
   // println(arduino.digitalRead(8)); 
    
   
    if(score >=0){
     speed = 1; 
    arduino.digitalWrite(2, Arduino.HIGH);     
    arduino.digitalWrite(4, Arduino.LOW);   
    arduino.digitalWrite(6, Arduino.LOW);
    }
    if(score >= 20){
     speed = 2; 
    arduino.digitalWrite(2, Arduino.LOW);     
    arduino.digitalWrite(4, Arduino.HIGH);   
    arduino.digitalWrite(6, Arduino.LOW);
    } 
   if(score >= 40){
     speed = 4; 
     arduino.digitalWrite(2, Arduino.LOW);     
    arduino.digitalWrite(4, Arduino.LOW);   
    arduino.digitalWrite(6, Arduino.HIGH);
     
    }
   if(score >= 60){
     speed = 8; 
     
    }
   
  }
  
  void fire()
  {
    fire = true;
  }
   
  void ballFalling()
  { 
    
    for (int i=0; i<5; i++)
    {
      if(dead==false){
      image(enemy, ballx[i], bally[i]+=speed, 35, 68);
      }else{
       speed = 0; 
      }
    }
  }
   
   void keyPressed(){
    if(key==' '){
     if (dead==true) {
        reset();
         dead = false;
    
    } 
    } 
   }
   
  void cannon()
  {
   
    float shotX = moveX;
    for (int i = 0; i < 5; i++)
    {
      if((shotX >= (ballx[i]-ballSize/2)) && (shotX <= (ballx[i]+ballSize/2))) {
        if (!buttonDown) {
        
        strike = true;
        fill(255);
        image(line1,moveX-45, 265, 30, 600);
        ellipse(ballx[i], bally[i],
                ballSize+25, ballSize+25);
        ballx[i] = getRandomX();
        bally[i] = 0;
        score++;
        buttonDown = true;
        laser.trigger();
        }
      }else{
      buttonDown = false;
      strike = false;
      //image(line1,moveX-45, 265, 30, 600);
      }   
    }
  }
   
  void gameFinish()
  {
    dead = true; 
    fill(color(255,0,0));
    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(40);
    text("GAME OVER", width/2 , height/2);
    textSize(20);
    text("Well done! Your score was : "+ score, width/2, height/2 + 50);
    textSize(20);
    text("PRESS GREEN BUTTON TO RESTART!", width/2, height/2 + 100);
  }
    
    
    void reset(){
           for (int i=0; i<5; i++)
    {
      bally[i] = 0;
    }
    score = 0;
    }
    
    void mousePressed(){
 if (mode ==0){
  mode = 1;
 } 
}
 

