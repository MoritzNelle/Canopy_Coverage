// FIJI-Macro for the messurement of canopy coverge
// CSA30806
// written by Moritz Nelle in 2023 for WUR

waitForUser("Fiji Macro: Canopy-Coverage", "Before you start, you will need to perform a color threshold\nas you would do without macro and note down the numbers, you used.\nThe result can be discarded, you will only need the numbers for the next step.\n \n!!! CAUTION: To avoid mix ups, the macro will first close all currenty open images!!!");

close("*");

print("-----------------------------");
print("All result images will be saved under the same path as the corresponding analysis images.");

//------variabels-----
var helpURL = "https://brightspace.wur.nl/d2l/le/content/239705/Home"; //change this URL so students are directed to a manual, when they click on the 'help'-button
var minValue;
var maxValue;
var value;
var fileName;
var fileNameWOEx;
var filePath;
var groundCoverageWOweed;
var repeat = 1;
var valData = 0;
var perCor;
var storeInterim;


//------default-variabels-----
hueMin = 59;
hueMax = 121;
satMin = 53;
satMax = 177;
briMin = 101;
briMax = 228
	

while (valData == 0) {
	Dialog.create("Fiji Macro: Canopy-Coverage");
	Dialog.addMessage("Threshold Settings");
	Dialog.addSlider("Hue min", 0, 255, hueMin);
	Dialog.addSlider("Hue max", 0, 255, hueMax);
	Dialog.addMessage("");
	Dialog.addSlider("Saturation min", 0, 255, satMin);
	Dialog.addSlider("Saturation max", 0, 255, satMax);
	Dialog.addMessage("");
	Dialog.addSlider("Brightness min", 1, 255, briMin); //min = 1, so it is defenitly filtered by the color threshold
	Dialog.addSlider("Brightness max", 1, 255, briMax);
	Dialog.addMessage("");
	Dialog.addMessage("Program Settings");
	Dialog.addCheckbox("Perspective Correction", true)
	Dialog.addCheckbox("Store Interim Results", true)
	Dialog.addMessage("");
	Dialog.addMessage("written by Moritz Nelle in 2023 for WUR");
	Dialog.addHelp(helpURL);
	Dialog.show();
	
	
	hueMin=Dialog.getNumber();
	hueMax=Dialog.getNumber();
	satMin=Dialog.getNumber();
	satMax=Dialog.getNumber();
	briMin=Dialog.getNumber();
	briMax=Dialog.getNumber();
	perCor=Dialog.getCheckbox();
	storeInterim=Dialog.getCheckbox();
	
	
	if(hueMin>hueMax||satMin>satMax||briMin>briMax){
		valData = 0;
		showMessage("Invalid Input", "At least one of the Min values exeeds its coresponding Max value.\nMake sure that Max >= Min.");
	}else {
		valData = 1;
	}
}
	print ("\nThreshold settings:");
	print("Hue Min: " + hueMin);
	print("Hue Max: " + hueMax);
	print("Saturation Min: " + satMin);
	print("Saturation Min: " + satMax);
	print("Brightness Min: " + briMin);
	print("Brightness Min: " + briMax);
	print("\n-----------------------------\n");


while (repeat == 1) {
	filePath = File.openDialog("Choose image to analyse");
	fileName = File.getName(filePath);
	fileNameWOEx = File.getNameWithoutExtension(filePath);
	open(filePath);
	print("File Path: " + filePath);
	print("File Name: " + fileName);
	rename("1st org");
	
	if (perCor==1) {
		run("Interactive Perspective");
		waitForUser("Perspective correction", "Correct the perspective by dragging the plus signs over the image\nuntil the frame is just outside the field of view.\nThen press the Enter key and hit 'OK'.");
	}
	
	run("Duplicate...", "2nd_org");
	//selectImage("1st org");
	
	colorThresholding();
	
	count0and255();
	if (storeInterim == true) {save(replace(filePath, fileName, fileNameWOEx + "_BW_CT_with_weed.tif"));}
	close(); //closes result image
	
	print("\nGround Coverage with Weeds");
	printMinMaxPre();
	groundCoverageWOweed = maxValue/(maxValue+minValue)*100;
	
	selectImage("1st org");
	Color.setBackgroundValue(0);
	setTool(1);
	waitForUser("Erase Weeds", "Erase all visible weeds. Mark the corresponding area with\nthe tools from the Fiji Taskbar and press delete.\nWhen all weeds are erased, hit 'OK'");
	if (storeInterim == true) {save(replace(filePath, fileName, fileNameWOEx + "_RGB_erase_weed.tif"));}
	
	colorThresholding();
	
	count0and255();
	if (storeInterim == true) {save(replace(filePath, fileName, fileNameWOEx + "_BW_CT_without_weed.tif"));}
	close(); //closes result image
	
	
	
	print("\nGround Coverage without Weeds");
	printMinMaxPre();
	print("\nWeed Ground Coverage: " + groundCoverageWOweed - (maxValue/(maxValue+minValue)*100) + " %");
	
	repeat = getBoolean("Do you want to analyse another image with the same settings?", "Yes, another image", "No, I am done");
	
	print("\n-----------------------------");
	
	}

print("Job Done.");

saveLogData();

print("-----------------------------");



//---------called functions----------

function colorThresholding() { 
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
	min[0]=hueMin;
	max[0]=hueMax;
	filter[0]="pass";
	min[1]=satMin;
	max[1]=satMax;
	filter[1]="pass";
	min[2]=briMin;
	max[2]=briMax;
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
}


function count0and255() { //needs performence optimisation
	minValue = 0;
	maxValue = 0;

// Get the dimensions of the image
//	width = getWidth();
//	height = getHeight();
	
	// Loop through each pixel
	for (x = 0; x < getWidth(); x++) {
	    for (y = 0; y < getHeight; y++) {
	        // Get the pixel value at (x, y)
	        value = getPixel(x, y);
	        
	        if (value == 0) {
	            minValue ++;
	        }else {
		        if (value == 255) {
		            maxValue ++;
		        }else {
		        showMessage("ERROR", "There are diffrent pixel values than 0 and 255.\nThis pixels will not be counted");
		        }
	        }
	    }
	}
}


function printMinMaxPre() { 
	print("# Min Value: " + minValue);
	print("# Max Value: " + maxValue);
	print("Canopee Coverage: " + maxValue/(maxValue+minValue)*100 + " %");
}

function saveLogData(){
	//var Nr = random()*100000;
	getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
	selectWindow("Log");
	saveAs("Text", replace(filePath, fileName, "Log_Data_" + year + "" + month + "" + dayOfMonth + "_" + hour + "" +  minute + "" + second ));
	print("Log saved at: " + replace(filePath, fileName, ""));
}