int gameScreen = 0;

void setup() {
    size(500,500);
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
}


void gameOverScreen() {

}

public void mousePressed() {
    if (gameScreen == 0); {
        startGame();
    }
}

void startGame(){
    gameScreen = 1;
}