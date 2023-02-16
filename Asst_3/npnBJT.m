function npnBJT(name,nodeCollector,nodeBase,nodeEmitter, Is,Vt,alphaF,alphaR)
% Adds BJT Stamp
% The Global varialble DIODE_LIST should be defined at the beginning of
% your netlist as follows
% 
% global npnBJT_LIST
% DIODE_LIST = struct('bjtName',{ }, 'collectorNode', [ ], 'baseNode', [ ], 'emitterNode', [ ],'Is', [ ], 'Vt', [ ], 'alphaF', [ ], 'alphaR', [ ]);




global npnBJT_LIST G

%current number of diodes
nbBJTs = size(npnBJT_LIST,2);

N = nbBJTs + 1;  %index of next npnBJT
npnBJT_LIST(N).bjtname = name;
npnBJT_LIST(N).collectorNode = nodeCollector;
npnBJT_LIST(N).baseNode = nodeBase;
npnBJT_LIST(N).emitterNode = nodeEmitter;
npnBJT_LIST(N).Is = Is;
npnBJT_LIST(N).Vt = Vt;
npnBJT_LIST(N).alphaF = alphaF;
npnBJT_LIST(N).alphaR = alphaR;


% adding the Cmu and Cpi ( these are the parasitic Capacitances)
cap(nodeCollector,nodeBase,1e-9)
cap(nodeBase,nodeEmitter,2e-9)
