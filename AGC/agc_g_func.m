g = @(K, b) (1 - b ./ K) .^ K;
bs = linspace(0, 4, 4000);
figure(1);
Ks = [1 2 4 40 -40 -4 -2 -1];
for K = Ks
    gK = @(b) g(K, b);
    gKs = gK(bs);
    endidx = length(bs);
    if (K > 0)
        for i = 1:length(bs)
            if bs(i) > K
                endidx = i;
                break;
            end
        end
    end
    if K == 4
        plot(bs(1:endidx), gKs(1:endidx), 'LineWidth', 2);
    elseif K == -4
        plot(bs, gKs, '--', 'LineWidth', 2);
    elseif K < 0
        plot(bs, gKs, '--');
    else
        plot(bs(1:endidx), gKs(1:endidx));
    end
    xlim([min(bs) max(bs)]);
    ylim([0 1]);
    hold on;
end
hold off;
legends = {};
for i = 1:length(Ks)
    legends{i} = int2str(Ks(i));
end
legend(legends, 'Location', 'Northeast');
