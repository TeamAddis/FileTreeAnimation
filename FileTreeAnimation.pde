import java.util.Iterator;
import java.util.HashSet;
import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

PBox2D box2d;
ArrayList<CCommit> commits;
int prevCommitId;
CFileTree tree;

CButton nextButton;

void setup()
{
  size(800, 800, P2D);
  smooth();

  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);

  commits = new ArrayList<CCommit>();
  load();
  tree = null;

  nextButton = new CButton("Next", new PVector(width/2, 20), 50, 25);

  drawFirstCommit();
}

void mouseMoved()
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

void mouseClicked()
{
  nextButton.buttonWasPressed(mouseX, mouseY);
}

void draw()
{
  background(0);
  noSmooth();
  box2d.step();

  tree.display();

  gui();
}

void gui()
{
  nextButton.display();
}

void load()
{
  println("loading xml....");
  XML xml = loadXML("commits.xml");
  XML[] commitElements = xml.getChildren("commit");

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

void drawFirstCommit()
{
  println("loading first commit.");

  // create the file tree for the project.
  tree = new CFileTree("Test Project");


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
}

void drawNextCommit()
{
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
  }
}
