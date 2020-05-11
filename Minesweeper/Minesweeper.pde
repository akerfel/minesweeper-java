// minesweeperonline

// Debug/cheat settings
boolean startBoardRevealed;
boolean onlyTwoMinesUpperLeftCorner;    // Overrides numMines

// Visual settings
int pixelCount;  // pixels per square side
int boardStartX;
int boardStartY;

// Difficulty settings
String difficulty;    // "Supersmall", "Beginner", "Intermediate" or "Expert"
int boardWidth;       // Depending on difficulty: 2, 9, 16, 30
int boardHeight;      // Depending on difficulty: 2, 9, 16, 16
int numMines;         // Depending on difficulty: 2, 10, 40, 99

// Important  variables
boolean squareHasMine[][];
boolean squareIsRevealed[][];
boolean gameOver;
boolean gameWon;

void setup() {
    // Game window
    size(800, 600);
    
    // Debug/cheat settings
    startBoardRevealed = false;
    onlyTwoMinesUpperLeftCorner = true;
    
    // Visual settings
    pixelCount = 20;  // pixels per square side
    boardStartX = 40;
    boardStartY = 40;
    ellipseMode(CORNER);
    
    // Difficulty settings
    difficulty = "Supersmall"; // "Supersmall", "Beginner", "Intermediate" or "Expert"
    setDifficulty();
    
    // Important  variables
    squareHasMine = new boolean[boardWidth][boardHeight];
    squareIsRevealed = new boolean[boardWidth][boardHeight];
    gameOver = false;
    gameWon = false;
    
    // Setup functions
    setupBoard();
    drawBoard();
}

void setupBoard() {
    setAllUnrevealed();
    if (onlyTwoMinesUpperLeftCorner) {
        placeTwoMinesUpperLeftCorner();
    }
    else {
        placeMines();
    }
}

void placeTwoMinesUpperLeftCorner() {
    squareHasMine[0][0] = true;
    squareHasMine[1][0] = true;
}

void setAllUnrevealed() {
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            if (startBoardRevealed) {
                squareIsRevealed[i][j] = true;
            }
            else {
                squareIsRevealed[i][j] = false;
            }
        }
    }
}

void placeMines() {
    int minesLeftToPlace = numMines;
    float mineChance = calculateMineChance();
    setAllSquaresToNoMines();
    while (minesLeftToPlace > 0) { 
        for (int i = 0; i < boardWidth; i++) {
            for (int j = 0; j < boardHeight; j++) {
                if (random(0, 1) < mineChance) {
                    squareHasMine[i][j] = true;
                    minesLeftToPlace--;
                }
                if (minesLeftToPlace == 0) {
                    return;
                }
            }
        }
    }
}

void setAllSquaresToNoMines() {
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            squareHasMine[i][j] = false;
        }
    }
}

// Calculates chance for a square to have a mine.
// Depends on difficulty chosen.
float calculateMineChance() {
    return (float) numMines / (boardWidth * boardHeight);
}

void setDifficulty() {
    if (difficulty.equals("Supersmall")) {
        boardWidth = 2;
        boardHeight = 2;
        numMines = 2;
    }
    else if (difficulty.equals("Beginner")) {
        boardWidth = 9;
        boardHeight = 9;
        numMines = 10;
    }
    else if (difficulty.equals("Intermediate")) {
        boardWidth = 16;
        boardHeight = 16;
        numMines = 40;
    }
    else if (difficulty.equals("Hard")) {
        boardWidth = 30;
        boardHeight = 16;
        numMines = 99;
    }
    else {     // else set board really small
        boardWidth = 2;
        boardHeight = 2;
        numMines = 0;
    }
}

void draw() {
    // Need to have this method in order for mouseClicked() to work correctly.
}

// drawBoard() is only called when mouse is clicked,
// since board does not need to be updated at any other point.
void drawBoard () {
    if (gameWon) {
        drawWinScreen();
    }
    else if (gameOver) {
        drawGameOverScreen();
    }
    else {
        for (int i = 0; i < boardWidth; i++) {
            for (int j = 0; j < boardHeight; j++) {
                if (squareIsRevealed[i][j]) {
                    fill(220, 220, 220);
                    square(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
                    if (squareHasMine[i][j]) {
                        fill(0, 0, 0);
                        circle(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
                    }
                }
                else {
                    fill(120, 120, 120);
                    square(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
                }
            }
        }
    }
}

// All squares are drawn green
void drawWinScreen() {
    text("GAME WON", 20, 20);
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            fill(0, 200, 0);
            square(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
            if (squareHasMine[i][j]) {
                fill(0, 0, 0);
                circle(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
            }
        }
    }
}

// All squares are drawn red
void drawGameOverScreen() {
    text("GAME OVER", 20, 20);
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            fill(220, 0, 0);
            square(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
            if (squareHasMine[i][j]) {
                fill(0, 0, 0);
                circle(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
            }
        }
    }
}

void setupBoardEasyWin() {
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            squareHasMine[i][j] = false;
        }
    }
    squareHasMine[0][0] = true;
}

void randomizeBoard() {
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            if (random(0, 1) < 0.5) {
                squareHasMine[i][j] = true;
            }
            else {
                squareHasMine[i][j] = false;
            }
        }
    }
}

void mouseClicked() {
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            if (mouseX > boardStartX + i * pixelCount && mouseX <= boardStartX + i * pixelCount + pixelCount && mouseY > boardStartY + j * pixelCount && mouseY <= boardStartY + j * pixelCount + pixelCount) {
                clickSquare(i, j);
            }
        }
    } 
    if (hasWon()) {
        gameWon = true;
    }
    drawBoard();
}

// if all squares without mines have been revealed, return true
boolean hasWon() {
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            if (!squareHasMine[i][j]) {  // if square has mine, skip it  
                // If square without mine is NOT revealed, game has not been won yet.
                if (!squareIsRevealed[i][j]) {
                    return false;
                }
            }
        }
    } 
    return true;    // if all squares without mines have been revealed, game has been won.
}

void clickSquare(int x, int y) {
    squareIsRevealed[x][y] = true;
    if (squareHasMine[x][y]) {
        gameOver = true;
    }
}
