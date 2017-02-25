% Calculate the 1/3-octave-smoothed power spectral density of the
% Handel example.

% load signal
load handel.mat

% take fft
Y = fft(y);

% keep only meaningful frequencies
NFFT = length(y);
if mod(NFFT,2)==0
    Nout = (NFFT/2)+1;
else
    Nout = (NFFT+1)/2;
end
Y = Y(1:Nout);
f = ((0:Nout-1)'./NFFT).*Fs;

% put into dB
Y = 20*log10(abs(Y)./NFFT);

% smooth
Noct = 3;
Z = iosr.dsp.smoothSpectrum(Y,f,Noct);

% plot
figure
semilogx(f,Y,f,Z)
grid on
