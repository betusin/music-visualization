import 'package:p5/PVector.dart';
import 'package:p5/p5.dart';

class Sketch extends PPainter {
  var strokes = <List<PVector>>[];

  @override
  void setup() {
    fullScreen();
  }

  @override
  void draw() {
    background(color(255, 255, 255));

    noFill();
    strokeWeight(10);
    stroke(color(10, 40, 200, 60));
    for (var stroke in strokes) {
      beginShape();
      for (var p in stroke) {
        vertex(p.x, p.y);
      }
      endShape();
    }
  }

  @override
  void mousePressed() {
    strokes.add([PVector(mouseX, mouseY)]);
  }

  @override
  void mouseDragged() {
    var stroke = strokes.last;
    stroke.add(PVector(mouseX, mouseY));
  }
}
