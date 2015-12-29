function out = trimWhite(img)
% Trims purely white rows off of the input image

rowsums = sum(img,2);
[r,c] = size(img);
blankrowval = c*255;

goodrows = find(rowsums ~= blankrowval);

topgoodrow = min(goodrows);
lastgoodrow = max(goodrows);

out = img(topgoodrow:lastgoodrow,:);