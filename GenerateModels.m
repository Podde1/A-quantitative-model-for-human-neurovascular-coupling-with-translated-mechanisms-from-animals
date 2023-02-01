%compile model files into callable mexfiles

path = [pwd, '/mex and sim files/'];

amiwrap('SSModel','SSModel_syms',path); % steady state model
amiwrap('Model','Model_syms',path);     % General model
amiwrap('ModelNegative','ModelNegative_syms',path);     % Model for negative input
amiwrap('ModelDesjardinsSensory','ModelDesjardinsSensory_syms',path); % 3Hz oscillative stimulation