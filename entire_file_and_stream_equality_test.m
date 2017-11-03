                                % load 16-bit file with audioread

src_file = '/Users/mikhail/Sounds/PerfectSense_44_1.wav';
[src_whole, fs] = audioread(src_file);

                                % load 16-bit file with audiofilereader

afr = dsp.AudioFileReader(src_file);
src_stream = [];
while ~isDone(afr)
  src_frame = afr();
  src_stream = [src_stream; src_frame];
end
release(afr);

                                % check that they are the same

validate_waves(src_whole, src_stream, fs, 'src');
src = src_whole;

                                % process entire vector with filter

load(sound_data_dir('ph-iir/m-30-1_2-left.m7.mat'));

res_whole = apply_binaural_filter(src, mdl_tf);

                                % process vector in frames with streaming filter

[frames, ~] = size(src);
res_stream = [];
state = [];
for i = 1:1024:frames
  bound = i + 1023;
  if bound > frames
    bound = frames;
  end
  [res_frame, state] = apply_binaural_filter(src(i:bound, :), mdl_tf, state);
  res_stream = [res_stream; res_frame];
end

                                % check that they are the same

validate_waves(res_whole, res_stream, fs, 'res');
res = res_whole;

                                % export into 16-bit file with audiowrite

res_audiowrite_file = '/Users/mikhail/Sounds/res_audiowrite.wav';
audiowrite(res_audiowrite_file, res_whole, fs, 'BitsPerSample', 16);

                                % export into 16-bit file with audiofilewriter

res_stream_file = '/Users/mikhail/Sounds/res_stream.wav';
afw = dsp.AudioFileWriter(res_stream_file, ...
                          'SampleRate', fs, ...
                          'DataType', 'int16');
for i = 1:1024:frames
  bound = i + 1023;
  if bound > frames
    bound = frames;
  end
  afw(res_stream(i:bound, :));
end
release(afw);

                                % load both files back with audioread

res_audiowrite = audioread(res_audiowrite_file);
res_stream = audioread(res_stream_file);

% check that they are the same

validate_waves(res_audiowrite, res_stream, fs, 'write');
delete(res_audiowrite_file);
delete(res_stream_file);

%%%%%%%

function validate_waves(a, b, fs, name)
  d = a - b;
  f_name = '/Users/mikhail/Sounds/diff.wav';
  if any(d, 1) | any(d, 2)
    audiowrite(f_name, d, fs, 'BitsPerSample', 16);
    [d, ~] = audioread(f_name);
    if any(d, 1) | any(d, 2)
      error([name ' differs']);
    else
      delete(f_name);
    end
  end
end
