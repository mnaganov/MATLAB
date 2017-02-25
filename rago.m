
clc;
clear all;
close all;

len = 44100;  %1second

N = 1024; %window
freq = 3000;  %100*44100/1024; %hz
sr = 44100;

d = sin(2*pi.*[1:len]*freq/sr);
data = d(1:N);

e = 0.5*sin(pi+ 2*pi.*[1:len]*freq/sr);
e = e + 0.1*rand(size(e));

data_e = e(1:N);


figure;
subplot(4,1,1);
plot([1:N],data,'b', [1:N], data_e,'r');
axis tight;
zoom on;

freqs = [0:(N/2)-1]*sr/N;

D = fft(data);  %this is the fft
D_e = fft(data_e);

subplot(4,1,2);
plot( freqs, 20 * log10(abs(D(1:N/2))),'b',  freqs, 20 * log10(abs(D_e(1:N/2))), 'r');
axis tight;
grid on;



xx = 20 *(log10(abs(D(1:N/2))) - log10(abs(D_e(1:N/2))));


subplot(4,1,3);
% plot(freqs, angle(D(1:N/2)), 'b', freqs, angle(D_e(1:N/2)), 'r');
plot(freqs, xx, 'b');
axis tight;
grid on;


xx2 = 20*log10( abs(D(1:N/2)) ./ abs(D_e(1:N/2)));

subplot(4,1,4);
plot(freqs, xx2, 'b');
axis tight;
grid on;







