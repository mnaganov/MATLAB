l_file = sound_data_dir('ph-iir/m-30-1_2-ld.csv');
r_file = sound_data_dir('ph-iir/m-30-1_2-ro.csv');

[meas_frqs, ~, meas_fq_resp] = filter_from_two_log_csv_files(l_file, r_file);

[mdl_tf, n_fft, fs] = tf_from_two_log_csv_files(l_file, r_file, 65536, 44100, 24, 24);
[mdl_frqs, mdl_fq_lim, mdl_fq_resp] = filter_from_tf([10, 22049], mdl_tf, n_fft, fs);

plot_filter_vs_fr_only( ...
    mdl_fq_lim, ...
    'measured', meas_frqs, meas_fq_resp, ...
    'model', mdl_frqs, mdl_fq_resp);
