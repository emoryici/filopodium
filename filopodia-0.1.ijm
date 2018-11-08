title = getTitle();
masktitle = title + "_mask";
str = "title=" + masktitle;
run("Duplicate...", str);
run("Median...", "radius=20");
setAutoThreshold("Li dark");
run("Convert to Mask");

run("Options...", "iterations=3 count=1 do=Nothing");
run("Dilate");
run("Options...", "iterations=1 count=1 do=Nothing");

run("Divide...", "value=255");
run("XOR...", "value=1");
run("Enhance Contrast", "saturated=0.35");
imageCalculator("Multiply create", title, masktitle);
run("Remove Outliers...", "radius=2 threshold=30 which=Bright");
setThreshold(250, 65535);
run("Convert to Mask");
run("Skeletonize");
run("Analyze Skeleton (2D/3D)", "prune=none show");
