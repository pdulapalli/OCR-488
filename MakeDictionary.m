clear, clc

files = dir('/Users/pdulapalli/Documents/Duke/Fall_2015/ECE 488/Projects/OCR_488/Dictionary/*.png');

for i = 1:length(files)
    name = files(i).name;
    image = rgb2gray(imread(name));
    save(strcat(name(1:end-4), '.mat'), 'image');
end