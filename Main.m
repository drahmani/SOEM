addpath('~/JnS-1.2')

clear all
% load data/Y and data/name
Y = Y_UCR; % rows is time and column is numebr inputs (no_input) to be cluster
label=names;
[N,M]=size(Y); %table array of M inputs 
L = 30; %choose an embedding dimension

% get the embedded matrix of it. 
 for j=1:M
      X(j).x = traj_mat(Y(1:N,j),L);
      Adjs(j).A = X(j).x*X(j).x';
 end
% Choose grid sizes:  Wlx and Wly and number of iteration to train the map
Wlx =30; Wly=30; NIter = 10;
%initialise a weight matrix with a Wlx*Wly grid
[W] = initkm(Adjs,Wlx,Wly);
plot_flag=0; % choose if you want to plot figures at each iteration
% training a kohonen map
[W,node] = trainkm_w(Adjs,W,NIter,plot_flag);

%% Results Analysis: 
% plot clustering map
figure
RR = zeros(30,30); 
for count =1:M
        for i=1:Wlx
        for j=1:Wly
            % deviation is the projection onto each basis fn.
            [c,f]  = proj_vect(Adjs(count).A,W(:,:,i,j));
            a(i,j) = sum(sum((c-diag(diag(c))).^2));
            b(i,j) = sum(sum((f-diag(diag(f))).^2)); % these are the eigenvalues
            %a(i,j) = sum(W(:,i,j)'*P_n);
        end
        end
    [~,maxx]=min(min(b'));
    [~,maxy]=min(min(b));
    RR(maxx,maxy)=RR(maxx,maxy)+1; 
    loc_log(count,:) = [maxx maxy]; % clustred location of each input  
    hold on
    plot(maxx,maxy,'.');
    text(maxx+0.5*rand,maxy+0.5*rand,label{count});
end
figure
bar3(RR)

% % find out which states are going where by plotting off_2 (||U_{i,j},C||)
for count = 1:M 
        mesh(log(b))
        xlabel('Grid i','FontSize',16); ylabel('Grid j','FontSize',16);
        zlabel('off_2 (||U_{i,j},C||)','FontSize',16);
        print('-depsc',['images_ordering/b_' num2str(count)])

end


    
