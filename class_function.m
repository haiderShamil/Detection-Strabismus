function  classT = class_function(YR,YL)  

if ((YR==1)&&(YL==1))
       classT='Normal';
   elseif (YR==1)&&(YL==2)
       classT='Exotropia';
       elseif (YR==1)&&(YL==3)
       classT='Esotropia';
       elseif (YR==2)&&(YL==1)
       classT='Esotropia';
       elseif (YR==2)&&(YL==2)
       classT='Normal';
       elseif (YR==2)&&(YL==3)
       classT='Crossed Eye';
       elseif (YR==3)&&(YL==1)
       classT='Exotropia';
       elseif (YR==3)&&(YL==2)
       classT='Crossed Eye';
       elseif (YR==3)&&(YL==3)
       classT='Normal';
   end