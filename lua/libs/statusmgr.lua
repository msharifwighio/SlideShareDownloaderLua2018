--[[
 Script Author: Mohammad Sharif Wighio
 Dated: 20 Apr 2017 06:32 PM GD
 -------------------------------------
 Project: Books Library v1.0
 Script: UI Status Manager
 Module: DevMSharif's Status Manager v2
 -------------------------------------
 DESCRIPTION:
           This script file contains the functions and routines to monitor and update the status of the program operations.
           
 FUNCTIONS:
           1. SetText(Caller, Text, Ep);
           
           
]]--



--[[ DevMSharif's Status Manager 2.0 ]]--
Status = {
    -- Configuations
    textObjectName = "paraStatusText", -- Name of a paragraph object employed on the page and dialogue
    ntmp = "",
    osleep = false,


};

-- Last log to keep the track
Status.LastLog = "";
Status.Logs = {};


--[[ Status Functions ]]--

-- SetText(Caller, Text, Ep);
function Status.SetText(Caller, Text, Ep)
  
  -- Caller: Operational Area
  -- Text:   Operational Status
  if Caller then
    
  if Text == nil then Text = "" else Text = " :: " .. Text end
  -- Generate the text pattern -- do formatting --
  text = Caller .. Text;
  if Ep then text = text .. "..." end
  
  Paragraph.SetText(Status.textObjectName, text);
  Status.LastLog = text;
  Status.Logs[Table.Count(Status.Logs)+1] = text;
  Page.StopTimer(205);
  -- Check the sleep mode
  if Status.osleep == false then Page.StartTimer(10000, 205); end
  end
  
end

function Status.Clear()
  
  Paragraph.SetText(Status.textObjectName, "");

end

function Status.SetReady()
Paragraph.SetText(Status.textObjectName, "Ready.");
end

function Status.tmp(strPara)
   if strPara ~= nil then
   Status.ntmp = Status.textObjectName;
   Status.textObjectName = strPara;
   end
  
end

function Status.untmp()
  if Status.ntmp ~= nil and Status.ntmp ~= "" then
  Status.textObjectName = Status.ntmp;
  end
end


function Status.Blur()
Paragraph.SetText(Status.textObjectName, "...");
end


----------------------------------------------
-- Function: LastUpdate();
-- Desc: This function re-displays the last msg/log
function Status.LastUpdate()
  
  if Status.LastLog ~= nil or Status.LastLog ~= "" then
  Paragraph.SetText(Status.textObjectName, Status.LastLog);
  Page.StopTimer(205);
  Page.StartTimer(10000, 205);
  end

end

function Status.Sleep(b)
 if b == false then
 Status.osleep = false;
 else
 Status.osleep = true;
 end
end




Alert = function(str)
   
   Dialog.Message("Alert", str, MB_OK, MB_ICONINFORMATION, MB_DEFBUTTON1);

end
