// 1. change 8-bit, set Color threshold, make all heart tissue in red, set measures (perimeter,area,limit,label)
// 2. use wand select whole border, send to ROI manager(Control+T) as s1; s1 delete right ventricle cavity as s2; select left ventricle cavity as s3;
// 3. Control+R to reverse, update s2 as whole left ventricle tissue, XOR s2 and s3, select infarct epicardial and endocardial border as s4
// 4. run this macro
// 5. measure two borders not belong to the circumference

roiManager("Select", 1);
run("Measure");
roiManager("Select", 2);
run("Measure");
roiManager("Select", 3);
run("Create Mask");
setTool("line");
setAutoThreshold("Default");
run("Create Selection");
run("Measure");
roiManager("Select", newArray(0,1,2,3));
roiManager("Delete");