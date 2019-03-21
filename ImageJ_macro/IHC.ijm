// written by Puifai Santisakultarm on 1/20/2017
// requires Bio-Formats and IHC Tool Box (https://imagej.nih.gov/ij/plugins/ihc-toolbox/index.html) plugins
// calibrate first
// when this is true, the script runs faster but images are hidden
setBatchMode(true);
run("Clear Results")
// load array of all files inside input directory
// edit by lwy, area means area of whole picture
path = getDirectory("Select folder of input tiff files"); 
filelist = getFileList(path);

//Set what are to be measured
run("Set Measurements...", "area integrated limit display redirect=None decimal=3");
// for some reason an image needs to be open otherwise IHC Toolbox won't let you select user-defined model..
run("Bio-Formats Importer", "open=[" + path + filelist[0] + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");         
// User selects "Read User Model". Ideally, would like to automate this part...
run("IHC Toolbox", "");
waitForUser("User selects custom color detection model", "Select \"Read User Model\", then click OK.")
close()

for (i=0; i< filelist.length; i++) {

	print("analyzing: "+ filelist[i]);
	// process tiff files only
	if (endsWith(filelist[i], ".tif") || endsWith(filelist[i], ".tiff"))  {
		 // open each file with Bio-Formats and convert to RGB
         run("Bio-Formats Importer", "open=[" + path + filelist[i] + "] color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");         
         run("RGB Color");

setBatchMode(false);

		// User clicks "Training" on IHC Toolbox. Ideally, would like to automate this part
		waitForUser("FOR NOW, user input is needed...", "Press \"Color\", then click OK when \"Stain Color Detection\" window appears.");

setBatchMode(true);
		
		selectWindow("Stain Color Detection");
		analyzedName = replace(replace(filelist[i],".tiff","_auto-detected.tiff"),".tif","_auto-detected.tif");
		print("Saving:  " + analyzedName);
		save(path + analyzedName); // save for checking the color detection result
		run("8-bit");
		setThreshold(0, 212, "raw");
		run("Measure");
		selectWindow(filelist[i] + " (RGB)");
		//run("8-bit");
		//setThreshold(0, 193, "raw");
		run("Measure");
		run("Close All");
	}
}
// resultName 根据具体文件路径设置
resultName=split(path,'\\');
resultName=resultName[7]+".csv";
saveAs("Results", path + resultName);

setBatchMode(false);