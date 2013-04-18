public class CCommit
{
  private ArrayList<CFile> files;
  private int id;
  
  public CCommit(int id)
  {
    this.id = id;
    files = new ArrayList<CFile>();
  }
  
  public void addFile(CFile file)
  {
    files.add(file);
  }
  
  /*
  **  Getters and Setters for private variables.
  */
  public int id() {return id;}
  public Iterator fileIt() { return files.iterator(); }
}
