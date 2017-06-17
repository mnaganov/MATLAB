[lkz_freqs, lkz_fq_lim, lkz_fq_resp] = filter_from_log_csv_file(
    sound_data_dir('linkwitz_2.csv'), 1);

[bs2b_freqs, bs2b_fq_lim, bs2b_fq_resp] = filter_from_wav_files(
    [20, 20000],
    sound_data_dir('logsweep_20Hz_20000Hz_-6dBFS_5s-LeftCh.wav'),
    sound_data_dir('lggu-bs2b-logsweep_20Hz_20000Hz_-6dBFS_5s-LeftCh.wav'),
    200);

plot_filter_vs(
    bs2b_fq_lim,
    'Linkwitz', lkz_freqs, lkz_fq_resp,
    'bs2b', bs2b_freqs, bs2b_fq_resp,
    [-100, 300]);
