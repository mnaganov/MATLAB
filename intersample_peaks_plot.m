1;

function in_db = to_db (ampls)
  in_db = 20 * log10(ampls);
end

[wave_44k, sr_44k] = audioread(sound_data_dir('Mono Sine 11025 45deg 0 dB 44-1.wav'));
N = 10;
frames_44 = 0:1:N;
sinframes = 0:0.1:N;

figure;
plot(sinframes, to_db((1 / sin(pi / 4)) * sin(pi / 2 * sinframes + pi / 4)), '-k', ...
     frames_44, to_db(wave_44k(1:length(frames_44))), '*b');
grid on;
xlim([0, N]);
ylim([-60, 5]);
xlabel("time");
ylabel("dBFS");
