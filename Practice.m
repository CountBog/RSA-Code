%%Practice Script 
% generate some input
input={'green','red','green','red','blue'}';

% find the unique elements in the input
uniqueNames=unique(input)';

% use string comparison ignoring the case
occurrences=strcmpi(input(:,ones(1,length(uniqueNames))),uniqueNames(ones(length(input),1),:));

% count the occurences
counts=sum(occurrences,1);

%pretty printing
for i=1:length(counts)
    disp([uniqueNames{i} ': ' num2str(counts(i))])
end

x = [.25 .25 .25 .25];
samples = [];
for i = 1:1000
samples(i) = sampler(x);
end

ux = unique(samples);
counts = histc(samples, ux)
    


% counts = zeros(10,2);
% for i = 1:ns
%     for j = 1:10
%         if matches_sizes_truths(i,1)==j
%             counts(j,1) = counts(j,1) + matches_sizes_truths(i,3);
%             counts(j,2) = counts(j,2) + matches_sizes_truths(i,4);
%         end
%     end
% end
% 
% probs = [];
% for j = 1:10
%     probs(j,1) = counts(j,1)/(counts(j,1) + counts(j,2));
%     probs(j,2) = counts(j,2)/(counts(j,1) + counts(j,2));
% end
% 
% line = 1:10
% plot(line,probs)
    
        
    


% Lit_List = Lit_List';
% bar(Lit_List);
% set(gca, 'XTickLabel', [0 1 2 3]);
% title('Listener Belief Distribution');
% ylabel('probability of world state according to literal listener');
% xlabel('number of red apples');
% legend('none', 'some', 'every', 'location', 'southwest');

%     for i = 1:N
%         x = rand;
%         if x < Prob_none
%             Speakers_belief(1,w) = Speakers_belief(1,w) + 1;
%         elseif x < (Prob_some + Prob_none)
%             Speakers_belief(2,w) = Speakers_belief(2,w) + 1;
%         else x < (Prob_every + Prob_some + Prob_none)
%             Speakers_belief(3,w) = Speakers_belief(3,w) + 1;
%         end
%     end

    %for i = 1:N
%         x = rand;
%         if x < Prob_0
%             Listeners_belief(w,1) = Listeners_belief(w,1) + 1;
%         elseif x < Prob_0 + Prob_1
%             Listeners_belief(w,2) = Listeners_belief(w,2) + 1;
%         elseif x < Prob_0 + Prob_1 + Prob_2
%             Listeners_belief(w,3) = Listeners_belief(w,3) + 1;
%         else x < Prob_0 + Prob_1 + Prob_2 + Prob_3
%             Listeners_belief(w,4) = Listeners_belief(w,4) + 1;
%         end
    %end