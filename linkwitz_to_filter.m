%data = csvread('/Users/mikhail/Sounds/Phonitor-Med-30-1.2-FR.csv', 1, 0);  % skip the header
data = csvread('/Users/mikhail/Sounds/linkwitz_2.csv', 1, 0);  % skip the header
log_freqs = data(:, 1);
start_fq = log_freqs(1);
end_fq = log_freqs(end);
log_l_freq_resp_db = data(:, 2);
log_r_freq_resp_db = data(:, 3);
log_l_phase_resp_deg = data(:, 4);
log_r_phase_resp_deg = data(:, 5);

correction = 14.3  % direct, nB,nA = 1,1
%correction = 36  % opposite
%correction = -72.75 % phonitor direct
%correction = -6.5  % phonitor opposite

angle_log_freqs = log_freqs .* (pi / end_fq);
H_l = complex((10 .^ ((log_l_freq_resp_db .+ correction) ./ 20)), log_l_phase_resp_deg .* (pi / 180));
[B_l, A_l] = invfreqz(H_l, angle_log_freqs, 2, 2);

[H_bq_l, fq_bq_l] = freqz(B_l, A_l, 2048, 0, end_fq * 2);

subplot(2, 1, 1);
semilogx(fq_bq_l, 20 * log10(abs(H_bq_l)), 'b', log_freqs, log_l_freq_resp_db .+ correction, 'r');
grid on;
xlim([start_fq, end_fq]);

subplot(2, 1, 2);
semilogx(fq_bq_l, angle(H_bq_l) .* (180 / pi), 'b', log_freqs, log_l_phase_resp_deg, 'r');
grid on;
xlim([start_fq, end_fq]);