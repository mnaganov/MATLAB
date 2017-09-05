ir_data = csvread(sound_data_dir('IR-With-AC.csv'), 1, 0);
audiowrite(sound_data_dir('IR-With-AC.wav'), ir_data(:, 2), 96000, 'BitsPerSample', 32);
