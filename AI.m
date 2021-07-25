clc;
clear all;
close all;

%unos podataka iz excel
otpor_JKS=xlsread('Podaci.xlsx','A:A');
otpor_JKS=transpose(otpor_JKS);
udaljenost=xlsread('Podaci.xlsx','B:B');
udaljenost=transpose(udaljenost);

%proracun stvarnih vrijednosti struja
n=length(otpor_JKS);
I_ef=zeros(n,1);
for i=1:1:n
    R=otpor_JKS(i);
    distanca=udaljenost(i);
    sim('AI_shema')
    I_ef(i)=mean(ef_JKS);
end

%upis u excel
vel0 = num2str(n+1);
granice10 = strcat('C','2',':','C',vel0);
xlswrite('Podaci.xlsx',I_ef,granice10)

%priprema podataka za trening
I_ef=transpose(I_ef);
ulazni_podaci_orginal=zeros(2,n);
for i=1:1:n
    ulazni_podaci_orginal(1,i)=otpor_JKS(i);
    ulazni_podaci_orginal(2,i)=udaljenost(i);
end

%treniranje mreze
net=feedforwardnet(5);
net=train(net,ulazni_podaci_orginal,I_ef);
view(net);

%ucitavanje novih podataka iz excel
novi_otpor_JKS=xlsread('Podaci.xlsx','D:D');
novi_otpor_JKS=transpose(novi_otpor_JKS);
nova_udaljenost=xlsread('Podaci.xlsx','E:E');
nova_udaljenost=transpose(nova_udaljenost);

%odredivanje novih struja
m=length(novi_otpor_JKS);
I_ef_nova=zeros(m,1);
for i=1:1:m
    R=novi_otpor_JKS(i);
    distanca=nova_udaljenost(i);
    sim('AI_shema')
    I_ef_nova(i)=mean(ef_JKS);
end

I_ef_nova=transpose(I_ef_nova);
ulazni_podaci_novi=zeros(2,m);
for i=1:1:m
    ulazni_podaci_novi(1,i)=novi_otpor_JKS(i);
    ulazni_podaci_novi(2,i)=nova_udaljenost(i);
end

%struja dobijena od mreze
AI_struja=net(ulazni_podaci_novi);
AI_struja=transpose(AI_struja);
I_ef_nova=transpose(I_ef_nova);

%upis podataka u excel
vel = num2str(m+1);
granice1 = strcat('F','2',':','F',vel);
granice2 = strcat('G','2',':','G',vel);
xlswrite('Podaci.xlsx',I_ef_nova,granice1)
xlswrite('Podaci.xlsx',AI_struja,granice2)
