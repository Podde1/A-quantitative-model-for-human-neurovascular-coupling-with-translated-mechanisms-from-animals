function [Data] = GenerateData_Desjardins()

    [DExLong, ~] = FetchData_Desjardins(1);
    [DExShort, ~] = FetchData_Desjardins(2);
    [DInLong, ~] = FetchData_Desjardins(3);
    [DInShort, ~] = FetchData_Desjardins(4);
    [DSensLong, ~] = FetchData_Desjardins(5);
    [DSensShort, ~] = FetchData_Desjardins(6);

    Data.OGexcitatory20.HbT  = DExLong.HbT;
    Data.OGexcitatory20.HbO  = DExLong.HbO;
    Data.OGexcitatory20.HbR  = DExLong.HbR;
    Data.OGinhibitory20 = DInLong;
    Data.Sensory20 = DSensLong;
    Data.OGexcitatory01 = DExShort;
    Data.OGinhibitory01 = DInShort;
    Data.Sensory2 = DSensShort;
    Data.OGexcitatory20BOLD = DExLong.BOLD;
    
end