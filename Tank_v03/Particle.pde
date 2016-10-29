class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float mass;
  float density;
  
  float diameter;
  
  color c;
  
  Particle() {
    float px = mouseX + random(-20, 20);
    float py = mouseY + random(-20, 20);
    position = new PVector(px, py);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = random(2, 50);
    density = random(0.25, 1);
    c = color(random(255), random(255), random(255), density * 255);
    diameter = 5 * sqrt(4 * mass / (PI * density));
  }
  
  PVector repel(Particle p) {
    float d1 = diameter;
    float d2 = p.diameter;
    PVector vectorBetween = PVector.sub(position, p.position);    
    float distance = vectorBetween.mag() - d1 / 2 - d2 / 2;
    distance = constrain(distance, 1, 200);
    float strength = 1 - exp(1 - distance / 200);
    vectorBetween.normalize();
    return vectorBetween.mult(-strength);
  }
  
  PVector flee(PVector m) {
    PVector vectorBetween = PVector.sub(position, m);
    float distance = vectorBetween.mag();
    distance = constrain(distance, 0, 250);
    float strength = 1 - exp(1 - distance / 250);
    vectorBetween.normalize();
    return vectorBetween.mult(strength * reputation * mass);
  }
  
  void applyForce(PVector force_) {
    PVector force = PVector.div(force_, mass);
    acceleration.add(force);
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(2);
    position.add(velocity);
    float x = position.x;
    float y = position.y;
    if (x - diameter / 2 < 0) { position.x = diameter / 2; velocity.x = 0; }
    if (x + diameter / 2 > width) { position.x = width - diameter / 2; velocity.x = 0; }
    if (y - diameter / 2 < 0) { position.y = diameter / 2; velocity.y = 0; }
    if (y + diameter / 2 > height) { position.y = height - diameter / 2; velocity.y = 0; }
    acceleration.mult(0);
  }
  
  void display() {
    noStroke();
    fill(c);
    ellipse(position.x, position.y, diameter, diameter);
  }
}