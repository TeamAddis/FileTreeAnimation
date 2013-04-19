/***********************************************************************************************
 **  Name:                  Enums.java
 **  Author:                Andrew Addis
 **  Language:              Processing [www.processing.com]
 **  Date [DD:MM:YYYY]:     [31:06:2010]  
 **  Description:           This file is part of the Challenger project and is used to store all
 **                         helper functions
 **  Input:                 None.
 **  Output:                None.
 ************************************************************************************************/
 
 /********************************************************************************************
  **  Name:          stringToRegular
  **  Purpose:       Converts a string to a regular expression string by adding \\b to the
  **                 front and end of the string, allowing it to be used in searches.
  **  Parameters:    String s: a string you want to turn into a regular expression.
  **        
  **  Returns:       A new string that is a regular expression.
  **        
  ***********************************************************************************************/
  public String stringToRegular(String s) { return "\\b" + s + "\\b"; }
