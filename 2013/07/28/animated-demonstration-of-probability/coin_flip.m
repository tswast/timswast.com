function coin_flip()
% Simulate a coin flip with a 'p' probability of landing on heads.
% This is an interactive function, so the value of p will be requested from
% the student.
%
% The result will be "plotted" as the text "Heads" or "Tails," which can
% then be combined into a gif image for the explanation.


p = input('enter p, the probability of heads (-1 to exit): ');
if (p > 1 || p < 0)
    return
end

t = input('enter t, the total number of trials: ');
if (t <= 0)
    return
end

% Now that we have all the parameters, we can run the trials.
% The rand method allows us to collect many samples with one function
% call, so we will run the trials up-front and create the plots later.
trials_uniform = rand([t, 1]);
trials = trials_uniform <= p;

for i=1:t
    % Plot the results.
    close all
    title(sprintf('trial %d', i));
    if trials(i)
        text(0.5, 0.5, 'Heads', ...
            'fontsize', 100, 'HorizontalAlignment', 'center');
    else
        text(0.5, 0.5, 'Tails', ...
            'fontsize', 100, 'HorizontalAlignment', 'center');
    end
    
    % For 'interactive', we pause between plots.
    sprintf('enter to continue')
    pause;
    
    % For 'automatic' (e.g. making an animation), we do not need to pause.
    % Instead, we save an image of the appropriate name.
    %print('-dpng', '-r100', sprintf('%03d.png', i));
end

end

