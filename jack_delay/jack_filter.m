fsamp = 48000;
wlp = 200 / fsamp;
%input = ones(1, 1000);
input = rand(1, 1000);
output1 = zeros(1, numel(input));
output2 = zeros(1, numel(input));
x1 = 0;
x2 = 0;
for k = 1:numel(input)
  x1 = x1 + wlp * (input(k) - x1 + 1e-20);
  x2 = x2 + wlp * (x1 - x2 + 1e-20);
  output1(k) = x1;
  output2(k) = x2;
end
plot([1:numel(input)], input, [1:numel(input)], output1, [1:numel(input)], output2);
