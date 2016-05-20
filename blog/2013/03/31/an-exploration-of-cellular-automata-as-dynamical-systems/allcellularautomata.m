function [history, fhistory] = allcellularautomata(initialstate, generations, initialrule, isheadless)

N = length(initialstate);

state = zeros(N, 1);
nextstate = zeros(N, 1);
history = zeros(generations, N);
fhistory = zeros(generations, 2);

for rulenumber = initialrule

if isheadless == 0
	f = figure();
else
	f = figure('visible','off');
end

state(:) = initialstate(:);
history(1,:) = state;
for g=2:generations
    for i=1:N
        % wrap around
        lefti = i-1;
        if lefti < 1
            lefti = N;
        end
        % wrap around
        righti = i+1;
        if righti > N
            righti = 1;
        end
        nextstate(i) = n3rule([state(lefti) state(i) state(righti)], rulenumber);
    end
    state(:) = nextstate(:);
    history(g,:) = state(:);
end

% Display a conventional cellular automata map,
% showing state as pixels in an image. This is like the examples here:
% http://mathworld.wolfram.com/CellularAutomaton.html
% and perhaps more appropriately,
% with examples of rules for neighborhood 3, here:
% http://mathworld.wolfram.com/ElementaryCellularAutomaton.html
imshow(history);
%colormap(hot(256))
title(strcat('History plot for Elementary Rule ', int2str(rulenumber)));


% To interpret the finite array of states in a way that would make sense
% for an infinite string of bits, we interpret the state as two floating
% point nubmers.
%
% More accurately, we treat the state as two strings of binary digits
% (bits), representing two real numbers in [0, 1]. They start in the middle
% of the array, and one has bits going right and the other has bits going
% left.
%
% The alternative, treating it as only one floating point number suffers
% from strange effects because of boundary conditions. That is, the
% least-significant bits of the floating point representation affect the
% most-significant bits. This is not an effect that would happen in the
% infinite case.
fhistory(:) = horzcat( ...
    sum( ...
        history(:,ceil(N/2):N) .* (2 .^ (-1 .* (1+repmat(ceil(N/2):N,generations,1)-ceil(N/2)))), ...
        2), ...
    sum( ...
        history(:,ceil(N/2)-1:-1:1) .* (2 .^ (-1 .* repmat(1:ceil(N/2)-1,generations,1))), ...
        2));


if isheadless == 0   
    disp('Initial state:')
    fhistory(1,:)
    disp('Ending state:')
    fhistory(generations,:)
    disp('press any key to continue');
    % wait for user input
    pause;
else
    print(f, '-r300', '-dpdf', strcat('rule', int2str(rulenumber), '-history.pdf'));
end


    plot(fhistory(:,1),fhistory(:,2));
    title(strcat('Orbit plot for Elementary Rule ', int2str(rulenumber)));

if isheadless ~= 0
    print(f, '-r300', '-dpdf', strcat('rule', int2str(rulenumber), '-orbit.pdf'));
end

datapath = strcat('rule', int2str(rulenumber), '.dat');
save(datapath, '-ascii', 'fhistory');
multilyapunov(datapath, rulenumber);

end % done with rules loop
end
