function [B, A] = compute_iir_filter (frqs, am_db, n_fft, fs, n_poles, n_zeroes)
  % Interpolate amplitude response from 0 to fs / 2.
  am_db_poly = interp1(frqs, am_db, 'linear', 'pp');
  full_frqs = [0, frqs, fs / 2];
  full_am_db = [ppval(am_db_poly, 0), am_db, ppval(am_db_poly, fs / 2)];
  full_am_db = full_am_db - full_am_db(1);

  % Resample amplitude response to a uniform frequency grid.
  uniform_frqs = fs * [0:n_fft / 2] / n_fft;
  uniform_am_db = interp1(full_frqs, full_am_db, uniform_frqs, 'spline');
  uniform_len = length(uniform_am_db);
  if (uniform_len ~= n_fft / 2 + 1)
    error("sanity check: amplitude response length %d does not correspond to n_fft %d", ...
          uniform_len, n_fft);
  end

  fs_am_db = [uniform_am_db, uniform_am_db(uniform_len - 1:-1:2)];
  % Verify that the source frequency response is smooth enough
  if (compute_error(real(ifft(from_db(fs_am_db))), uniform_len, 'impulse') > 1.0)
    error("insufficient n_fft, or non-smooth target response");
  end

  cepst = ifft(fs_am_db);
  if (compute_error(cepst, uniform_len, 'cepstrum') > 1.0)
    error("insufficient n_fft, or non-smooth target response");
  end
  cepst_folded = [cepst(1), cepst(2:uniform_len - 1) + cepst(n_fft:-1:uniform_len + 1), ...
                  cepst(uniform_len), zeros(1, n_fft - uniform_len)];

  min_phase_spec_full = from_db(fft(cepst_folded));
  min_phase_spec = min_phase_spec_full(1:uniform_len);
  weights = 1 ./ (uniform_frqs + 1);
  [B, A] = invfreqz(min_phase_spec, 2 * pi * uniform_frqs / fs, n_zeroes, n_poles, weights);
end

function in_ampls = from_db (db)
  in_ampls = 10 .^ (db / 20);
end

function err = compute_error(resp, len, name)
  err = 100 * norm(resp(round(0.9 * len:1.1 * len))) / norm(resp);
  disp(sprintf(['Outer 20%% of %s holds %0.2f'], name, err));
end
