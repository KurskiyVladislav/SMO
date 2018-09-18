function outputArg1 = ProcessData(simout, n)
%Обработка данных и возвращение порции времени для соответствующего числа
%заявок, arr(i) = t, sum(arr) == 1.
data = get(simout, 'Data');
time = get(simout, 'Time');
outputArg1=[]
lok = cell(1,n+1);
for j = 1:length(lok)
    lok{j} = 0;
end
ind = [];
dt = [];
for i = 1:length(data)
    if isempty(ind)
        ind = 1;
        dt = time(1);
    else
        dt = time(i) - dt;
    end
    
    %Запишем в индекс количество времени проведенное в этом состоянии
    lok{ind}=lok{ind}+dt;
    dt = time(i);
    ind = data(i)+1;
end
fulltime = time(length(time));
for i = 1:length(lok)
    outputArg1(i) = lok{i}/fulltime; 
end
end

