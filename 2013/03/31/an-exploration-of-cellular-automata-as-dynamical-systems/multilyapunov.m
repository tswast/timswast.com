function multilyapunov(filename, isheadless)
% Calculates the largest Lyapunov exponent of a dataset.
% Uses the method described here:
% http://sprott.physics.wisc.edu/chaos/lyapexp.htm
% We use norm(), rather than abs(). This amounts to taking the
% Euclidean distance between vectors.

% load in data file
data = load(filename);
% calculate number of data points
[N,M] = size(data);
N2 = floor(N/2);
N4 = floor(N/4);
% find mid point of orbit sequence
k=N2;
% create space for exponents
exponent = zeros(N4,1);
dprev = zeros(M,1)';
myeps = eps('single');
% look at 1/4 of the points
for (j=1:N4)
    % set distance initially
    d = norm(data(k+1,:)-data(k,:));
    index = k+1;
    for (i=2:N-1)
        % see if there is a closer point
        % We must be careful in this step to ensure that
        % we renormalize along the line between the two previous
        % points. That way we are getting the largest Lyapunov exponent.
        dcurr = data(i,:)-data(k,:);
        if (i ~= k) && (norm(dcurr))<d && ismultiple(dprev, dcurr) == 1
            d = norm(dcurr);
            index = i;
        end
    end
    % write log of quotient as difference of logs to get better accuracy!
    if norm(data(k,:)-data(index,:)) > myeps && norm(data(k+1,:)-data(index+1,:)) > myeps
        exponent(j) = log( norm(data(k+1,:)-data(index+1,:)))-log(norm(data(k,:)-data(index,:)));
    end
    % repeat with the next point
    k = k+1;
end

% now plot the lyapunov exponents
t = 1:N4;
lyapunov = exponent(1:N4);
exp_avg = 0.0;
% find the average value for lyapunov exponent
for (i=1:N4)
    exp_avg = exp_avg + exponent(i);
end


% plot the exponents, the average, and the baseline
if isheadless == 0
	f = figure();
else
	f = figure('visible','off');
end
exp_avg = exp_avg/N4;
plot(t,lyapunov,t,0,t,exp_avg);

if isheadless ~= 0
    pathprefix = strcat('rule', int2str(isheadless), '-lyapunov');
    print(f, '-r300', '-dpdf', strcat(pathprefix, '.pdf'));
    fid = fopen(strcat(pathprefix, '.txt'), 'w');
else
    fid = 0;
end
fprintf(fid, 'average value for lyapunov exponent is: %f\n', exp_avg);
fclose(fid);

