s_file = sound_data_dir('logsweep_20Hz_20000Hz_-6dBFS_5s-LeftCh.wav');
r_file = sound_data_dir('lggu-bs2b-logsweep_20Hz_20000Hz_-6dBFS_5s-LeftCh.wav');
fq_lim = [20, 20000];

[meas_freqs, _, meas_fq_resp] = filter_from_wav_files(fq_lim, s_file, r_file, 20);

[mdl_tf, n_fft, fs] = tf_from_wav_files(fq_lim, s_file, r_file, 100, 2048, 2, 2);
[mdl_freqs, mdl_fq_lim, mdl_fq_resp] = filter_from_tf(fq_lim, mdl_tf, n_fft, fs);

plot_filter_vs(
    fq_lim,
    'measured', meas_freqs, meas_fq_resp,
    'model', mdl_freqs, mdl_fq_resp);
