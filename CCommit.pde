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
