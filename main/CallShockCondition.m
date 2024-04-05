function [ssdot,sbdot]= CallShockCondition(c,v,N,Ne,ss,sb,Lt,detaf_dt_end,Ss,temp,val)
    [ssdot,sbdot]= ShockCondition(c,v,N,ss,sb,detaf_dt_end,Ss,0);  

