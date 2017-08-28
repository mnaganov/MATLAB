t_l_data = csvread('/Users/mikhail/Sounds/Phonitor/TargetFR-L.csv', 1, 0);
t_r_data = csvread('/Users/mikhail/Sounds/Phonitor/TargetFR-R.csv', 1, 0);
a_l_data = csvread('/Users/mikhail/Sounds/Phonitor/ActualFR-L.csv', 1, 0);
a_r_data = csvread('/Users/mikhail/Sounds/Phonitor/ActualFR-R.csv', 1, 0);

figure;
semilogx(t_l_data(:, 1), t_l_data(:, 2), 'b', ...
         t_r_data(:, 1), t_r_data(:, 2), 'r', ...
         a_l_data(:, 1), a_l_data(:, 2) + 21.0, 'c', ...
         a_r_data(:, 1), a_r_data(:, 2) + 21.0, 'm');
xlim([20, 22050]);
ylim([-20, -5]);
grid on;
