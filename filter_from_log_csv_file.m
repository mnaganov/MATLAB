function [freqs, start_fq, end_fq, fq_resp] = filter_from_log_csv_file (csv_file, l_l_r_r)
  data = csvread(csv_file, 1, 0);  % skip the header

  if (l_l_r_r == 1)
    log_l_phase_resp_deg = data(:, 4);
    log_r_r_freq_resp_db = data(:, 3);
  else % l_r_l_r
    log_l_phase_resp_deg = data(:, 3);
    log_r_r_freq_resp_db = data(:, 4);
  endif
  [freqs, start_fq, end_fq, fq_resp] = transform_log_data(data(:, 1), data(:, 2), log_l_phase_resp_deg, data(:, 1), log_r_r_freq_resp_db, data(:, 5));
endfunction
