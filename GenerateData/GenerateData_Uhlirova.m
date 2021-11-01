function [D] =GenerateData_Uhlirova(Trigger)
D=[];
load('Datamatrixes/Uhlirova/Thy1_Con_AP5_data_WITHSE.mat')
D(1).t=Thy1_Con_AP5_data.t(1:48);
D(1).Y=Thy1_Con_AP5_data.Y(1:48,1);
D(1).Sigma_Y(1:48,:)=Thy1_Con_AP5_data.Sigma_Y(1:48,1);

D(6).t=Thy1_Con_AP5_data.t(1:42);
D(6).Y=Thy1_Con_AP5_data.Y(1:42,2);
D(6).Sigma_Y=Thy1_Con_AP5_data.Sigma_Y(1:42,2);
D(6).Y(1,1)=0;
D(6).Sigma_Y(28:30,1)=0.6;
load('Datamatrixes/Uhlirova/Con_BIBP_data_WITHSE.mat')
 D(2).t=Con_BIBP_data.t(1:48);
 D(2).Y=Con_BIBP_data.Y(1:48,1);
 D(2).Sigma_Y=Con_BIBP_data.Sigma_Y(1:48,1);
 D(7).t=Con_BIBP_data.t(1:48);
 D(7).Y=Con_BIBP_data.Y(1:48,2);
 D(7).Sigma_Y=Con_BIBP_data.Sigma_Y(1:48,2);

 load('Datamatrixes/Uhlirova/Sensory_Con_BIBP.mat')
 D(3).t=Sensory_Con_BIBP.t;
 D(3).Y=Sensory_Con_BIBP.Y(:,1);
 D(3).Sigma_Y=Sensory_Con_BIBP.Sigma_Y(:,1);
  D(8).t=Sensory_Con_BIBP.t;
 D(8).Y=Sensory_Con_BIBP.Y(:,2);
 D(8).Sigma_Y=Sensory_Con_BIBP.Sigma_Y(:,2);
 
 
 
 load('Datamatrixes/Uhlirova/AnethesiaData.mat')
 D(4).t=AnethesiaData.t;
 D(4).Y=AnethesiaData.Y(:,2);
 D(4).Sigma_Y=AnethesiaData.Sigma_Y(:,2);
 D(4).Y(1,1)=0;
 
 D(5).t=AnethesiaData.t;
 D(5).Y=AnethesiaData.Y(:,1);
 D(5).Sigma_Y=AnethesiaData.Sigma_Y(:,1);
 D(5).Y(1,1)=0;

if Trigger~=1
    for k=1:size(D,2)
    for j=1:size(D(k).Sigma_Y,2)
     c=mean(D(k).Sigma_Y(:,j));
     for l=1:size(D(k).Sigma_Y(:,j),1)
         if D(k).Sigma_Y(l,j)<c
             D(k).Sigma_Y(l,j)=c;
         end
     end
    end
    
end
end