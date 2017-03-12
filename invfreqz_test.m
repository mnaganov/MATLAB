[B,A] = butter(4,1/4);
[H,F] = freqz(B,A);
[Bh,Ah] = invfreq(H,F,4,4);
Hh = freqz(Bh,Ah);
disp(sprintf('||frequency response error|| = %f',norm(H-Hh)));
