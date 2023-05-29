// This function is only called when mouse is clicked,
// since board does not need to be updated at any other point.
void drawBoard () {
    drawBackground();
    drawInstructions();
    drawSquares();
}

// Draw background
void drawBackground() {
    fill(200, 200, 200);
    rect(0, 0, width, height);
}

// Draw instructions
void drawInstructions() {
    textAlign(CORNER);
    fill(0, 0, 0);
    textSize(16);
    text("Left click: Reveal", 30, 30);
    text("Right click: Flag", 30, 50);
    text("period ( . ) : zoom in", 30, 70);
    text("comma ( , ): zoom out", 30, 90);
}

// Draw all squares on the board
void drawSquares() {
    for (int x = 0; x < boardWidth; x++) {
        for (int y = 0; y < boardHeight; y++) {
            if (squareIsRevealed[x][y]) {
                drawRevealedSquare(x, y);
            } else {
                drawUnrevealedSquare(x, y);
            }
        }
    }
}

// Draw square with coords (x, y) which has been clicked/revealed
void drawRevealedSquare(int x, int y) {
    fill(220, 220, 220);

    // Check if game is over
    if (gameWon) {
        fill(0, 220, 0);
    } else if (gameOver) {
        fill(220, 0, 0);
    }

    // Draw square
    square(boardStartX + x * pixelCount, boardStartY + y * pixelCount, pixelCount);

    // Draw number which shows the amount of nearby mines
    int minesNextTo = countNearbyMines(x, y);
    if (minesNextTo != 0) {
        fill(0, 0, 0);
        textSize(20);
        textAlign(CENTER, CENTER);
        text(minesNextTo, boardStartX + x * pixelCount + pixelCount / 2, boardStartY + y * pixelCount + pixelCount / 2);
    }

    // Draw mine if the square has one
    if (squareHasMine[x][y]) {
        drawMine(x, y);
    }
}

// Draw square with coords (x, y) which has not been clicked/revealed
void drawUnrevealedSquare(int x, int y) {
    fill(120, 120, 120);
    square(boardStartX + x * pixelCount, boardStartY + y * pixelCount, pixelCount);
    if (squareIsFlagged[x][y]) {
        fill(200, 0, 0);
        ellipseMode(CENTER);
        circle(boardStartX + x * pixelCount + pixelCount / 2, boardStartY + y * pixelCount + pixelCount / 2, pixelCount / 3);
    }
}

// Draw the mine in a square with coords (x, y)
void drawMine(int x, int y) {
    // Draw mine
    fill(0, 0, 0);
    ellipseMode(CORNER);
    circle(boardStartX + x * pixelCount, boardStartY + y * pixelCount, pixelCount);
    
    // Draw potential flag on top of mine
    if (squareIsFlagged[x][y]) {
        fill(255, 165, 0);
        ellipseMode(CENTER);
        circle(boardStartX + x * pixelCount + pixelCount / 2, boardStartY + y * pixelCount + pixelCount / 2, pixelCount / 3);
    }
}
