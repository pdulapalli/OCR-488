function lineSpace = lineTrans(img)
% Outputs an array of arrays (struct) containing each line of text in the
% input image. 
%
% img must be MxNx3 (rgb)

img = rgb2gray(img); % convert to grayscale
[r,c] = size(img);

rowsums = sum(img,2);

blankrowval = 255*c;

sigrows = find(rowsums < blankrowval); % find all rows containing a 'significant' pixel (non-white)
sigrowDiffs = diff(sigrows);
numlines = sum(sigrowDiffs > 1) + 1;
lines = cell(numlines,1);

% The following section (lines 21-33) groups consecutive 'significant rows'
% and outputs their corresponding pixel values to the lines struct.

currLine = 1;
lines{currLine}(1,:) = img(sigrows(1),:);
currLineIdx = 2;
for i = 2:length(sigrows);
    if sigrowDiffs(i-1) > 1
        currLine = currLine + 1;
        currLineIdx = 1;
    end
    
    lines{currLine}(currLineIdx,:) = img(sigrows(i),:);
    currLineIdx = currLineIdx + 1;
end

% The following section (lines 38-49) strips off the columns of whitespace at
% the left- and right-hand side of the line matrix.

for j = 1:numlines
    line = lines{j};
    [rL,cL] = size(line);
    blankcolval = 255*rL;
    
    colsums = sum(line,1);
    sigcols = find(colsums < blankcolval);
    firstcol = min(sigcols);
    lastcol = max(sigcols);
    
    lines{j} = lines{j}(:,firstcol:lastcol);
end

lineSpace = lines;

end