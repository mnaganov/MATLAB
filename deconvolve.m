[conv_ir, sr] = audioread(sound_data_dir('dc-system-ir.wav'));
[ir, sr] = audioread(sound_data_dir('dc-ir-nz.wav'));

[filt_ir, r] = deconv(conv_ir, ir);

audiowrite(sound_data_dir('dc-filt-ir.wav'), filt_ir, sr, 'BitsPerSample', 32);
