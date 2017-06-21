[tf, n_fft, fs] = experimental_phonitor_tf();
apply_binaural_filter(
    sound_data_dir('fzm-stimulus-leftch.wav'),
    tf, fs,
    sound_data_dir('fzm-phonitor-response.wav'));
