l_file = sound_data_dir('Phonitor-Med-30-1.2-L-96.csv');
r_file = sound_data_dir('Phonitor-Med-30-1.2-R-96.csv');

[meas_frqs, _, meas_fq_resp] = filter_from_two_log_csv_files(l_file, r_file);

[mdl_tf, n_fft, fs] = tf_from_two_log_csv_files(l_file, r_file, 8192, 96000, 12, 12);
[mdl_frqs, mdl_fq_lim, mdl_fq_resp] = filter_from_tf([20, 20000], mdl_tf, n_fft, fs);

plot_filter_vs(
    mdl_fq_lim,
    'measured', meas_frqs, meas_fq_resp,
    'model', mdl_frqs, mdl_fq_resp);
