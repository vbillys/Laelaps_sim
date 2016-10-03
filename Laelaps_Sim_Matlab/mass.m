function M = mass(t,x)

%-------------------------------------------------------------------------%
% All solvers solve systems of equations in the form 
% y' = f(t,y) or problems that involve a mass matrix, 
% M(t,y)y' = f(t,y). The ode23s solver can solve only 
% equations with constant mass matrices. ode15s and 
% ode23t can solve problems with a mass matrix that is 
% singular, i.e., differential-algebraic equations (DAEs).
%-------------------------------------------------------------------------%

global mb Ib mF1 IF1 mF2 IF2 mF3 IF3 mH1 IH1 mH2 IH2 mH3 IH3 mT mTR ITR
global db dbT dF1 dF2 dF3 dH1 dH2 dH3 dT dTR

%-------------------------------------------------------------------------%
% Matrix form: M(x,x') * x' = F(x,x')
%-------------------------------------------------------------------------%
% x(1) = xb 
% x(2) = xb' 
% x(3) = yb
% x(4) = yb'
% x(5) = thb
% x(6) = thb'
% x(7) = thFR1
% x(8) = thFR1'
% x(9) = thFR2
% x(10) = thFR2'
% x(11) = lFR
% x(12) = lFR'
% x(13) = thHR1
% x(14) = thHR1'
% x(15) = thHR2
% x(16) = thHR2'
% x(17) = lHR
% x(18) = lHR'
% x(19) = thFL1
% x(20) = thFL1'
% x(21) = thFL2
% x(22) = thFL2'
% x(23) = lFL
% x(24) = lFL'
% x(25) = thHL1
% x(26) = thHL1'
% x(27) = thHL2
% x(28) = thHL2'
% x(29) = lHL
% x(30) = lHL'
%-------------------------------------------------------------------------%

xb = x(1);
xbdot = x(2); 
yb = x(3);
ybdot = x(4);
thb = x(5);
thbdot = x(6);
thFR1 = x(7);
thFR1dot = x(8);
thFR2 = x(9);
thFR2dot = x(10);
lFR = x(11);
lFRdot = x(12);
thHR1 = x(13);
thHR1dot = x(14);
thHR2 = x(15);
thHR2dot = x(16);
lHR = x(17);
lHRdot = x(18);
thFL1 = x(19);
thFL1dot = x(20);
thFL2 = x(21);
thFL2dot = x(22);
lFL = x(23);
lFLdot = x(24);
thHL1 = x(25);
thHL1dot = x(26);
thHL2 = x(27);
thHL2dot = x(28);
lHL = x(29);
lHLdot = x(30);

%-------------------------------------------------------------------------%
% Mass matrix
%-------------------------------------------------------------------------%
M = zeros(30,30);

%-------------------------------------------------------------------------%
% from Mathematica we get

M(2,2)=mb+2.*(mF1+mF2+mF3+mH1+mH2+mH3);
M(2,4)=0;
M(2,6)=2.*db.*((-1).*mF1+(-1).*mF2+(-1).*mF3+mH1+mH2+mH3).*sin(thb);
M(2,8)=dF1.*(mF1+2.*(mF2+mF3)).*cos(thFR1);
M(2,10)=(lFR.*mF3+dF2.*(mF2+mF3)).*cos(thFR2);
M(2,12)=mF3.*sin(thFR2);
M(2,14)=dH1.*(mH1+2.*(mH2+mH3)).*cos(thHR1);
M(2,16)=(lHR.*mH3+dH2.*(mH2+mH3)).*cos(thHR2);
M(2,18)=mH3.*sin(thHR2);
M(2,20)=dF1.*(mF1+2.*(mF2+mF3)).*cos(thFL1);
M(2,22)=(lFL.*mF3+dF2.*(mF2+mF3)).*cos(thFL2);
M(2,24)=mF3.*sin(thFL2);
M(2,26)=dH1.*(mH1+2.*(mH2+mH3)).*cos(thHL1);
M(2,28)=(lHL.*mH3+dH2.*(mH2+mH3)).*cos(thHL2);
M(2,30)=mH3.*sin(thHL2);

M(4,4)=mb+2.*(mF1+mF2+mF3+mH1+mH2+mH3);
M(4,6)=2.*db.*(mF1+mF2+mF3+(-1).*mH1+(-1).*mH2+(-1).*mH3).*cos(thb);
M(4,8)=dF1.*(mF1+2.*(mF2+mF3)).*sin(thFR1);
M(4,10)=(lFR.*mF3+dF2.*(mF2+mF3)).*sin(thFR2);
M(4,12)=(-1).*mF3.*cos(thFR2);
M(4,14)=dH1.*(mH1+2.*(mH2+mH3)).*sin(thHR1);
M(4,16)=(lHR.*mH3+dH2.*(mH2+mH3)).*sin(thHR2);
M(4,18)=(-1).*mH3.*cos(thHR2);
M(4,20)=dF1.*(mF1+2.*(mF2+mF3)).*sin(thFL1);
M(4,22)=(lFL.*mF3+dF2.*(mF2+mF3)).*sin(thFL2);
M(4,24)=(-1).*mF3.*cos(thFL2);
M(4,26)=dH1.*(mH1+2.*(mH2+mH3)).*sin(thHL1);
M(4,28)=(lHL.*mH3+dH2.*(mH2+mH3)).*sin(thHL2);
M(4,30)=(-1).*mH3.*cos(thHL2);

M(6,6)=Ib+2.*db.^2.*(mF1+mF2+mF3+mH1+mH2+mH3);
M(6,8)=(-1).*db.*dF1.*(mF1+2.*(mF2+mF3)).*sin(thb+(-1).*thFR1);
M(6,10)=(-1).*db.*(lFR.*mF3+dF2.*(mF2+mF3)).*sin(thb+(-1).*thFR2);
M(6,12)=(-1).*db.*mF3.*cos(thb+(-1).*thFR2);
M(6,14)=db.*dH1.*(mH1+2.*(mH2+mH3)).*sin(thb+(-1).*thHR1);
M(6,16)=db.*(lHR.*mH3+dH2.*(mH2+mH3)).*sin(thb+(-1).*thHR2);
M(6,18)=db.*mH3.*cos(thb+(-1).*thHR2);
M(6,20)=(-1).*db.*dF1.*(mF1+2.*(mF2+mF3)).*sin(thb+(-1).*thFL1);
M(6,22)=(-1).*db.*(lFL.*mF3+dF2.*(mF2+mF3)).*sin(thb+(-1).*thFL2);
M(6,24)=(-1).*db.*mF3.*cos(thb+(-1).*thFL2);
M(6,26)=db.*dH1.*(mH1+2.*(mH2+mH3)).*sin(thb+(-1).*thHL1);
M(6,28)=db.*(lHL.*mH3+dH2.*(mH2+mH3)).*sin(thb+(-1).*thHL2);
M(6,30)=db.*mH3.*cos(thb+(-1).*thHL2);

M(8,8)=IF1+dF1.^2.*(mF1+4.*(mF2+mF3));
M(8,10)=2.*dF1.*(lFR.*mF3+dF2.*(mF2+mF3)).*cos(thFR1+(-1).*thFR2);
M(8,12)=(-2).*dF1.*mF3.*sin(thFR1+(-1).*thFR2);
M(8,14)=0;
M(8,16)=0;
M(8,18)=0;
M(8,20)=0;
M(8,22)=0;
M(8,24)=0;
M(8,26)=0;
M(8,28)=0;
M(8,30)=0;

M(10,10)=IF2+IF3+lFR.*(2.*dF2+lFR).*mF3+dF2.^2.*(mF2+mF3);
M(10,12)=0;
M(10,14)=0;
M(10,16)=0;
M(10,18)=0;
M(10,20)=0;
M(10,22)=0;
M(10,24)=0;
M(10,26)=0;
M(10,28)=0;
M(10,30)=0;

M(12,12)=mF3;
M(12,14)=0;
M(12,16)=0;
M(12,18)=0;
M(12,20)=0;
M(12,22)=0;
M(12,24)=0;
M(12,26)=0;
M(12,28)=0;
M(12,30)=0;

M(14,14)=IH1+dH1.^2.*(mH1+4.*(mH2+mH3));
M(14,16)=2.*dH1.*(lHR.*mH3+dH2.*(mH2+mH3)).*cos(thHR1+(-1).*thHR2);
M(14,18)=(-2).*dH1.*mH3.*sin(thHR1+(-1).*thHR2);
M(14,20)=0;
M(14,22)=0;
M(14,24)=0;

M(14,26)=0;
M(14,28)=0;
M(14,30)=0;

M(16,16)=IH2+IH3+lHR.*(2.*dH2+lHR).*mH3+dH2.^2.*(mH2+mH3);
M(16,18)=0;
M(16,20)=0;
M(16,22)=0;
M(16,24)=0;
M(16,26)=0;
M(16,28)=0;
M(16,30)=0;

M(18,18)=mH3;
M(18,20)=0;
M(18,22)=0;
M(18,24)=0;
M(18,26)=0;
M(18,28)=0;
M(18,30)=0;

M(20,20)=IF1+dF1.^2.*(mF1+4.*(mF2+mF3));
M(20,22)=2.*dF1.*(lFL.*mF3+dF2.*(mF2+mF3)).*cos(thFL1+(-1).*thFL2);
M(20,24)=(-2).*dF1.*mF3.*sin(thFL1+(-1).*thFL2);
M(20,26)=0;
M(20,28)=0;
M(20,30)=0;

M(22,22)=IF2+IF3+lFL.*(2.*dF2+lFL).*mF3+dF2.^2.*(mF2+mF3);
M(22,24)=0;
M(22,26)=0;
M(22,28)=0;
M(22,30)=0;

M(24,24)=mF3;
M(24,26)=0;
M(24,28)=0;
M(24,30)=0;

M(26,26)=IH1+dH1.^2.*(mH1+4.*(mH2+mH3));
M(26,28)=2.*dH1.*(lHL.*mH3+dH2.*(mH2+mH3)).*cos(thHL1+(-1).*thHL2);
M(26,30)=(-2).*dH1.*mH3.*sin(thHL1+(-1).*thHL2);

M(28,28)=IH2+IH3+lHL.*(2.*dH2+lHL).*mH3+dH2.^2.*(mH2+mH3);
M(28,30)=0;

M(30,30)=mH3;

%-------------------------------------------------------------------------%
% We add aces for diagonal odd elements

M(1,1) = 1;
M(3,3) = 1;
M(5,5) = 1;
M(7,7) = 1;
M(9,9) = 1;
M(11,11) = 1;
M(13,13) = 1;
M(15,15) = 1;
M(17,17) = 1;
M(19,19) = 1;
M(21,21) = 1;
M(23,23) = 1;
M(25,25) = 1;
M(27,27) = 1;
M(29,29) = 1;



