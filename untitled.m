format shortG

x = 0:2/16:2-2/16;

y = sin(15*x)
[sprintf('%d,', y(1:end-1)), sprintf('%d', y(end))]