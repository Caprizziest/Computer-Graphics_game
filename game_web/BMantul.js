// ======================
// Global Variables
// ======================
var gameScreen = 0;

var ballX, ballY;
var ballSize = 20;
var ballColor;

var gravity = 1;
var ballSpeedVert = 0;

var airFriction = 0.001;
var friction = 0.1;

var racketColor;
var racketWidth = 100;
var racketHeight = 10;
var racketBounceRate = 20;

var ballSpeedHorizon = 10;

var wallSpeed = 5;
var wallInterval = 1000;
var lastAddTime = 0;
var minGapHeight = 200;
var maxGapHeight = 300;
var wallWidth = 80;
var wallColors;
var walls = [];

var maxHealth = 100;
var healthBarWidth = 60;
var health = 100;
var healthDecrease = 1;

var score = 0;


// ======================
// Setup
// ======================
function setup() {
    createCanvas(500, 500);

    ballColor = color(0);
    racketColor = color(0);
    wallColors = color(0, 180, 255);

    ballX = width / 4;
    ballY = height / 5;
}



// ======================
// Main Loop
// ======================
function draw() {
    if (gameScreen == 0) {
        initScreen();
    } else if (gameScreen == 1) {
        gamePlayScreen();
    } else if (gameScreen == 2) {
        gameOverScreen();
    }
}



// ======================
// Screens
// ======================
function initScreen() {
    background(0);
    fill(255);
    textAlign(CENTER);
    text("Kilik untuk memulai", height / 2, width / 2);
}

function gamePlayScreen() {
    background(255);

    drawBall();
    applyGravity();
    keepInScreen();
    drawRacket();
    watchRacketBounce();
    applyHorizontalSpeed();

    wallAdder();
    wallHandler();

    drawHealthBar();
    printScore();
}

function gameOverScreen() {
    background(0);
    fill(255);
    textAlign(CENTER);

    textSize(30);
    text("Game Over", height / 2, width / 2 - 20);

    textSize(20);
    text("Score: " + score, width / 2, height / 2 + 15);

    textSize(15);
    text("Click to Restart", height / 2, width / 2 + 40);
}



// ======================
// Input
// ======================
function mousePressed() {
    if (gameScreen == 0) startGame();
    if (gameScreen == 2) restart();
}

function startGame() {
    gameScreen = 1;
}



// ======================
// Ball Physics
// ======================
function drawBall() {
    fill(ballColor);
    ellipse(ballX, ballY, ballSize, ballSize);
}

function applyGravity() {
    ballSpeedVert += gravity;
    ballY += ballSpeedVert;
    ballSpeedVert -= (ballSpeedVert * airFriction);
}

function keepInScreen() {
    if (ballY + (ballSize / 2) > height) {
        makeBounceBottom(height);
    }
    if (ballY - (ballSize / 2) < 0) {
        makeBounceTop(0);
    }
    if (ballX - (ballSize / 2) < 0) {
        makeBounceLeft(0);
    }
    if (ballX + (ballSize / 2) > width) {
        makeBounceRight(width);
    }
}

function makeBounceBottom(surface) {
    ballY = surface - (ballSize / 2);
    ballSpeedVert *= -1;
    ballSpeedVert -= ballSpeedVert * airFriction;
}

function makeBounceTop(surface) {
    ballY = surface + (ballSize / 2);
    ballSpeedVert *= -1;
    ballSpeedVert -= ballSpeedVert * airFriction;
}

function applyHorizontalSpeed() {
    ballX += ballSpeedHorizon;
    ballSpeedHorizon -= ballSpeedHorizon * airFriction;
}

function makeBounceLeft(surface) {
    ballX = surface + (ballSize / 2);
    ballSpeedHorizon *= 1;
    ballSpeedHorizon -= ballSpeedHorizon * airFriction;
}

function makeBounceRight(surface) {
    ballX = surface - (ballSize / 2);
    ballSpeedHorizon *= -1;
    ballSpeedHorizon -= ballSpeedHorizon * airFriction;
}



// ======================
// Racket
// ======================
function drawRacket() {
    fill(racketColor);
    rectMode(CENTER);
    rect(mouseX, mouseY, racketWidth, racketHeight);
}

function watchRacketBounce() {
    var overhead = mouseY - pmouseY;

    // Horizontal alignment
    if ((ballX + (ballSize / 2) > mouseX - (racketWidth / 2)) &&
        (ballX - (ballSize / 2) < mouseX + (racketWidth / 2))) {

        // Vertical alignment
        if (dist(ballX, ballY, ballX, mouseY) <= (ballSize / 2) + abs(overhead)) {

            makeBounceBottom(mouseY);
            ballSpeedHorizon = (ballX - mouseX) / 5;

            if (overhead < 0) {
                ballY += overhead;
                ballSpeedVert += overhead;
            }
        }
    }
}



// ======================
// Walls
// ======================
function wallAdder() {
    if (millis() - lastAddTime > wallInterval) {

        var randHeight = round(random(minGapHeight, maxGapHeight));
        var randY = round(random(0, height - randHeight));

        var randWall = [width, randY, wallWidth, randHeight, 0];
        walls.push(randWall);

        lastAddTime = millis();
    }
}

function wallHandler() {
    for (var i = 0; i < walls.length; i++) {
        wallMover(i);
        wallDrawer(i);
        wallRemover(i);
        watchWallCollision(i);
    }
}

function wallDrawer(index) {
    var wall = walls[index];

    var gapWallX = wall[0];
    var gapWallY = wall[1];
    var gapWallWidth = wall[2];
    var gapWallHeight = wall[3];

    rectMode(CORNER);
    fill(wallColors);

    // Rounded rect
    rect(gapWallX, 0, gapWallWidth, gapWallY, 20);
    rect(gapWallX, gapWallY + gapWallHeight, gapWallWidth, height - (gapWallY + gapWallHeight), 20);
}

function wallMover(index) {
    walls[index][0] -= wallSpeed;
}

function wallRemover(index) {
    var wall = walls[index];
    if (wall[0] + wall[2] <= 0) {
        walls.splice(index, 1);
    }
}

function watchWallCollision(index) {
    var wall = walls[index];

    var gapWallX = wall[0];
    var gapWallY = wall[1];
    var gapWallWidth = wall[2];
    var gapWallHeight = wall[3];

    var wallTopX = gapWallX;
    var wallTopY = 0;
    var wallTopWidth = gapWallWidth;
    var wallTopHeight = gapWallY;

    var wallBottomX = gapWallX;
    var wallBottomY = gapWallY + gapWallHeight;
    var wallBottomWidth = gapWallWidth;
    var wallBottomHeight = height - (gapWallY + gapWallHeight);

    // Collision upper
    if (
        (ballX + (ballSize / 2) > wallTopX) &&
        (ballX - (ballSize / 2) < wallTopX + wallTopWidth) &&
        (ballY + (ballSize / 2) > wallTopY) &&
        (ballY - (ballSize / 2) < wallTopY + wallTopHeight)
    ) {
        decreaseHealth();
    }

    // Collision bottom
    if (
        (ballX + (ballSize / 2) > wallBottomX) &&
        (ballX - (ballSize / 2) < wallBottomX + wallBottomWidth) &&
        (ballY + (ballSize / 2) > wallBottomY) &&
        (ballY - (ballSize / 2) < wallBottomY + wallBottomHeight)
    ) {
        decreaseHealth();
    }

    // Scoring
    var wallScored = wall[4];
    if (ballX > gapWallX + (gapWallWidth / 2) && wallScored == 0) {
        wall[4] = 1;
        addScore();
    }
}



// ======================
// Health & Score
// ======================
function drawHealthBar() {
    noStroke();
    fill(236, 240, 241);

    rectMode(CORNER);
    rect(ballX - (healthBarWidth / 2), ballY - 30, healthBarWidth, 5);

    if (health > 60) {
        fill(46, 204, 113);
    } else if (health > 30) {
        fill(230, 126, 34);
    } else {
        fill(231, 76, 60);
    }

    rect(ballX - (healthBarWidth / 2), ballY - 30, healthBarWidth * (health / maxHealth), 5);
}

function decreaseHealth() {
    health -= healthDecrease;
    if (health <= 0) gameOver();
}

function gameOver() {
    gameScreen = 2;
}

function addScore() {
    score++;
}

function printScore() {
    fill(255, 0, 0);
    textSize(30);
    textAlign(CENTER);
    text(score, width / 2, height / 2);
}



// ======================
// Restart
// ======================
function restart() {
    score = 0;
    health = maxHealth;

    ballX = width / 4;
    ballY = height / 5;
    lastAddTime = 0;

    walls = [];
    gameScreen = 0;
}
