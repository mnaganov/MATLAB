[meas_freqs, _, meas_fq_resp] = filter_from_two_log_csv_files(
    sound_data_dir('Phonitor-Med-30-1.2-FR-Left-1_3.csv'),
    sound_data_dir('Phonitor-Med-30-1.2-FR-Right-1_3.csv'));

[mdl_tf, n_fft, fs] = experimental_phonitor_tf();
[mdl_freqs, mdl_fq_lim, mdl_fq_resp] = filter_from_tf(
    [20, 20000], mdl_tf, n_fft, fs);

plot_filter_vs(
    mdl_fq_lim,
    'measured', meas_freqs, meas_fq_resp,
    'model', mdl_freqs, mdl_fq_resp);