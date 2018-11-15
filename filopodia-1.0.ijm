//  Integrated Cellular Imaging (ICI) - Emory University
//  Integrated Core Facilities
//
//  Neil R. Anthony  -  11/15/2018

//  Analyze filopodia 

//  get file path and title; remove file ext
title0 = getTitle();
path = getInfo("image.directory");
dotIndex = indexOf(title0, "."); 
if (dotIndex > 0) {
	title = substring(title0, 0, dotIndex); 
}
else {
	title = title0;  //  in cases where it's already been taken off
}
masktitle = title + "_mask";
rename(title);

str = "title=" + masktitle;
run("Duplicate...", str);
run("Median...", "radius=20");
setAutoThreshold("Li dark");
run("Convert to Mask");

//  section to split and count cells
run("Watershed");
run("Analyze Particles...", "size=75-Infinity show=Outlines display clear summarize");
savStr = path + title + "_cells_outlines.png";
saveAs("PNG", savStr);
close();
savStr = path + title + "_cells_summary.csv";
saveAs("Results", savStr);
selectWindow(masktitle);

//  dilate three times; change setting and then change back to 1 iteration
run("Options...", "iterations=3 count=1 do=Nothing");
run("Dilate");
run("Options...", "iterations=1 count=1 do=Nothing");

//  convert to real binary and invert
run("Divide...", "value=255");
run("XOR...", "value=1");
run("Enhance Contrast", "saturated=0.35");

//  apply binary to original image
imageCalculator("Multiply create", title, masktitle);

//clean and theshold filopodia
run("Remove Outliers...", "radius=2 threshold=30 which=Bright");
setThreshold(250, 65535);
run("Convert to Mask");

//  analyze skeleton
run("Skeletonize");
run("Analyze Skeleton (2D/3D)", "prune=none show");

//  save and clean up
selectWindow("Branch information");
savStr = path + title + "_branch_info.csv";
saveAs("Results", savStr);
run("Close");

selectWindow("Results");
savStr = path + title + "_filo_results.csv";
saveAs("Results", savStr);
run("Close");

str = "Result of " + title;
selectWindow(str);
savStr = path + title + "_filo_results.png";
saveAs("PNG", savStr);
close();

selectWindow(masktitle);
savStr = path + title + "_mask.png";
saveAs("PNG", savStr);
close();

selectWindow("Tagged skeleton");
savStr = path + title + "_filo_tagged.png";
saveAs("PNG", savStr);
close();




