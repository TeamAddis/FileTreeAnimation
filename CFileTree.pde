public class CFileTree
{
  private String name;
  CFile parent;                                  // Top Level Directory.
  private ArrayList<CFile> files;                // contains all files in tree.

  public CFileTree(String projectName)
  {
    files = new ArrayList<CFile>();
    name = projectName;
    parent = null;
  }
  
  public void setup(CFile topLevelDir)
  {
    parent = topLevelDir;
  }

  public void display()
  {
    if (parent == null) {return;}
    
    parent.display();
    applyForces();
  }

  public void addFile(String parentName, CFile fileToAdd)
  {
    for (CFile parent : files)
    {
      
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
  
  /*
  **  Getters and Setters for private variables.
  */
  public Iterator fileIt() { return files.iterator(); }
  public String name() { return name; }
  
  /*
  **  Test functions.
  */
  void addTestFiles(CFile parent)
  {
    // add a files to the top level directory.
    Vec2 pos = box2d.getBodyPixelCoord(parent.body);
    for (int i = 0; i < 5; i++)
    {
      CFile file = new CFile("test");
      files.add(file);

      if (i == 3 || i == 4)
      {
        // make a new directory.
        // and add new files.
        for (int k = 0; k < 2; k++)
        {
          CFile f = new CFile("test");
          files.add(f);
          file.addFile(f);
        }
      }
      // add the file to the parent.
      parent.addFile(file);
    }
  }
}

