clc;
clear;
addpath('RSA F');

%relevent parameters
lp = [1:15]; %list of all the players
nm = [1:10]; %number of matches
ms = [2:12]; %match size (so team size would be half this)
ns = 10000; %number of samples

matches_sizes_truths = [];
players_matches = [];
again = 1;

for i = 1:ns
    %randomly select how many matches to be played
    match = randi(nm(end));
    matches_sizes_truths(i,1) = match;
    %randomly select match size
    m_size = randi([ms(1) ms(end)]);
    matches_sizes_truths(i,2) = m_size;
    %sample players for each match
    for j = 1:match
        players_matches(j,:) = datasample(lp,m_size,'Replace',false);
    end
    matches_sizes_truths(i,3) = mostsome(lp,players_matches);
    matches_sizes_truths(i,4) = somemost(lp,players_matches);
    players_matches = [];
    again = 1;
end

counts = zeros(10,2);
for i = 1:ns
    for j = 1:10
        if matches_sizes_truths(i,1)==j
            counts(j,1) = counts(j,1) + matches_sizes_truths(i,3);
            counts(j,2) = counts(j,2) + matches_sizes_truths(i,4);
        end
    end
end

probs = [];
for j = 1:10
    probs(j,1) = counts(j,1)/(counts(j,1) + counts(j,2));
    probs(j,2) = counts(j,2)/(counts(j,1) + counts(j,2));
end

line = 1:10;
plot(line,probs(:,1),'g',line,probs(:,2),'k');
xlabel('Number of Matches');
ylabel('Probability of Interpretation');
legend('most > some','some > most');

