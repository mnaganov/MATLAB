m_file = sound_data_dir('ph-iir/hd650.csv');

[meas_frqs, ~, meas_fq_resp] = filter_from_log_csv_file_mono(m_file);

[mdl_tf, n_fft, fs] = tf_from_log_csv_file(m_file, 65536, 44100, 48, 48);
[mdl_frqs, mdl_fq_lim, mdl_fq_resp] = filter_from_tf_mono([10, 22049], mdl_tf, n_fft, fs);

plot_mono_filter_vs( ...
    mdl_fq_lim, ...
    'measured', meas_frqs, meas_fq_resp, ...
    'model', mdl_frqs, mdl_fq_resp);
