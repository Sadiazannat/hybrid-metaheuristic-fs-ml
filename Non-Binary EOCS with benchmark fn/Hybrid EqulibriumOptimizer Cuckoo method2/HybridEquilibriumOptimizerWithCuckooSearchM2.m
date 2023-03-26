%
%
function export = HybridEquilibriumOptimizerWithCuckooSearchM2()
    global Algorithms;
    export.name = 'HEOCS2';
    export.bootstrap = @BootstrapEOCS2;
    Algorithms(end + 1) = export;
end

function BootstrapEOCS2(nSolutions, dimession, ub, lb, fobj, nIter, onIterating)
    HybridEOCSM2(nSolutions, dimession, ub, lb, fobj, nIter, onIterating)
end