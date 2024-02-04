## Installation of FIJI:

1. Download and install FIJI (FIJI is just ImageJ)
1. Download link for PC and MAC: [https://imagej.net/software/fiji/downloads](https://imagej.net/software/fiji/downloads)
2. If you have FIJI already installed, make sure, it is up to date: Help › Update...
2. Open Fiji, it should look like this:

![image](https://github.com/CropCoder/Canopy_Coverage/assets/152723862/cfd512ca-abe2-4e6a-819e-c83b57db7b2d)


## Canopy Coverage analysis with FIJI (without Macro):

1. Open your clearly named canopy coverage image by drag and drop or File › Open
2. Perform a perspective correction
  1. Plugins › Transform › Interactive Perspective
  2. Four small plus signs should appear on the image, drag them across the image until the frame is just outside the field of view.

![image](https://github.com/CropCoder/Canopy_Coverage/assets/152723862/0365fc71-70ab-4fc7-b927-5828bd4291b8)
![image](https://github.com/CropCoder/Canopy_Coverage/assets/152723862/5e7f81c7-ceaf-44e7-bc91-8e1fdd953a54)



### Isolate the green plants with a color threshold
1. Image › Adjust › Color Threshold...
2. Set all filters to 'Pass'
2. Thresholding method: Default
2. Threshold color: B&W
2. Color space: HSB
2. Dark background: enabled
1. Set Hue, Saturation and Brightness, so only plants are white and anything else is black.

![alt text](image.png) ![alt text](image-1.png)


2. Create a histogram for the black and white image
  1. Select the image
  2. Duplicate the image: Image › Duplicate... (Ctrl + Shift + D)
  3. Analyze › Histogram (Ctrl + H)
  4. Press 'List' on the Histogram Window (red in the picture below)
  5. Note down the count for value=0 (background) and value=255 (canopy)
  6. Calculate the canopy coverage

![Shape5](RackMultipart20240204-1-konh4a_html_174c376834ecadff.gif) ![](RackMultipart20240204-1-konh4a_html_1296ceb0d7a1b8e.png)

1. Erase all weeds from the RGB image (created in step 4.b)
  1. Double click on the color picker (green in the picture below) and select black as background color.
  2. Use the selection tools from Fiji (red in the picture below) to select one weed or a group of weeds at a time, when selected press the del key. The weeds should now be replaced by solid black color.

![Shape7](RackMultipart20240204-1-konh4a_html_9761daa9e00074e0.gif) ![Shape6](RackMultipart20240204-1-konh4a_html_9835a6678d6335b2.gif) ![](RackMultipart20240204-1-konh4a_html_c8b5da963571cbe7.png)

  1. Repeat, until there are no visible weeds left
  2. You can reverse the last deletion with Cntr + Z
1. Preform steps 3 and 4 again for the image without weeds and calculate the weed coverage from the difference.


## Use Macro to analyze multiple images

1. Perform a color threshold as you would do without macro (see step 3 above) and note down the numbers, you used. The result and color threshold window can be discarded, you will only need the numbers.
2. Drag and drop the macro file on to the FIJI Window and press the 'Run' button in the popped-up window.
3. Enter the numbers from Step 1 in to the dialog window




4. From now on follow the instructions given by the Macro.
  1. Read the dialogs carefully!
  2. All numerical result will be printed in the Log-window, save it then you finished your analysis!


