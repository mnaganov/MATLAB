function [frqs, fq_lim, fq_resp] = filter_from_log_csv_file_mono (csv_file)
  data = csvread(csv_file, 1, 0);  % skip the header

  [frqs, fq_lim, fq_resp] = transform_log_data_mono(data(:, 1), data(:, 2), data(:, 3));
endfunction
