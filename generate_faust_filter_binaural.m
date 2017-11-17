function generate_faust_filter_binaural (tf, dsp_file_name)
  pre_attn = 1.0;
  if (any(strcmp(fieldnames(tf), 'pre_am_attn_db')))
    pre_attn = from_db(-tf.pre_am_attn_db);
  end
  opp_attn = 1.0;
  if (any(strcmp(fieldnames(tf.r), 'am_attn_db')))
    opp_attn = from_db(-tf.r.am_attn_db);
  end
  dsp_file = fopen(dsp_file_name, 'w');
  fprintf(dsp_file, 'd_bcoeffs = %s;\nd_acoeffs = %s;\no_bcoeffs = %s;\no_acoeffs = %s;\n', ...
          print_vector(tf.l.B), print_vector(tf.l.A(2:end)), ...
          print_vector(tf.r.B), print_vector(tf.r.A(2:end)));
  fprintf(dsp_file, 'pre_attn = %.10f;\nopp_attn = %.10f;\n', pre_attn, opp_attn);
  fclose(dsp_file);
end

function s = print_vector (v)
  s = '';
  for i = 1 : 1 : size(v, 2)
    if size(s, 1) > 0
      s = [s ', '];
    end
    s = sprintf('%s%.10f', s, v(i));
  end
  s = ['(' s ')'];
end

function in_ampls = from_db (db)
  in_ampls = 10 .^ (db / 20);
end
