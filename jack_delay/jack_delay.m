f = [4096]; %[4096 2048 3072] %2560 2304 2176 1088 1312 1552 1800 3332 3586 3841];
ampls = 0.01 * ones(1, numel(f));
ampls(1) = 0.2;
fsamp = 48000;
len = 200;%8192*2;
tests = 10000;
delays = zeros(1, tests + 1);
%delays_fft = zeros(1, tests + 1);
actual_delay = 50;
%for actual_delay = 0:tests
p = 0 * ones(1, numel(f));
in = zeros(1, len);
%phase = zeros(1, len);
for k = actual_delay+1:len
    for frq = 1:numel(f)
        a = 2 * pi * p(frq) / 65536;
        p(frq) = p(frq) + f(frq);
        s = -sin(a);
        in(k) = in(k) + ampls(frq) * s;
%        phase(k) = a / (2 * pi);
    end
end
echoes = [zeros(1, 15), 0.25 * in];
in = in + echoes(1:len);
plot([1:len], in);

p = 0 * ones(1, numel(f));
x2 = zeros(1, numel(f));
y2 = zeros(1, numel(f));
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
        cnt = cnt + 1;
        if cnt == period
            cnt = 0;
            x2(frq) = x2(frq) + xa(frq);
            y2(frq) = y2(frq) + ya(frq);
            xa(frq) = 0;
            ya(frq) = 0;
        end
    end
end

d = atan2(y2(1), x2(1)) / (2 * pi);
%if (d > 0.5) d = d - 1.0; end
m = 1;
for frq = 2:numel(f)
%     ph = atan2(y2(frq), x2(frq)) / (2 * pi) - d * f(frq) / f(1);
%     ph = (ph - floor(ph)) * 2;
%     k = round(ph);
%     d = d + m * rem(k, 2);
%     m = m * 2;
    ph = atan2(y2(frq), x2(frq)) / (2 * pi) - d * f(frq) / f(1);
    d = d + m * (ph - floor(ph)) * 2;
    m = m * 2;
end

% Why do we have to start p from 128? Where does the offset in phase come
% from?
% Period 16 is natural for f = 4096 -- we have seamless wave, no need to
% window
% Why we need to "* (4096 / f(1))"? -- because d is from [-0.5, 0.5],
% period is 16, in order to scale the period we have to multiply
% Why using f < 64 looks wiggly? -- because it's arctan! It is not straight.
%del = d * period * (4096 / f(1));
if (d < 0) d = d + 1.0; end
del = d * 65536 / f(1);%(d + 0.5) * f(1) / 65536 * period;
delays(actual_delay + 1) = del;
%F = fft(in);
%d = (-angle(F(2)) + pi / 2) / (2 * pi);
%if (d < 0) d = d + 1.0; end
%delays_fft(actual_delay + 1) = d * 65536 / f(1);
%end
%plot([1:tests+1], [0:tests], [1:tests+1], delays);
%plot([1:tests+1], [0:tests], [1:tests+1], delays, [1:tests+1], delays_fft);
%plot([1:tests+1], delays);
