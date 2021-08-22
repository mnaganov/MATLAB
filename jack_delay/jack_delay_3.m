f = [4096 2048 3072 2560 2304 2176 1088 1312 1552 1800 3332 3586 3841];
ampls = 0.01 * ones(1, numel(f));
ampls(1) = 0.2;
fsamp = 48000;
wlp = 200 / fsamp;
len = 12000;
tests = 300;
delays = zeros(1, tests + 1);
for actual_delay = 0:tests
    p = 128 * ones(1, numel(f));
    in = zeros(1, len);
    for k = actual_delay+1:len
        for frq = 1:numel(f)
            a = 2 * pi * p(frq) / 65536;
            p(frq) = p(frq) + f(frq);
            s = -sin(a);
            in(k) = in(k) + ampls(frq) * s;
        end
    end
    %in = 20 * in;
    %in(in > 1.0) = 1.0;
    %in(in < -1.0) = -1.0;
    echoes = [zeros(1, 50), 0.25 * in];
    in = in + echoes(1:len);
    
    p = 128 * ones(1, numel(f));
    x2 = zeros(1, numel(f));
    y2 = zeros(1, numel(f));
    x1 = zeros(1, numel(f));
    y1 = zeros(1, numel(f));
    xa = zeros(1, numel(f));
    ya = zeros(1, numel(f));
    cnt = 0;
    period = 16;
    for k = 1:len
        for frq = 1:numel(f)
            a = 2 * pi * p(frq) / 65536;
            p(frq) = p(frq) + f(frq);
            c = cos(a);
            s = -sin(a);
            xa(frq) = xa(frq) + s * in(k);
            ya(frq) = ya(frq) + c * in(k);
        end
        cnt = cnt + 1;
        if cnt == period
            cnt = 0;
            for frq = 1:numel(f)
                x1(frq) = x1(frq) + wlp * (xa(frq) - x1(frq) + 1e-20);
                y1(frq) = y1(frq) + wlp * (ya(frq) - y1(frq) + 1e-20);
                x2(frq) = x2(frq) + wlp * (x1(frq) - x2(frq) + 1e-20);
                y2(frq) = y2(frq) + wlp * (y1(frq) - y2(frq) + 1e-20);
                xa(frq) = 0;
                ya(frq) = 0;
            end
        end
    end

    d = atan2(y2(1), x2(1)) / (2 * pi);
    m = 1;
    for frq = 2:numel(f)
        ph = atan2(y2(frq), x2(frq)) / (2 * pi) - d * f(frq) / f(1);
        ph = (ph - floor(ph)) * 2;
        k = round(ph);
        d = d + m * rem(k, 2);
        m = m * 2;
    end

% Period 16 is natural for f = 4096 -- we have seamless wave, no need to
% window
    del = d * 65536 / f(1);
    delays(actual_delay + 1) = del;
end
plot(1:tests+1, 0:tests, '--', 1:tests+1, delays);
legend({'Actual delay, frames','Phase delay, frames'},'Location','northwest');
xlim([0 tests+1]);
grid on;
%plot([1:tests+1], [0:tests], [1:tests+1], delays, [1:tests+1], delays_fft);
%plot([1:tests+1], delays);
