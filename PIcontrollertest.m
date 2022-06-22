%Tune the controller gains to satisfy (risetime<0.6s && overshoot<8%)
%start for a Ki/Kp ratio close to 0.2 (close to the 0.1 pole of H)

Kp=1;
ZeroRatio=0.2; %equal to (Ti)^(-1)
progstep=0.1;


while true %tune the PI
    Ki=Kp*ZeroRatio;
    PI=zpk(-Ki/Kp,0,Kp);
    H = zpk([], [-0.1 -10], 25);
    OpenLoop = PI*H;
    sys = feedback(OpenLoop,1);
    
    S = stepinfo(sys);
    Rise=S.RiseTime;
    Overshoot=S.Overshoot;
    
    if Rise>0.6
        Kp=Kp+progstep; %Kp determines how fast the system responds
    end
    if Overshoot>8
        ZeroRatio=ZeroRatio-(progstep/10); %the integral term increases the overshoot percentage
    end
    if (Rise<0.6 && Overshoot<8)
        break
    end
end 

figure(1)
step(sys);
figure(2)
rlocus(sys);
%controlSystemDesigner(sys)
PI %#ok<NOPTS>
sys %#ok<NOPTS>