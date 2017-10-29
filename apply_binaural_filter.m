function apply_binaural_filter (stim_file, tf, fs, resp_file)
  [stim_wave_lr, s_rate] = audioread(stim_file);
  if (columns(stim_wave_lr) ~= 2)
    error("stimulus file must be stereo");
  end
  if (s_rate ~= fs)
    error("stimulus file sampling rate %d ~= filter sampling rate %d", s_rate, fs);
  end
  stim_info = audioinfo(stim_file);
  pre_attn = 1.0;
  if (any(strcmp(fieldnames(tf), 'pre_am_attn_db')))
    pre_attn = from_db(-tf.pre_am_attn_db);
  end
  stim_wave_l = stim_wave_lr(:, 1) .* pre_attn;
  stim_wave_r = stim_wave_lr(:, 2) .* pre_attn;
  opposite_attn = 1.0;
  if (any(strcmp(fieldnames(tf.r), 'am_attn_db')))
    opposite_attn = from_db(-tf.r.am_attn_db);
  end
  resp_wave(:, 1) = filter(tf.l.B, tf.l.A, stim_wave_l) + ...
                    filter(tf.r.B, tf.r.A, stim_wave_r) .* opposite_attn;
  resp_wave(:, 2) = filter(tf.l.B, tf.l.A, stim_wave_r) + ...
                    filter(tf.r.B, tf.r.A, stim_wave_l) .* opposite_attn;
  audiowrite(resp_file, resp_wave, fs, ...
             'BitsPerSample', stim_info.BitsPerSample, ...
             'Title', stim_info.Title, ...
             'Artist', stim_info.Artist, ...
             'Comment', 'Processed with binaural IIR filter');
end

function in_ampls = from_db (db)
  in_ampls = 10 .^ (db / 20);
end
