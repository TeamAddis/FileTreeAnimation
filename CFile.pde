class CFile 
{
  private String name;                                     // the name of the file.
  FileType type;                                   // the file type.
  ObjectInputState inputState;                    // the inpute state of the object.
  
  ArrayList<CFile> files;                          // list of children files.
  
  color col;                                       // the color.
  
  // We need to keep track of a Body and a radius
  Body body;
  float r;
  
  public CFile(String name) 
  {
    this.name = name;
    this.r = (25/2);
    this.type = FileType.ASCII;
    this.inputState = ObjectInputState.NONE;
    
    this.files = new ArrayList<CFile>();
  }
  
  public void createBody(float x, float y, BodyType type)
  {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x,y);
    bd.type = type;
    this.body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = 0.5;
    
    // Attach fixture to body
    this.body.createFixture(fd);
    this.body.setLinearVelocity(new Vec2(random(-1, 1), random(1, 2)));
  }
  
  private void pickColor()
  {
    // check for file type.
    switch (this.type)
    {
      case ASCII:
      {
        // set the normal color of an ascii file.
        col = color(0xffB2B2B2);
        return;
      }
      case FOLDER:
      {
        col = color(0xffff0000);
        return;
      }
      default:{return;}
    }
  }
  
  void checkInputState()
  {
    switch (this.inputState)
        {
          case NONE:
          {
            // use this so we can reset the input state.
            return;
          }
          case HOVER:
          {
            this.col = color(0xff96FF00);
            for (CFile file : files)
            {
              file.col = color(0xffffff00);
            }
            return;
          }
          case SELECTED:
          {
            return;
          }
          default:{return;}
        }
  }

  // This function removes the particle from the box2d world
  void killBody() 
  {
    box2d.destroyBody(body);
  }
  
  // Is the particle ready for deletion?
  boolean done() 
  {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  void display() 
  {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    for (CFile f : files)
    {
      // draw a line from the center of the parent
      // to the children.
      stroke(255);
      Vec2 childPos = box2d.getBodyPixelCoord(f.body);
      line(pos.x, pos.y, childPos.x, childPos.y);
      f.display();
    }
    
    pushMatrix();
    translate(pos.x,pos.y);
    pickColor();
    checkInputState();
    fill(col);
    noStroke();
    strokeWeight(1);
    ellipse(0,0,r*2,r*2);
    
    fill(col);
    text(name, r*2, -r*2);
    popMatrix();
  }
  
  void applyForce(Vec2 v)
  {
    body.applyForce(v, body.getWorldCenter());
  }
  
  void addFile(CFile f)
  {
    // create the joint between parent and
    // the file we are added. This joint will
    // act like a spring keeping the file from
    // wandering far from its parent.
    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = body;
    djd.bodyB = f.body;
    
    // equilibrium length
    djd.length = box2d.scalarPixelsToWorld(100.0f);
    
    // spring properties
    djd.frequencyHz = 2.5;
    djd.dampingRatio = 0.9;
    
    DistanceJoint dj = (DistanceJoint)box2d.world.createJoint(djd);
    
    files.add(f);
    
    // since we added a file to this file
    // we will label it as a folder.
    type = FileType.FOLDER;
  }
  
  void push(CFile b)
  {
    float G = 5;
    
    Vec2 pos = body.getWorldCenter();
    Vec2 boxPos = b.body.getWorldCenter();
    
    // vector pointing from this object to the other box.
    Vec2 force = boxPos.sub(pos);
    float distance = force.length();
    
    // keep force within bounds.
    distance = constrain(distance, 1, box2d.scalarPixelsToWorld(5.0f));
    force.normalize();
    
    float strength = (G * body.m_mass * b.body.m_mass) / (distance * distance);
    force.mulLocal(strength);
    
    b.applyForce(force);
  }
  
   boolean contains(float x, float y) {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }
  
  /*
  **  Getters and Setters for private variables.
  */
  public String name() {return name;}
}
