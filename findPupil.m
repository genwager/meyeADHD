%% Pupil Video Processing
%% Transfer data into Matlab

% Read MP4 video file into .png series 
v = VideoReader("distribution_video2_720p90.h264.mp4");
numframes = v.NumFrames;
NFP = ceil(sqrt(numframes));

for i=1:numframes
    frame = read(v,i);
    ImgName = strcat(int2str(i),'.png');
    imwrite(frame,ImgName);
end

%% Detect and Measure Circular Objects in an Image

% read .png files
A = imread('860.png');
imshow(A)

% determine the appropriate radius range
d = drawline; 
pos = d.Position;
diffPos = diff(pos);
diameter = hypot(diffPos(1),diffPos(2));

% convert image to grayscale if not already converted
gray_image = im2gray(A);
imshow(gray_image)

% convert to binary
BW = im2bw(A);
imshow(BW)

% find pupil
stats = regionprops('table', BW, 'Centroid', 'Eccentricity', 'EquivDiameter');
centroid = stats.Centroid(:,1);
radius = (stats.EquivDiameter)/2;
imshow(A)
viscircles(centroid,radius,'Color','b')

% find pupil
[centerspupil, radiipupil, metricpupil] = imfindcircles(A, ...
    [30 60], ...
    ObjectPolarity="dark", ... % finds dark circles
    Sensitivity=0.95, ... % lowers recognition threshold,
    EdgeThreshold=0.09); 
imshow(A)
viscircles(centerspupil,radiipupil,'Color','b')

% Enhance and visualize grayscale image
pout = gray_image;
imshow(pout)
pout_imadjust = imadjust(pout);
pout_histeq = histeq(pout);
pout_adapthisteq = adapthisteq(pout);

montage({gray_image,pout_imadjust,pout_histeq,pout_adapthisteq},"Size",[1 4])
title("Original Image and Enhanced Images using " + ...
    "imadjust, histeq, and adapthisteq")

% Visualize pixel values in a histogram
figure(2)
subplot(1,3,1)
imhist(gray_image)
title("Histogram of gray-image.png")
subplot(1,3,2)
imhist(pout_imadjust)
title("Histogram of pout-imadjust.png")
subplot(1,3,3)
imhist(pout_histeq)
title("Histogram of pout-histeq.png")

% determine the appropriate radius range
imshow(pout_imadjust)

d = drawline; 
pos = d.Position;
diffPos = diff(pos);
diameter = hypot(diffPos(1),diffPos(2));

% find pupil
[centerspupil, radiipupil, metricpupil] = imfindcircles(pout_imadjust, ...
    [30 40], ...
    ObjectPolarity="dark", ... % finds dark circles
    Sensitivity=0.92, ... % lowers recognition threshold,
    EdgeThreshold=0.3); 

imshow(A)
viscircles(centerspupil,radiipupil,'Color','b')
