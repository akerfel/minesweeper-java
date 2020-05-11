// minesweeperonline

// Debug/cheat settings
boolean startBoardRevealed;

// Visual settings
int pixelCount;  // pixels per square side
int boardStartX;
int boardStartY;

// Difficulty settings
String difficulty;    // "Beginner", "Intermediate" or "Expert"
int boardWidth;       // Depending on difficulty: 9, 16, 30
int boardHeight;      // Depending on difficulty: 9, 16, 16
int numMines;         // Depending on difficulty: 10, 40, 99

// Important  variables
boolean squareHasMine[][];
boolean squareIsRevealed[][];

void setup() {
    // Game window
    size(800, 600);
    
    // Debug/cheat settings
    startBoardRevealed = false;
    
    // Visual settings
    pixelCount = 20;  // pixels per square side
    boardStartX = 40;
    boardStartY = 40;
    ellipseMode(CORNER);
    
    // Difficulty settings
    difficulty = "Beginner"; // "Beginner", "Intermediate" or "Expert"
    setDifficulty();
    
    // Important  variables
    squareHasMine = new boolean[boardWidth][boardHeight];
    squareIsRevealed = new boolean[boardWidth][boardHeight];
    
    // Setup functions
    setAllUnrevealed();
    placeMines();
    drawBoard();
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
    println("mineChance: " + mineChance);
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
    println("41");
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
    if (difficulty.equals("Beginner")) {
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
    else {     // else set Beginner
        boardWidth = 9;
        boardHeight = 9;
        numMines = 10;
    }
}

void draw() {
    // Need to have this method in order for mouseClicked() to work correctly.
}

// drawBoard() is only called when mouse is clicked,
// since board does not need to be updated at any other point.
void drawBoard () {
    if (!hasWon()) {
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
    else {
        drawWinScreen();
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
    if (!hasWon()) {
        for (int i = 0; i < boardWidth; i++) {
            for (int j = 0; j < boardHeight; j++) {
                if (mouseX > boardStartX + i * pixelCount && mouseX <= boardStartX + i * pixelCount + pixelCount && mouseY > boardStartY + j * pixelCount && mouseY <= boardStartY + j * pixelCount + pixelCount) {
                    clickSquare(i, j);
                }
            }
        } 
    }
    drawBoard();
}

void clickSquare(int x, int y) {
    squareIsRevealed[x][y] = true;
}

void drawWinScreen() {
    fill(0, 200, 0);
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            square(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
        }
    }
}

boolean hasWon() {
    return false;
}
