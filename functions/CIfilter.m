function [FSamples] = CIfilter(Samples,cutOff)
AcceptableP=[];
for i=1:size(Samples,1) 
    if Samples(i,1)<cutOff
        AcceptableP=[AcceptableP; i];
    end
end

FSamples=Samples(AcceptableP,:);
