%%%extra pragmatic speaker stuff
%pragmatic speaker pass for calculating P(u|w,qud, scope)
p_PS_1 = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                p_PS_1(a,b,c,d) = p_PL(a,b,c,d)/sum(p_PL(a,:,c,d));
            end
        end
    end
end
p_PS_1(isnan(p_PS_1))=0;

%pragmatic speaker pass for calculating P(u|w,qud)
p_PS_2 = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                p_PS_2(a,b,d) = sum(p_PL(a,b,:,d))/sum(sum(p_PL(a,:,:,d)));
            end
        end
    end
end
p_PS_2(isnan(p_PS_2))=0;

%%%extra pragmatic listener stuff    %getting joint probability for PL, P(world|utterance, QUD)
pw_PL_uq = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                pw_PL_uq(a,b,c,d) = temp_PL(a,b,c,d)/sum(sum(sum(sum(temp_PL(:,b,:,d)))));
            end
        end
    end
end
pw_PL_uq(isnan(pw_PL_uq))=0;
%getting P(world state|utterance, qud, scope) to pass to pragmatic speaker
p_PL = [];
for a = 1:w
    for b = 1:u
        for c = 1:s
            for d = 1:q
                p_PL(a,b,c,d) = temp_PL(a,b,c,d)/sum(temp_PL(:,b,c,d));
            end
        end
    end
end
p_PL(isnan(p_PL))=0;

    %pragmatic Listener time
%     temp_PL = [];
%     for a = 1:w
%         for b = 1:u
%             for c = 1:s
%                 for d = 1:q
%                     if b == 1
%                         temp_PL(a,b,c,d) = p_S(a,b,c,d).*prior_w(a).*QUD_prior(d).*scopes_p(c);
%                     else
%                         temp_PL(a,b,c,d) = p_S(a,b,c,d).*prior_w(a).*QUD_prior(d);
%                     end
%                 end
%             end
%         end
%     end