function plot_filter_from_two_log_csv_files (l_csv_file, r_csv_file)
  l_data = csvread(l_csv_file, 1, 0);  % skip the header
  r_data = csvread(r_csv_file, 1, 0);  % skip the header

  [freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us] = transform_log_data(l_data(:, 1), l_data(:, 2), l_data(:, 3), r_data(:, 1), r_data(:, 2), r_data(:, 3));
  plot_filter(freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us);
endfunction
