function process_stream_binaural_filter (stim_file, tf, fs, resp_file)
  [stim_sample, s_rate] = audioread(stim_file, [1, 1]);
  [~, channels] = size(stim_sample);
  if (channels ~= 2)
    error("stimulus file must be stereo");
  end
  if (s_rate ~= fs)
    error("stimulus file sampling rate %d ~= filter sampling rate %d", s_rate, fs);
  end
  stim_info = audioinfo(stim_file);

  afr = dsp.AudioFileReader(stim_file);
  afw = dsp.AudioFileWriter(resp_file, ...
                            'SampleRate', afr.SampleRate, ...
                            'DataType', data_type_from_bps(stim_info.BitsPerSample));

  state = [];
  while ~isDone(afr)
    stim_frame = afr();
    [resp_frame, state] = apply_binaural_filter(stim_frame, tf, state);
    afw(resp_frame);
  end

  release(afr);
  release(afw);
end

function dt = data_type_from_bps (bps)
  if bps == 8
    dt = 'uint8';
  elseif bps == 16
    dt = 'int16';
  elseif bps == 24
    dt = 'int24';
  else
    dt = 'single';
  end
end
