function apply_filter_mono (stim_file, tf, fs, resp_file)
  [stim_wave, s_rate] = audioread(stim_file);
  [~, channels] = size(stim_wave);
  if (channels ~= 1)
    error("stimulus file must be mono");
  end
  if (s_rate ~= fs)
    error("stimulus file sampling rate %d ~= filter sampling rate %d", s_rate, fs);
  end
  stim_info = audioinfo(stim_file);
  resp_wave = filter(tf.B, tf.A, stim_wave);
  audiowrite(resp_file, resp_wave, fs, ...
             'BitsPerSample', stim_info.BitsPerSample, ...
             'Title', optional_param(stim_info.Title), ...
             'Artist', optional_param(stim_info.Artist), ...
             'Comment', 'Processed with IIR filter');
end

function o_p = optional_param(i_p)
  o_p = i_p;
  if isempty(o_p)
    o_p = '';
  end
end
