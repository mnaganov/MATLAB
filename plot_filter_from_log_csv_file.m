function plot_filter_from_log_csv_file (csv_file, l_l_r_r)
  [freqs, start_fq, end_fq, fq_resp] = filter_from_log_csv_file(csv_file, l_l_r_r);
  plot_filter(freqs, start_fq, end_fq, fq_resp);
endfunction
