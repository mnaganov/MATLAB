function plot_filter_from_log_csv_file (csv_file, l_l_r_r)
  [frqs, fq_lim, fq_resp] = filter_from_log_csv_file(csv_file, l_l_r_r);
  plot_filter(frqs, fq_lim, fq_resp);
endfunction
