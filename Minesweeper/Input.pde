void mouseClicked() {
    int xm = mouseX;
    int ym = mouseY;
    if (!gameWon && !gameOver) {
        if (mouseButton == LEFT) {
            int x = (xm - boardStartX) / pixelCount;
            int y = (ym - boardStartY) / pixelCount;
            print("clicked square " + x + " " + y);
            if (x >= 0 && y >= 0 && x < boardWidth && y < boardHeight) {
                clickSquare(x, y);
                print(", SUCCESS");
            }
            if (hasWon()) {
                setGameWon();
            }
            println("");
        }
        else if (mouseButton == RIGHT) {
            int x = (xm - boardStartX) / pixelCount;
            int y = (ym - boardStartY) / pixelCount;
            flagOrUnflagSquare(x, y);
        }
    }
    drawBoard();
}

void keyPressed() {
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
