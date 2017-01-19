%RSA model, capturing the 'some, but not all' scalar implicature
clc;
%clear;

%For this model there are 4 world states: 0, 1, 2, or 3 red apples out of a
%total of 3 apples (the non-red apples can be green).  The information 
%that the speaker wants to communicate is how many of the apples are red.
%The speaker's and listener's lexicon is restricted to the quantifiers
%'every', 'some' and 'not'.


%Pragmatic listener's prior belief state about how many red apples there are.  Given
%they have no information about the world state, other than the speaker's
%utterance, the listener has a uniform prior over world statse.  
PS_0 = .2;
PS_1 = .2;
PS_2 = .4;
PS_3 = .2;


%The speaker's deviation from optimality, controlled by parameter alpha.
%A higher alpha value corresponds to a lower probability the speaker
%chooses a sub-optimal utterance.
alpha = 4;

%The literal listener treats utterances as true. 
%Upon hearing an utterance, the listener will assume it's true in
%porportion to the total number of world states it is true in.
Lit_List = zeros(3,4);
for s = 1:4
    s = s - 1;
    Lit_List(1,s+1) = none(s,3)/(none(0,3) + none(1,3) + none(2,3) + none(3,3));
    Lit_List(2,s+1) = some(s,3)/(some(0,3) + some(1,3) + some(2,3) + some(3,3));
    Lit_List(3,s+1) = every(s,3)/(every(0,3) + every(1,3) + every(2,3) + every(3,3));
end

%The speaker chooses the utterance that leaves the least amount of information unknown about the
%world state.  This is captured in the equation (P_lex(s|w))^alpha, where
%'s' is world states and 'w' is utterances.  The speaker samples from a normalized 
%distribution of the literal listener.  Given how I've simplified the
%model, both the speaker's belief distribution and the pragmatic
%listener's belief distribution could be calculated analytically without
%sampling.  If I unsimplify, however, sampling is probably the easiest
%method to impliment.
Speakers_belief = zeros(3,4);
New_Lit_List = Lit_List.^alpha;

for w = 1:4
        Speakers_belief(1,w) = New_Lit_List(1,w)/sum(New_Lit_List(:,w));
        Speakers_belief(2,w) = New_Lit_List(2,w)/sum(New_Lit_List(:,w));
        Speakers_belief(3,w) = New_Lit_List(3,w)/sum(New_Lit_List(:,w));
end
Speakers_belief = Speakers_belief';
bar(Speakers_belief);
set(gca, 'XTickLabel', [0 1 2 3]);
title('Speaker Belief Distribution');
ylabel('probability that the speaker chooses an utterance');
xlabel('number of red apples');
legend('none', 'some', 'every', 'location', 'southwest');

%Now the pragmatic listener reasons about how the speaker chose their
%utterance, including any prior information they have about the world
%state.  The pragmatic listener is captured by the equation P_listener(s|w)= P_speaker(w|s)P(s)
%where P(s) is their prior belief about the world state, and P(w|s) is the
%speakers belief distribution over utterances.  In this case the prior
%cancels since it is uniform across states.
Listeners_belief = zeros(3,4);
Speakers_belief = Speakers_belief';
for w = 1:3
    Listeners_belief(w,1) = (PS_0*Speakers_belief(w,1))/(PS_0*sum(Speakers_belief(w,:)));
    Listeners_belief(w,2) = (PS_1*Speakers_belief(w,2))/(PS_1*sum(Speakers_belief(w,:)));
    Listeners_belief(w,3) = (PS_2*Speakers_belief(w,3))/(PS_2*sum(Speakers_belief(w,:)));
    Listeners_belief(w,4) = (PS_3*Speakers_belief(w,4))/(PS_3*sum(Speakers_belief(w,:)));
end
Listeners_belief = Listeners_belief';
figure;
bar(Listeners_belief);
set(gca, 'XTickLabel', [0 1 2 3]);
title('Listener Belief Distribution');
ylabel('probability of world state according to pragmatic listener');
xlabel('number of red apples');
legend('none', 'some', 'every', 'location', 'southwest')  
