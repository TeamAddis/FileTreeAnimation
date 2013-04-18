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
    rect(x, y, w, h);
    popMatrix();
  }
  
  public void buttonWasPressed(float mX, float mY)
  {
    if (contains(mX, mY))
    {
      println(text+" button was pressed.");
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
