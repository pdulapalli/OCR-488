% Display script to show results of OCR system
% Shows results for first line by default.. adjust it if need be
line = lines{1};

fits{6,1} = [2 9 7 20 5 19 20]; % adjust this manually - alpha indices of correct chars

x = length(fits{1,1}); % set to num chars

figure(3);clf
for i=1:x
    subplot(4,x,i) % first row is inline chars
    imshow(fits{3,1}{i})
    subplot(4,x,i+x) % second row is scaled inline chars
    imshow(fits{4,1}{i})
    subplot(4,x,i+2*x) % third row is best found match
    imshow(fits{5,1}{i})
    subplot(4,x,i+3*x) % fourth row is true match (set manually above)
    imshow(dictionary(fits{6,1}(i)).image)
end