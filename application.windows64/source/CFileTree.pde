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

