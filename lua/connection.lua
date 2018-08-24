-----------------------------------------------
-- Script Author: Mohammad Sharif Wighio
-- Dated: 24 Aug 2018, Thu
-- Project: SlideShare Downloader
-----------------------------------------------
-- SlideShare Grabber --
------------------------------------------------
-- Connection Manager Class --

--[[
  
  Functions:
    
	- TestConnection(); -- Tests the connection whether the internet is available or not;
                        -- Updates the status text
]]

Connection = {};



Connection.TestConnection = function()
     local T = HTTP.GetConnectionState();
	 
	 if T.Connected  == true then
	 Status.SetText("Internet is available.");
	   return true;
	 end
	 
	 Status.SetText("You are not connected to the Internet. Please connect and then try.");
	 return false;

end










---------------------------
_handleDownloadFetchData = function()
	Progress.StepIt("progStatus");
end