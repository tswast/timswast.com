function out = n3rule(M, n)
% Given a rule set, n, as a unsigned 8-bit integer (uint8),
% does the state M produce a live or dead cell?
% M is a size-3 array representing a small neighborhood.

% Convert the neighborhood into a bitmask representing the rule
% number.
bitindex = M .* [4, 2, 1];
bitindex = sum(bitindex);
bitmask = uint8(2^bitindex);

out = bitand(bitmask, n) ~= 0;

end
