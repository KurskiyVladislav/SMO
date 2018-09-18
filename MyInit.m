function [inits,ret] = MyInit(n)
%Генерирует лямбду, мю для н приборов, а так же считает все это дело и
%возвращает массив, содержащий стат вероятности для состояния arr(i)=p, где
%i = кол-во заявок
while(true)
    [ok,inits] = Generate(n);
    if ok==1
        break;
    end
end
[ret] = MyCalcStProb(inits);
end
function [ok,inits] = Generate(n)
inits.n = n;
for i=1:n
    flag=false;
    while(~flag)
        inits.lambda(i) = rand(1);
        inits.mu(i) = rand(1);
        if inits.lambda(i) < inits.mu(i)
            inits.prob(i) = rdivide(inits.lambda(i),inits.mu(i));
            flag = true;
        end
    end
end
ok=1;
for i= 1:length(inits.prob)
    if inits.prob(i)>1
        ok=0;
        break;
    end
end
end