function plot_filter_from_two_log_csv_files (l_csv_file, r_csv_file)
  [frqs, fq_lim, fq_resp] = filter_from_two_log_csv_files(l_csv_file, r_csv_file);
  plot_filter(frqs, fq_lim, fq_resp);
end
