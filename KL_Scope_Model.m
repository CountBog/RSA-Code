%%D-RSA Model Script in Matlab.  Functions in RSA F
clc;
clear;
addpath('RSA F');

%%%%some parameters
%worlds
w = 3;
%utterances, needs to change depending on v
u = 2;
%questions under discussion
q = 2;

%Literal Listener
%curretly need to set v here.  LitList(w,v) v = 0 for everynot, v = 1 for
%didn'ttwo. 
v = 2;
if v == 0
    worlds = [0 1 2 3];
elseif v == 1
    worlds = [1 2 3 4];
elseif v == 2
    worlds = [0 1 2];
end
[LL, M] = LitList(worlds, v);

%Speaker
%My Speaker calculation is currently wonky.  I normalize both the utility
%function and the KL divergence before adding them together, and
%renormalizing.  I do this so that both calculations prior to being added
%are of the same domain (namely a probability).  This also allows alpha and
%beta to scale each dimension similarly, so a 2 alpha and a 2 beta would be
%on the same scale of measurement.  I don't know if this is kosher,
%however.
opt = 2.5;
info = KL(LL, 3, v);
utility = util(LL, 1);
TS = [];
for i = 1:w
    TS(:,i,1) = (utility(:,i) + info(:,1)).^opt;
    TS(:,i,2) = (utility(:,i) + info(:,2)).^opt;
end

S = [];
for i = 1:q
    for c = 1:w
        for r = 1:u
            S(r,c,i) = TS(r,c,i);%/sum(TS(:,c,i));
        end
    end
end
S(isnan(S)) = 0;

%%The following gives a raw probability for the joint utterance, world
%%state, QUD
% sumS = sum(S(:));
% for i = 1:numel(S)
%     S(i) = S(i)/sumS;
% end


%Pragmatic Listener
%my current issue is how to deal with the meaning inference.  Since the
%speaker matrix contains numbers for the probability of selecting the ambiguous
%utterance, the two meanings are represented implicitly, not explicitly.  Although, they are reprsented explicitly
%by the two unambiguous utterance numbers.  My current plan is just to use
%those numbers for the meaning inference on the ambiguous utterance, and
%then weight the unambiguous utterance world state numbers accordingly.  I think I just
%figurd it out, and this seems to be kosher  
none_prior = .5;
na_prior = .5;

%posterior over meanings.  can make it a joint between the meanings and the
%world state if I want.  right now its P(M|W,U,QUD)
TM = S(1:2,:,:);
TM(1,:) = TM(1,:) * na_prior;
TM(2,:) = TM(2,:) * none_prior;
M = [];
for i = 1:q
    for c = 1:w
        for r = 1:2
            M(r,c,i) = TM(r,c,i)/sum(TM(:,c,i));
        end
    end
end

%P(W|U,QUD)
prior_worlds = [(1/3) (1/3) (1/3)];
NS = S;
for r = 1:u
    for i = 1:q
        NS(r,:,i) = NS(r,:,i) .* prior_worlds;
    end
end
% for q = 1:2
%     for w = 1:4
%         NS(3,w,q) = NS

PL = [];
for r = 1:u
    for i = 1:q
        for c = 1:w
            PL(r,c,i) = NS(r,c,i);%/%sum(NS(r,:,i));
        end
    end
end

if v == 0
    graphS = S(:,:,1)';
    figure;
    bar(graphS(:,:));
    set(gca, 'XTickLabel', [0 1 2 3]);
    title('Speaker Selection');
    ylabel('P(U|W,QUD = none?)');
    xlabel('world states');
    legend('not all', 'none', 'every', 'ambig', 'location', 'northeast');

    graphStwo = S(:,:,2)';
    figure;
    bar(graphStwo(:,:));
    set(gca, 'XTickLabel', [0 1 2 3]);
    title('Speaker Selection');
    ylabel('P(U|W,QUD = all?)');
    xlabel('world states');
    legend('not all', 'none', 'every', 'ambig', 'location', 'northeast');

    %graphPL = S(:,:,1)';
    figure;
    bar(PL(:,:,1));
    set(gca, 'XTickLabel', {'not all', 'none', 'every', 'ambig'});
    title('Probability of World State for Pragmatic List');
    ylabel('P(W|U,QUD = none)');
    xlabel('utterances');
    legend('0', '1', '2', '3', 'location', 'northeast');

    figure;
    bar(PL(:,:,2));
    set(gca, 'XTickLabel', {'not all', 'none', 'every', 'ambig'});
    title('Probability of World State for Pragmatic List');
    ylabel('P(W|U,QUD = all)');
    xlabel('utterances');
    legend('0', '1', '2', '3', 'location', 'northeast');
    
elseif v == 1
    graphS = S(:,:,1)';
    figure;
    bar(graphS(:,:));
    set(gca, 'XTickLabel', [1 2 3 4]);
    title('Speaker Selection');
    ylabel('P(U|W,QUD = none?)');
    xlabel('world states');
    legend('twonot', 'nottwo', 'ambig', 'location', 'northeast');
    
    figure;
    bar(PL(:,:,1));
    set(gca, 'XTickLabel', {'twonot', 'nottwo', 'ambig'});
    title('Probability of World State for Pragmatic List');
    ylabel('P(W|U,QUD = two?)');
    xlabel('utterances');
    legend('1', '2', '3', '4', 'location', 'northeast');
    
    figure;
    bar(PL(:,:,2));
    set(gca, 'XTickLabel', {'twonot', 'nottwo', 'ambig'});
    title('Probability of World State for Pragmatic List');
    ylabel('P(W|U,QUD = all?)');
    xlabel('utterances');
    legend('1', '2', '3', '4', 'location', 'northeast');
    
elseif v == 2
    graphS = S(:,:,1)';
    figure;
    bar(graphS(:,:));
    set(gca, 'XTickLabel', [0 1 2 3]);
    title('Speaker Selection');
    ylabel('P(U|W,QUD = many?)');
    xlabel('world states');
    legend('ambig', 'silence', 'location', 'northeast');
    
    graphS = S(:,:,2)';
    figure;
    bar(graphS(:,:));
    set(gca, 'XTickLabel', [0 1 2 3]);
    title('Speaker Selection');
    ylabel('P(U|W,QUD = all?)');
    xlabel('world states');
    legend('ambig', 'silence', 'location', 'northeast');
    
    figure;
    bar(PL(:,:,1));
    set(gca, 'XTickLabel', {'ambig', 'silence'});
    title('Probability of World State for Pragmatic List');
    ylabel('P(W|U,QUD = many?)');
    xlabel('utterances');
    legend('0', '1', '2', '3', 'location', 'northeast'); 
    
    figure;
    bar(PL(:,:,2));
    set(gca, 'XTickLabel', {'ambig', 'silence'});
    title('Probability of World State for Pragmatic List');
    ylabel('P(W|U,QUD = all)');
    xlabel('utterances');
    legend('0', '1', '2', '3', 'location', 'northeast'); 
end

    
            




