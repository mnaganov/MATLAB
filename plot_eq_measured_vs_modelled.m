## s_file = sound_data_dir('logsweep_20Hz_20000Hz_-6dBFS_5s-48kHz-LeftCh.wav');
s_file = sound_data_dir('equalized-48k.wav');
r_file = sound_data_dir('equalized-48k.wav');
fq_lim = [20, 20000];

[meas_frqs, _, meas_fq_resp] = filter_from_wav_files(fq_lim, s_file, r_file, 20);

[mdl_tf, n_fft, fs] = tf_from_wav_files(fq_lim, s_file, r_file, 100, 4096, 9, 9);
[mdl_frqs, mdl_fq_lim, mdl_fq_resp] = filter_from_tf(fq_lim, mdl_tf, n_fft, fs);

plot_filter_vs(
    fq_lim,
    'measured', meas_frqs, meas_fq_resp,
    'model', mdl_frqs, mdl_fq_resp);
