function apply_filter (stim_file, tf, fs, resp_file)
  [stim_wave_lr, s_rate] = audioread(stim_file);
  if (columns(stim_wave_lr) != 2)
    error("stimulus file must be stereo");
  endif
  if (s_rate != fs)
    error("stimulus file sampling rate %d != filter sampling rate %d", s_rate, fs);
  endif
  resp_wave(:, 1) = filter(tf.l.B, tf.l.A, stim_wave_lr(:, 1));
  resp_wave(:, 2) = filter(tf.l.A, tf.l.B, stim_wave_lr(:, 2));
  if (any(strcmp(fieldnames(tf.r), 'am_attn_db')))
    resp_wave(:, 2) = resp_wave(:, 2) .* from_db(tf.r.am_attn_db);
  endif
  audiowrite(resp_file, resp_wave, fs);
endfunction

function in_ampls = from_db (db)
  in_ampls = 10 ** (db / 20);
endfunction
