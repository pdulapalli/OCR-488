function chars = charExtract(currline)
% Outputs an array of arrays (struct) of each character in the input line


colprods = prod(currline); % calculate column products of the line

log = find(colprods < 0.4*max(colprods)); % threshold at 40% of pure whitespace

start = 1;
past = log(1);
charidx = 1;

clear chars

% The following section (lines 18-27) groups columns within a line, sectioned by
% the 'white' columns

for idx = 2:length(log)
    
    curr = log(idx);
    if (curr ~= past + 1) || idx == length(log)
        chars{charidx} = currline(:,start:past);
        charidx = charidx + 1;
        start = curr;
    end
    
   past = curr;
    
end