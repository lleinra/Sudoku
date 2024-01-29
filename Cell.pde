class Cell {
  int x;
  int y;
  int i;
  int j;
  int value = 0;
  ArrayList<Integer> valuePool;
  String state = "";

  Cell(int x, int y, int i, int j) {
    this.x = x;
    this.y = y;
    this.i = i;
    this.j = j;
    valuePool = new ArrayList<Integer>();
    setValuePool();
  }

  void setValuePool() {
    valuePool.clear();
    for (int i = 1; i < 10; i++) {
      valuePool.add(i);
    }
  }

  int takeValueFromPool() {
    int randomIndex = (int)random(valuePool.size());
    int value = valuePool.get(randomIndex);
    valuePool.remove(randomIndex);
    return value;
  }

  Boolean isClicked() {
    int x = mouseX;
    int y = mouseY;
    return this.x < x && this.x + RAD > x && this.y < y && this.y + RAD > y;
  }

  void show() {
    stroke(0);
    strokeWeight(1);
    if (value == 0) {
      fill(0, 0, 0);
    } else {
      fill(0, 0, 50);
    }
    for (Cell cell : board.missingCells) {
      if (this == cell) {
        fill(0, 0, 255);
      }
    }
    if (state == "correct") {
      fill(100, 100, 255);
    } else if (state == "wrong") {
      fill(250, 100, 255);
    } else if (state == "unknown") {
      fill(50, 100, 255);
    }
    if (this == board.currentCell) {
      fill(50, 255, 255);
      //fill(0, 0, 255);
    }
    if (board.highlightedCells.contains(this)) {
      fill(40, 100, 100);
    }
    if (this == changingValueCell) {
      fill(50, 255, 255);
    }
    square(x, y, RAD);
    float textColor = map(value, 1, 10, 0, 255);
    fill(textColor, 255, 255);
    textSize(RAD);
    textAlign(CENTER, CENTER);
    if (value != 0) {
      text(value, x + RAD / 2, y + RAD / 3);
    }
  }
}
