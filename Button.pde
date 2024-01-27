class Button {
  int x;
  int y;
  String str;
  int txtSize;
  int fillVal = 50;
  Boolean isToggled = false;

  Button(int x, int y, String str, int txtSize) {
    this.x = x;
    this.y = y;
    this.str = str;
    this.txtSize = txtSize;
  }

  Boolean isClicked(int x, int y) {
    return this.x < x && this.x + 250 > x && this.y < y && this.y + 75 > y;
  }

  void show() {
    stroke(0);
    strokeWeight(1);
    if (isToggled) {
      fill(150);
    } else {
      fill(50);
    }
    if (this == solveBtn || this == instantSolveBtn) {
      strokeWeight(1);
      fill(150);
    }
    rect(x, y, 250, 75);
    if (isToggled) {
      fill(0);
    } else {
      fill(255);
    }
    textSize(txtSize);
    text(str, x + 125, y + 30);
  }
}
