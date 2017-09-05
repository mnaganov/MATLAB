m_file = sound_data_dir('HA-DSP-Loopback.csv');

[tf, n_fft, fs] = tf_from_log_csv_file(m_file, 8192, 96000, 12, 12);

apply_filter_mono(
    sound_data_dir('impulse-96-mono.wav'),
    tf, fs,
    sound_data_dir('ha-dsp-looback-96-IR.wav'));
