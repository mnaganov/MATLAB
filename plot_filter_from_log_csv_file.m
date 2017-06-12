function plot_filter_from_log_csv_file (csv_file, l_l_r_r)
  [freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us] = filter_from_log_csv_file(csv_file, l_l_r_r);
  plot_filter(freqs, start_fq, end_fq, l_freq_resp_db, l_phase_resp_deg, l_gd_us, r_freq_resp_db, r_phase_resp_deg, r_gd_us);
endfunction
