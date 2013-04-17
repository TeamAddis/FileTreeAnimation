import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

PBox2D box2d;

CFile topLevelDir;
ArrayList<CFile> files;

void setup()
{
  size(800, 800, P2D);
  smooth();
  
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  files = new ArrayList<CFile>();
  
  topLevelDir = new CFile(width/2, height/2, true);
  files.add(topLevelDir);
  
  // add a files to the top level directory.
  addTestFiles(topLevelDir);
  
  println(files.size());
}

void addTestFiles(CFile parent)
{
  // add a files to the top level directory.
  Vec2 pos = box2d.getBodyPixelCoord(parent.body);
  for (int i = 0; i < 5; i++)
  {
    CFile file = new CFile(pos.x, pos.y, false);
    files.add(file);
    
    if (i == 3 || i == 4)
    {
      // make a new directory.
      // and add new files.
      for (int k = 0; k < 2; k++)
      {
        CFile f = new CFile(pos.x, pos.y, false);
        files.add(f);
        file.addFile(f);
      }
    }
    // add the file to the parent.
    parent.addFile(file);
  }
}

void draw()
{
  background(0);
  
  box2d.step();
  
  topLevelDir.display();
  
  applyForces();
}

void mouseMoved()
{
  color hoverColor;     // the hover color.
  for (CFile file : files)
  {
    if (file.contains(mouseX, mouseY))
    {
      
    }
  }
}

void applyForces()
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

