%compile model files into callable mexfiles

pathStr = [pwd, '/mex and sim files/'];

amiwrap('SSModel','SSModel_syms',pathStr); % steady state model
amiwrap('Model','Model_syms',pathStr);     % General model
amiwrap('ModelNegative','ModelNegative_syms',pathStr);     % Model for negative input
amiwrap('ModelDesjardinsSensory','ModelDesjardinsSensory_syms',pathStr); % 3Hz oscillative stimulation