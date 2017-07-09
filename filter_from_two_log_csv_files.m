function [frqs, fq_lim, fq_resp] = filter_from_two_log_csv_files (l_csv_file, r_csv_file)
  l_data = csvread(l_csv_file, 1, 0);  % skip the header
  r_data = csvread(r_csv_file, 1, 0);  % skip the header

  [frqs, fq_lim, fq_resp] = transform_log_data(l_data(:, 1), l_data(:, 2), l_data(:, 3), r_data(:, 1), r_data(:, 2), r_data(:, 3));
endfunction
