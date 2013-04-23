public class CCommit
{
  private ArrayList<CFile> files;
  private ArrayList<String> fileNames;
  private int id;
  
  public CCommit(int id)
  {
    this.id = id;
    files = new ArrayList<CFile>();
    fileNames = new ArrayList<String>();
  }
  
  public void addFile(CFile file)
  {
    files.add(file);
  }
  
  public void addFileName(String s)
  {
    fileNames.add(s);
  }
  
  /*
  **  Getters and Setters for private variables.
  */
  public int id() {return id;}
  public Iterator fileIt() { return files.iterator(); }
  public Iterator fileNameIt() {return fileNames.iterator();}
}
