class FlowField {
  PVector position;
  int w, h;
  int cellsH, cellsV;
  float cellSide;

  PVector[][] forces;

  float scl = 0.0007;
  float tStep = 0.004;

  int flowDisplayMax = 20;

  FlowField(PVector position_, int w_, int h_, int resolution_) {
    position = position_;
    w = w_;
    h = h_;
    cellSide = min(width, height) / resolution_;
    cellsH = ceil(width / cellSide);
    cellsV = ceil(height / cellSide);
    forces = new PVector[cellsH][cellsV];
  }
  
  PVector lookup(PVector l) {
    int i = constrain(floor(l.x / cellSide), 0, cellsH - 1);
    int j = constrain(floor(l.y / cellSide), 0, cellsV - 1);
    return forces[i][j];
  }
  
  PVector drag(Particle p) {
    float speed = p.velocity.mag();
    float magnitude = 100 * speed * speed;
    PVector drag = p.velocity.copy();
    drag.normalize();
    drag.mult(-magnitude);
    return drag;
  }

  void update(float t_) {
    for (int j = 0; j < cellsV; j++) {
      for (int i = 0; i < cellsH; i++) {
        float noiseval = noise(i * cellSide * scl, j * cellSide * scl, t_);
        float angle = map(noiseval, 0, 1, 0, 8 * PI);
        PVector force = PVector.fromAngle(angle);
        force.normalize();
        forces[i][j] = force;
      }
    }
  }

  void render(int method) {
    if (method > 0) {
      for (int j = 0; j < cellsV; j++) {
        for (int i = 0; i < cellsH; i++) {

          PVector force = forces[i][j];

          switch(method) {

          case 1:
          
            PVector arrow = force.copy().normalize().mult(cellSide / 2);

            float x1 = i * cellSide + cellSide / 2;
            float y1 = j * cellSide + cellSide / 2;

            float x2 = x1 + arrow.x;
            float y2 = y1 + arrow.y;

            float d = cellSide * 0.1;

            noStroke();
            fill(100);
            ellipse(x1, y1, d, d);

            stroke(100);
            strokeWeight(1);
            line(x1, y1, x2, y2);

            break;
          case 2:

            float angle = force.heading();

            float x = i * cellSide;
            float y = j * cellSide;

            float a;
            if (angle < 0) {
              a = map(angle, -PI, 0, 0, flowDisplayMax);
            } else {
              a = map(angle, 0, PI, flowDisplayMax, 0);
            }

            noStroke();
            fill(0, a);
            rect(x, y, cellSide, cellSide);

            break;

          case 3:

            float g = map(force.x, -1, 1, 255, 0);
            float b = map(force.y, -1, 1, 255, 0);

            noStroke();
            fill(0, g, b, flowDisplayMax);
            rect(i * cellSide, j * cellSide, cellSide, cellSide);

            break;
          }
        }
      }
    }
  }
}