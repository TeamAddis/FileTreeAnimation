public class CFileTree
{
  private String name;
  CFile parent;                                  // Top Level Directory.
  CFile workingDirectory;                        // the current directory we are adding files to.
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
    workingDirectory = topLevelDir;
    files.add(parent);
  }

  public void display()
  {    
    parent.display();
    applyForces();
  }
  
  public boolean exists(String s)
  {
    boolean flag = false;
    for (CFile f : files)
    {
      if (match(f.name(), s) != null)
      {
        flag = true;
        println("adding file... file already exsists, skipping.");
        break;
      }
    }
    return flag;
  }
  
  private void resetWorkingDir() {workingDirectory = parent;}
  private void setWorkingDir(String name) 
  {
    if (name == null)
    {
      resetWorkingDir();
    }
    else
    {
      for (CFile f : files)
      {
        if (match(f.name(), name) != null)
        {
          workingDirectory = f;
          break;
        }
      }
    }
  }
  
  public void addFileWithName(String name)
  {
    // split the file name so we can break up the path.
    String[] s = name.split("/");
    println(s);
    
    ArrayList newFiles = new ArrayList<CFile>();
    for (int i = 0; i < s.length; i++)
    {
      // check to see if a file already exists with this name.
      if (!exists(s[i])
      {
        // set the working directory.
        
        CFile newFile = new CFile(s[i]);
        
        // add file to its parent.
        Vec2 pos = box2d.getBodyPixelCoord(workingDirectory.body);
        
        // add file to list of file in the tree.
        newFiles.add(newFile);
      }
    }
  }

  public void addFile(String parentName, CFile fileToAdd)
  {
    if (exists(fileToAdd.name()))
    {
      return;
    }
    
    for (CFile parent : files)
    {
      if (match(parent.name(), stringToRegular(parentName)) != null)
      {
        Vec2 parentPos = box2d.getBodyPixelCoord(parent.body);
        fileToAdd.createBody(parentPos.x, parentPos.y, BodyType.DYNAMIC);
        parent.addFile(fileToAdd);
      }
      else
      {
        Vec2 parentPos = box2d.getBodyPixelCoord(this.parent.body);
        fileToAdd.createBody(parentPos.x, parentPos.y, BodyType.DYNAMIC);
        this.parent.addFile(fileToAdd);
      }
    }
    files.add(fileToAdd);
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

