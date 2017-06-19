cutoff_l = 300;
cutoff_r = 1000;
fs = 44100;
[butter_tf.l.B, butter_tf.l.A] = butter(6, cutoff_l / (fs / 2));
[butter_tf.r.B, butter_tf.r.A] = butter(6, cutoff_r / (fs / 2));
plot_filter_from_tf([20, 20000], butter_tf, 2048, fs);
