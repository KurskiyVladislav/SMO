function [maxMinMean] = CalcMSE(mval)
%Подсчитываем срквд ошибку
%   Detailed explanation goes here
for j = 1:length(mval)
input = mval{j};    
allMse = [];
for i = 1:length(input)
    predicted = cell2mat(input{1,i}(1));
    modeled = cell2mat(input{1,i}(2));
    allMse(i) = immse(predicted,modeled); 
end
maxMinMean{j} = [max(allMse), min(allMse), mean(allMse)];
end
end
