l_file = sound_data_dir('Phonitor-Med-30-1.2-L-96.csv');
r_file = sound_data_dir('Phonitor-Med-30-1.2-R-96.csv');

[tf, n_fft, fs] = tf_from_two_log_csv_files(l_file, r_file, 131072, 96000, 48, 48);

apply_binaural_filter(
    sound_data_dir('impulse-96-32-leftch.wav'),
    tf, fs,
    sound_data_dir('phonitor-96-IR.wav'));
