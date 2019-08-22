function data = vid2mat(videoFile)
%
% Obtains the information of each frame in a video.
%
% USAGE: data = vid2mat(videoFile)
%
% Inputs:
% videoFile = string with the file name of the video.
%
% Outputs:
% data = structure with fields:
%
%       frames: matrix with the information of each frame. The data is
%               vectorized, thus all the rows in one column is the info of one
%               frame. Use reshape to reorganize the vector into a matrix that can be
%               read by imshow (see the example below).
%               * uint8 type of data. 
%
%       dim: two element vector with the dimensions of the image.
%               * height is the first element.
%       
% Example:
%
% videoFile = 'path/to/cool/video.mp4'
% data = vid2mat(videoFile)
% dim = data.dim;
% frame1 = reshape(data.frames(:,1),dim(1),dim(2),3); % dim(1) = height,
%                                                       dim(2) = width, 
%                                                       3 because its a color (rgb) image.
% frame_grayscale = rgb2gray(uint8(frame1)); % convert to gray scale

% Load video file to video object
v = VideoReader(videoFile);

% Video Dimensions
w = v.Width;
h = v.Height;
nf = v.NumberOfFrames;

% Initialize structure to save individual matrices
frames = zeros(w*h*3,nf);

% Loop to save video in individual matrices
v = VideoReader(videoFile); 
k = 1;
while hasFrame(v)
    f = readFrame(v);
    frames(:,k) = f(:) ;
   k = k+1;
end

data = struct('frames',uint8(frames),'dim',[h,w],'numFrames',nf);
