    int gameScreen = 0;

    float ballX, ballY;
    int ballSize = 20;
    int ballColor = color(0);

    float gravity = 1;
    float ballSpeedVert = 0;

    float airFriction = 0.001;
    float friction = 0.1;

    color racketColor = color(0);
    float racketWidth = 100;
    float racketheight = 10;
    int racketBounceRate = 20;

    float ballSpeedHorizon = 10;


    int wallSpeed = 5;
    int wallInterval = 1000;
    float lastAddTime = 0;
    int minGapHeight = 200;
    int maxGapHeight = 300;
    int wallWidth = 80;
    color wallColors = color(0, 180, 255);
    ArrayList<int[]> walls = new ArrayList<int[]>();


    int maxHealth = 100;
    int healthBarWidth = 60;
    float health = 100;
    float healthDecrease = 1;
    
    int score = 0;

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
        wallAdder();
        wallHandler();
        drawHealthBar();
        printScore();
    }


    void gameOverScreen() {
        background(0);
        textAlign(CENTER);
        fill(255);
        textSize(30);
        text("Game Over", height/2, width/2 -20);
        textSize(20);
        text("Score: " + score, width/2, height/2 + 15);
        textSize(15);
        text("Click to Restart", height/2, width/2 + 40);
    }

    public void mousePressed() {
        if (gameScreen == 0) {
            startGame();
        }

        if (gameScreen == 2) {
            restart();
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

    // 1. First, check if the ball is horizontally aligned with the racket.
    if ((ballX + (ballSize/2) > mouseX - (racketWidth/2)) && (ballX - (ballSize/2) < mouseX + (racketWidth/2))) {
        
        // 2. ONLY if it is aligned, check if it's vertically close enough for a collision.
        if (dist(ballX, ballY, ballX, mouseY) <= (ballSize/2) + abs(overhead)) {
            
            // 3. If it's a collision, make it bounce.
            makeBounceBottom(mouseY);
            ballSpeedHorizon = (ballX - mouseX)/5;

            // 4. ONLY if a bounce just happened, check if the racket was moving up.
            if (overhead < 0) {
                // Apply the racket's upward speed to the ball.
                ballY += overhead; 
                ballSpeedVert += overhead;
            }
        }
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

    void wallAdder() {
        if (millis()-lastAddTime > wallInterval) {
            int randHeight = round(random(minGapHeight, maxGapHeight));
            int randY = round(random(0, height-randHeight));

            int[] randWall = {width, randY, wallWidth, randHeight, 0};
            walls.add(randWall);
            lastAddTime = millis();
        }
    }

    void wallHandler() {
        for (int i = 0; i < walls.size(); i++) {
            wallMover(i);            
            wallDrawer(i);
            wallRemover(i);
            watchWallCollision(i);
        }
    }

    void wallDrawer(int index) {
        int[] wall = walls.get(index);
        int gapWalX = wall[0];
        int gapWallY = wall[1];
        int gapWallWidth = wall[2];
        int gapWallHeight = wall[3];

        rectMode(CORNER);
        fill(wallColors);
        rect(gapWalX, 0, gapWallWidth, gapWallY, 20);
        rect(gapWalX, gapWallY+gapWallHeight, gapWallWidth, height-(gapWallY+gapWallHeight), 20);
        
    }

    void wallMover(int index) {
        int[] wall = walls.get(index);
        wall[0] -= wallSpeed;
    }

    void wallRemover(int index) {
        int[] wall = walls.get(index);
        if (wall[0]+wall[2] <=0) {
            walls.remove(index);
        }
    }

    void watchWallCollision(int index) {
        int[] wall = walls.get(index);

        int gapWallX = wall[0];
        int gapWallY = wall[1];
        int gapWallWidth = wall[2];
        int gapWallHeight = wall[3];
        int wallTopX = gapWallX;
        int wallTopY= 0;
        int wallTopWidth =gapWallWidth;
        int wallTopHeight = gapWallY;
        int wallBottomX = gapWallX;
        int wallBottomY = gapWallY+gapWallHeight;
        int wallBottomWidth = gapWallWidth;
        int wallBottomHeight = height-(gapWallY+gapWallHeight);

        if (
            (ballX+(ballSize/2)>wallTopX) &&
            (ballX-(ballSize/2)<wallTopX+wallTopWidth) &&
            (ballY+(ballSize/2)>wallTopY) &&
            (ballY-(ballSize/2)<wallTopY+wallTopHeight)
        ) {
            decreaseHealth();
        }

        if (
            (ballX+(ballSize/2)>wallBottomX) &&
            (ballX-(ballSize/2)<wallBottomX+wallBottomWidth) &&
            (ballY+(ballSize/2)>wallBottomY) &&
            (ballY-(ballSize/2)<wallBottomY+wallBottomHeight)
        ) {
            decreaseHealth();
        }

        int wallScored = wall[4];

        if (ballX > gapWallX+(gapWallWidth/2) && wallScored==0) {
            wallScored=1;
            wall[4]=1;
            score();
        }
    }

    void drawHealthBar() {
        noStroke(); 
        fill(236, 240, 241);
        rectMode(CORNER);
        rect(ballX-(healthBarWidth/2), ballY-30, healthBarWidth, 5);
        if (health > 60) {
            fill(46, 204, 113);
        } else if (health > 30) {
            fill(230, 126, 34);
        } else {
            fill(231, 76, 60);
        }

        rectMode(CORNER);
        rect(ballX-(healthBarWidth/2), ballY-30, healthBarWidth*(health/maxHealth), 5);
    }

    void decreaseHealth() {
        health -= healthDecrease;
        if (health <= 0) {
            gameOver();
        }
    }

    void gameOver() {
        gameScreen = 2;
    }

    void score() {
        score++;
    }

    void printScore() {
        textAlign(CENTER);
        fill(255, 0, 0);
        textSize(30);
        text(score, width/2, height/2);
    }

    void restart() {
        score = 0;
        health = maxHealth;
        ballX=width/4;
        ballY=height/5;
        lastAddTime = 0;
        walls.clear();
        gameScreen = 0;
    }


