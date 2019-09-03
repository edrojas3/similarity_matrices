vfile = '0001.mp4';
v = vid2mat(vfile);

%%
rows = [36864, 23780, 16416, 12201, 9216, 7296, 5974, 4982];
c1_stack = cell(1,8);
for r = 1:length(rows)
   c1_stack{r} = zeros(rows(r),v.numFrames,4) ;
end

%%
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

%%

dims = zeros(length(c1),2);
for d = 1:length(c1);
    [dims(d,1), dims(d,2),~] = size(c1{d});
end

%%

c1_pca = cell(1,8);
for r = 1:8
   c1_pca{r} = zeros(dims(r,1),dims(r,2),4) ;
end

for nb = 1:length(c1)
    for o = 1:4
        [~, scores] = princomp(c1_stack{nb}(:,:,o));
        scores = max(scores(:,1),zeros(size(scores(:,1))))/max(scores(:,1));
        c1_pca{nb}(:,:,o) = reshape(scores,dims(nb,:));
    end
    
end
