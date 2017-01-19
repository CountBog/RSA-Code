%RSA model, looking at scope interpretation
clc;
clear;
addpath('RSA F');

%Coding up model as it was talked about in our last meeting.
%Variables to consider:
%Context, World State, QUD, Utterance, and Utterance Interpretation
%I'm just going to represent Utterance implicitly and represent each
%interpretation of the two alternative utterances explicitly
%So we have 4 world states (although this changes depending on the 'horse'
%parameter), we have 2 alternative QUDs, and we have 4 Interpretations to
%choose from.  Which means we have a 4x4x2 dimensional space.


%Basic features that could change
horses = 3;
%What context are we in
context = 0; %1 for P_Succ, and 0 for uniform
%Free parameters in model
P_Succ = .8;
alpha = 1;
% P_Inv = .5;
% P_Iso = (1 - P_Inv);

%First we calculate P(w|c), which indicates the probability
%of the horses succeeding at some task.  This functions like a prior on the
%world state calculation.  I think the only person who considers this is
%the pragmatic listener.  
W = [];
if context
    W = binopdf([0:horses],horses,P_Succ);
else
    W(1:(horses + 1)) = (1/(horses + 1));
end

%So the literal listener is just considering the truth-functional
%definition for each interpretation.  Its a P(w|I) calculation, normalized
%across world states
L_Zero = zeros(4, (horses + 1), 2);
%This will be constant given discrete number of interpretations. 
L_Den = zeros(1,4);
for i = 1:(horses + 1)
    L_Den(1) = L_Den(1) + noneScope((i - 1), horses, 1);
    L_Den(2) = L_Den(2) + notallScope((i - 1), horses, 1);
    L_Den(3) = L_Den(3) + someSucc((i - 1), horses, 1);
    L_Den(4) = L_Den(4) + AllSucc((i - 1), horses, 1);
end

for i = 1:(horses + 1)
    L_Zero(1,i,:) = noneScope((i-1),horses,1)/L_Den(1);
    L_Zero(2,i,:) = notallScope((i-1),horses,1)/L_Den(2);
    L_Zero(3,i,:) = someSucc((i-1),horses,1)/L_Den(3);
    L_Zero(4,i,:) = AllSucc((i-1),horses,1)/L_Den(4);
end

%So now I need to calculate Speaker_One.  She is optimizing her choice of
%utterance (in this case represented explicitly as optimizing
%interpretation) given the literal listeners truth-functional semantics.
%The probability of varius QUDs is worked in here.  So we actually get P(I
%|W,QUD).  This acts as a 'prior' on which QUD is more likely.  This affects
%which utterance the speaker will be likely to choose.
Qud = [];
if context
    Qud = [P_Succ, (1 - P_Succ)];
else
    Qud = [.5 .5];
end

%%% Speaker Part
KL = 0;
%We set up the speaker matrix, multiplying by the prior probability of each
%QUD.  Alpha is a free parameter that can be adjusted to control for
%speaker optimality.  A higher alpha will make the speaker more
%deterministic (i.e. the speaker will assign more weight to more true
%interpretations, and less weight to less true interpretations)
S_One = zeros(4, (horses + 1), 2);
New_L_Zero(:,:,1) = (L_Zero(:,:,1)*Qud(1)).^alpha;
New_L_Zero(:,:,2) = (L_Zero(:,:,2)*Qud(2)).^alpha;

%QUD calculation for each interpretation
QUD_Speak = zeros(4,2);
if KL = 0
    for i = 1:4
        QUD_Speak(i,1) = QUD(L_Zero(i,4,1), L_Zero(i,(1:3),1));
        QUD_Speak(i,2) = QUD(L_Zero(i,1,2), L_Zero(i,(2:4),2));
    end
    for q = 1:2
        for w = 1:(horses + 1)
            S_one(1, w, q) = (QUD_Speak(1,q).*New_L_Zero(1, w, q))/sum(New_L_Zero(:,w,q).*QUD_Speak(:,q));
            S_one(2, w, q) = (QUD_Speak(2,q).*New_L_Zero(2, w, q))/sum(New_L_Zero(:,w,q).*QUD_Speak(:,q));
            S_one(3, w, q) = (QUD_Speak(3,q).*New_L_Zero(3, w, q))/sum(New_L_Zero(:,w,q).*QUD_Speak(:,q));
            S_one(4, w, q) = (QUD_Speak(4,q).*New_L_Zero(4, w, q))/sum(New_L_Zero(:,w,q).*QUD_Speak(:,q));
        end
    end
else
    for i = 1:4
        QUD_Speak(i,1) = QUD(L_Zero(i,4,1), L_Zero(i,(1:3),1));
        QUD_Speak(i,2) = QUD(L_Zero(i,1,2), L_Zero(i,(2:4),2));
    end
    for q = 1:2
    
    

figure(1);
bar(S_one(:,:,1)');
set(gca, 'XTickLabel', [0 1 2 3]);
title('P(I|W,QUD)');
ylabel('probability of selecting the interpretation');
xlabel('number of horeses over the fence');
legend('none', 'notall', 'some', 'every', 'location', 'North')

figure(2);
bar(S_one(:,:,2)');
set(gca, 'XTickLabel', [0 1 2 3]);
title('P(I|W,QUD)');
ylabel('probability of selecting the interpretation');
xlabel('number of horeses over the fence');
legend('none', 'notall', 'some', 'every', 'location', 'North')

%So now for the pragmatic listener.  Here we have a prior on context that
%was calculated before.  
Prag_L_one = zeros(4,4,2);

for q = 1:2
    for i = 1:4
        for w = 1:(horses + 1)
            Prag_L_one(i, w, q) = (W(w).*S_one(i, w, q))/sum(S_one(i,:,q).*W);
        end
    end
end

figure(3);
bar(Prag_L_one(:,:,2));
interp = {'none'; 'not all'; 'some'; 'every'};
set(gca, 'XTickLabel', interp);
title('P(W|I,QUD)');
ylabel('probability of the world state');
xlabel('Interpretation');
legend('0', '1', '2', '3', 'location', 'North')



    


