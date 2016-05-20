function [output] = ismultiple(scaledv, rootv)
% Returns 1 if scaledv = lambda * rootv for some scalar lambda.
% Otherwise 0

% Define some value of 'close'.
% Here we use the machine epsilon for the single precision value of 1.
% Even though the default is double precision, this will make it more
% likely for us to find better Lyapunov exponents in the multi-dimensional
% case.
myeps = eps('single');
output = 0;

% Two vectors are linearly dependent when the determinant of this matrix
% is zero. See:
% http://www.math.oregonstate.edu/home/programs/undergrad/CalculusQuestStudyGuides/vcalc/lindep/lindep.html
% http://en.wikipedia.org/wiki/Linear_independence#Alternative_method_using_determinants
D = horzcat(scaledv', rootv');
if det(D) <= myeps
    output = 1;
end

end