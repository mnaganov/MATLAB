function [tf, n_fft, fs] = tf_from_two_log_csv_files (l_csv_file, r_csv_file, n_fft, fs, n_poles, n_zeroes)
  l_data = csvread(l_csv_file, 1, 0);  % skip the header
  r_data = csvread(r_csv_file, 1, 0);  % skip the header

  [tf.l.B, tf.l.A] = compute_iir_filter(l_data(:, 1).', l_data(:, 2).', n_fft, fs, n_poles, n_zeroes);
  [tf.r.B, tf.r.A] = compute_iir_filter(r_data(:, 1).', r_data(:, 2).', n_fft, fs, n_poles, n_zeroes);
  tf.r.am_attn_db = l_data(1, 2) - r_data(1, 2);
end
