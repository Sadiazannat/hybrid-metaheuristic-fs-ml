% Wrapper Feature Selection

function model = jfs(type,feat,label,opts)
switch type
  % 2020
  case 'eo'   ; fun = @jEquilibriumOptimizer;
  % 2019  
  case 'aso'  ; fun = @jAtomSearchOptimization; 
  case 'hho'  ; fun = @jHarrisHawksOptimization;  
  % 2017
  case 'ssa'  ; fun = @jSalpSwarmAlgorithm; 
  % 2016
  case 'csa'  ; fun = @jCrowSearchAlgorithm; 
  case 'sca'  ; fun = @jSineCosineAlgorithm; 
  case 'woa'  ; fun = @jWhaleOptimizationAlgorithm;
  % 2015
  case 'mfo'  ; fun = @jMothFlameOptimization;
  case 'mvo'  ; fun = @jMultiVerseOptimizer; 
   
  % 2014 
  case 'gwo'  ; fun = @jGreyWolfOptimizer; 
   
  % 2009 - 2010 
  case 'cs'   ; fun = @jCuckooSearchAlgorithm;  
  
  % Traditional      
  case 'de'   ; fun = @jDifferentialEvolution; 
  case 'pso'  ; fun = @jParticleSwarmOptimization; 
  case 'ga'   ; fun = @jGeneticAlgorithm; 

  % Hybrid
  case 'new'  ; fun = @jnew;    
  case 'new2'  ; fun = @new_2; 
  case 'heo'   ; fun = @hEquilibriumOptimizer;
end
tic;
model = fun(feat,label,opts); 
% Computational time
t = toc;

model.t = t;
fprintf('\n Processing Time (s): %f % \n',t); fprintf('\n');
end


