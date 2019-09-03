function  video_pca = videoModelPCA(video_file)
% Calculates the C1 responses to every frame and gets a PCA for every
% filter orientation and receptive field size on the v1 model.
%
% USAGE: video_pca = videoModelPCA(video_file)
%
% Inputs:
%       video_file: string with 'path/to/video.mp4';
%
% Outputs:
%       video_pca: cell array of size {1,8} with the pca's of the video.
%       Each cell represents a receptive field size, with the smallest at
%       index = 1 and largest at index = 8. Inside each cell theres a
%       matrix of size m x n x 4. Each index of the 3rd dimension
%       represents an orientation of the gabor filters used to model v1
%       cells.
%
%

% Transform video file into a matlab readable structure
v = vid2mat(video_file);

% Initialize a cell to stack the c1 responses of each frame.
% NOTE: the matrices inside the cell are for videos of 576 x 1024 pixels.

if ~(all(v.dim == [576, 1024])) 
   error('The function works for video frames of 576 x 1024 pixels. If your video frames have a different size, please read the documentation to optimize the functions to your needs.' ) 
end

rows = [36864, 23780, 16416, 12201, 9216, 7296, 5974, 4982];
c1_stack = cell(1,8);
for r = 1:length(rows)
   c1_stack{r} = zeros(rows(r),v.numFrames,4) ;
end

% Calculate the response of C1 units for each frame and group them by
% receptive field size, and orientation. The response of each unit is
% stored as a column vector.
for f = 1:v.numFrames
    
    frame = double(rgb2gray(reshape(v.frames(:,f),v.dim(1),v.dim(2),3)));
    img = frame;

    c1 = v1model(img);

    nBands = length(c1);
     
    for nb = 1:nBands
        s = size(c1{nb});
        c1_stack{nb}(:,f,:) = reshape(c1{nb},s(1)*s(2),1,4);
    end
    
end

% dimensions of the 2d matrices of each c1 band
dims = zeros(length(c1),2);
for d = 1:length(c1);
    [dims(d,1), dims(d,2),~] = size(c1{d});
end

% Initialize cell array for storing the pca's
video_pca = cell(1,8);
for r = 1:8
   video_pca{r} = zeros(dims(r,1),dims(r,2),4) ;
end

% PCA between of all frames for each receptive field size and orientation
for nb = 1:length(c1)
    for o = 1:4
        [~, scores] = princomp(c1_stack{nb}(:,:,o));
        scores = max(scores(:,1),zeros(size(scores(:,1))))/max(scores(:,1));
        video_pca{nb}(:,:,o) = reshape(scores,dims(nb,:));
    end
    
end
