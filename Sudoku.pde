/* Sudoku
 A 9×9 square must be filled in with numbers from 1-9 with no repeated numbers in each line,
 horizontally or vertically. There are 3×3 squares marked out in the grid,
 and each of these squares can't have any repeat numbers either.
 */
/* Sudoku Board
 In all 9 sub matrices 3×3 the elements should be 1-9, without repetition.
 In all rows there should be elements between 1-9 , without repetition.
 In all columns there should be elements between 1-9 , without repetition.
 */
/* Features:
 -----button to generating board cell by cell
 -----button to generate board instantly
 -----ability to put answers
 -----toggle to change computer generated values
 -----check validity without submitting
 -----submit button
 -----restart board
 -----clicking numbers while not changing board highlights cells with similar value
 */
/* pending:
 autosolve: slow and instant
 stop overwriting user-generated numbers
 better color scheme
 */

import java.util.*;
Difficulty difficulty = new Difficulty();
Board board;
final int RAD = 75;
ArrayList<Button> buttons;
Cell changingValueCell = null;
Button generateBtn;
Button instantGenBtn;
Button toggleBtn;
Button refreshBtn;
Button validityBtn;
Boolean isShowingValidity;
Button submitBtn;
Button restartBtn;
Button solveBtn;
Button instantSolveBtn;

void setup() {
  size(1100, 800);
  colorMode(HSB, 255);
  setBoard();
  buttons = new ArrayList<Button>();
  generateBtn = new Button(50, 70, "Start", 50);
  instantGenBtn = new Button(50, 170, "Generate Instantly", 25);
  toggleBtn = new Button(50, 270, "Change Board", 35);
  refreshBtn = new Button(50, 370, "Reset Answers", 30);
  validityBtn = new Button(50, 470, "Check Validity", 30);
  submitBtn = new Button(50, 570, "Submit", 50);
  restartBtn = new Button(50, 670, "Restart", 50);
  solveBtn = new Button(435, 710, "Solve", 50);
  instantSolveBtn = new Button(710, 710, "Instant Solve", 35);
  buttons.add(generateBtn);
  buttons.add(instantGenBtn);
  buttons.add(toggleBtn);
  buttons.add(refreshBtn);
  buttons.add(validityBtn);
  buttons.add(submitBtn);
  buttons.add(restartBtn);
  buttons.add(solveBtn);
  buttons.add(instantSolveBtn);
  display();
}

void setBoard() {
  isShowingValidity = false;
  board = new Board(360, 25);
}

void draw() {
  if (!board.isDone) {
    if (!board.isInstantGenerate) {
      if (board.isGenerating) {
        board.generate();
      }
    } else {
      while (board.isGenerating) {
        board.generate();
      }
    }
  } else {//if board is done
    if (board.missingCells.isEmpty()) {
      board.removeRandomNumbers(difficulty.hard);
      board.cellStack.clear();
    } else {
      if (board.isSolving) {
        if (board.currentCell == null) {
          board.currentCell = board.missingCells.get(0);
        }
        if (board.isInstantSolve) {
          while (board.currentCell != null) {
            board.solve();
          }
        } else {
          board.solve();
          delay(25);
        }
      }
    }
  }
  display();
}

void mousePressed() {
  if (board.isDone) {
    for (Cell cell : board.missingCells) {
      if (cell.isClicked()) {//if one of missing cells is clicked
        if (cell == changingValueCell) {//and if that cell is the cell currently being changed
          changingValueCell = null;
        } else {
          changingValueCell = cell;
        }
        return;
      }
    }
    if (solveBtn.isClicked()) {
      if (board.missingCells.get(board.missingCells.size() - 1).value != 0) {
        board.resetMissingCells();
      }
      board.isSolving = board.isSolving == true ? false : true;
      return;
    }
    if (instantSolveBtn.isClicked()) {
      if (board.missingCells.get(board.missingCells.size() - 1).value != 0) {
        board.resetMissingCells();
      }
      board.isSolving = true;
      board.isInstantSolve = true;
      return;
    }
  }
  Cell clickedCell = getClickedCell();
  if (clickedCell != null) {
    /*if a cell is clicked,
     and if board is being changed,
     -and if the clicked cell is the cell being changed,
     --then remove that as the cell being changed.
     -otherwise, if the clicked cell is not the cell being changed,
     --then set that as the clicked cell.
     */
    if (board.isChanging) {
      if (clickedCell == changingValueCell) {
        changingValueCell = null;
        return;
      }
      changingValueCell = clickedCell;
      return;
    } else {//
      /*if board is not being changed
       and if the clicked cell is part of the highlighted cells,
       -then remove the highlights
       otherwise, if clicked cell is not part of the highlighted cells,
       -then set the cells with similar value as the highlighted cells.
       */
      if (board.highlightedCells.contains(clickedCell)) {
        board.highlightedCells.clear();
        return;
      }
      board.highlightedCells.clear();
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          Cell cell = board.cells[i][j];
          if (cell.value == 0) {
            continue;
          }
          if (clickedCell.value == cell.value) {
            board.highlightedCells.add(cell);
          }
        }
      }
      return;
    }
  }
  if (toggleBtn.isClicked()) {
    //update toggle button and if board is being changed
    changingValueCell = null;
    if (board.isChanging) {
      toggleBtn.isToggled = false;
      board.isChanging = false;
    } else {
      toggleBtn.isToggled = true;
      board.isChanging = true;
    }
  }
  if (refreshBtn.isClicked()) {
    //refresh missing cells
    board.resetMissingCells();
    board.currentCell = null;
  }
  if (validityBtn.isClicked()) {
    if (!board.isDone) {
      return;
    }
    isShowingValidity = isShowingValidity ? false : true;
    board.highlightedCells.clear();
    if (board.missingCells.get(0).state != "") {
      for (Cell cell : board.missingCells) {
        cell.state = "";
      }
      return;
    }
  }
  if (submitBtn.isClicked()) {
    board.highlightedCells.clear();
    board.validateAnswer();
    Boolean hasWrongAnswer = board.missingCells.isEmpty() ? true : false;
    for (Cell cell : board.missingCells) {
      if (cell.state != "correct") {
        cell.state = "wrong";
        hasWrongAnswer = true;
      }
    }
    if (!hasWrongAnswer) {
      println("done");
    } else {
      println("wrong");
    }
  }
  if (restartBtn.isClicked()) {
    setup();
  }
  if (generateBtn.isClicked()) {
    if (board.isDone) {
      setBoard();
    }
    toggleStartButton();
  }
  if (instantGenBtn.isClicked()) {
    if (board.isDone) {
      setBoard();
    }
    if (board.currentCell == null) {
      board.currentCell = board.cells[0][0];
    }
    board.isInstantGenerate = true;
    board.isGenerating = true;
  }
}

void toggleStartButton() {
  if (board.isGenerating) {
    board.isGenerating = false;
  } else {
    if (board.currentCell == null) {
      board.currentCell = board.cells[0][0];
    }
    board.isGenerating = true;
  }
}

Cell getClickedCell() {
  for (int i = 0; i < 9; i++) {
    for (int j = 0; j < 9; j++) {
      Cell cell = board.cells[i][j];
      if (cell.isClicked()) {
        return cell;
      }
    }
  }
  return null;
}

void keyPressed() {
  if (changingValueCell == null) {
    return;
  }
  for (int i = 0; i < 10; i++) {
    if (key == Integer.toString(i).charAt(0)) {
      changingValueCell.value = i;
      changingValueCell.state = "";
      if (!board.highlightedCells.isEmpty()) {
        board.highlightedCells.remove(changingValueCell);
        if (board.highlightedCells.get(0).value == changingValueCell.value) {
          board.highlightedCells.add(changingValueCell);
        }
      }
      changingValueCell = null;
    }
  }
}

void display() {
  background(100, 100, 100);
  board.show();
  for (Button button : buttons) {
    if (button == solveBtn || button == instantSolveBtn) {
      if (board.isDone) {
        button.show();
      }
    } else {
      button.show();
    }
  }
  if (isShowingValidity) {
    board.validateAnswer();
  }
  generateBtn.str = board.isGenerating ? "Stop" : "Start";
}
