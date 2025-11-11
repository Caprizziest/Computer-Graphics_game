int gameScreen = 0;

float ballX, ballY;
int ballSize = 20;
int ballColor = color(0);

float gravity = 1;
float ballSpeedVert = 0;

float airFriction = 0.0001;
float friction = 0.1;

color racketColor = color(0);
float racketWidth = 100;
float racketheight = 10;
int racketBounceRate = 20;

float ballSpeedHorizon = 10;

void setup() {
    size(500,500);
    ballX=width/4;
    ballY=height/5;

}

void draw() {
    if (gameScreen == 0) {
        initScreen();
    } else if (gameScreen == 1) {
        gameScreen();
    } else if (gameScreen == 2) {
        gameOverScreen();
    }
}


void initScreen() {
    background(0);
    textAlign(CENTER);
    text("Kilik untuk memulai", height/2, width/2);
}

void gameScreen() {
    background(255);
    drawBall();
    applyGravity();
    keepInScreen();
    drawRacket();
    watchRacketBounce();
    applyHorizontalSpeed();
}


void gameOverScreen() {

}

public void mousePressed() {
    if (gameScreen == 0) {
        startGame();
    }
}

void startGame(){
    gameScreen = 1;
}

void keepInScreen() {
    if (ballY+(ballSize/2) > height) {
        makeBounceBottom(height);
    }
    if (ballY-(ballSize/2) < 0) {
        makeBounceTop(0);
    }

    if (ballX-(ballSize/2) < 0) {
        makeBounceLeft(0);
    }
    if (ballX+(ballSize/2) > width) {
        makeBounceRight(width);
    }
}

void drawBall() {
    fill(ballColor);
    ellipse(ballX, ballY, ballSize, ballSize);
}

void applyGravity() {
    ballSpeedVert += gravity;
    ballY += ballSpeedVert;
    ballSpeedVert -= (ballSpeedVert * airFriction);
}

void makeBounceBottom(float surface) {
    ballY = surface - (ballSize/2);
    ballSpeedVert *= -1;
    ballSpeedVert -= (ballSpeedVert * airFriction);
}

void makeBounceTop(float surface) {
    ballY = surface + (ballSize/2);
    ballSpeedVert *= -1;
    ballSpeedVert -= (ballSpeedVert * airFriction);
}

void drawRacket() {
    fill(racketColor);
    rectMode(CENTER);
    rect(mouseX, mouseY, racketWidth, racketheight);
}

void watchRacketBounce() {
    float overhead = mouseY - pmouseY;
    if ((ballX + (ballSize/2) > mouseX - (racketWidth/2)) && (ballX - (ballSize/2)) < mouseX + (racketWidth/2)) {
    } if (dist(ballX, ballY, ballX, mouseY) <= (ballSize/2)  + abs(overhead)) {
        makeBounceBottom(mouseY);
        ballSpeedHorizon = (ballX - mouseX)/5;
    } if (overhead < 0) {
        ballY += overhead;
        ballSpeedVert += overhead;
    }
}

void applyHorizontalSpeed() {
    ballX += ballSpeedHorizon;
    ballSpeedHorizon -= (ballSpeedHorizon * airFriction);
}

void makeBounceLeft(float surface) {
    ballX = surface + (ballSize/2);
    ballSpeedHorizon *= 1;
    ballSpeedHorizon -= (ballSpeedHorizon * airFriction);
}

void makeBounceRight(float surface) {
    ballX = surface - (ballSize/2);
    ballSpeedHorizon *= -1;
    ballSpeedHorizon -= (ballSpeedHorizon * airFriction);
}