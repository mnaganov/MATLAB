% remove n_taps!
function B = compute_fir_filter (frqs, am_db, n_fft, fs, n_taps)
  % Interpolate amplitude response from 0 to fs / 2.
  am_db_poly = interp1(frqs, am_db, 'linear', 'pp');
  full_frqs = [0, frqs, fs / 2];
  full_am_db = [ppval(am_db_poly, 0), am_db, ppval(am_db_poly, fs / 2)];
  full_am_db = full_am_db - full_am_db(1);

  % Resample amplitude response to a uniform frequency grid.
  uniform_frqs = fs * [0:n_fft / 2] / n_fft;
  uniform_am_db = interp1(full_frqs, full_am_db, uniform_frqs, 'spline');
  uniform_len = length(uniform_am_db);
  if (uniform_len != n_fft / 2 + 1)
    error("sanity check: amplitude response length %d does not correspond to n_fft %d",
          uniform_len, n_fft);
  endif

  fs_am_db = [uniform_am_db, uniform_am_db(uniform_len - 1:-1:2)];
  B_non_causal = real(ifft(from_db(fs_am_db)));
  % Verify that the source frequency response is smooth enough
  if (compute_error(B_non_causal, uniform_len, 'impulse') > 1.0)
    error("insufficient n_fft, or non-smooth target response");
  endif
  B = [B_non_causal(n_fft / 2 + 2:n_fft), B_non_causal(1:n_fft / 2 + 1)];
  %B = B .* blackmanharris(length(B));
endfunction

function in_ampls = from_db (db)
  in_ampls = 10 .^ (db / 20);
endfunction

function err = compute_error(resp, len, name)
  err = 100 * norm(resp(round(0.9 * len:1.1 * len))) / norm(resp);
  disp(sprintf(['Outer 20%% of %s holds %0.2f'], name, err));
endfunction
