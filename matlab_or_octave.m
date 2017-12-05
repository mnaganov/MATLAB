function s = matlab_or_octave ()
  if exist('OCTAVE_VERSION')
    s = 'octave';
  else
    s = 'matlab';
  end
end
