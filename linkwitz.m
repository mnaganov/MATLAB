data = csvread('/Users/mikhail/Sounds/linkwitz_3.csv', 1, 0);  % skip the header
log_freqs = data(:, 1);
start_fq = log_freqs(1);
end_fq = log_freqs(end);
log_l_freq_resp_db = data(:, 2);
log_r_freq_resp_db = data(:, 3);
log_l_phase_resp_deg = data(:, 4);
log_r_phase_resp_deg = data(:, 5);

freqs = start_fq:1:end_fq;
l_phase_resp = interp1(log_freqs, log_l_phase_resp_deg, freqs, 'spline') .* (pi / 180);
r_phase_resp = interp1(log_freqs, log_r_phase_resp_deg, freqs, 'spline') .* (pi / 180);
l_gd = -diff(unwrap(l_phase_resp)) / (2 * pi * (freqs(2) - freqs(1)));
r_gd = -diff(unwrap(r_phase_resp)) / (2 * pi * (freqs(2) - freqs(1)));

figure;

subplot(3, 1, 1);
semilogx(log_freqs, log_l_freq_resp_db, 'b', log_freqs, log_r_freq_resp_db, 'r');
grid on;
ylabel('dB');
xlim([start_fq, end_fq]);
title('Frequency response of the filter for direct (blue) and opposite (red) channels');

subplot(3, 1, 2);
semilogx(log_freqs, log_l_phase_resp_deg, 'b', log_freqs, log_r_phase_resp_deg, 'r');
grid on;
ylabel('deg');
xlim([start_fq, end_fq]);
title('Phase response of the filter for direct (blue) and opposite (red) channels');

subplot(3, 1, 3);
semilogx(freqs(2:end), l_gd * 1000000, 'b', freqs(2:end), r_gd * 1000000, 'r');
grid on;
ylabel('{\mu}s');
xlim([start_fq, end_fq]);
title('Group delay of the filter for direct (blue) and opposite (red) channels');
