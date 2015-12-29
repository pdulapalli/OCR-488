% OCR System
% Written by: Thomas Gettliffe, Anurag Dulapalli

% Figure 1 is the extracted lines from the input image
% Figure 3 is the comparison between best match (row 3) and true match (row
% 4)

%% Initialize Workspace
clear;

load('dictionary');
uppers = [1:26,53:62];
biglowers = [28,30,32:38,42:43,47,51]; % tall lowercase like l, p, b, d, etc
lowers = [27, 29, 31, 39:41, 44:46, 48:50, 52]; % true lowercase, like a e o, etc

img = imread('capture.png'); % Change this to selected image

lines = lineTrans(img); % outputs a struct - array of arrays, each a line

numlines = length(lines);

%% Display each line

figure(1);clf;
for i = 1:numlines
    subplot(4,2,i)
    imshow(lines{i});
    
    heights(i) = size(lines{i},1);
    
end

%% Preprocess scale
% Attempt to guess the pixel height of upper and lower case characters
% given the unique line heights observed
%
% 3 possible unique line heights:
% aaa - only small (least likely)
% Aaaa - upper and lower (middle likely)
% Aaay - upper and underline (most likely)
%
% If there's only 1, it's PROBABLY upper + underline
% If there's 2, the missing one is probably all lower
% if there's 3, then we're done
%
% Ultimately we didn't use this.

%{

scales = unique(heights);

switch length(scales)
    case 1 % all lines same height - assume upper + underline chars (max size)
        testline = lines{1};
        testline = testline + uint8(testline == 0);
        rowprods = prod(testline,2);
        
        lowerrange = find(rowprods < .0000000000001*max(rowprods));
        % This section tries to find the 'main line' .. we're assuming a
        % given row has most of its 'mass' in the lower-case size part of
        % the line
        
        lowerheight = lowerrange(end) - lowerrange(1) + 1;
        upperheight = lowerrange(end);
    case 2 % most likely: Some lines with upper + big lower, others with just upper
        upperheight = min(scales);
        lowerheight = upperheight - (max(scales)-upperheight); % lower case has evenly spaced margins
    case 3
        upperheight = median(scales);
        lowerheight = min(scales);
end
margin = upperheight - lowerheight;

clear rowprods testline lowerrange i
%}

%% Character extraction and fit

fits = cell(4,length(lines)); % initialize fit matrix

for lineidx = 1:length(lines) % for each line
    
    currline = lines{lineidx}; % extract the line matrix
    linechars = charExtract(currline); % extract the characters
    
    
    fits{1,lineidx} = inf(1,length(linechars));
    fits{2,lineidx} = cell(1,length(linechars));
    fits{3,lineidx} = cell(1,length(linechars));
    fits{4,lineidx} = cell(1,length(linechars));
    fits{5,lineidx} = cell(1,length(linechars));
    
    for linecharidx = 1:length(linechars) % for each character in the line

        

        inchar = linechars{linecharidx}; % extract the character matrix
        inchar = trimWhite(inchar); % trim off all whitespace (dictionary is same format - no whitespace)

        [ir,ic] = size(inchar);
        
        %[ar,ac] = size(dictionary(27).image);
        %ratio = ir/ar;
        
        for dictidx = 1:length(dictionary) % for each character in the dictionary

            dictchar = dictionary(dictidx).image; % pull out the character matrix
            [dr,dc] = size(dictchar);
            
            %adjchar = imresize(dictchar,ratio);
            %[sr,sc] = size(adjchar);

            %if sc >= ic
                
                newchar = imresize(inchar,[dr dc]); % scale up the selection to the dictionary char size
                %figure(3)
                %subplot(3,1,1)
                %imshow(inchar)
                %subplot(3,1,2)
                %imshow(adjchar)
                %subplot(3,1,3)
                %imshow(newchar)
                fit = sum(sum((abs(double(newchar) - double(dictchar)).^2)))/numel(dictchar); % measure fit based on RMSE
                bestfit = fits{1,lineidx}(linecharidx); % compare to bestfit so far
                if fit < bestfit % if current fit is better than best fit so far
                    %figure(3)
                    %subplot(3,1,1)
                    %imshow(inchar)
                    %title('Line character')
                    %subplot(3,1,2)
                    %imshow(newchar)
                    %title('Line character scaled')
                    %subplot(3,1,3)
                    %imshow(dictchar)
                    %title('Dictionary comparison')
                    
                   
                    fits{1,lineidx}(linecharidx) = fit; % put it into the fit matrix
                    fits{2,lineidx}(linecharidx) = cellstr(dictionary(dictidx).character);
                    fits{3,lineidx}{linecharidx} = inchar;
                    fits{4,lineidx}{linecharidx} = newchar;
                    fits{5,lineidx}{linecharidx} = dictchar;
                end
            %end
        end


    end
    
    OCRdisplay;
                
        

        %{
        for pos = 1:length(thing)-yn


            selection = thing(:,pos:pos+yn-1);
            selections(:,:,pos) = selection;


            charnew = double(charnew);
            selection = double(selection);

            fitval(pos) = sum(rms(abs(charnew-selection)));

        end
        %}
    %end
end


% transform line into character space with
% space-finder



% map the fit with respect to linear pos
% find the peaks

%{
        if find(uppers == charidx) % char is upper-height
            adjchar = imresize(char,upperheight/rc);
            [rc, cc] = size(adjchar);
            buffer = 255*ones(margin,cc);
            adjchar = vertcat(adjchar,buffer);
            %fits = slidingCharDetector(currline,adjchar,'upper');
        elseif find(biglowers == charidx)
            adjchar = imresize(char,upperheight/rc);
            [rc, cc] = size(adjchar);
            buffer = 255*ones(margin,cc);
            adjchar = vertcat(buffer,adjchar);
            %fits = slidingCharDetector(currline,adjchar,'biglower');
        else
            adjchar = imresize(char,lowerheight/rc);
            [rc, cc] = size(adjchar);
            buffer = 255*ones(margin,cc);
            adjchar = vertcat(buffer,adjchar,buffer);
            %fits = slidingCharDetector(currline,adjchar,'lower');
        end
        %}