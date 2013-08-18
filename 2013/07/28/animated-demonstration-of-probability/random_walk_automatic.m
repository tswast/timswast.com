function random_walk_automatic()
% Simulate a 'random walk'. With probability, p, have a payout of 1
% otherwise, the payout is -1. We then watch to see how the total payout
% evolves.

% By setting automatic, we create files instead of waiting for plots.
is_automatic = 0;

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
trials = 2.0 .* (trials_uniform <= p) - 1.0;
totals = cumsum(trials);
bounds = max([max(totals) -min(totals)]);

for i=1:t
    % Plot the results.
    %close all
    %title(sprintf('trial %d', i));
    cla
    
    plot(1:i, totals(1:i));
    ylim([-bounds bounds]);
    xlim([0 t]);
    
    if is_automatic
        % For 'automatic' (e.g. making an animation), we do not need to pause.
        % Instead, we save an image of the appropriate name.
        print('-dpng', '-r100', sprintf('%03d.png', i));
    else
        % For 'interactive', we pause between plots.
        sprintf('enter to continue')
        pause;
    end
end

end
