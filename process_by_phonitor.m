l_file = sound_data_dir('Phonitor-Med-30-1.2-L-96.csv');
r_file = sound_data_dir('Phonitor-Med-30-1.2-R-96.csv');

[meas_frqs, _, meas_fq_resp] = filter_from_two_log_csv_files(l_file, r_file);
[tf, n_fft, fs] = tf_from_two_log_csv_files(l_file, r_file, 8192, 96000, 12, 12);

apply_binaural_filter(
    sound_data_dir('impulse-96-LeftCh.wav'),
    tf, fs,
    sound_data_dir('phonitor-96-IR.wav'));
