function [c,f]  = proj_vect(A,V)
% A function to project the matrix A onto the vectors specified in V. 
% Inputs: 
% A - a square matrix. NxN
% V - an orthogonal basis matrix. Nxn 
% c - the coefficients of A in V. nxN
% f - the projection of A in V. nxn
% inv(V' * V) * V'=pinv(V) (when V is an square matrix here =inv(V) )
c =  inv(V' * V) * V' * A;
f = inv(V' * V) * V' * A*V;  %change of basis formula inv(P)*A*P.

