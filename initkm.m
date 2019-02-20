function [W] = initkm(Adjs,Wlx,Wly)
% Function to initialise a weight matrix with a Wlx*Wly grid based on the average 
% Inputs: 
% Adjs input matrices to be classified, [row*no_inputs].
% Grid sizes:  Wlx and Wly.
% Output: Weight matrices of size (L,L,Wlx,Wly)
% eigenvectors of a random sample of the inputs (N_sample=15).  
inds = randperm(length(Adjs));
N = length(Adjs(1).A);
N_sample=15;
for i=1:N_sample
    % get the eigenvectors of the first 15 to start the ball rolling. 
    AA= Adjs(inds(i)).A;
    [v,~] = eig(full(AA));
    if isempty('v')
        N_sample=N_sample+1;
    else
        V(:,:,i)=v;
    end
end
mm = mean(V,3);
ss = std(V,0,3);
W = ones(N,N,Wlx,Wly);
% Set the weights to the mean of the input matrix
for i=1:Wlx
   for j=1:Wly
      W(:,:,i,j) =W(:,:,i,j).*mm ;
% Adjust using an unbiased random element scaled by the variance of the input matrix.
      W(:,:,i,j)=W(:,:,i,j) + randn(N,N).*ss;
% Normalise the weights via Gram-Schmidt orthonormalization method;
      W(:,:,i,j)=grsm(W(:,:,i,j));
   end
end



