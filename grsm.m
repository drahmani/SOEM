function [O] = grsm(A)
	if nargin~=1 || size(A,2)<2, error('Please provide at least 2 vectors as a matrix'); end
	% Gram-Schmidt orthonormalization method
	% input : a matrix of n column vectors
	% output: a matrix of n orthonormal column vectors 
	O = 0*A;
	for(i=1:size(A,2))
		Z(:,i)=A(:,i)-sum(O(:,1:i)*diag(A(:,i)'*O(:,1:i)),2);
		O(:,i)=Z(:,i)/norm(Z(:,i));
	end	


