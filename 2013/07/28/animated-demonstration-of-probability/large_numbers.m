function large_numbers()
% Simulate a 'random walk'. With probability, p, have a payout of 1
% otherwise, the payout is -1.
%
% Instead of watching the total payout, as we did in the random_walk
% experiments, we watch the *average* payout. This should converge to
% the expected value of the random variable.

% By setting automatic, we create files instead of waiting for plots.
is_automatic = 1;
skipsize=4;

p = input('enter p, the probability of heads (-1 to exit): ');
if (p > 1 || p < 0)
    return
end

t = input('enter t, the total number of trials: ');
if (t <= 0)
    return
end

hvalue = input('enter the value associated with heads: ');
tvalue = input('enter the value associated with tails: ');

% Now that we have all the parameters, we can run the trials.
% The rand method allows us to collect many samples with one function
% call, so we will run the trials up-front and create the plots later.
trials_uniform = rand([t, 1]);
trials = hvalue .* (trials_uniform <= p) + tvalue .* (trials_uniform > p);
totals = cumsum(trials);
averages = totals ./ [1:t]';
bounds = max([max(averages) -min(averages)]);

% Calculate the expected value so that we have something with which to
% compare.
expected_value = (hvalue * p) + (tvalue * (1-p));

for i=1:skipsize:t
    % Plot the results.
    %close all
    %title(sprintf('trial %d', i));
    cla
    
    plot(1:i, averages(1:i), ...
        [1 t], [expected_value expected_value]);
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
