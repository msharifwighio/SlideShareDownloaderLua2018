-----------------------------------------------
-- Script Author: Mohammad Sharif Wighio
-- Dated: 24 Aug 2018, Thu
-- Project: SlideShare Downloader
-----------------------------------------------
-- SlideShare Grabber --
-- 

  
  TEMP_PATH = _SourceFolder .. "\\tmp\\";
  SLIDESHARE_CHECK_PATTERN = "slideshare.net/";
  SLIDESHARE_LAST_URL = "";





-- Misc Functions -- 
function BalanceDigits(a,b)
  
   a = a .. "";
   b = b .. "";
   
   while String.Length(a) <= String.Length(b) do
	a = "0" .. a;
   end
   
   return a;

end




function StringCopyMid(source, strStart, strEnd, numStart, tbContext)
    
	local rtn = "";
	local base = 1; if numStart ~= nil then base = numStart; end
	local offset = String.Length(strStart);
	local find = String.Find(source, strStart, base);
	local findB;
	local copyLen = 0;
	
	if find ~= -1 then
	    
		findB = String.Find(source, strEnd, find + offset);
		if findB == -1 then findB = 0; end
		copyLen = findB - find - offset;
		
		rtn = String.Mid(source, find + offset, copyLen);
		if tbContext then 
		  tbContext.LastPos = findB + String.Length(strEnd);
	    end
	  
	end
	
	-- Clean the string
	rtn = String.Replace(rtn, "\n","");
	rtn = String.Replace(rtn, "  ","");
	  
	return rtn;

end



TempFolderReady = function()
    
	if not Folder.DoesExist(TEMP_PATH) then
	  Folder.Create(TEMP_PATH);
	  --File.SetAttributes(TEMP_PATH, {Hidden = true});
	end
	
  TestError();
  
  return true;
   
end



TestError = function()
  
   local err = Application.GetLastError();
   if err == 0 then return true; end   -- No Error
   
   Status.SetText(_tblErrorMessages[err]);
   return false;
  
end


--------------------------------------

DisplaySlideShareInfo = function(a)
   
   if not a then a = SlideShare.Info; end
     --
   Paragraph.SetText("lbTitle", a.Title);
   Paragraph.SetText("lbSlides", a.TotalSlides);
   Paragraph.SetText("lbDescription", a.Description);
   Paragraph.SetText("lbPublishDate", "Published On ".. a.PublishDate);
   
   
    -- Splash the cover photo
	 if TempFolderReady() then
	   local tmp = TEMP_PATH .. "cover.dat"; 
	     
	   if File.DoesExist(tmp) then File.Delete(tmp); end
	   HTTP.DownloadSecure(a.CoverImageLink, tmp);  
	   if File.DoesExist(tmp) then
		   Image.Load("imgCover", tmp);
		   Image.SetVisible("imgCover", true);
	   end
	   
	 end -- End Load Cover
	 
	 
	 -- Enable the download controll
	 xButton.SetEnabled("btnDownload", true);
	 
     	 

end



ClearSlideShareInfo = function()
   
   
   -- Hide the objects
   xButton.SetEnabled("btnDownload", false);
   Image.SetVisible("imgCover", false);
   
   -- Reset the objects
   Paragraph.SetText("lbTitle", "...");
   Paragraph.SetText("lbSlides", "...");
   Paragraph.SetText("lbDescription", "...");
   Paragraph.SetText("lbPublishDate", "...");
   
   
   -- Delete the temporary files and folders
   Folder.DeleteTree(TEMP_PATH);
   
end