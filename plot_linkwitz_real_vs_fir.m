file = sound_data_dir('linkwitz_2.csv');

[real_frqs, ~, real_fq_resp] = filter_from_log_csv_file(file, 1);

[fir_tf, n_fft, fs] = fir_tf_from_log_csv_file(file, 1, 1024, 96000, 1024);
[mdl_frqs, mdl_fq_lim, mdl_fq_resp] = filter_from_tf([20, 20000], fir_tf, n_fft, fs);

plot_filter_vs(
    mdl_fq_lim,
    'real', real_frqs, real_fq_resp,
    'fir', mdl_frqs, mdl_fq_resp);

fid = fopen(sound_data_dir('l_fir.txt'), 'w');
for i = 1:length(fir_tf.l.B)
  fprintf(fid, 'b%d = %f,\n', i - 1, fir_tf.l.B(i));
end
fclose(fid);

fid = fopen(sound_data_dir('r_fir.txt'), 'w');
for i = 1:length(fir_tf.r.B)
  fprintf(fid, 'b%d = %f,\n', i - 1, fir_tf.r.B(i));
end
fclose(fid);

printf('Attn: %f\n', fir_tf.r.am_attn_db);
