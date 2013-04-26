public class CFile
{
  private String name;
  private FileType type;
  public ObjectInputState inputState;

  private ArrayList<CFile> files;

  private color col;
  private color lineCol;

  private Body body;
  private BodyDef bd;
  private float r;                               

  public CFile(String name, float x, float y, BodyType type)
  {
    this.name = name;
    files = new ArrayList<CFile>();
    this.type = FileType.ASCII;
    inputState = ObjectInputState.NONE;
    r = (10/2);

    // Define a body.
    bd = new BodyDef();

    // set its position.
    bd.position = box2d.coordPixelsToWorld(x, y);

    // set the body type.
    bd.type = type;

    body = box2d.world.createBody(bd);

    // make the body'd shape a circle.
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    // create a fixture def.
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;

    // Paraeters that affect physics.
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = 0.5;

    // attach fixture to body.
    body.createFixture(fd);
    body.setLinearVelocity(new Vec2(random(-1, 1), random(1, 2)));

    col = color(175);
    lineCol = color(255);
  }

  // This function removes the particle from the box2d world
  private void killBody() 
  {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  private boolean done() 
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
    default:
      {
        return;
      }
    }
  }

  private void checkInputState()
  {
    switch (this.inputState)
    {
    case NONE:
      {
        // use this so we can reset the input state.
        lineCol = color(255);
        noStroke();
        return;
      }
    case HOVER:
      {
        lineCol = color(0xff00FFDD);
        stroke(color(0xff96FF00));
        strokeWeight(3);
        for (CFile file : files)
        {
          file.inputState = ObjectInputState.HOVER;
        }
        return;
      }
    default:
      {
        return;
      }
    }
  }

  public void display()
  {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);

    for (CFile f : files)
    {
      // draw a line from the center of the parent
      // to the children.
      pushMatrix();
      stroke(lineCol);
      strokeWeight(1);
      Vec2 childPos = box2d.getBodyPixelCoord(f.body);
      line(pos.x, pos.y, childPos.x, childPos.y);
      popMatrix();
      f.display();
    }

    pushMatrix();
    translate(pos.x, pos.y);
    pickColor();
    checkInputState();
    fill(col);
    ellipse(0, 0, r*2, r*2);
    fill(col);
    text(name, r*2, -r*2);
    popMatrix();
  }

  public boolean exists(String fileName)
  {
    boolean flag = false;
    for (CFile file : files)
    {
      if (match(file.name(), fileName) != null)
      {
        flag = true;
        break;
      }
    }
    return flag;
  }

  public void addFile(CFile f)
  {
    // create the joint between parent and
    // the file we are added. This joint will
    // act like a spring keeping the file from
    // wandering far from its parent.
    DistanceJointDef djd = new DistanceJointDef();
    djd.bodyA = body;
    djd.bodyB = f.body;

    // equilibrium length
    djd.length = box2d.scalarPixelsToWorld(50.0f);

    // spring properties
    djd.frequencyHz = 2.5;
    djd.dampingRatio = 0.9;

    DistanceJoint dj = (DistanceJoint)box2d.world.createJoint(djd);

    files.add(f);

    // since we added a file to this file
    // we will label it as a folder.
    type = FileType.FOLDER;
  }

  private void applyForce(Vec2 v)
  {
    body.applyForce(v, body.getWorldCenter());
  }

  public void push(CFile b)
  {
    float G = 1;

    Vec2 pos = body.getWorldCenter();
    Vec2 boxPos = b.body.getWorldCenter();

    // vector pointing from this object to the other box.
    Vec2 force = boxPos.sub(pos);
    float distance = force.length();

    // keep force within bounds.
    distance = constrain(distance, 1, box2d.scalarPixelsToWorld(20.0f));
    force.normalize();

    float strength = (G * body.m_mass * b.body.m_mass) / (distance * distance);
    force.mulLocal(strength);

    b.applyForce(force);
  }

  public boolean contains(float x, float y) 
  {
    Vec2 worldPoint = box2d.coordPixelsToWorld(x, y);
    Fixture f = body.getFixtureList();
    boolean inside = f.testPoint(worldPoint);
    return inside;
  }

  /*
  **  Getters and Setters for private variables.
   */
  public String name() {
    return name;
  }
  public int numChildren() {return files.size();}
  public Iterator fileIt() {
    return files.iterator();
  }
  public Body body() {
    return body;
  }
  public void col(color c) {
    col = c;
  }
  public String typeAsString()
  {
    // check for file type.
    switch (this.type)
    {
    case ASCII:
      {
        return "ascii";
      }
    case FOLDER:
      {
        return "folder";
      }
    default:
      {
        return "";
      }
    }
  }
}

