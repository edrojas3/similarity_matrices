function c1 = vid2c1(vidfile)
%
% USAGE: c1 = vid2c1(vidfile)
%
% Inputs:
%   vidfile: string with the path/to/name of the video file
%
% Outputs:
%   c1: matrix with the c1 model of each frame of the video per column
%
data  = vid2mat(vidfile);

numframes = data.numFrames;
c1dim = [53,94];
veclen = c1dim(1)*c1dim(2);
c1 = zeros(veclen,numframes);
for f = 1:numframes
    img = double(rgb2gray(reshape(data.frames(:,f),...
                            data.dim(1),data.dim(2),3)));
    c1(:,f) = reshape(v1model(img),veclen,1);
    
end

