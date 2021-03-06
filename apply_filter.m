function apply_filter (stim_file, tf, fs, resp_file)
  [stim_wave_lr, s_rate] = audioread(stim_file);
  [~, channels] = size(stim_wave_lr);
  if (channels ~= 2)
    error("stimulus file must be stereo");
  end
  if (s_rate ~= fs)
    error("stimulus file sampling rate %d ~= filter sampling rate %d", s_rate, fs);
  end
  stim_info = audioinfo(stim_file);
  resp_wave(:, 1) = filter(tf.l.B, tf.l.A, stim_wave_lr(:, 1));
  resp_wave(:, 2) = filter(tf.l.A, tf.l.B, stim_wave_lr(:, 2));
  if (any(strcmp(fieldnames(tf.r), 'am_attn_db')))
    resp_wave(:, 2) = resp_wave(:, 2) .* from_db(tf.r.am_attn_db);
  end
  audiowrite(resp_file, resp_wave, fs, ...
             'BitsPerSample', stim_info.BitsPerSample, ...
             'Title', optional_param(stim_info.Title), ...
             'Artist', optional_param(stim_info.Artist), ...
             'Comment', 'Processed with IIR filter');
end

function in_ampls = from_db (db)
  in_ampls = 10 .^ (db / 20);
end

function o_p = optional_param(i_p)
  o_p = i_p;
  if isempty(o_p)
    o_p = '';
  end
end
