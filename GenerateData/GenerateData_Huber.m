function [Data] = GenerateData_Huber()

    Data = [];

    load('BOLDfig4.mat')
    load('CBVfig4.mat')
    load('BOLDfig4.mat')
    load('CBVfig4.mat')
    load('CBVfig5b.mat')
    load('CBFfig6c.mat')    
    load('CBVfig5c.mat')
    
    Data.CBVPos = CBV.positve;
    Data.CBVNeg = CBV.negative;
    
    Data.CBVExcitatoryTotal = CBVfig5b.total;
    Data.CBVExcitatoryArteriole = CBVfig5b.arteriol;
    Data.CBVExcitatoryVenule = CBVfig5b.venul;
    
    Data.CBVIhibitatoryTotal = CBVfig5c.total;
    Data.CBVInhibitatoryArteriole = CBVfig5c.arteriole;
    Data.CBVInhibitatoryVenule = CBVfig5c.venule;
    
    Data.BOLDPos = BOLD.positive;
    Data.BOLDNeg = BOLD.negative;
    
    Data.CBFPos = CBF.pos;
    Data.CBFNeg = CBF.neg;
    

end