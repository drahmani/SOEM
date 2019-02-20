function [W,node] = trainkm_w(Adjs,W,NIter,plot_flag)
% Function to train a kohonen map.
% Inputs :
% Adjs input matrices to be classified, [row*no_inputs].
% W initialised Weight vector size [no_output nodes*gridx,gridy];
% Niter , iterations
% plot_flag=1 shows the grid map at each iteration
% Joint Diagonalisation package should be downloaded from http://bsp.teithe.gr/members/downloads/JointDiagonalization.html
% and installed in a folder called /JnS-1.2 where  is the base directory for jd_koh 
if ~exist('plot_flag')
    plot_flag=0;
end
if ~exist('NIter')
    NIter = 10;
end
threshold =1e-5;
Ns=length(Adjs); % number of samples
row = length(Adjs(1).A);
for i=1:length(Adjs) % make sure the presented matrices are norm 1.
    Adjs(i).A = Adjs(i).A/norm(Adjs(i).A);
end
[dim,~,gridx,gridy]=size(W);
b_all = ones(gridx,gridy,Ns,NIter);
if dim~=row
    disp('W and Adjs must have same number of columns to rows consec.');
    return
end

counter=1; clear griddy
for i=1:gridx
    for j=1:gridy
        griddy(counter,:)=[i j];
        counter=counter+1;
    end
end
% Gaussian Kernel to update nodes: initialise at random spread
pd = makedist('normal','mu',0,'sigma',gridx/4);
%% SOEM consists of the following steps:
for iteration =1:NIter
    % step1: The competetive step
    %Initialise the log structure node
    node(iteration).d = zeros(gridx,gridy);
    rand_order = randperm(Ns);
    counter = 1;
    for count = 1:Ns
        % Calculate the activation of each node.
        for i=1:gridx
            for j=1:gridy
                % deviation is the projection onto each basis fn.
                [c,f]  = proj_vect(Adjs(count).A,W(:,:,i,j));
                a(i,j) = sum(sum((c-diag(diag(c))).^2));
                b(i,j) = sum(sum((f-diag(diag(f))).^2)); % This one is the  eigenvalues
            end
        end
        % Find the largest activation s
        [~,maxx]=min(min(b'));
        [~,maxy]=min(min(b));
        if iteration == 1
            maxx = floor(rand*gridx)+1;
            maxy = floor(rand*gridy)+1;
        end
        % ok so after finding the winner get the distances from them from
        % every node.
        DD = reshape(pdist2(griddy,[maxx maxy]),gridx,gridy);
        WW = pdf(pd,DD);
        SpreadW(count,:,:) = WW;
        disp(['Winner: ' num2str([maxx maxy]) ]);
        % Indicate the day type that has activated this node.
        node(iteration).d(maxx,maxy)=node(iteration).d(maxx,maxy)+1;
        % Update all the weights in the maximum neighbourhood
    end
    % step2: Update step
    for i=1:gridx
        for j = 1:gridy
            % update the node simultaneously
            stack=W(:,:,i,j);
            for kk=1:Ns
                stack = [stack Adjs(kk).A*SpreadW(kk,i,j)*100];
            end
            [ V ] = joint_diag_cpp(stack, threshold);
            W(:,:,i,j) = V;
        end
    end
    % step3: Iteration step
    % View the iteration results:
    disp([ 'iteration : ' num2str(iteration)]);
    % plot the grid map of each iteration
    if plot_flag ==1
        mesh(node(iteration).d);
        xlabel('Grid x'); ylabel('Grid y');zlabel('|Winners|');
        hold on
        print('-depsc',['images_test/koh_nodes_' num2str(iteration)])
    end
    % drop the size of the kernel
    pd = makedist('normal','mu',0,'sigma',gridx/(4+iteration));
end

