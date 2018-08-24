-----------------------------------------
-- Script
-- ======
-- Author: Mohammad Sharif Wighio , $DevMSahrif
-----------------------------------------------
-- Dated: 30 Aug 2016; E GD
-----------------------------------------------
-- Script Name:   Lib SettingsMgr
-- Required Libs: DevMSharif Misc Functions; for some functions
-- Script For: Autoplay Media Studio, OFFICIALLY Designed during the Development of App 'My School _(Rebuild to 1.1)'.
------------------------------------------------
-- Script Valid For: Lua5.1 or later, Autoplay Media Studio 8 or later;
-------------------------------------------
--=======================================--


-- SettingsMgr, version 1.1, by $DevMSharif
-------------------------------------------
-- DESCRIPTION:
--              It is a handy lua library to offer the reliable and stable functions with pretty 
--              smart interface to manage the settings without creating the burden on the developers.
-- FEATURES:   
--              There is no need for defining the burden of global or local settings;
--              The functions are directly/globally called without the reference to the SettingMgr;
------------------------------------------

--- FUNCTIONS;
--
--  Constructoral Function:
--  =======================
--   1: SettingMgr.SetAppName( arg )        // Sets the App Name and Creates the Registry Setting with the App Name.
--   2: SettingMgr.SetStandardFile( arg )   // Sets the path for the file; Standard Settings will be saved therein -
--                                          // It must be constant.
--   3: SettingMgr.SetLocalFile( arg )      // Sets the path for Local Settings File.
--   4: SettingMgr.Init()                   // Starts the Settings Manager; Archtectural functions wont work until -
--                                          // This function is not called; RETURNS 0 if success; Error msg.

--  Main Functions:
--  =======================
--  1: SaveSetting( argSection, argName , argValue )      // Saves the classic standard setting.
--  2: GetSetting( argSection, argName )                  // Retrieves the standard setting with classic mode.

--  3: SaveLocalSetting( argSection, argName , argValue ) // Saves the classic local setting.
--  4: GetLocalSetting( argSection, argName )             // Retrieves the local setting with classic mode.

--  5: SaveRegSetting( argSection, argName , argValue ) // Saves the setting in the system registry.
--  6: GetRegSetting( argSection, argName )             // Retrieves setting from the registry.

--  7: DelSetting( argClass, argSection, argName, argLocalFile) // Deletes a setting from any class.
--                                                              // Use -1 in argClass to delete all prefered settings
--                                                              // Use -1 in argSection to del all settings from the specified class.
--  8: EnValuateSetting( argSetting, tbFormat, argIndex )       // Returns a valid setting;


-- 











------------------------------------------------------------------------------------------------------------------------------
--==========================================================================================================================--

-- Create the global SettingMgr table and assign the default info
SettingMgr = {


     -- Config the Standard Settings file
     StandardFile = _SourceFolder .. "\\Settings.ini";
     EncryptStandardFile = false;
     
     
     -- Config Local Setting file
     LocalFile = "local.dat";
     EncryptLocalFile = false;
     
     
     -- Config the Registery Settings;
     RegMainKey = HKEY_CURRENT_USER;
     RegAppKey  = "\\Softwares\\$DevMSharif Tools\\";
     
     
     -- Config the global settings
     DefaultSection = "Misc";
     IsInited = false; 
     EncryptionKey = "";  -- Key for encryption of the settings;
     EncryptionPass = "$DevMSharif$_SM@1@3$%6&8;#0#$0##%%=";
     BackupFile     = "Backup\\_Settings_backup_" .. String.Replace(System.GetDate(2), "-", "_") .. "_" ..String.Replace(System.GetTime(0), ":", "") .. ".zip";
     
     Errors = {};
     LastError = "";
};

-- Create the global array for holding the settings from the Standard Setting file
_tblSettings = {};

-- Create SettingMgr Constants

_SM_REGISTRY = 1;
_SM_STANDARD = 2;
_SM_LOCAL    = 3;

--------------------------------------------------------------------------------------
-- Functions for the interaction to the SettingMgr; Constructoral Functions
--------------------------------------------------------------------------------------
-- Function to set the Registry Key; AppKey; AppName;
 function SettingMgr.SetAppName( arg )
   -- Check the args; set the file
   if arg ~= nil or arg ~= "" then
   SettingMgr.RegAppKey =  "\\Software\\" .. arg .. "\\";
   end
 
 end
 --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
-- Function to set the standard file; path
 function SettingMgr.SetStandardFile( arg )
   -- Check the args; set the file
   if arg ~= nil or arg ~= "" then
   SettingMgr.StandardFile = arg;
   
     -- Check and create the file
     if File.DoesExist(arg) == false then
     TextFile.WriteFromString(arg, "");
     -- Report the error
     error = Application.GetLastError();
     if error ~= 0 then SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError; end
     
     end
     
   end
 
 end
 --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
 -- Function to set the Local file; path
 function SettingMgr.SetLocalFile( arg )
   -- Check the args; set the file
   if arg ~= nil or arg ~= "" then
   SettingMgr.StandardFile = arg;
   
     -- Check and create the file
     if File.DoesExist(arg) == false then
     TextFile.WriteFromString(arg, "");
     -- Report the error
     error = Application.GetLastError();
     if error ~= 0 then SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError; end
     
     end
     
   end
 
 end
 --~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
 -- Function for the starting the Setting Manager;
 -- Returns the bool; if succes> 0 or Error Message
 function SettingMgr.Init()
 
   -- Init the Registry Setting;
   if Registry.DoesKeyExist(SettingMgr.RegMainKey, SettingMgr.RegAppKey) == false then
   -- Create the ERgistry Settings
   Registry.CreateKey(SettingMgr.RegMainKey, SettingMgr.RegAppKey);
   end
   
   -- Init the Standard Setting
   local file = SettingMgr.StandardFile;
   if File.DoesExist(file) == false then
   TextFile.WriteFromString(file, "");
   end
   
    -- Test for error
    error = Application.GetLastError();
    if (error ~= 0) then
    SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError;
	return _tblErrorMessages[error];
    end
    
    -- Update the info
    SettingMgr.IsInited = true;
    return 0; 
 end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~--
-- End of the Constructal Functions
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- SettingMgr, Main Functions;
--------------------------------------------------------------------------------------
-- Function for Saving a standard setting;
-- Args:    String argSection,  // Section or part where in save the Setting.
--          String argName,     // The name of the setting; to Retrieve it easily.
--          String argValue     // Value that should be saved and retrieved on get call.
-- Returns: Nothing
 function SaveSetting( argSection, argName, argValue )
    
    -- Local Info
    local file = SettingMgr.StandardFile;
    -- Check and set the info
    if argSection == nil or argSection == "" then argSection = SettingMgr.DefaultSection; end
    if argValue == nil then argValue = ""; end
    
    if argName ~= nil or argName ~= "" then
    -- Save the setting now
    INIFile.SetValue(file, argSection, argName, argValue);
    end
 
 
 end
-- End of the SaveSetting();
-------------------------------------------------------------------------------------
-- Function for retrieving the setting from the Standard file
-- Args:   String argSection,
--         String argName

-- Returns: The Saved Setting
function GetSetting( argSection , argName )
  
    -- Local Info
    local file = SettingMgr.StandardFile;
    local saved = "";
    
    -- Check the info
    if argSection == nil or argSection == "" then argSection = SettingMgr.DefaultSection; end
    if argName ~= nil or argName ~= "" then
    -- Retrive
    saved = INIFile.GetValue(file, argSection, argName);
    -- Report the error
    error = Application.GetLastError();
    if error ~= 0 then SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError; end 
    end
    
    return saved;
    

end
-- End GetSetting();
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
-- Function for Saving a local setting;
-- Args:    String argSection,  // Section or part where in save the Setting.
--          String argName,     // The name of the setting; to Retrieve it easily.
--          String argValue     // Value that should be saved and retrieved on get call.
-- Returns: Nothing
 function SaveLocalSetting( argSection, argName, argValue, argFile )
    
    -- Local Info
    if argFile == nil or argFile == "" then argFile =SettingMgr.LocalFile; end
    local file = argFile
    -- Check and set the info
    if argSection == nil or argSection == "" then argSection = SettingMgr.DefaultSection; end
    if argValue == nil then argValue = ""; end
    
    -- Verify the file
    if File.DoesExist(file) == false then TextFile.WriteFromString(file, ""); end
    -- Report the error
    error = Application.GetLastError();
    if error ~= 0 then SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError; end 
     
    if argName ~= nil or argName ~= "" then
    -- Save the setting now
    INIFile.SetValue(file, argSection, argName, argValue);
    end
 
 
 end
-- End of the SaveLocalSetting();
----------------------------------------------------------------------------------------------
-- Function for retrieving the setting from the local file
-- Args:   String argSection,
--         String argName

-- Returns: The Saved Setting
function GetLocalSetting( argSection, argName, argFile )
  
    -- Local Info
    if argFile == nil or argFile == "" then argFile =SettingMgr.LocalFile; end
    local file = argFile
    local saved = "";
    
    -- Check the info
    if argSection == nil or argSection == "" then argSection = SettingMgr.DefaultSection; end
    if argName ~= nil or argName ~= "" then
    -- Retrive
    saved = INIFile.GetValue(file, argSection, argName);
    -- Report the error
    error = Application.GetLastError();
    if error ~= 0 then SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError; end 
    end
    
    return saved;
    

end
-- End GetLocalSetting();
---------------------------------------------------------------------------------------------
-- Function for Saving the Registry Setting
-- Args:   String argSection,
--         String argName,
--         String argValue

-- Returns: Nothing
function SaveRegSetting( argSection, argName, argValue )

   -- Verify the access info
   if argSection == nil or argSection == "" then argSection = SettingMgr.DefaultSection; end
   if argName ~= nil or argName ~= "" then
   local mKey = SettingMgr.RegMainKey;
   local sKey = SettingMgr.RegAppKey .. argSection;
   Registry.SetValue(mKey, sKey, argName, argValue, REG_SZ);
   -- Report the error
   error = Application.GetLastError();
   if error ~= 0 then SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError; end
   
   end
   -- End Verify and enter


end
-- End Function SaveRegSetting();
---------------------------------------------------------------------------------------------
-- Function for retrieving the Setting from the registry
-- Args:   String argSection,
--         String argName,

-- Returns: The Saved Setting
function GetRegSetting( argSection, argName )

   -- Verify the access info
   local saved = "";
   if argSection == nil or argSection == "" then argSection = SettingMgr.DefaultSection; end
   if argName ~= nil or argName ~= "" then
   local mKey = SettingMgr.RegMainKey;
   local sKey = SettingMgr.RegAppKey .. argSection;
   saved = Registry.GetValue(mKey, sKey, argName);
   -- Report the error
   error = Application.GetLastError();
   if error ~= 0 then SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError; end
   
   end
   -- End Verify and enter
   -- Get the Return
   return saved;
end
-- End Function GetRegSetting();
--------------------------------------------------------------------------------------------
-- Function for deleting a setting from any of the above class
-- Args:     String argClass,
--           String argSection,
--           String argName
-- Returns:  Nothing
function DelSetting( argClass, argSection, argName, argLocalFile)
 
  -- Verify the info
  -- Implementing the default argClass
  if argClass == nil or argClass == "" then argClass = 1; end --// Default 1; to Delete from Registry
  if argSection == nil or argSection == "" then argSection = SettingMgr.DefaultSection; end
  
  -- Now proceed to exploit    
  -- Del from reg
    if argClass == 1 then
    
       local mKey = SettingMgr.RegMainKey;
       local sKey = SettingMgr.RegAppKey;
     
           -- Check wether to delete the whole appKey
           if argSection == -1 or argSection == "-1" then
           Registry.DeleteKey(mKey, sKey);
           else
           
           -- Delete the Section  
           sKey = sKey .. argSection;
           Registry.DeleteKey( mKey, sKey );
           end
    end
    -- End Del Reg Setting
    
  -- Delete the setting from the Standard file
  if argClass == 2 then
  
       local file = SettingMgr.StandardFile;
       
       -- Check wether to del the whole setting
       if argSection == -1 or argSection == "-1" then
       --[[
       The file can be deleted and then recreated!!
       But i am not going to del any file; just reset the file
       ]]
       local tbSections = INIFile.GetSectionNames( file );
         -- Del the section one by one
         if tbSections ~= nil then
           for index, section in pairs(tbSections) do
           INIFile.DeleteSection(file, section);
           end
         end
         -- End the loop
       
       -- Not to delete the whole setting; but the just specified;
       else
       
          -- Verify the argName
          if argName == nil or argName == "" then
          INIFile.DeleteSection(file, argSection);
          else
          INIFile.DeleteValue(file, argSection, argName);
          end
       
       
       end
       -- End Check Whole
  
  
  
  end
  -- End delete standard setting
 
  -- Delete the setting from the Local file
  if argClass == 3 then
  
       local file = "";
       -- Verify the local setting file
       if argLocalFile == nil or argLocalFile == "" then argLocalFile = SettingMgr.LocalFile; end
       file = argLocalFile;
       
       -- Check wether to del the whole setting
       if argSection == -1 or argSection == "-1" then
       --[[
       The file can be deleted and then recreated!!
       But i am not going to del any file; just reset the file
       ]]
       local tbSections = INIFile.GetSectionNames(file);
         -- Del the section one by one
         if tbSections ~= nil then
           for index, section in pairs(tbSections) do
           INIFile.DeleteSection(file, section);
           end
         end
         -- End the loop
       
       -- Not to delete the whole setting; but the just specified;
       else
       
          -- Verify the argName
          if argName == nil or argName == "" then
          INIFile.DeleteSection(file, argSection);
          else
          INIFile.DeleteValue(file, argSection, argName);
          end
       
       
       end
       -- End Check Whole
  
  
  
  end
  -- End delete standard setting
  
  -- Report back the error
  if (error ~= 0) then
  SettingMgr.LastError = _tblErrorMessages[error]; SettingMgr.Errors[Table.Count(SettingMgr.Errors)+1] = SettingMgr.LastError;
  return _tblErrorMessages[error];
  end
  
  return 0; 
  


end
-- End Fucntion DelSetting();
--------------------------------------------------------------------------
-- $DevMSharif SettingMgr 1.1 Special Functions
--------------------------------------------------------------------------'
--[[
   Function to retrieve the valid settings
   This Function uses the self functions to retrieve the saved setting from any specified class - 
   and checks it in respect to the settings/Strings if the retrieved setting is found in the given table of settings-
   then it will be returned the retrieved value other it will return the value from the table; index is supplied as -
   the argument;
   
   It minimizes the error which are occured by the editing of the setting files.
   
]]
-- Args:     String argRS     // Retrieved Setting either directly returned by the function
--           Table  tbFormat 
--           Number argIndex  // Index of the default setting;
--
-- Returns: Formated saved setting as String
function EnValuateSetting( argSetting, tbFormat, argIndex )

  -- Verify the info
  if argIndex == nil or argIndex == "" then argIndex = 0; else argIndex = String.ToNumber(argIndex); end
  -- Check wether the tbFormat is table; if String; return the returned
  if type(tbFormat) ~= "table"  or Table.Count(tbFormat) <= 0 then return argSetting; end
   -- Continue
  local saved = "";
  for index, val in pairs(tbFormat) do
     -- Check point
     if String.Lower(val) == String.Lower(argSetting) then
     saved = argSetting;
     break;
     else
     saved = "";
     end
     -- End Check point
  
  end
  -- End Loop
  
  -- Faciliate the return value
  if saved == "" then saved = tbFormat[argIndex]; end
  
  return saved;


end
-- End Function EnValuateSetting();
-----------------------------------------------------------------------------------------
-- Function for the backup of the settings;
-- This functions gets an array for argusments, every required arguments msut be definded in an
-- Porvided associative table.
--
-- Args:     Table argTable = {
--           
--           String Class,     // One of the three classes defined as either 1,2 & 3 for registry,standard and local respectively.
--                                Use -1 to backup the whole settings; including sub-settings

--           String Section,   // One of the Specified sections, use -1 to backup the whole settings from the specified class.
--
--           String LocalFile  // Use if you're backing up the whole settings or local settings; if left nil; Global local file will
--                                be processed to backup.
--  
--           BackupFile        // Name the full path of backup (.zip) file where in the settings are stored.?if left nil
--                                Global backup file name will be used with the build timestamp.
--
--           
--
--           NOTE: Backup files must be encrypted to minimize the user interaction, which can result in the abnormal activity.
--                 Backup File will be secured with the built-in password or encryption key.
--                 
--                 This function is bit louder.
--             }
--
-- Returns: 0 is success ? error; if occured
function BackupSettings( argTable )
  
  -- Verify the argTable
  if type(argTable) ~= "table" then return nil; end
  -- Continue
  -- Verify the info;
  -- This validation calls the $DevMSharif Global Misc Functions.
  -- Check wether the DevMSharif Misc functions are initiated.
  --- This function wont proceed without DevMSharif Misc Functions.
  if DevMSharif.MiscFunctionsInit == nil or DevMSharif.MiscFunctionsInit == 0 then return nil; end
  -- Still Continue;
  -- Validate the info
   -- Convert the all keys of the argTable to lower to minimize the case-sensitivity errors.
   -- Neutralizing the case-sensivity of the associative table keys
   for key, val in pairs(argTable) do
   if not null(key) then argTable[String.Lower(key)] = val; end
   end
   
   
   
   local Class        = notNull(IntVal(argTable["class"]), -1 );  --// Backup the whole as by Default
   local Section      = notNull(argTable["section"],    SettingMgr.DefaultSection);
   local StandardFile = SettingMgr.StandardFile;
   local LocalFile    = notNull(argTable["localfile"],  SettingMgr.LocalFile);
   local BackupFile   = notNull(argTable["backupfile"], SettingMgr.BackupFile );
   
   -- Listen to the backup request
   -- Listen if the whole settings are requested to backup.
   if Class == -1 then
     -- Build up the registry backup file
     
   
   
   
   
   end
   -- End Lsiten & backup the whole settings
   
   
   
   
  
  

  
end
