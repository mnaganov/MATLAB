function resp_wave = apply_binaural_filter (stim_wave_lr, tf)
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
end

function in_ampls = from_db (db)
  in_ampls = 10 .^ (db / 20);
end
