function generate_nyquist_prompt_filter_binaural (tf, ny_file_name)
  pre_attn = 1.0;
  if (any(strcmp(fieldnames(tf), 'pre_am_attn_db')))
    pre_attn = from_db(-tf.pre_am_attn_db);
  end
  opp_attn = 1.0;
  if (any(strcmp(fieldnames(tf.r), 'am_attn_db')))
    opp_attn = from_db(-tf.r.am_attn_db);
  end
  ny_file = fopen(ny_file_name, 'w');
  fprintf(ny_file, '(vector\n%s\n%s\n)\n', ...
          generate_ny_channel_mix(4, 0, 1, pre_attn, tf.l.B, tf.l.A, tf.r.B, tf.r.A, opp_attn), ...
          generate_ny_channel_mix(4, 1, 0, pre_attn, tf.l.B, tf.l.A, tf.r.B, tf.r.A, opp_attn));
  fclose(ny_file);
end

function ny = generate_ny_channel_mix (indent, d_ch, o_ch, pre_attn, d_B, d_A, o_B, o_A, o_attn)
  ny = sprintf('%*s(sum\n%s\n%*s(scale %.10e\n%s))', ...
               indent, '', ...
               generate_ny_filter(indent * 2, ny_channel_src(d_ch), pre_attn, d_B, d_A), ...
               indent * 2, '', ...
               o_attn, ...
               generate_ny_filter(indent * 3, ny_channel_src(o_ch), pre_attn, o_B, o_A));
end

function ny = generate_ny_filter (indent, stim, pre_attn, B, A)
  ny = sprintf('\n%*s(scale %.10e %s)', indent, '', pre_attn, stim);
  biquads = tf2sos(B, A);
  for i = size(biquads, 1) : -1 : 1
    ny = sprintf('(biquad-m %s\n%*s%.10e %.10e %.10e %.10e %.10e %.10e)', ...
                 ny, ...
                 indent, '', ...
                 biquads(i, 1), biquads(i, 2), biquads(i, 3), ...
                 biquads(i, 4), biquads(i, 5), biquads(i, 6));
  end
  ny = sprintf('%*s%s', indent, '', ny);
end

function expr = ny_channel_src (ch)
  expr = sprintf('(aref s %d)', ch);
end

function in_ampls = from_db (db)
  in_ampls = 10 .^ (db / 20);
end
