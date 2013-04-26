public class CommitTimer extends Thread
{
  boolean running;
  public CommitTimer()
  {
    running = false;
  }
  
  void start()
  {
    running = true;
    super.start();
  }
  
  void run()
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
