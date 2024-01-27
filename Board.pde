class Difficulty {
  public final int easy = 10;
  public final int medium = 20;
  public final int hard = 30;
}

class Board {
  int x;
  int y;
  Cell[][] cells = new Cell[9][9];
  Boolean isGenerating = false;
  Boolean isInstantGenerate = false;
  Boolean isDone = false;
  Boolean isChanging = false;
  Stack<Cell> cellStack = new Stack<Cell>();
  Cell currentCell = null;
  ArrayList<Cell> missingCells = new ArrayList<Cell>();
  ArrayList<Cell> highlightedCells = new ArrayList<Cell>();
  Boolean isSolving = false;
  Boolean isInstantSolve = false;

  Board(int x, int y) {
    this.x = x;
    this.y = y;
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        cells[i][j] = new Cell(x + (j * RAD), y + (i * RAD), i, j);
      }
    }
  }

  void solve() {
    if (!currentCell.valuePool.isEmpty()) {
      currentCell.value = currentCell.takeValueFromPool();
    } else {
      currentCell.value = 0;
      currentCell.setValuePool();
      currentCell = cellStack.pop();
      return;
    }
    if (isValid(currentCell)) {
      cellStack.push(currentCell);
      do {
        currentCell = getNextCell(currentCell);
      } while (!missingCells.contains(currentCell) && currentCell != null);
    }
    if (currentCell == null) {
      isSolving = false;
      isInstantSolve = false;
      return;
    }
  }

  void generate() {
    if (currentCell != null) {
      cellStack.push(currentCell);
      currentCell.value = currentCell.takeValueFromPool();
      if (isValid(currentCell)) {
        currentCell = getNextCell(currentCell);
      } else {
        if (!currentCell.valuePool.isEmpty()) {
          cellStack.pop();
        } else {
          cellStack.pop();
          do {
            currentCell.setValuePool();
            currentCell.value = 0;
            currentCell = cellStack.pop();
          } while (currentCell.valuePool.isEmpty());
        }
      }
    } else {
      isDone = true;
      isGenerating = false;
    }
  }

  void validateAnswer() {
    for (Cell cell : missingCells) {
      if (cell.value == 0) {
        cell.state = "unknown";
      } else if (!isValid(cell)) {
        cell.state = "wrong";
      } else {
        cell.state = "correct";
      }
    }
  }

  Cell getNextCell(Cell cell) {
    int i = cell.i;
    int j = cell.j;
    if (j + 1 < 9) {
      j += 1;
    } else {
      i += 1;
      j = 0;
    }
    if (i >= 9) {
      return null;
    }
    return cells[i][j];
  }

  void resetMissingCells() {
    if (!missingCells.isEmpty()) {
      missingCells.forEach(cell -> {
        cell.value = 0;
        cell.state = "";
        cell.setValuePool();
      }
      );
    }
  }

  void removeRandomNumbers(int count) {
    List<Cell> toRemove = new ArrayList<Cell>();
    for (int i = 0; i < count; i++) {
      Cell cell;
      do {
        int indexI = floor(random(9));
        int indexJ = floor(random(9));
        cell = cells[indexI][indexJ];
        cell.value = 0;
      } while (toRemove.contains(cell));
      toRemove.add(cell);
    }
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        Cell cell = cells[i][j];
        if (toRemove.contains(cell)) {
          missingCells.add(cell);
        }
      }
    }
    resetMissingCells();
  }

  Boolean isValid(Cell cell) {
    int value = cell.value;
    int i = cell.i;
    int j = cell.j;
    if (lineInvalid(value, i, j) || blockInvalid(value, i, j)) {
      return false;
    }
    return true;
  }

  Boolean blockInvalid(int value, int row, int column) {
    Cell centerCell = getCenterCell(row, column);
    int indexI = centerCell.i;
    int indexJ = centerCell.j;
    for (int i = indexI - 1; i < indexI + 2; i++) {
      for (int j = indexJ - 1; j < indexJ + 2; j++) {
        if (i == row && j == column) {
          continue;
        }
        if (cells[i][j].value == value) {
          return true;
        }
      }
    }
    return false;
  }

  Cell getCenterCell(int i, int j) {
    int jQuotient = floor(j / 3);
    int indexJ = jQuotient * 3 + 1;
    int iQuotient = floor(i / 3);
    int indexI = iQuotient * 3 + 1;
    return cells[indexI][indexJ];
  }

  Boolean lineInvalid(int value, int row, int column) {
    for (int i = 0; i < 9; i++) {
      if (i == column) {
        continue;
      }
      if (cells[row][i].value == value) {
        return true;
      }
    }
    for (int i = 0; i < 9; i++) {
      if (i == row) {
        continue;
      }
      if (cells[i][column].value == value) {
        return true;
      }
    }
    return false;
  }

  void show() {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        cells[i][j].show();
      }
    }
    strokeWeight(5);
    line(x, y, x + RAD * 9, y);
    line(x, y, x, y + RAD * 9);
    line(x + RAD * 9, y + RAD * 9, x + RAD * 9, y);
    line(x + RAD * 9, y + RAD * 9, x, y + RAD * 9);
    line(x + RAD * 3, y, x + RAD * 3, y + RAD * 9);
    line(x + RAD * 6, y, x + RAD * 6, y + RAD * 9);
    line(x, y + RAD * 3, x + RAD * 9, y + RAD * 3);
    line(x, y + RAD * 6, x + RAD * 9, y + RAD * 6);
  }
}
