// minesweeperonline

// Debug/cheat settings
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
boolean squareIsFlagged[][];
boolean gameOver;
boolean gameWon;

void setup() {
    // Game window
    size(800, 600);
    
    // Debug/cheat settings
    onlyTwoMinesUpperLeftCorner = false;
    
    // Visual settings
    pixelCount = 25;  // pixels per square side
    boardStartX = 30;
    boardStartY = 150;
    // draw background
    drawBackground();
    
    // Difficulty settings
    difficulty = "Intermediate"; // "Supersmall", "Beginner", "Intermediate" or "Expert"
    setDifficulty();
    
    // Important  variables
    squareHasMine = new boolean[boardWidth][boardHeight];
    squareIsRevealed = new boolean[boardWidth][boardHeight];
    squareIsFlagged = new boolean[boardWidth][boardHeight];
    gameOver = false;
    gameWon = false;
    
    // Setup functions
    setupBoard();
    drawBoard();
}

void setupBoard() {
    setAllUnrevealed();
    setAllNotFlagged();
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
            squareIsRevealed[i][j] = false;
        }
    }
}

void setAllNotFlagged() {
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            squareIsFlagged[i][j] = false;
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

// this function is only called when mouse is clicked,
// since board does not need to be updated at any other point.
void drawBoard () {
    textAlign(CORNER);
    fill(0, 0, 0);
    textSize(16);
    text("LMB: reveal", 30, 30);
    text("Space: Flag", 30, 50);
    text(". [dot]: zoom in", 30, 70);
    text(", [comma]: zoom out", 30, 90);
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            if (squareIsRevealed[i][j]) {
                fill(220, 220, 220);
                if (gameWon) {
                    fill(0, 220, 0);
                }
                else if (gameOver) {
                    fill(220, 0, 0);
                }
                square(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
                if (squareHasMine[i][j]) {
                    fill(0, 0, 0);
                    ellipseMode(CORNER);
                    circle(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
                }
                int minesNextTo = countNearbyMines(i, j);
                if (minesNextTo != 0) {
                    fill(0, 0, 0);
                    textSize(20);
                    textAlign(CENTER, CENTER);
                    text(minesNextTo, boardStartX + i * pixelCount + pixelCount / 2, boardStartY + j * pixelCount + pixelCount / 2);
                }
            }
            else {
                fill(120, 120, 120);
                square(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
                if (squareIsFlagged[i][j]) {
                    fill(200, 0, 0);
                    ellipseMode(CENTER);
                    circle(boardStartX + i * pixelCount + pixelCount / 2, boardStartY + j * pixelCount + pixelCount / 2, pixelCount / 3);
                }
            }
        }
    }
}

void drawBackground() {
    fill(200, 200, 200);
    rect(0, 0, width, height);
}

int countNearbyMines(int x, int y) {
    int minesCounted = 0;
    // squares above, aka checking y - 1
    if (y != 0) {
        if (x != 0) {
            if (squareHasMine[x - 1][y - 1]) {
                minesCounted++;
            }
        }
        if (squareHasMine[x][y - 1]) {
            minesCounted++;
        }
        if (x != boardWidth - 1) {
            if (squareHasMine[x + 1][y - 1]) {
                minesCounted++;
            }
        }
    }
    
    // square to the left
    if (x != 0) {
        if (squareHasMine[x - 1][y]) {
            minesCounted++;
        }
    }
    
    // square to the right
    if (x != boardWidth - 1) {
        if (squareHasMine[x + 1][y]) {
            minesCounted++;
        }
    }
    
    // squares below
    if (y != boardHeight - 1) {
        if (x != 0) {
            if (squareHasMine[x - 1][y + 1]) {
                minesCounted++;
            }
        }
        if (squareHasMine[x][y + 1]) {
            minesCounted++;
        }
        if (x != boardWidth - 1) {
            if (squareHasMine[x + 1][y + 1]) {
                minesCounted++;
            }
        }
    }
    return minesCounted;
}

// All squares are drawn green
void drawWinScreen() {
    fill(0, 200, 0);
    text("GAME WON", 60, 20);
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
    fill(220, 0, 0);
    text("GAME OVER", 60, 20);
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

void keyPressed() {
    if (key == ' ') {
        int xm = mouseX;
        int ym = mouseY;
        int x = (xm - boardStartX) / pixelCount;
        int y = (ym - boardStartY) / pixelCount;
        flagOrUnflagSquare(x, y);
    }
    if (key == '.') {
        pixelCount++;
        drawBackground();
    }
    if (key == ',') {
        pixelCount--;
        drawBackground();
    }
    drawBoard();
}

void flagOrUnflagSquare(int x, int y) {
    if (squareIsFlagged[x][y]) {
        squareIsFlagged[x][y] = false;
    }
    else {
        squareIsFlagged[x][y] = true;
    }
}

void mouseClicked() {
    int xm = mouseX;
    int ym = mouseY;
    if (!gameWon && !gameOver && mouseButton == LEFT) {
        int x = (xm - boardStartX) / pixelCount;
        int y = (ym - boardStartY) / pixelCount;
        if (x >= 0 && y >= 0 && x < boardHeight && y < boardWidth) {
            clickSquare(x, y);
            println("clicked square " + x + " " + y);
        }
        if (hasWon()) {
            setGameWon();
        }
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

void setGameOver() {
    gameOver = true;
    setAllMinesRevealed();
}

void setGameWon() {
    gameWon = true;
    setAllMinesRevealed();
}

void setAllMinesRevealed() {
    for (int i = 0; i < boardWidth; i++) {
        for (int j = 0; j < boardHeight; j++) {
            if (squareHasMine[i][j]) {
                squareIsRevealed[i][j] = true;
            }
        }
    }
}

void clickSquare(int x, int y) {
    squareIsRevealed[x][y] = true;
    if (squareHasMine[x][y]) {
        setGameOver();
    }
    // recursivly check if mines next clicked square has zero mines next to it
    if (!squareHasMine[x][y]) {
        recursiveClick(x, y);
    }
    /*
    // squares above, aka checking same y - 1
    recursiveClick(x - 1, y - 1);
    recursiveClick(x, y - 1);
    recursiveClick(x + 1, y - 1);
    
    // squares left and right, aka checking same y
    recursiveClick(x - 1, y);
    recursiveClick(x + 1, y);
    
    // squares below, aka checking same y + 1
    recursiveClick(x - 1, y + 1);
    recursiveClick(x, y + 1);
    recursiveClick(x + 1, y + 1);
    */
}

void recursiveClick(int x, int y) {
    squareIsRevealed[x][y] = true;
    if (y != 0) {
        if (x != 0) {
            if (!squareIsRevealed[x - 1][y - 1] && !squareHasMine[x - 1][y - 1] && countNearbyMines(x - 1, y - 1) == 0) {
                recursiveClick(x - 1, y - 1);
            }
            if (!squareHasMine[x - 1][y - 1]) {
                squareIsRevealed[x - 1][y - 1] = true;
            }
        }
        
        if (!squareIsRevealed[x][y - 1] && !squareHasMine[x][y - 1] && countNearbyMines(x, y - 1) == 0) {
            recursiveClick(x, y - 1);
        }
        if (!squareHasMine[x][y - 1]) {
                squareIsRevealed[x][y - 1] = true;
        }
            
        if (x != boardWidth - 1) {
            if (!squareIsRevealed[x + 1][y - 1] && !squareHasMine[x + 1][y - 1] && countNearbyMines(x + 1, y - 1) == 0) {
                recursiveClick(x + 1, y);
            }
            if (!squareHasMine[x + 1][y - 1]) {
                squareIsRevealed[x + 1][y - 1] = true;
            }
        }
    }
    
    // square to the left
    if (x != 0) {
        if (!squareIsRevealed[x - 1][y] && !squareHasMine[x - 1][y] && countNearbyMines(x - 1, y) == 0) {
            recursiveClick(x - 1, y);
        }
        if (!squareHasMine[x - 1][y]) {
            squareIsRevealed[x - 1][y] = true;
        }
    }
    
    // square to the right
    if (x != boardWidth - 1) {
        if (!squareIsRevealed[x + 1][y] && !squareHasMine[x + 1][y] && countNearbyMines(x + 1, y) == 0) {
            recursiveClick(x + 1, y);
        }
        if (!squareHasMine[x + 1][y]) {
            squareIsRevealed[x + 1][y] = true;
        }
    }
    
    // squares below
    if (y != boardHeight - 1) {
        if (x != 0) {
            if (!squareIsRevealed[x - 1][y + 1] && !squareHasMine[x - 1][y + 1] && countNearbyMines(x - 1, y + 1) == 0) {
                recursiveClick(x - 1, y + 1);
            }
            if (!squareHasMine[x - 1][y + 1]) {
                squareIsRevealed[x][y] = true;
            }
        }
        
        if (!squareIsRevealed[x][y + 1] && !squareHasMine[x][y + 1] && countNearbyMines(x, y + 1) == 0) {
            recursiveClick(x, y + 1);
        }
        if (!squareHasMine[x][y + 1]) {
            squareIsRevealed[x][y + 1] = true;
        }
            
            
        if (x != boardWidth - 1) {
            if (!squareIsRevealed[x + 1][y + 1] && !squareHasMine[x + 1][y + 1] && countNearbyMines(x + 1, y + 1) == 0) {
                recursiveClick(x + 1, y + 1);
            }
            if (!squareHasMine[x + 1][y + 1]) {
                squareIsRevealed[x + 1][y + 1] = true;
            }
        }
    }
}
