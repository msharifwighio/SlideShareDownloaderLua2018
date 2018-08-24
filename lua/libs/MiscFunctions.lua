--[[
Script:-
========
 Author:  Mohammad Sharif Wighio, $DevMSahrif

 Dated: 01 Sep 2016 Thu M GD 
 Script Valid For: Lua5.1 or later, Autoplay Media Studio 8 or later.
 Script For: Autoplay Media Studio, OFFICIALLY Designed during the Development of App 'My School _(Rebuild to 1.1)'.
 
 DevMSharif Misc Functions 1.0
 ==============================
 Description:  This library contains the wide variety of function, including extensions to the String Manipulation (Regex) function,
               Sqlite, Mysql extension to data mainipulation functions, Directory verifiers, many other ease creating functions etc.
               
 Features:     This library contains the handy functions to inmprove the experience of the developers.
               It minizes the burden for wrtitng the long scripts.
               Most of the DevMSharif Libraries require misc functions library to work. It must be put first before the other libs.


]]
-- Start global and technical info
DevMSharif = {
  -- Metainfo
  Author = "Mohammad Sharif Wighio",
  Version = "1.0";
  
  -- Technical info
  MiscFunctionsInit = 1,
  

};
------------------------------------------------------------------------------------------------------------------------------------
--[[
 Functions:
  Ease Creating Functions:
  =======================
  1. empty( arg )                          // Checks the empty string either nil or blank; Returns Bool.
  2. null( arg )                           // Copy of the function empty().
  3. IntVal( arg )                         // Return a number from a string.
  4. notEmpty( arg1,arg2 )                 // Checks a string and returns arg2 if arg1 is empty.
  5. notNull( arg1,arg2 )                  // Copy of the function notEmpty().
  6. EnValidateString( arg1,arg2 )         // Copy of the function notEmpty().
  7. GetValidPath( arg1,arg2 )             // Checks for the path arg1; if exists returns arg1,else returns arg2.
  8. BoolToInt(bool)                          // 1 for true 0 for false
  9. SplitString(string, delimiter);
  10. ToString(x);
  
  String Manipulation Regex Functions:
  ===================================
  1. GetRealString( argSourceString )      // Removes wildcards, linebreaks, table breaks etc from a string. 
  2. RemoveWildCards( argSourceString )    // Removes wildcards, Neccessory for directory strings.
  3. CleanWhiteSpaces( argSourceString )   // Removes the whitespaces (double, triple ...... ? whitespaces).
  4. CleanSpaces( argSourceString )        // Removes the all spaces from a string.
  
  SQLite String Functions:
  ===================================
  1. GetSQLiteRealString( arg )            // Formats a string into SQLite Real String.
  2. GetSQLRealString( arg )               // Copy of the function, GetSQLiteRealString( arg ).
  3. GetSQLString( arg )                   // Copy of the function, GetSQLiteRealString( arg ). 
  4. GetSQLRealString( arg )               // Copy of the function, GetSQLiteRealString( arg ).
  
  5. SQLRestoreString( arg )               // Restores or reforms the SQLite formated string into original form.
  6. SQLiteRestoreString( arg )            // Copy of the function, SQLRestoreString( arg ).
  7. SQLCleanString( arg )                 // Cleans out the SQL unreal chars from a string, this function cant reverse the chars, cleaned.
  

  
]]

------------------------------------------------------------------------------------------------------------------------------------
--  Ease Creating Function, String Manipulation Functions
---------------------------------------------------------
--[[
 Function for checking an empty or null string
 Args:  String arg
 
 Returns bool   // if the arg is nil or empty: true;?false

]]
function empty( arg )
  -- 
  if arg == nil or arg == "" then
   -- The data provided as argument is not defined or nil; or empty string
   return true;
  else
   return false;
  end
  
end
-- End Function empty();
-------------------------------------------------------------
-- Another ease function, similar to the empty();
function null( arg )
  -- 
  if arg == nil or arg == "" then
   -- The data provided as argument is not defined or nil; or empty string
   return true;
  else
   return false;
  end
  
end
-- End Function null();
---------------------------------------------------------------

--[[
 Function for separating or converting the number from a string
 Note: This function is only ease creating, thus it uses the AMS Builtin function for conversion;
 Args:  String arg
 
 Returns: number

]]
function IntVal( arg )
 
 -- Verify
 if not null(arg) then
  return String.ToNumber(arg);
 end


end
-- End Fucntion IntVal();
--------------------------------------------------------------
--[[
 One of the special ease creating functions, notNull() or notEmpty();
 This Function checks the provided arguments if first one is nil or empty then the second one will be returned.
 This function is the modified copy of earlier versions of DevMSharif Misc Functions or Global Functions.
 To minimize the error for the programs, that use former version of the lib, the function with the former reference
 is also included.
 
 Args:    String arg1,
          String ag2
        
 Returns: Not empty string as String
]]
function notEmpty( arg1, arg2 )
  
  -- Check the info
  if arg1 == nil or arg1 == "" then
  return arg2;
  else
  return arg1;
  end


end
-- End Function notEmpty();
-- Adding the former reference of the fucntion;
function EnValidateString( arg1, arg2 )

-- Check the info
  if arg1 == nil or arg1 == "" then
  return arg2;
  else
  return arg1;
  end

end
-- End the Function EnValidateString();
-- Adding the other refernce of the function as notNull()
function notNull( arg1, arg2 )
  
  -- Check the info
  if arg1 == nil or arg1 == "" then
  return arg2;
  else
  return arg1;
  end

end
-- End the fucntion notNull();
-----------------------------------------------------------------------
-- Function for returning the valid path
--[[
 This functions takes two arguments, the first one is checked to exists;if exists then arg1 is returned otherwise the arg2 is returned.
 -*The former referenced function is modified to the new function with the similar work but implemented with single argument.
 Args:     String arg1
           String arg2
           
 Returns:  String

]]
function GetValidPath( arg1 , arg2 )
  
  --
  if File.DoesExist(arg1) == true or Folder.DoesExist(arg1) == true then
  return arg1;
  else
  return arg2;
  end

end
-- End Function GetValidPath()
-----------------------------------------------------------------------

-- Function for converting a bool into int
function BoolToInt(bool)
  
  if bool == true then return 1; else return 0; end

end


SplitString = function(str,delim)

      -- Accessing Information
      local StringLength;
      local lenDelim = String.Length(delim);

      local tbReturn={}; -- Array;
	  local flow = 0;
	  local sub = "";
	  
	  -- Method used: Copy Carrage no splition; identify the next block then copy the substring
	  
	  local nextPos = 0; -- postition of the delim
	  local startPos = 1;
	        nextPos = String.Find(str,delim, 1, true);
			
			if str == "" or nextPos == -1 then return tbReturn; end
			
	  
	  -- Continue....
	  -- Keep copying until the delim is found
	  -- Must Copy the last element outside
	  while nextPos > 0 do
	       local len = nextPos - startPos;
	       sub = String.Mid(str, startPos, len);
	       
	       flow = flow + 1;
		   Table.Insert(tbReturn, flow, sub);
		   
		   startPos = nextPos + lenDelim;
		   nextPos = String.Find(str, delim, startPos, true);
	  
	  end
		
		sub = String.Mid(str, startPos, -1);
		Table.Insert(tbReturn, flow+1, sub);
		-- Done
		
      return tbReturn;

  end -- Ending the Function String.Split();

--------------------------------------------------------------------
-- Function ToString(x) // Converts a number etc to string
function ToString(x)
  
  -- For nil conversion
  if x == nil then
  return  "nil";
  end
  
  -- For boolean conversion
  if x == true then
  return "true";
  end
  if x == false then
  return "false";
  end
  
  -- else
  return "" .. x .. "";

end

-- String Manipulation (Regex) Functions
--[[
 Function for removing the wildcards from a string
 This function is important to minimize the errors during generating the directory path or filename, as it removes the wildcard.
 The function can be called with reference to RemoveWildCards(), or GetRealString().
 
 Args:    String argSoureString
 
 Returns: String
]]
-- Function for removing wilds and unReals
function GetRealString( argSourceString )
  
  -- Verify the input
  argSourceString = notNull(argSourceString, "");
  local wildCards = {"/", "\\", ":", "?", "*", "<", ">", "|"}
  local unReals   = {"\n", "\t", "\r"};
  local fresh = "";
  
  -- Remove the wilds first
  for i, wild in pairs(wildCards) do
  argSourceString = String.Replace(argSourceString, wild, fresh);
  end
  -- Remove unReals
  for i, unReal in pairs(unReals) do
  argSourceString = String.Replace(argSourceString, unReal, fresh);
  end
  
  -- Return the cleaned argSourceString
  return argSourceString;


end
-- End function GetRealString();
------------------------------------------------------------
-- Adding Simliar Function, But Remove WildCards only
function RemoveWildCards( argSourceString )
  
  -- Verify the input
  argSourceString = notNull(argSourceString, "");
  local wildCards = {"/", "\\", ":", "?", "*", "<", ">", "|"}
  local fresh = "";
  
  -- Remove the wilds first
  for i, wild in pairs(wildCards) do
  argSourceString = String.Replace(argSourceString, wild, fresh);
  end
  
  -- Return the cleaned argSourceString
  return argSourceString;


end
-- End function RemoveWildCards();
---------------------------------------------------------------
--[[
 Function for removing the double white spaces
 This function will only remove double white spaces
 
 Args:    argSourceString
 
 Returns: String


]]
function CleanWhiteSpaces( argSourceString )

 -- Verify the info
 if argSourceString ~= nil then
 
   local spaces = "  ";
   local space  = " ";
   -- Throw a loop to cleanout the every occurence of the double spaces
   while String.Find(argSourceString, spaces, 1) >= 1 do
   if String.Find(argSourceString, spaces, 1) == -1 then break; end
   argSourceString = String.Replace( argSourceString, spaces, space);
   end
 
 end
 
 -- Return the Cleaned String
 return argSourceString;
 
end
-- End Fucntion CleanWhiteSpaces();
---------------------------------------------------------------


--[[
 Function for removing the all white spaces
 This function will remove all spaces
 
 Args:    argSourceString
 
 Returns: String


]]
function CleanSpaces( argSourceString )

 -- Verify the info
 if argSourceString ~= nil then
 argSourceString = String.Replace(argSourceString, " ", "");
 end
 
 -- Return the Cleaned String
 return argSourceString;
 
end
-- End Fucntion CleanSpaces();
---------------------------------------------------------------------------------------------


--[[
 Function for adding the single quotes to a string
 
 Arg:     String argSourceString
 
 Returns: String
]]
function UnderSingleQuotes( argSourceString )
  argSourceString = notNull(argSourceString, "");
  return "'"..argSourceString .. "'";

end
-- End fucntion UnderSingleQuotes();
---------------------------------------------------------------------------------------------
--[[
 Function for adding the double quotes to a string
 
 Arg:     String argSourceString
 
 Returns: String
]]
function UnderDuoQuotes( argSourceString )
  
  return "\""..argSourceString .. "\"";

end
-- End fucntion UnderDuoQuotes();


---------------------------------------------------------------------------------------------
-- Regex Functions for the SQLite database, functions can be implemented with other databases
--[[
 Function for minimizing the errors that are occured by the certain functional characters within a string;
 The function can be implemented by various references that are
 familiar to the SQLite programmers; AddSlashes(), GetSQLiteRealString()
 Args:     String arg
 
 Returns: String

]]
function GetSQLiteRealString( arg )
--
  local chars   = {"'"};
  local replace = {"''"}
    if not null(arg) then
      -- Throw a loop
      for index, char in pairs(chars) do
      arg = String.Replace(arg, char, replace[index]);
      end
    end
  
  -- Return the manipulated string
  return arg;
end


-- Adding the other refernce to the function
function GetSQLRealString( arg )
return GetSQLiteRealString( arg );
end
-- Adding another new reference to the function
function GetSQLString( arg )
return GetSQLiteRealString( arg );
end
-- Adding even new reference to the function
function GetSQLRealString( arg )
return GetSQLiteRealString( arg );
end
----------------------------------------------------------------------------------------------
-- Function for restoring the original string; from SQLRealString
--[[
 This manipulates a string by reverse-replacing of the SQLRealString chars
 
 Args:    String arg
 
 Return: String;
]]
function SQLRestoreString( arg )
  --
  local chars   = {"'", "\n"};
  local replace = {"&DE;", "&newline;"}
  -- Throw a loop
  for index, char in pairs(replace) do
  arg = String.Replace(arg, char, chars[index]);
  end
  -- End the loop
  return arg;
  
end
-- End Function SQLRestoreString();
-- Adding the other reference of the function
function SQLiteRestoreString( arg )
return SQLRestoreString( arg );
end
-- End Function SQLiteRestoreString()
-------------------------------------------------------------------
--[[
 The function for cleanig the string into the Real SQLite String.
 This function will remove/clean/eskip out the wildcards that can cause problems during the query execution.
 
 Args:     String arg
 
 Returns:  String

]]
function SQLCleanString( arg )

 -- Accessing the information
 local tbUnReal = {"'","\"", "/","\\"};
   
   -- Going throw the loop to remove the UnReal chars
   for x, unReal in pairs(tbUnReal) do
   -- Process the removal
   arg = String.Replace(arg, unReal, "", true);
   end
   -- End the loop 
   
   -- Passsing the cleaned String
   return arg;

end
-- End function SQLCleanString()
------------------------------------------------------------------
--------------------------------------------------------------
-- Function: shdivide(n)
-- Desc: Divides an number and returns a tab containg q and r
function shdivide(n,d)
 
 tbR = {q=0,r=0};
 if not n or n == 0 then return tbR; end
   
   local q = 0;
   
   while(n >= d) do
    n = n-d;
    q = q + 1;
   end
   
   tbR.q = q;
   tbR.r = n;
 
 return tbR;
 
end