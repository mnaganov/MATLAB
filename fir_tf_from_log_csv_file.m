function [tf, n_fft, fs] = fir_tf_from_log_csv_file (csv_file, l_l_r_r, n_fft, fs, n_taps)
  data = csvread(csv_file, 1, 0);  % skip the header

  frqs = data(:, 1).';
  log_l_freq_resp_db = data(:, 2).';
  if (l_l_r_r == 1)
    log_r_freq_resp_db = data(:, 3).';
  else % l_r_l_r
    log_r_freq_resp_db = data(:, 4).';
  end

  tf.l.B = compute_fir_filter(frqs, log_l_freq_resp_db, n_fft, fs, n_taps);
  tf.l.A = [];
  tf.r.B = compute_fir_filter(frqs, log_r_freq_resp_db, n_fft, fs, n_taps);
  tf.r.A = [];
  tf.r.am_attn_db = log_l_freq_resp_db(1) - log_r_freq_resp_db(1);
end
