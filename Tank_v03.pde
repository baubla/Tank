ArrayList<Particle> particles;
FlowField ff;

PFont f;

float reputation = 0;

float t = 0;

int flowDisplay = 3;

float edge = 200;

float weightRepel = 2;
float weightFlow = 7;
float weightFlee = 0.5;
float weightEdges = 20;

int maxParticles = 1000;

void setup() {
  //size(1280, 720);
  fullScreen();
  frameRate(30);
  
  particles = new ArrayList<Particle>();
  ff = new FlowField(new PVector(0, 0), width, height, 50);
  
  f = createFont("Arial", 100);
}

void draw() {
  background(255);
  ff.update(t);
  ff.render(flowDisplay);
  
  if (mousePressed && particles.size() < maxParticles) {
    particles.add(new Particle());
    reputation = constrain(reputation + 0.00005 * (particles.size() - 1), -1, 1);
  }
  
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    
    for (int j = particles.size() - 1; j >= 0; j--) {
      if (i != j) {
        PVector repel = p.repel(particles.get(j));
        repel.mult(weightRepel);
        p.applyForce(repel);
      }
    }

    PVector mouse = new PVector(mouseX, mouseY);
    PVector flee = p.flee(mouse);
    flee.mult(weightFlee);
    p.applyForce(flee);
    
    PVector flow = ff.lookup(p.position);
    flow.mult(weightFlow);
    p.applyForce(flow);
    
    //PVector drag = ff.drag(p);
    //p.applyForce(drag);
    
    PVector edges = new PVector(0, 0);
    if (p.position.x < edge) { edges.x = 1 - p.position.x / edge; }
    if (p.position.x > ff.w - edge) { edges.x = -1 + (ff.w - p.position.x) / edge; }
    if (p.position.y < edge) { edges.y = 1 - p.position.y / edge; }
    if (p.position.y > ff.h - edge) { edges.y = -1 + (ff.h - p.position.y) / edge; }
    edges.mult(weightEdges);
    p.applyForce(edges);
    
    p.update();
    p.display();
  }
  
  t = t + ff.tStep;
  
  //fill(100);
  //textFont(f);
  //textAlign(LEFT);
  //text(t, 0, 90);
  
  //text(reputation, 0, height - 10);
  
  //textAlign(RIGHT);
  //text(frameRate, width - 10, 90);
  
  //text(particles.size(), width - 10, height - 10);

}

void keyPressed() {
  if (key == '0') {
    flowDisplay = 0;
  }
  if (key == '1') {
    flowDisplay = 1;
  }
  if (key == '2') {
    flowDisplay = 2;
  }
  if (key == '3') {
    flowDisplay = 3;
  }
  if (key == ' ') {
    int particlesRemoved = 0;
    for (int i = particles.size() - 1; i >= 0; i--) {
      if (random(0, 1) < 0.20) {
        particles.remove(i);
        particlesRemoved++;
      }
    }
    if (particlesRemoved > 0) {
      if (particles.size() == 0) {
        reputation = 0;
      } else {
        reputation = constrain(reputation - 0.00005  * particles.size() * particlesRemoved, -1, 1);
      }
    }
  }
}