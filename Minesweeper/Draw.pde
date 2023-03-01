
// this function is only called when mouse is clicked,
// since board does not need to be updated at any other point.
void drawBoard () {
    drawBackground();
    textAlign(CORNER);
    fill(0, 0, 0);
    textSize(16);
    text("Left click: reveal", 30, 30);
    text("Right click: Flag", 30, 50);
    text("period ( . ) : zoom in", 30, 70);
    text("comma ( , ): zoom out", 30, 90);
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
                int minesNextTo = countNearbyMines(i, j);
                if (minesNextTo != 0) {
                    fill(0, 0, 0);
                    textSize(20);
                    textAlign(CENTER, CENTER);
                    text(minesNextTo, boardStartX + i * pixelCount + pixelCount / 2, boardStartY + j * pixelCount + pixelCount / 2);
                }
                if (squareHasMine[i][j]) {
                    fill(0, 0, 0);
                    ellipseMode(CORNER);
                    circle(boardStartX + i * pixelCount, boardStartY + j * pixelCount, pixelCount);
                    if (squareIsFlagged[i][j]) {
                        fill(255, 165, 0);
                        ellipseMode(CENTER);
                        circle(boardStartX + i * pixelCount + pixelCount / 2, boardStartY + j * pixelCount + pixelCount / 2, pixelCount / 3);
                    }
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
