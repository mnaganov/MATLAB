[ir, sr] = audioread(sound_data_dir('dc-ir-nz.wav'));
[filt_ir, sr] = audioread(sound_data_dir('dc-filt-ir.wav'));

result_ir = conv(filt_ir, filt_ir);

audiowrite(sound_data_dir('dc-conv-ir.wav'), result_ir, sr, 'BitsPerSample', 32);
