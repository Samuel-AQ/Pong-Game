/*
* This is a code that creates a Pong game. In order to use it you need to know this controls:
* Player 1: <w> (to move up) and <s> (to move down)
* Player 2: <up arrow> (to move up) and <down arrow> (to move down)
* @author: Samuel Arrocha Quevedo
* @version: 15/02/2021
*/

import processing.sound.*;

SoundFile hitSound, pointSound;
int xCoordinate, yCoordinate, radius, ballSpeed, ballInclination, rightPlayerZone, leftPlayerZone, rectangleHeight, rectangleWidth, player1Score, player2Score;

void setup(){
  size(500, 500);
  rectangleHeight = 50;
  rectangleWidth = 5;
  rightPlayerZone = height / 2 - (rectangleHeight / 2);
  leftPlayerZone = height / 2 - (rectangleHeight / 2);
  radius = 20;
  hitSound = new SoundFile(this, "../../data/sounds/pong_sound.mp3");
  pointSound = new SoundFile(this, "../../data/sounds/point_pong_sound.mp3");
  player1Score = 0;
  player2Score = 0;
  
  setGameOptions();
}

void draw(){
  runPong();
}

void runPong(){
  setPongColors();
  drawPlayers();
  drawField();
  
  circle(xCoordinate, yCoordinate, radius);
  
  xCoordinate += ballSpeed;
  yCoordinate += ballInclination;
  
  boolean ballHitsVerticalLimits = (yCoordinate + radius / 2) == height || (yCoordinate - radius / 2) == 0;
  boolean ballHitsLeftLimits = (xCoordinate - radius / 2) < 0;
  boolean ballHitsRightLimits = (xCoordinate + radius / 2) > width;
  boolean rightPlayerHits = yCoordinate >= rightPlayerZone && (yCoordinate <= (rightPlayerZone + rectangleHeight)) && (xCoordinate + radius / 2 >= (width - 27));
  boolean leftPlayerHits = yCoordinate >= leftPlayerZone && yCoordinate <= leftPlayerZone + rectangleHeight && xCoordinate - radius / 2 <= 20;
  
  if(rightPlayerHits || leftPlayerHits){ 
    changeHitBallDirection();
  }else if(ballHitsVerticalLimits){
    // If the ball hits the upper or lower limit it will bounce
    ballInclination = -ballInclination;
  }else if (ballHitsLeftLimits){
    // If the ball falls out of the space it will return to its original coordinates with a different speed mode and different inclination
    player2Score++;
    resetGameOptions();
  }else if(ballHitsRightLimits){
    // If the ball falls out of the space it will return to its original coordinates with a different speed mode and different inclination
    player1Score++;
    resetGameOptions();
  }
}

void drawPlayers(){
  rect(20, leftPlayerZone, rectangleWidth, rectangleHeight);
  rect(width - 27, rightPlayerZone, rectangleWidth, rectangleHeight);
}

void drawField(){
  for(int i = 0; i <= 500; i += 20){
    line(width / 2, i, width / 2, i + 10);
  }
  textSize(25);
  text("P1 score = " + player1Score, 50, 50);
  text("P2 score = " + player2Score, 300, 50);
}

void keyPressed(){
  // Player 1
  if(keyCode == 'W') leftPlayerZone -= 20;
  if(keyCode == 'S') leftPlayerZone += 20;
  // Player 2
  if(keyCode == UP) rightPlayerZone -= 20;
  if(keyCode == DOWN) rightPlayerZone += 20;
}

void changeHitBallDirection(){
  ballSpeed = -ballSpeed;
  thread("playhitSound");
}

void setGameOptions(){
  xCoordinate = width / 2;  
  yCoordinate = height / 2;
  ballSpeed = (int) random(2, 5);
  while(ballInclination == 0) ballInclination = (int) random(-5, 5);
}

void resetGameOptions(){
  setGameOptions();
  thread("playPointSound");
}

void setPongColors(){
  color black = color(0, 0, 0);
  color white = color(255, 255, 255);
  background(black);
  fill(white);
  stroke(white);
}

void playhitSound(){
  hitSound.play();
}

void playPointSound(){
  pointSound.play();
}
