function process_entire_file_binaural_filter (stim_file, tf, fs, resp_file)
  [stim_wave_lr, s_rate] = audioread(stim_file);
  [~, channels] = size(stim_wave_lr);
  if (channels ~= 2)
    error("stimulus file must be stereo");
  end
  if (s_rate ~= fs)
    error("stimulus file sampling rate %d ~= filter sampling rate %d", s_rate, fs);
  end
  stim_info = audioinfo(stim_file);

  resp_wave = apply_binaural_filter(stim_wave_lr, tf);

  audiowrite(resp_file, resp_wave, fs, ...
             'BitsPerSample', stim_info.BitsPerSample, ...
             'Title', optional_param(stim_info.Title), ...
             'Artist', optional_param(stim_info.Artist), ...
             'Comment', 'Processed with binaural IIR filter');
end

function o_p = optional_param(i_p)
  o_p = i_p;
  if isempty(o_p)
    o_p = '';
  end
end