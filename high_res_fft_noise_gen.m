clear;
clc;

N = 2^20;
M = 2 * N;
fs = 48000;

print_RMS();
[c, X_c, c2, X_c2, uc_l, X_uc_l, uc_r, X_uc_r] = generate_interleaved_pink_noise(N, fs);
[y, ~] = audioread('Music.wav');
music_l = y(:,1);
music_r = y(:,2);
process_stereo('Corr', c, X_c, c, X_c, fs);
process_stereo('Left', c, X_c, zeros(1, M).', zeros(1, M), fs);
process_stereo('Uncorr2', c, X_c, c2, X_c2, fs);
process_stereo('UncorrI', uc_l, X_uc_l, uc_r, X_uc_r, fs);
process_stereo('Music', music_l, fft(music_l).', music_r, fft(music_r).', fs);

function process_stereo(name, l, X_l, r, X_r, fs)
    audiowrite(sprintf('%s_lr.wav', name), [l, r], fs, 'BitsPerSample', 32);
    [m, s] = build_ms(l, r);
    audiowrite(sprintf('%s_ms.wav', name), [m, s], fs, 'BitsPerSample', 32);
    [s_l, s_r, c] = extract_phantom_center(l, X_l, r, X_r);
    audiowrite(sprintf('%s_cs.wav', name), ...
        [s_l, s_r, c, zeros(1, length(l)).'], fs, 'BitsPerSample', 32);
    print_RMS(name, l, r, m, s, c, s_l, s_r);
end

function [m, s] = build_ms(l, r)
    m = (l + r) / 2;
    s = (l - r) / 2;
end

function [s_l, s_r, c] = extract_phantom_center(l, X_l, r, X_r)
    M = length(l);
    N = M / 2;
    X_c = zeros(1, M);
    for k = 2:(N + 1) % Includes DC (k=1) and Nyquist (k=N+1)
        xl_k = X_l(k);
        xr_k = X_r(k);
        % 1. Calculate the signed scalar for the center channel. 
        % This value can be negative if the inputs are largely out of phase.
        c_scalar = sqrt(0.5) * (abs(xl_k + xr_k) - abs(xl_k - xr_k));

        % 2. Get the sum vector, which defines the direction of the center channel. [cite: 166]
        sum_vec = xl_k + xr_k;

        % 3. Construct the final center channel FFT coefficient.
        % This creates a unit vector in the direction of `sum_vec` and scales it
        % by `c_scalar`. The complex multiplication automatically handles the
        % phase flip when `c_scalar` is negative. `eps` prevents division by zero.
        X_c(k) = (sum_vec / (abs(sum_vec) + eps)) * c_scalar;        
    end
    X_c((N + 2):M) = conj(fliplr(X_c(2:N)));
    X_sl = X_l - sqrt(0.5) * X_c;
    X_sr = X_r - sqrt(0.5) * X_c;
    X_sl((N + 2):M) = conj(fliplr(X_sl(2:N)));
    X_sr((N + 2):M) = conj(fliplr(X_sr(2:N)));
    c = real(ifft(X_c)).';
    s_l = real(ifft(X_sl)).';
    s_r = real(ifft(X_sr)).';
end

function [c, X_c, c2, X_c2, uc_l, X_uc_l, uc_r, X_uc_r] = generate_interleaved_pink_noise(N, fs)
    phases = 2 * pi * rand(1, N - 1);
    M = 2 * N;
    pos_freq_indices = 2:N;
    frequencies = (pos_freq_indices - 1) * fs / M;
    amplitudes = 1 ./ sqrt(frequencies);
    f_nyquist = N * fs / M;
    amp_nyquist = 1 / sqrt(f_nyquist);

    X_c_raw = zeros(1, M);
    X_c_raw(pos_freq_indices) = amplitudes .* exp(1i * phases);
    X_c_raw(N + 1) = amp_nyquist;
    [c, X_c] = td_from_fd(X_c_raw);
    
    phases2 = 2 * pi * rand(1, N - 1);
    X_c2_raw = zeros(1, M);
    X_c2_raw(pos_freq_indices) = amplitudes .* exp(1i * phases2);
    X_c2_raw(N + 1) = amp_nyquist;
    [c2, X_c2] = td_from_fd(X_c2_raw);
    
    X_uc_l_raw = X_c_raw;
    X_uc_r_raw = X_c_raw;
    X_uc_l_raw(2:2:end) = 0;
    X_uc_r_raw(3:2:end) = 0;
    [uc_l, X_uc_l] = td_from_fd(X_uc_l_raw);
    [uc_r, X_uc_r] = td_from_fd(X_uc_r_raw);

    rms_c = rms(c);
    rms_c2 = rms(c2);
    rms_uc_l = rms(uc_l);
    rms_uc_r = rms(uc_r);
    min_rms = min([rms_c rms_c2 rms_uc_l rms_uc_r]);
    c = c * min_rms / rms_c;
    X_c = X_c * min_rms / rms_c;
    c2 = c2 * min_rms / rms_c2;
    X_c2 = X_c2 * min_rms / rms_c2;
    uc_l = uc_l * min_rms / rms_uc_l;
    X_uc_l = X_uc_l * min_rms / rms_uc_l;
    uc_r = uc_r * min_rms / rms_uc_r;
    X_uc_r = X_uc_r * min_rms / rms_uc_r;
end

function [t, X_t] = td_from_fd(X_t_raw)
    M = length(X_t_raw);
    N = M / 2;
    X_t_raw((N + 2):M) = conj(fliplr(X_t_raw(2:N)));
    t_raw = real(ifft(X_t_raw)).';
    t_norm = max(abs(t_raw));
    t = t_raw / t_norm;
    X_t = X_t_raw / t_norm;
end

function print_RMS(name, l, r, m, s, c, s_l, s_r)
    if nargin < 1
        fprintf('  RMS in dB\n');
        fprintf('         [     L      R] [     M      S] [     C      L      R]\n');
    else
        rms_left_db = db(rms(l));
        rms_right_db = db(rms(r));
        rms_mid_db = db(rms(m));
        rms_side_db = db(rms(s));
        rms_corr_db = crop_db(db(rms(c)));
        rms_side_l_db = crop_db(db(rms(s_l)));
        rms_side_r_db = crop_db(db(rms(s_r)));
        fprintf('%8s [%6.2f %6.2f] [%6.2f %6.2f] [%6.2f %6.2f %6.2f]\n', ...
            name, rms_left_db, rms_right_db, rms_mid_db, rms_side_db, ...
            rms_corr_db, rms_side_l_db, rms_side_r_db);
    end
end

function crop = crop_db(db)
    if db >= -99.99
        crop = db;
    else
        crop = -Inf;
    end
end
