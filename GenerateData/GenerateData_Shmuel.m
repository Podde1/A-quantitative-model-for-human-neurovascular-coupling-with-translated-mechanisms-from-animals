function [Data] = GenerateData_Shmuel()

    load('SchmuelBOLD.mat')
    load('Schmuelneuralactfig2a.mat')
    
    
    Data = [];
    Data.BOLD = SchmuelBOLD.pos;
    Data.act = Schmuelneuralactfig2a.pos;
    Data.BOLDneg = SchmuelBOLD.neg;
    Data.actneg = Schmuelneuralactfig2a.neg;
    
    for j=1:size(Data.actneg.Sigma_Y,2)
     c=mean(Data.actneg.Sigma_Y(:,j));
     for l=1:size(Data.actneg.Sigma_Y(:,j),1)
         if Data.actneg.Sigma_Y(l,j)<c
             Data.actneg.Sigma_Y(l,j)=c;
         end
     end
    end
    
    for j=1:size(Data.act.Sigma_Y,2)
        c=mean(Data.act.Sigma_Y(:,j));
        for l=1:size(Data.act.Sigma_Y(:,j),1)
            if Data.act.Sigma_Y(l,j)<c
             Data.act.Sigma_Y(l,j)=c;
            end
        end
    end
    
    % Adding pre stim values for LFP
    Data.act.t = [-4.5; -3.5; -2.5; -1.5; -0.5000; Data.act.t];
    Data.act.Y = [-3.3373; 0.7265; 2.3848; 3.3010; -3.1889; Data.act.Y];
    Data.act.Sigma_Y = [1.4810; 1.4823; 1.4814; 1.6671; 1.2958; Data.act.Sigma_Y];
    
    Data.actneg.t = [-4.5; -3.5; -2.5; -1.5; -0.5000; Data.actneg.t];
    Data.actneg.Y = [-1.1147; 0.3575; 0.3483; 0.1516; -0.5973; Data.actneg.Y];
    Data.actneg.Sigma_Y = [1.1106; 0.7412; 0.5542; 1.1129; 0.3699; Data.actneg.Sigma_Y]; 
    
end