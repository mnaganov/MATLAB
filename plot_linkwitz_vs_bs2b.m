[lnk_freqs, lnk_start_fq, lnk_end_fq, lnk_l_freq_resp_db, lnk_l_phase_resp_deg, lnk_l_gd_us, lnk_r_freq_resp_db, lnk_r_phase_resp_deg, lnk_r_gd_us] = ...
filter_from_log_csv_file(sound_data_dir('linkwitz_2.csv'), 1);

[bs2b_freqs, bs2b_start_fq, bs2b_end_fq, bs2b_l_freq_resp_db, bs2b_l_phase_resp_deg, bs2b_l_gd_us, bs2b_r_freq_resp_db, bs2b_r_phase_resp_deg, bs2b_r_gd_us] = ...
filter_from_wav_files(
    20, 20000,
    sound_data_dir('logsweep_20Hz_20000Hz_-6dBFS_5s-LeftCh.wav'),
    sound_data_dir('lggu-bs2b-logsweep_20Hz_20000Hz_-6dBFS_5s-LeftCh.wav'),
    200);

plot_filter_vs(
    bs2b_start_fq, bs2b_end_fq,
    'Linkwitz',
    lnk_freqs,
    lnk_l_freq_resp_db, lnk_l_phase_resp_deg, lnk_l_gd_us,
    lnk_r_freq_resp_db, lnk_r_phase_resp_deg, lnk_r_gd_us,
    'bs2b',
    bs2b_freqs,
    bs2b_l_freq_resp_db, bs2b_l_phase_resp_deg, bs2b_l_gd_us,
    bs2b_r_freq_resp_db, bs2b_r_phase_resp_deg, bs2b_r_gd_us,
    [-100, 300]);
