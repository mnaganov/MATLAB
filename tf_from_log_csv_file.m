function [tf, n_fft, fs] = tf_from_log_csv_file (csv_file, n_fft, fs, n_poles, n_zeroes)
  data = csvread(csv_file, 1, 0);  % skip the header

  [tf.B, tf.A] = compute_iir_filter(data(:, 1).', data(:, 2).', n_fft, fs, n_poles, n_zeroes);
endfunction
