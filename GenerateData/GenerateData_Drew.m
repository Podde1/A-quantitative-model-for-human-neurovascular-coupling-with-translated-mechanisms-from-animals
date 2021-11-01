function [Data] = GenerateData_Drew()
 
    load('Data3Art.mat')
    load('Data3Ven.mat')
    
    out=[];
    out10=[];
    out30=[];

        out.t=Data3Art.ms20.t;
         out.Y=Data3Art.ms20.Y;

        out.Sigma_Y=Data3Art.ms20.Sigma_Y_SEM;
        out.Y(:,2)=Data3Ven.ms20.Y;
        out.Sigma_Y(:,2)=Data3Ven.ms20.Sigma_Y_SEM;

        out10.t=Data3Art.s10.t;
        out10.Y=Data3Art.s10.Y;
                out10.Sigma_Y=Data3Art.s10.Sigma_Y_SEM;

        out10.Y(:,2)=Data3Ven.s10.Y;
        out10.Sigma_Y(:,2)=Data3Ven.s10.Sigma_Y_SEM;

        
             out30.t=Data3Art.s30.t;
        out30.Y=Data3Art.s30.Y;
                out30.Sigma_Y=Data3Art.s30.Sigma_Y_SEM;
        out30.Y(:,2)=Data3Ven.s30.Y;
        out30.Sigma_Y(:,2)=Data3Ven.s30.Sigma_Y_SEM;
        
        Data.D = out;
        Data.D10 = out10;
        Data.D30 = out30;
end

