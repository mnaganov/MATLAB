function generate_faust_filter (tf, dsp_file_name)
  dsp_file = fopen(dsp_file_name, 'w');
  fprintf(dsp_file, 'bcoeffs = %s;\nacoeffs = %s;\n', ...
          print_vector(tf.B), print_vector(tf.A(2:end)));
  fclose(dsp_file);
end

function s = print_vector (v)
  s = '';
  for i = 1 : 1 : size(v, 2)
    if size(s, 1) > 0
      s = [s ', '];
    end
    s = sprintf('%s%.10e', s, v(i));
  end
  s = ['(' s ')'];
end
