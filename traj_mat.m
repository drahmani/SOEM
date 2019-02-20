function X = traj_mat(Y,L)
% Create a trajectory matrix (hankelisation) from the data in Y of window length L. 
%Input: %
% Y time series . 
% L embedding dimension
%Output:
% Embedded matrix or trajectory matrix or hankelisation matrix of dimension L*L
N = length(Y); 
K = N-L+1;
X=[];% Trajectory matrix.
for k=1:K
    X(1:L,k) = Y(k:k+L-1);
end
