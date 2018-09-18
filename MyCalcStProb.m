function [StatProb] = MyCalcStProb(data)
%Считаем по формуле

%Определим все возможные комбинации

[StatProb,denominator] = MySumOfMultip(data);

end

function [StatProb, denominator] = MySumOfMultip(data)
%Создадим массив в котором подсчитаем перемножение вероятностей для каждого
%возможного состояния
combinations = sortrows(de2bi(0:pow2(data.n)-1));

tableofmultiplications = zeros(1,2^data.n);
%знаменатель формулы(meanMost+meanLeast)/2
denominator = 0;
for z = 1:2^data.n
   row = combinations(z,:);
   mult = 1;
   %Считаем перемножение вероятностей для строки(состояния)
   for n = 1:length(row)
       prob = data.prob(n)^row(n);
       %disp(prob);
       mult = mult*prob;
   end
   tableofmultiplications(z) = mult;
   denominator = denominator + mult;
end
StatProbOfState = zeros(1,2^data.n);
for i = 1:length(StatProbOfState)
    %StatProb(i) = tom(i)
    StatProbOfState(i) = tableofmultiplications(i)/denominator;
end
NumOfReqByIndexes = cell(1,data.n); 
%Инициализируем массив для всех стат вероятностей
%Заодно создадим список массивов, где каждый индекс i соответствует
%количеству заявок, а каждый массив содержит список индексов состояний таких, что
%x1...+xn = i
for j = 2:length(combinations)
    i= sum(combinations(j,:));
    NumOfReqByIndexes{i} = [NumOfReqByIndexes{i},j];
end
%Теперь сложим вероятности для каждого состояния так, StatProb(i) стало
%стационарной вероятностью состония где i = количество заявок.
StatProb =[];
for i = 2:data.n+1
    ArOfInd = NumOfReqByIndexes{i-1};
    summa = 0;
    for j = 1:length(ArOfInd)
        summa = summa + StatProbOfState(ArOfInd(j));
    end
    StatProb(i) = summa;
end
%Подсчитаем для 0 заявок
StatProb(1) = StatProbOfState(1);
end

