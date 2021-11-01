function [f,g,df,dg] = meigoDummy(theta, fun)
% Objective function wrapper for MEIGO / PSwarm / ... which need objective
% function *file*name* and cannot use function handles directly.
%
% Parameters:
%   theta: parameter vector
%   fun: objective function handle
%   varargin:
%
% Return values:
% f: Objective function value
    switch nargout
        case 1
            [f] = fun(theta);
        case 2
            [f,g] = fun(theta);
        case 3
            [f,g,df] = fun(theta);           
        case 4
            [f,g,df,dg] = fun(theta);
    end
end

