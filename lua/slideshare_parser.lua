-----------------------------------------------
-- Script Author: Mohammad Sharif Wighio
-- Dated: 24 Aug 2018, Thu
-- Project: SlideShare Downloader
-----------------------------------------------
-- SlideShare Grabber --
------------------------------------------------
-- SlideShare Parser Class -- 
-- This class contains the algorithms to parse and extract the information from a slideshare presentation page.
  
  
  -- SlideShare Class --
  SlideShare = {};
 
 
-----------------------------------------------------------------------------------------------------------------------------
-- This class will contain the information of the slides/presentation that will be extracted from the slideshare.net/page
-- Info: 
--   TotalSlides
--   Title 
--   Description
--   tbSlideLinks[] 
------------------------------------------------------------------------------------------------------------------------------  
  
  SlideShare.Info = {
           TotalSlides =0,
		   Title = "",
		   Description = "",
		   PublishDate = "",
		   tbSlideLinks = {}, -- Links of the slides
		   tbSlideFiles = {},
		   
		   CoverImageLink = "",
		   
		   -- Technical --
		   Remarks = "",
		   _Status = 0
  };
  
  
  
  --[[ Functions ]]--
  
  ---------------------------------------------------------------------------
  -- This function parses the slideshare web source to extract the information
  -- Params: strSource, tbAttrs
  SlideShare.ParseHTMLPage = function(strFile, tbAttrs)
     
	 
	 ------------------------------------------------------
	 -- Steps:
	 --   Checkpoint
	 --   Default Values tbAttrs
	 --   Reset SlideShareInfo
	 --   
	 --   Open the source
	 --   Verfiy file is a slideshare file
	 --   Extract the information
	 
	 
	 
	 ------------------------------------------------------
	 
	 
	 -- Checkpoint
	 if not strFile or strFile == "" then return false; end
	 
     -- Default values
	 if not tbAttrs then 
	   tbAttrs = {
	     -- List of the attrs goes here --
	   
	   }; 
	 end
	 
	 
	 -- Reset SlideShareInfo
	 SlideShare.Info = {};
	 SlideShare.Info.TotalSlides = 0;
	 SlideShare.Info.Title = "";
	 SlideShare.Info.Description = "";
	 SlideShare.Info.PublishDate = "";
	 
	 SlideShare.Info.tbSlideLinks = {};
	 SlideShare.Info.tbSlideFiles = {};
	 
	 SlideShare.Info.Remarks = "";
	 SlideShare.Info._Status = 0;
	 ---
	 
	 -- Download Controlls
	 SlideShare.StopDownload = false;
	 
	 
	 -- Open the html source file --
	 html = TextFile.ReadToString(strFile);
	 
	 -- Raw Data for the links
	 local htmTitleStart = '<span class="j-title-breadcrumb">';
	 local htmTitleEnd   = '</span>';
	 
	 local htmTotalSlidesStart = '<span id="total-slides" class="j-total-slides">';
	 local htmTotalSlidesEnd   = '</span>';
	 
	 local htmDescriptionStart = '<p id="slideshow-description-paragraph" class="notranslate">';
	 local htmDescriptionEnd   = '</p>';
	 
	 local htmDatePublishStart = 'itemprop="datePublished">';
	 local htmDatePublishEnd   = '</time>';
	 
	 local htmLinksStart = '<div class="slide_container">';
	 local htmLinksEnd   = '</div>';
	 
	 
	 -- Extract the data from the html Source --
	 -- Information about the presentation --
	 SlideShare.Info.Title           = StringCopyMid(html, htmTitleStart, htmTitleEnd);
	 SlideShare.Info.TotalSlides     = String.ToNumber(StringCopyMid(html, htmTotalSlidesStart, htmTotalSlidesEnd));
	 SlideShare.Info.Description     = StringCopyMid(html, htmDescriptionStart, htmDescriptionEnd);
	 SlideShare.Info.PublishDate     = StringCopyMid(html, htmDatePublishStart, htmDatePublishEnd);
	 
	 -- Process the Links Data --
	 local rawlinks = StringCopyMid(html, htmLinksStart, htmTitleEnd);
	 SlideShare.Info.CoverImageLink  = StringCopyMid(rawlinks, 'data-small="','"');
	 
	 -- Veriy the data
	 -- Check the critical/ primary values and then compare the results
	 if SlideShare.Info.Title == "" and SlideShare.Info.TotalSlides == 0 or rawlinks == "" then
	    
		Status.SetText("Error, invalid response from the server.");
		return false;
		
	 end
	 
	 
	 -- Status / Context of the process
	 local flow = 0
	 local tbContext = {LastPos = 1};
	 
	 for i = 1, SlideShare.Info.TotalSlides, 1 do
	   flow = flow + 1;
	   
	   local Start = 'data-full="';
	   local End = '?cb';
       	     
		 
	   local link = StringCopyMid(rawlinks, Start, End, tbContext.LastPos, tbContext);
	   SlideShare.Info.tbSlideLinks[flow] = link;
	 
	 end -- End of the links grabber loop
	 -----------------------------------------------------
	 
	 
	 -- Now delete the file
	 File.Delete(strFile);
	 
	 return true;
	 
  
  end -- End Function ParseHTMLPage
  ----------------------------------------------------------------------------------------------------
  
  --
  SlideShare.FetchDataFromURL = function(url)
    
	--[[
	     Steps:
		   - Check for the valid url
		   - Download the file and save it
		   - Check for errors and update the status 
		   
	
	]]--
	
	
	local rtn = ""; -- It will return the file path of the fetched data
	
	-- Checkpoint: Chk for url
	  Status.SetText("Checking the URL, Please wait...");
	
	  --local sltest = "slideshare.net";
	  local sltest = SLIDESHARE_CHECK_PATTERN;
	  
	  if String.Find(url, sltest) == -1 then
	    -- Error it does not looks to be a slideshre link/url
	    Status.SetText("URL is not a SlideShare link. Please enter the correct URL.");
	    return false;
	  end
	
	-- Download the file and save it
	-- Temp
	if TempFolderReady() then
	    local file = TEMP_PATH .. "slf.dat"
		
		-- Delete if file exits 
		if File.DoesExist(file) then File.Delete(file); end
		
		Status.SetText("Retreiving the Information from the server, Please wait...");
		Progress.SetCurrentPos("progStatus", 1);
		Progress.SetVisible("progStatus", true);
		
		HTTP.DownloadSecure(url, file, MODE_BINARY, 30, 443, nil, nil, _handleDownloadFetchData);
		
		Progress.SetCurrentPos("progStatus", 100);
		Progress.SetVisible("progStatus", false);
		
		local err = Application.GetLastError();
		local T = HTTP.GetHTTPErrorInfo();
		local cstatus = T.Status;
		
		-- Error conditions
		if err ~= 0 or cstatus > 299 or not File.DoesExist(file) then
		
		    local msg = "Error in Retreiving the Information, You may have entered an invalid or expired URL.";
			if cstatus == 404 then
			  msg = "The Requested link is not found on the server.";
			end
			
			Status.SetText(msg);
			
		return '';
		end
		
		Status.SetText("Information Retrieved Successfully.");
		rtn = file;
	   
	end
	
	return rtn;
	
  
  end
  
  
  
  SlideShare.StartDownload = function(fmt,saveto)
       
	   ----------------------------------
	   -- Steps:
	   
	   -- Verify the path
	   local path = saveto .. "" .. SlideShare.Info.Title;
	   local postfix = 0;
	   
	   -- get the prefix
	   local opath = path;
	   
	   while Folder.DoesExist(opath) do
	     postfix = postfix + 1;
	     opath = path .. "_" .. postfix;
	   end
	  
	     -- Create the new folder
		 Folder.Create(opath);
		-- Test for the errors again to make confirm or sure
	    if not Folder.DoesExist(opath) then
		  Status.SetText("Error in creating the files, Download cannot proceed...");
		  return false;
		end
	  
	  ---------------------------------------------
	  -- Start Downloading
	  
	  local imgExt = ".jpg";
	  local total  = SlideShare.Info.TotalSlides;
	  local success = 0;
	  local failed  = 0;
	  
	  -- Show the status bar
		 Progress.SetVisible("progStatus", true);
		 Progress.SetCurrentPos("progStatus", 1);
		 Status.SetText("Connecting to the server for downloading, Please wait...");
		 
	  
	  for i = 1, SlideShare.Info.TotalSlides, 1 do
	  
	  
	     -- Stop download controll
		 if SlideShare.StopDownload == true then
		  Status.SetText("Download Stopped.");
		  SlideShare.StopDownload = false;
		 break;
		 end
	     
		 local url  = SlideShare.Info.tbSlideLinks[i];
		 local file = opath .. "\\" .. BalanceDigits(i, SlideShare.Info.TotalSlides) .. imgExt;
		 
		 local perc = Math.Ceil((i*100) / total);
		 Progress.SetCurrentPos("progStatus", perc);
		 
		 HTTP.DownloadSecure(url, file);
			   
		Status.SetText("Downloading " .. perc .. "% (Slide " .. i .. "/" .. SlideShare.Info.TotalSlides .. ")..." );
		
		if not File.DoesExist(file) then
		 Status.SetText("Download failed at downloading slide " .. i ..", Please your Internet and then retry.");
		 return false;
		end
		 
	  end
	  
	 Status.SetText("Download Completed.");
  
  end
  
  