function [Data, tend] = FetchData_Desjardins(in)


switch in
    case 1
        load('Desjardinssupp4d.mat')
        Data = Data4d;
        tend = 20;
        
    case 2
        load('Desjardinssupp4a.mat')
        Data = Data4a;
        tend = 0.1; 
        
    case 3
        load('Desjardinssupp4e.mat')
        Data = Data4e;
        tend = 20;
        
    case 4
        load('Desjardinssupp4b.mat')
        Data = Data4b;
        tend = 0.1; 
        
    case 5
        load('Desjardinssupp4f.mat')
        Data = Data4f;
        tend = 20;
        
    case 6
        load('Desjardinssupp4c.mat')
        Data = Data4c;
        tend = 2;
        
    case 7
        load('Desjardinsposter3e.mat')
        Data = DataSens;
        tend = 1;
        
    case 8
        load('Desjardinsposter3f.mat')
        Data = DataOG;
        tend = 0.15;
        
    otherwise
        disp('faulty input')
end

end