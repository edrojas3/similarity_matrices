function c1_stack = vid2c1(vidfile)
%
% USAGE: c1_stack = vid2c1(vidfile)
%
% Inputs:
%   vidfile: string with the path/to/name of the video file
%
% Outputs:
%   c1: matrix with the c1 model of each frame of the video per column
%
h = waitbar(0,'Please wait...');

v  = vid2mat(vidfile);

numFrames = v.numFrames;

rows = [36864, 23780, 16416, 12201, 9216, 7296, 5974, 4982];
c1_stack = cell(1,8);

for r = 1:length(rows)
   c1_stack{r} = zeros(rows(r),v.numFrames,4) ;
end

for f = 1:numFrames
    waitbar(f/numFrames,h)
    frame = double(rgb2gray(reshape(v.frames(:,f),v.dim(1),v.dim(2),3)));
    img = frame;

    c1 = v1model(img);

    nBands = length(c1);
     
    for nb = 1:nBands
        s = size(c1{nb});
        c1_stack{nb}(:,f,:) = reshape(c1{nb},s(1)*s(2),1,4);
    end
    
end

close(h)