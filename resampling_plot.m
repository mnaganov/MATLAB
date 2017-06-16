[wave_44k, sr_44k] = audioread(sound_data_dir('Mono Sine 11025 45deg -6 dB 44-1.wav'));
[wave_48k, sr_48k] = audioread(sound_data_dir('Mono Sine 11025 45deg -6 dB 48.wav'));
N = 10;
frames_44 = 0:1:N;
frames_48 = 0:441/480:N;
sinframes = 0:0.1:N;

figure;
plot(sinframes, (0.5 / sin(pi / 4)) * sin(pi / 2 * sinframes + pi / 4), '-k', ...
     frames_44, wave_44k(1:length(frames_44)), '*b', ...
     frames_48, wave_48k(1:length(frames_48)), '*r');
grid on;
xlim([0, N]);
xlabel("time");
ylabel("waveform");
