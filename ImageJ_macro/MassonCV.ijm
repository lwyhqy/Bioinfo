// processFile: choose fibrotic areas; processFile0: choose all tissues
dir = getDirectory("Choose Source Directory");
list = getFileList(dir);
run("Clear Results")
if (getVersion>="1.40e")
    setOption("display labels", true);
setBatchMode(true);
for (i=0; i<list.length; i++) {
	path = dir+list[i];
    showProgress(i, list.length);
    if (endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")){
    	open(path);
    	processFile();
    	close();
	}
}
for (i=0; i<list.length; i++) {
	path = dir+list[i];
    showProgress(i, list.length);
    if (endsWith(list[i], ".tif") || endsWith(list[i], ".tiff")) {
    	open(path);
    	processFile0();
    	close();
	}	
}
function processFile(){
	min=newArray(3);
	max=newArray(3);
	filter=newArray(3);
	a=getTitle();
	run("HSB Stack");
	run("Convert Stack to Images");
	selectWindow("Hue");
	rename("0");
	selectWindow("Saturation");
	rename("1");
	selectWindow("Brightness");
	rename("2");
	min[0]=107;
	max[0]=206;
	filter[0]="pass";
	min[1]=23;
	max[1]=255;
	filter[1]="pass";
	min[2]=130;
	max[2]=255;
	filter[2]="pass";
	for (i=0;i<3;i++){
  		selectWindow(""+i);
  		setThreshold(min[i], max[i]);
  		run("Convert to Mask");
  		if (filter[i]=="stop")  run("Invert");
	}
	imageCalculator("AND create", "0","1");
	imageCalculator("AND create", "Result of 0","2");
	for (i=0;i<3;i++){
  		selectWindow(""+i);
  		close();
	}
	selectWindow("Result of 0");
	close();
	selectWindow("Result of Result of 0");
	rename(a);
	run("Create Selection");
	run("Measure");
}
function processFile0(){
	min=newArray(3);
	max=newArray(3);
	filter=newArray(3);
	a=getTitle();
	run("HSB Stack");
	run("Convert Stack to Images");
	selectWindow("Hue");
	rename("0");
	selectWindow("Saturation");
	rename("1");
	selectWindow("Brightness");
	rename("2");
	min[0]=70;
	max[0]=255;
	filter[0]="pass";
	min[1]=23;
	max[1]=255;
	filter[1]="pass";
	min[2]=130;
	max[2]=255;
	filter[2]="pass";
	for (i=0;i<3;i++){
  		selectWindow(""+i);
  		setThreshold(min[i], max[i]);
  		run("Convert to Mask");
  		if (filter[i]=="stop")  run("Invert");
	}
	imageCalculator("AND create", "0","1");
	imageCalculator("AND create", "Result of 0","2");
	for (i=0;i<3;i++){
  		selectWindow(""+i);
  		close();
	}
	selectWindow("Result of 0");
	close();
	selectWindow("Result of Result of 0");
	rename(a);
	run("Create Selection");
	run("Measure");
}
resultName=split(dir,'\\');
resultName=resultName[2]+".xls";
saveAs("Results", dir + resultName);