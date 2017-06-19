function plot_filter_from_two_log_csv_files (l_csv_file, r_csv_file)
  [freqs, fq_lim, fq_resp] = filter_from_two_log_csv_files(l_csv_file, r_csv_file);
  plot_filter(freqs, fq_lim, fq_resp);
endfunction
