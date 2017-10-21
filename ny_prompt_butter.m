cutoff_l = 300;
cutoff_r = 1000;
fs = 44100;
[butter_tf.l.B, butter_tf.l.A] = butter(6, cutoff_l / (fs / 2));
[butter_tf.r.B, butter_tf.r.A] = butter(6, cutoff_r / (fs / 2));
generate_nyquist_prompt_filter_binaural(butter_tf, sound_data_dir('butter_binaural.ny'));
