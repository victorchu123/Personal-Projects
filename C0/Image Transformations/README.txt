Programming 3 (Images)

==========================================================

Files you will modify:
   remove-red.c0      - An example transform
   quantize.c0        - Quantize transform
   rotate90.c0        - Rotate90 transform
   rotate.c0          - Rotate transform
   
Files you might modify: 
   manipulate.c0     - Place to do the bonus task

Files you won't modify:
   pixel.c0           - Define the pixel type
   images-main.c0     - Code for running the transforms

==========================================================

Compiling images:

   $ make
   (This may not work if you don't have the right cygwin/macports
    package installed.)

   $ cc0 -d -o transform pixel.c0 remove-red.c0 quantize.c0 rotate90.c0 rotate.c0 manipulate.c0 images-main.c0
   (You need to do this every time you make changes.)

Running remove red:
   $ ./transform -t remove_red -i images/gargoyle.png
   (This produces images/gargoyle_remove_red.png, which should be the same
    as images/gargoyle_remove_red_sample.png)

Running quantize:
   $ ./transform -t quantize6 -i images/gargoyle.png
   (This produces images/gargoyle_quantize2.png, which should be the same
    as images/gargoyle_quantize6_sample.png)
   You can change the quantize6 to quantizeN for n in {0,1,2,3,4,5,6,7}
   to quantize by different amounts.

Running rotate90:
   $ ./transform -t rotate90 -i images/gargoyle.png
     (This produces images/gargoyle_rotate90.png, which should be the same
      as images/gargoyle_rotate90_sample.png)

Running rotate:
   $ ./transform -t rotate -i images/gargoyle.png
     (This produces images/gargoyle_rotate.png, which should be the same
      as images/gargoyle_rotate_sample.png)

Running manipulate:
   $ ./transform -t manipulate -i images/gargoyle.png

Note that you can also run 

./transform -t <whatever> -i images/gargoyle.png -o images/you-pick-the-file-name.png

if you'd like to specify the output file name.

==========================================================

There is a directory on WesFiles named
/courses/COMP-211-dlicata/handin/<yourname>/

You must upload the files
   remove-red.c0      
   quantize.c0        
   rotate90.c0        
   rotate.c0          

You can do that on the web by going to https://wesfiles.wesleyan.edu
