import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Iterator; 
import java.util.HashSet; 
import pbox2d.*; 
import org.jbox2d.common.*; 
import org.jbox2d.collision.shapes.*; 
import org.jbox2d.dynamics.*; 
import org.jbox2d.dynamics.joints.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FileTreeAnimation extends PApplet {










PBox2D box2d;
ArrayList<CCommit> commits;
int prevCommitId;
CFileTree tree;

ControlP5 ui;
Textarea infoText;

CommitTimer timer;

String projectName;

// CButton nextButton;

public void setup()
{
  size(displayWidth, displayHeight, P2D);
  
  ui = new ControlP5(this);
  infoText = ui.addTextarea("info")
                .setPosition(10, 10)
                .setSize(200, 400)
                .setFont(createFont("arial",16))
                .setLineHeight(20)
                .setColor(color(0xffffffff))
                .setColorBackground(color(155));
  hideInfoText();
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  commits = new ArrayList<CCommit>();
  load();
  tree = null;

  // nextButton = new CButton("Next", new PVector(width/2, 20), 50, 25);
  timer = new CommitTimer();

  drawFirstCommit();
}

public void mouseMoved()
{ 
  Iterator it = tree.fileIt();
  while (it.hasNext ())
  {
    CFile file = (CFile)it.next();

    if (file.contains(mouseX, mouseY))
    {
      file.inputState = ObjectInputState.HOVER;
    }
    else
    {
      file.inputState = ObjectInputState.NONE;
    }
  }
}

public void mouseClicked()
{
  tree.resetCurrentDirectory();
  hideInfoText();
  clearInfoText();
  
  Iterator it = tree.fileIt();
  while(it.hasNext())
  {
    CFile file = (CFile)it.next();
    if (file.contains(mouseX, mouseY))
    {
      tree.currentDirectory(file);
      updateInfoText(file);
    }
  }
}

public void draw()
{
  background(0);
  noSmooth();
  
  box2d.step();

  tree.display();
}

public void updateInfoText(CFile file)
{
  clearInfoText();
  
  if (!infoText.isVisible())
  {
    showInfoText();
  }
  
  String info = "Project name: "+"\n"+
                "   "+tree.name()+"\n"+
                "\n"+
                "\n"+
                "Filename: "+file.name()+"\n"+
                "File type: "+file.typeAsString()+"\n"+
                "Number of children: "+file.numChildren()+"\n"
                ;
  infoText.setText(info);
}

public void clearInfoText()
{
  infoText.setText("");
}

public void hideInfoText()
{
  infoText.hide();
}

public void showInfoText()
{
  infoText.show();
}

public void load()
{
  println("loading xml....");
  XML xml = loadXML("commits.xml");
  XML[] commitElements = xml.getChildren("commit");
  XML root = commitElements[0].getParent();
  projectName = root.getString("name");

  for (int i = 0; i < commitElements.length; i++)
  {
    println("parsing commit.");
    XML commitElement = commitElements[i];
    CCommit commit = new CCommit(commitElement.getInt("id"));

    XML[] fileElements = commitElement.getChildren("file");
    for (int k = 0; k < fileElements.length; k++)
    {
      println("parsing commit files.");
      commit.addFileName(fileElements[k].getContent());
    }

    commits.add(commit);
  }

  println("done loading xml.");
}

public void drawFirstCommit()
{
  println("loading first commit.");

  // create the file tree for the project.
  tree = new CFileTree(projectName);


  // get the first commit.
  for (CCommit commit : commits)
  {
    if (commit.id() == 0)
    {
      prevCommitId = commit.id();

      Iterator it = commit.fileNameIt();
      while (it.hasNext ())
      {
        String s = (String)it.next();
        
        tree.addFileWithName(s);
      }
    }
  }
  timer.start();
}

public void drawNextCommit()
{
  tree.resetCurrentDirectory();
  
  int currId = prevCommitId + 1;

  for (CCommit commit : commits)
  {
    if (commit.id() == currId)
    {
      prevCommitId = commit.id();

      Iterator it = commit.fileNameIt();
      while (it.hasNext ())
      {
        String s = (String)it.next();
        
        tree.addFileWithName(s);
      }
    }
    
    if (commits.size() == currId)
    {
      timer.running = false;
    }
  }
}
public class CButton
{
  private String text;
  float x, y;
  float w, h;
  
  public CButton(String text,PVector pos, float w, float h)
  {
    this.text = text;
    x = pos.x;
    y = pos.y;
    this.w = w;
    this.h = h;
  }
  
  public void display()
  {
    pushMatrix();
    rectMode(CENTER);
    noStroke();
    fill(255);
    rect(x, y, w, h, 5);
    fill(0);
    textAlign(CENTER);
    text(text, x, y+5);
    popMatrix();
  }
  
  public void buttonWasPressed(float mX, float mY)
  {
    if (contains(mX, mY))
    {
      println(text+" button was pressed.");
      drawNextCommit();
    }
  }
  
  public boolean contains(float mX, float mY)
  {
    float left = x - w/2;
    float right = x + w/2;
    float top = y - h/2;
    float bottom = y + h/2;
    
    if ((mX > left) && (mX < right) && (mY > top) && (mY < bottom))
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  /*
  **  Getters and Setters for private variables.
  */
  
}
public class CCommit
{
  private ArrayList<String> fileNames;
  private int id;
  
  public CCommit(int id)
  {
    this.id = id;
    fileNames = new ArrayList<String>();
  }
  
  public void addFileName(String s)
  {
    fileNames.add(s);
  }
  
  /*
  **  Getters and Setters for private variables.
  */
  public int id() {return id;}
  public Iterator fileNameIt() {return fileNames.iterator();}
}
public class CFile
{
  private String name;
  private FileType type;
  public ObjectInputState inputState;

  private ArrayList<CFile> files;

  private int col;
  private int lineCol;

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
    fd.friction = 0.1f;
    fd.restitution = 0.5f;

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
    djd.frequencyHz = 2.5f;
    djd.dampingRatio = 0.9f;

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
  public void col(int c) {
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

public class CFileTree
{
  private ArrayList<CFile> files;
  private CFile rootDirectory;
  private CFile currentDirectory;
  private String projectName;

  public CFileTree(String name)
  {
    files = new ArrayList<CFile>();
    projectName = name;

    // create the top level directory.
    rootDirectory = new CFile(name, width/2, height/2, BodyType.STATIC);
    files.add(rootDirectory);
    currentDirectory = rootDirectory;
  }

  public void addFileWithName(String name)
  { 
    // split the string on '/' so we can follow the
    // file path.
    String[] s = name.split("/");

    // we want to start at root.
    CFile workingDir = rootDirectory;

    for (int i = 0; i < s.length; i++)
    {
      String nextName = s[i];
      if (!workingDir.exists(nextName))
      {
        // file doesn't exist, we need to create it.
        Vec2 pos = box2d.getBodyPixelCoord(workingDir.body());
        CFile nFile = new CFile(nextName, pos.x, pos.y, BodyType.DYNAMIC);
        workingDir.addFile(nFile);

        // we also want to keep a reference to this file in the tree.
        files.add(nFile);
        println("added "+nextName+" to dir: "+workingDir.name());
        workingDir = nFile;
      }
      else
      {
        // file does exist. set it as working directory.
        Iterator it = workingDir.fileIt();
        while (it.hasNext ())
        {
          CFile file = (CFile)it.next();
          if (match(file.name(), nextName) != null)
          {
            workingDir = file;
            break;
          }
        }
      }
    }
  }

  public void display()
  {
    currentDirectory.display();
    applyForces();
  }

  public void applyForces()
  {
    for (CFile file : files)
    {
      for (CFile f : files)
      {
        if (file != f)
        {
          file.push(f);
        }
      }
    }
  }

  /*
  **  Getters and Setters for private variables.
   */
  public Iterator fileIt() { 
    return files.iterator();
  }
  public String name() { 
    return projectName;
  }
  public CFile currentDirectory() {
    return currentDirectory;
  }
  public void currentDirectory(CFile file) 
  {
    currentDirectory = file;
    // currentDirectory.move(0,0);
  }
  public void resetCurrentDirectory() {currentDirectory = rootDirectory;}
}

public class CommitTimer extends Thread
{
  boolean running;
  public CommitTimer()
  {
    running = false;
  }
  
  public void start()
  {
    running = true;
    super.start();
  }
  
  public void run()
  {
    while(running)
    {
      try
      {
        sleep((long)(6000));
      }
      catch (Exception e)
      {
      }
      
      drawNextCommit();
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "FileTreeAnimation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
