// Debug/cheat settings
boolean onlyTwoMinesUpperLeftCorner; // Overrides numMines

// Visual settings
int pixelCount;  // pixels per square side
int boardStartX;
int boardStartY;

// Difficulty settings
String difficulty;    // "Supersmall", "Beginner", "Intermediate" or "Expert"
int boardWidth;       // Depending on difficulty: 2, 9, 16, 30
int boardHeight;      // Depending on difficulty: 2, 9, 16, 16
int numMines;         // Depending on difficulty: 2, 10, 40, 99

// Game state
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
    pixelCount = 25;  // pixels per side of square
    boardStartX = 30;
    boardStartY = 150;

    // Difficulty settings
    difficulty = "Expert"; // "Supersmall", "Beginner", "Intermediate" or "Expert"
    setDifficulty();

    // Important  variables
    squareHasMine = new boolean[boardWidth][boardHeight];
    squareIsRevealed = new boolean[boardWidth][boardHeight];
    squareIsFlagged = new boolean[boardWidth][boardHeight];
    gameOver = false;
    gameWon = false;

    // Setup functions
    setupBoard();
    drawBackground();
    drawBoard();
}

void draw() {
    // Need to have this method in order for mouseClicked() to work correctly.
}
