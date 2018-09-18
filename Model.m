function myarray = Model(num)
%Основная функция(==main), на вход подать количество приборов
myarray = cell(2,10);
for g=1:10
[inits,ret] = MyInit(num);    
sys = 'TestModel';
new_system(sys);
load_system(sys);
load_system('blueprint');
x = 130;
y = 130;
w = 30;
h = 30;
offset = 200;
pos = [x y+h/4 x+w y+h*.75];
add_block('blueprint/exponentialTime','TestModel/exponentialTime');
add_block('simulink/Math Operations/Add', 'TestModel/Adder', 'Position', [x+1000 y+h/4 x+1150 y+1025]);
add_block('simulink/Sinks/To Workspace', 'TestModel/out', 'Position', [x+1300 y+h/4 x+1350 y+1025]);
add_line(sys,"Adder/1","out/1",'autorouting','on');
set_param("TestModel/Adder",'Inputs', getSigns(inits.n));
set_param(sys, 'StopTime', '300000')
for i=1:inits.n
    y = y+20;
    r = 0.5;
    
    add_block('blueprint/genNextCustomer',"TestModel/genNextCustomer"+num2str(i),'Position',[x y+h/4 x+50 y+25]);
    %не всегда прописывает, так что убедмися
    funIsChanged(i);
    
    add_block('blueprint/EnGen',"TestModel/EnGen"+num2str(i),'Position',[x+100 y+h/4 x+150 y+25]);
    set_param("TestModel/EnGen"+num2str(i), "AttributeInitialValue", inits.lambda(i)+"|"+inits.mu(i)+"|"+num2str(r)+"|"+num2str(r));
    add_block('blueprint/Gate',"TestModel/Gate"+num2str(i),'Position',[x+200 y+h/4 x+250 y+25]);
    add_block('blueprint/EnServ1',"TestModel/EnServ1"+num2str(i),'Position',[x+300 y+h/4 x+350 y+25]);
    add_block('blueprint/EnServ2',"TestModel/EnServ2"+num2str(i),'Position',[x+400 y+h/4 x+450 y+25]);
    add_block('blueprint/Terminator',"TestModel/Terminator"+num2str(i),'Position',[x+500 y+h/4 x+550 y+25]);
    set_param("TestModel/Terminator"+num2str(i),'EntryAction',"genNextCustomer"+num2str(i)+"();");
    
    add_line(sys,"genNextCustomer"+num2str(i)+"/1","Gate"+num2str(i)+"/1",'autorouting','on');
    add_line(sys,"EnGen"+num2str(i)+"/1","Gate"+num2str(i)+"/2",'autorouting','on');
    add_line(sys,"Gate"+num2str(i)+"/1","EnServ1"+num2str(i)+"/1",'autorouting','on');
    add_line(sys,"EnServ1"+num2str(i)+"/1","EnServ2"+num2str(i)+"/1",'autorouting','on');
    add_line(sys,"EnServ2"+num2str(i)+"/2","Terminator"+num2str(i)+"/1",'autorouting','on');
    add_line(sys,"EnServ2"+num2str(i)+"/1","Adder/"+num2str(i),'autorouting','on');
end
a= sim(sys,'SimulationMode','normal');
simout = a.get('simout'); 
%disp(ret);
rt = ProcessData(simout, num);
p = cell(1);
p{1,1} = ret;
p{1,2}= rt;
myarray{1,g} = p;
close_system(sys, 0);
end
end
function [] = funIsChanged(i)
    name = get_param("TestModel/genNextCustomer"+num2str(i)+"/genNextCustomer","Name")+""+num2str(i);
    isChanged = false;
    while ~isChanged
        set_param("TestModel/genNextCustomer"+num2str(i)+"/genNextCustomer","FunctionName",name);
        set_param("TestModel/genNextCustomer"+num2str(i)+"/genNextCustomer","Name",name);
        o=false;
        try
            o = get_param("TestModel/genNextCustomer"+num2str(i)+"/genNextCustomer"+num2str(i),"Name") == name;
        catch
            warning("Pok");
            isChanged = false;
            o=false;
        end
        if o
            isChanged = true;
        end
    end
end
function signs = getSigns(n)
signs ="";
for i=1:n
    signs = signs+"+";
end
end