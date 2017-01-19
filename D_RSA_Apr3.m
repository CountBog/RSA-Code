%RSA model, looking at scope interpretation
clc;
clear;

%Coding up model as it exists thus far


%Basic features that could change
horses = 3;
%What context are we in
context = 1; %1 for P_Succ, and 0 for uniform
%Free parameters in model
P_Succ = .8;
P_Inv = .5;
P_Iso = (1 - P_Inv);
P_Obt = 1; %I don't understand this parameter.  I don't think I need it


%First we calculate P(w|c), which indicates the probability
%of the horses succeeding at some task
W = [];
if context
    W = binopdf([0:horses],horses,P_Succ);
else
    W = 1/(horses + 1);
end

%Now we have to calculate the probability of what the implicit QUD is
%about.  This is P(QUD|C).  The QUD depends on how the discourse has gone so far.
%So the probability of a QUD should change around the interlocutors
%expectation of the horses.
%We are currently considering two QUD: "Did all the horses
%succeed?" and "Did all the horses fail?"  Perhaps we should also consider:
%"Did at least one horse succeed?"
QUD = [];
if context
    QUD = [P_Succ, (1 - P_Succ)];
else
    QUD = .5;
end

%Now we calculate the probability of a given meaning, given the world state
%and the QUD, so P(m|W,QUD).  R_XY is some calculation of relevance, the
%more relevant the meaning is, and the more true it is, the more likely it
%is.
M = [];
%for meaning 1; the 'none' interpretation, given QUD_1
R_NQ1 = .99;
for i = 0:horses
    M(1,(i + 1),1) = R_NQ1 * P_Iso * noneScope(i,horses);
end
%for meaning 1; given QUD_2
R_NQ2 = .99;
for i = 0:horses
    M(1,(i + 1),2) = R_NQ2 * P_Iso * noneScope(i,horses);
end
%for meaning 2; the 'not all interpretation given QUD_1
R_AQ1 = .99;
for i = 0:horses
    M(2,(i + 1),1) = R_AQ1 * P_Inv * notallScope(i,horses);
end
%for meaning 2, given QUD_2
R_AQ2 = .01;
for i = 0:horses
    M(2,(i + 1),2) = R_AQ2 * P_Inv * notallScope(i,horses);
end
%normalizing across world states and QUDs, given the probability of the QUD
M(:,:,1) = M(:,:,1).*.8;
M(:,:,2) = M(:,:,2).*.2;
M = M./sum(M(:));

%so now we calculate the probability of the speaker generating the
%utterance, from the perspective of the literal listener (I think).
%According to the principle of charity, the literal listener should assume
%that the is being truthful.  It looks like we are just normalizing are
%'meaning' matrix across world states.


    


