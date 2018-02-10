function sm = smoothen (x, order, repeats)
  sm = smoothdata(x, 'gaussian', order);
  % Octave version
  % sm_coeff = bincoeff(order, 0:order);
  % sm_coeff_sum = sum(sm_coeff);
  % sm = x;
  % for i = 1:repeats
  %   sm = conv(sm, sm_coeff ./ sm_coeff_sum, 'same');
  % end
end
