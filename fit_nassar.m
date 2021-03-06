function fit = fit_nassar(d, c, variance, X0flag)

% setup objective function
obFunc = @(x) obFunc_nassar(x, d, c, variance);

% initial conditions

switch X0flag
    case 1
        % initial
        X0 = [0.5 2];
        
    otherwise
        % randomize after first time
        X0 = [rand 10*rand];
end

% bounds
LB(1,1) = 0; UB(1,1) = 1;
LB(1,2) = 0; UB(1,2) = Inf;

% linear constraints (none!)
A = []; B = [];

% set optimization options
options = optimset('MaxFunEvals', 100, 'TolFun', 1e-40, ...
   'FinDiffType', 'central', 'algorithm', 'active-set', 'display', 'off');

try
    [X, val,~,~,~,~,hess] = fmincon(obFunc, X0,A,B,[],[],LB,UB,[], options);
catch
    X = nan; val = nan; hess = nan;
end
n = length(d);
BIC      = 2*val + length(X)*log(n);



fit.X = X;
fit.val = val;
fit.BIC = BIC;
fit.hessian = hess;
fit.detH = det(hess);
fit.nNodes   = nan;
fit.var      = variance;
fit.n        = length(d);
fit.subNum   = nan; % placeholder
fit.model = nan; % placeholder