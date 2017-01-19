%RSA model, looking at scope interpretation
clc;
clear;

%Right now I'm assuming 5 horses, and two interpretations for the
%scopally ambiguous utterance.  


%Listener's prior belief state about how many horses make it over the fense.  
%Or perhaps it should be a prior on the interpretation.   
%So yeah, lets do a prior over the interpretation.  This should put a lot
%of weight on the 'none' interpretation.  How do we justify the prior?
prior_I = [.5 .5];

%Number of horses in consideration
horses = 3;
h = horses + 1;

%Number of discrete interpretations
int = 2;

%I don't know if we will need this for the horse model, but it's unclear
%The speaker's deviation from optimality, controlled by parameter alpha.
%A higher alpha value corresponds to a lower probability the speaker
%chooses a sub-optimal utterance.
alpha = 2;

%Ok so probnone and probnotall represent how much uncertainty there is
%about the truth-function of the interpretation.  There is a Tprob and a
%Fprob for each interpretation.  It might be more salient that none is true
%when 0 horses make it over the fence, however when 1 out of 5 makes it
%over the fence there might be some uncertainty about its truth value.
%This might also change give the proportion of horses that made it
%over. This measure feels random, and I'm not sure if it legit.  A
%FprobNone closer to zero indicatse that the listener wants 'none' to be
%true, even in situations where it is false, so they will reject the
%utterance in situations where it is false, when they assume its true
TprobNone = 1;
FprobNone = 1;
TprobNotAll = 1;
FprobNotAll = 1;

%Iterations for the literal listener to settle on a distribution over
%intentions given the world states
iter = 1000;

%The literal listener treats utterances as true. 
%Upon hearing an utterance, the listener will assume it's true in
%porportion to the total number of world states it is true in.  In this
%case there is 5 different world states, and two truth-functional
%interpretations.  The interpretations are the rows, and the world states
%are the columns
Lit_List = zeros(int,h);

%%%Need these for commented out code
% noneDen = 0;
% notallDen = 0;

for s = 1:h
    for i = 1:iter
        Lit_List(1,s) = Lit_List(1,s) + ProbNoneScope((s - 1),horses,TprobNone,FprobNone);
        Lit_List(2,s) = Lit_List(2,s) + ProbnotallScope((s - 1),horses,TprobNotAll,FprobNotAll);
    end
end

noneDen = sum(Lit_List(1,:));
notallDen = sum(Lit_List(2,:));
for s = 1:h
    Lit_List(1,s) = Lit_List(1,s)/noneDen;
    Lit_List(2,s) = Lit_List(2,s)/notallDen;
end

    
%%% This is for the 'default' script where the truth functions are certian

% for alts = 0:horses
%         NS = noneScope(alts, horses);
%         noneDen = noneDen + NS;
%         NAS = notallScope(alts, horses);
%         notallDen = notallDen + NAS;
% end
% 
% for s = 1:h
%     Lit_List(1,s) = noneScope((s - 1),horses)/noneDen;
%     Lit_List(2,s) = notallScope((s - 1),horses)/notallDen;
% end


figure;
%Lit_List = Lit_List';
bar(Lit_List);
set(gca, 'XTickLabel', {'none', 'note all'});
title('P(W|I)');
ylabel('probability of world state');
xlabel('Interpretations');
legend('0', '1', '2', '3', 'location', 'northeast');  
%Lit_List = Lit_List';

%So with the Speakers_belief distribution, what are we getting at?  Her
%selection of the interpretation?  I.e. her intended meaning?
%The speaker chooses the utterance that leaves the least amount of information unknown about the
%world state.  This is captured in the equation (P_lex(s|w))^alpha, where
%'s' is world states and 'w' is utterances.  The speaker samples from a normalized 
%distribution of the literal listener.
Speakers_belief = zeros(2,h);
New_Lit_List = Lit_List.^alpha;

for w = 1:h
        Speakers_belief(1,w) = (New_Lit_List(1,w)*prior_I(1))/sum(New_Lit_List(:,w).*prior_I(:));
        Speakers_belief(2,w) = (New_Lit_List(2,w)*prior_I(2))/sum(New_Lit_List(:,w).*prior_I(:));
end

Speakers_belief(isnan(Speakers_belief))=0;
Speakers_belief = Speakers_belief';
figure;
bar(Speakers_belief);
set(gca, 'XTickLabel', [0:horses]);
title('probability of interpretations given the world state');
ylabel('probability of interpretation');
xlabel('number of horses making it over fence');
legend('none', 'not all', 'location', 'northeast');

%Now the pragmatic listener reasons about how the speaker chose their
%utterance, including any prior information they have about the world
%state.  The pragmatic listener is captured by the equation P_listener(s|w)= P_speaker(w|s)P(s)
%where P(s) is their prior belief about the world state, and P(w|s) is the
%speakers belief distribution over utterances.  In this case the prior
%cancels since it is uniform across states.
Listeners_belief = zeros(2,h);
Speakers_belief = Speakers_belief';

for w = 1:2
    for col = 1:h
    Listeners_belief(w,col) = (Speakers_belief(w,col))/(sum(Speakers_belief(w,:)));
    end
end
% Listeners_belief = Listeners_belief';
% figure;
% bar(Listeners_belief);
% set(gca, 'XTickLabel', [0:horses]);
% title('Listener Belief Distribution');
% ylabel('probability of world state according to pragmatic listener');
% xlabel('number of horses over the fence');
% legend('none', 'not all', 'location', 'northeast');  
% Listeners_belief = Listeners_belief';
