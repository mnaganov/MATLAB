[phn_freqs, phn_fq_lim, phn_fq_resp] = filter_from_two_log_csv_files(
    sound_data_dir('Phonitor-Med-30-1.2-FR-Left-1_1.csv'),
    sound_data_dir('Phonitor-Med-30-1.2-FR-Right-1_1.csv'));

[tb_freqs, tb_fq_lim, tb_fq_resp] = filter_from_wav_files(
    [20, 20000],
    sound_data_dir('fzm-stimulus-leftch.wav'),
    sound_data_dir('fzm-tb-min-response.wav'),
    200);

plot_filter_vs(
    tb_fq_lim,
    'phn', phn_freqs, phn_fq_resp,
    'tb', tb_freqs, tb_fq_resp,
    [-150, 500]);
