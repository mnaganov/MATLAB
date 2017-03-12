
function [xdb] = db(x,mindb)
% [y] = db(x,mindb) 
% convert x to db, optionally clipped to mindb - see also dbn()

ax = abs(x);
xmax = max(ax(:));
if nargin<2, xmin = xmax*eps; else xmin = 10^(mindb/20); end
xdb = 20*log10(max(abs(x),xmin*ones(size(x))));
