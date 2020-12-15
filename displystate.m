function [strR strL] =  displystate(YR,YL)
if (YR==1)
strR='the Right eye normal';
elseif (YR==2)
strR='the Right eye starbismus to Right';
elseif (YR==3)
strR='the Right eye starbismus to left';
end

if (YL==1)
strL='the Left eye normal';
elseif (YL==2)
strL='the Left eye starbismus to Right';
elseif (YL==3)
strL='the Left eye starbismus to left';
end