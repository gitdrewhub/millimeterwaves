clc;clear all;close all;
%% Importing data from HFSS simulation
dataIM=csvread('dataIM.csv',1,1,[1,1,76,36]);
dataRE=csvread('dataRE.csv',1,1,[1,1,76,36]);

freq=csvread('dataRE.csv',1,0,[1,0,length(dataIM),0]);
data=dataRE+1i*dataIM;

s11=data(:,1);
s12=data(:,2);
s13=data(:,3);
s21=data(:,7);
s22=data(:,8);
s23=data(:,9);
s31=data(:,13);
s32=data(:,14);
s33=data(:,15);
s34=data(:,16);
s43=data(:,21);
s44=data(:,22);

Zo=50;
%% Calculating measured ABCD
Am=((1+s11).*(1-s22)+s12.*s21)./(2*s21);
Bm=Zo*((1+s11).*(1+s22)-s12.*s21)./(2*s21);
Cm=(1/Zo)*((1-s11).*(1-s22)-s12.*s21)./(2*s21);
Dm=((1-s11).*(1+s22)+s12.*s21)./(2*s21);


%% Calculating ABCD around the DUT
A=((1+s11).*(1-s33)+s13.*s31)./(2*s31);
B=Zo*((1+s11).*(1+s33)-s13.*s31)./(2*s31);
C=(1/Zo)*((1-s11).*(1-s33)-s13.*s31)./(2*s31);
D=((1-s11).*(1+s33)+s13.*s31)./(2*s31);



for f=1:length(freq)
    ABCDprime= inv([A(f),B(f);C(f),D(f)])*[Am(f),Bm(f);Cm(f),Dm(f)]*inv([D(f),B(f);C(f),A(f)]);
    Aprime=ABCDprime(1,1);
    Bprime=ABCDprime(1,2);
    Cprime=ABCDprime(2,1);
    Dprime=ABCDprime(2,2);
    denom=(Aprime+Bprime/Zo+Cprime*Zo+Dprime);
    s11prime(f)=(Aprime+Bprime/Zo-Cprime*Zo-Dprime)/denom;
    s12prime(f)=2*(Aprime*Dprime-Bprime*Cprime)/denom;
    s21prime(f)=2/denom;
    s22prime(f)=(-Aprime+Bprime/Zo-Cprime*Zo+Dprime)/denom;
end

%% Plot Measured and Deembeded S-parameters
plot(freq,20*log10(abs(s11)), freq, 20*log10(abs(s12)),freq,20*log10(abs(s21)), freq, 20*log10(abs(s22)))
legend('S11','S12','S21','S22')
xlabel('Frequency(GHz)')
ylabel('Magnitude(dB)')
title('Deembeded S-Parameters')

figure
plot(freq,20*log10(abs(s11prime)), freq, 20*log10(abs(s12prime)),freq,20*log10(abs(s21prime)), freq, 20*log10(abs(s22prime)))
legend('S11','S12','S21','S22')
xlabel('Frequency(GHz)')
ylabel('Magnitude(dB)')
title('Measured DUT S-Parameters')

figure
plot(freq,20*log10(abs(s33)), freq, 20*log10(abs(s34)),freq,20*log10(abs(s43)), freq, 20*log10(abs(s44)))
legend('S33','S34','S43','S44')
xlabel('Frequency(GHz)')
ylabel('Magnitude(dB)')
title('Actual S-Parameters')

