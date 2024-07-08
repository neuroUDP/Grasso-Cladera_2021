%% Figuras paper EEG
% load('/Volumes/SPUTNIK/Data/OLD_data/Comp1Results/Data/Dat_Info.mat')
% load('/Volumes/SPUTNIK/Data/OLD_data/Comp1Results/Data/ERP_DataControls.mat')
%%
[ALLEEG,thesefiles]=LoadSetFiles(...
    '/Volumes/DARWIN14/UDP_Data/JohaContext/JohaGaze/ToUse/Control2',[])
%     '/Volumes/SPUTNIK/Data/OLD_data/JohaContext/JohaGaze/ToUse/Control2',[])
%%
tmp=[];
for i=1:size(ALLEEG,2)
    tmp{i}=ALLEEG(i).data;
end
trialData=concatdata(tmp);
tasaMuestreo=ALLEEG(1).srate;
vectorTiempo=ALLEEG(1).times;
save('trialData2.mat','trialData','tasaMuestreo','vectorTiempo')
%% Figura 1 
close all;
lineColorMap=linspecer(5,'qualitative');
fontSize=15;
% load ERPdata.mat
% tasaMuestreo=ALLEEG(1).srate;
% vectorTiempo=ALLEEG(1).times;
% sensor=27;
% trialData=datosCrudos;
sensor=169;
ston=dsearchn(vectorTiempo',646);
% Plot trials
postn=[1 173 1920 606];
fig=figure('Position',postn);
pos=[1 2 4 5];
pix=1;
for t=[5 20 50 100]
    subplot(2,3,pos(pix))
    hold on
    if t==20
        hf=plot(vectorTiempo,squeeze(trialData(sensor,:,1:t)),...
            'linewidth',2,'color',[[lineColorMap(pix,:)]]);
    else
        hf=plot(vectorTiempo,squeeze(trialData(sensor,:,1:t)),...
            'linewidth',2,'color',[[lineColorMap(pix,:)]]);
    end
    for l=1:size(hf,1)
        hf(l).Color(4)=.1;
    end
    dat(pix,:)=squeeze(mean(trialData(sensor,:,1:t),3));
%     hf=plot(vectorTiempo,dat(pix,:),'linewidth',3,'color','k');
    hf=plot(vectorTiempo,dat(pix,:),'linewidth',5,'color',[lineColorMap(pix,:)]);
    set(gca,'FontSize',fontSize,'xTick',[512 646 806 956 1106 1182],...
        'xTickLabel',{'','0','170','300','450','',''})
    hf=title(sprintf('n = %d',t));
    xlabel('Tiempo (ms)','FontSize',fontSize);
    ylabel('Potencial (µV)','FontSize',fontSize);
    hf.FontSize=fontSize;
    vline(646,'k');
    xlim([512 1200]); %446 = -200 | 646 = 0
    ylim([-20 20]);
    pix=pix+1;    
end
suptitle('ERP calculado con diversos valores de \itn',20)
% SaveAnyFigure(fig,'Figura1',pwd,'png','n',postn)
% close all
%% Figura 1B
subplot(6,3,[6 9 12 15])
hold on
for l=1:size(hf,1)
    hf(l).Color(4)=.1;
end
for im=1:4
    %     hf=plot(vectorTiempo,dat(im,:),'linewidth',3,'color',[0 0 0]+0.2*im);
    hf=plot(vectorTiempo,dat(im,:),'linewidth',3,'color',lineColorMap(im,:));
end
legend({'n=5','n=20','n=50','n=100'},'Location','Best')
set(gca,'FontSize',fontSize,'xTick',[512 646 806 956 1106 1182],...
    'xTickLabel',{'','0','170','300','450','',''})
hf=title('ERP con distintos valores de n');
xlabel('Tiempo (ms)','FontSize',fontSize);
ylabel('Potencial (µV)','FontSize',fontSize);
hf.FontSize=fontSize;
vline(646,'k');
xlim([512 1200]); %446 = -200 | 646 = 0
ylim([-9 7]);
% export_fig test_gs927_color.pdf -pdf -painters
% SaveAnyFigure(fig,'Figura1_color',pwd,'eps','n',postn)
exportgraphics(gcf,'Figura1_color.png','Resolution',600)
% close all
%% Figura 2 - parte 1
close all
% crear una onda sinusoidal
tasaMuestreo=1000;
vectorTiempo=0:1/tasaMuestreo:1;
frecuencia=3;
ondaSin=sin(2*pi*frecuencia.*vectorTiempo);
additiveModel=[zeros(1,500) ondaSin];
fig=figure;
hn=plot(additiveModel,'LineWidth',10,'Color','k','MarkerFaceColor','none');
set(gca,'ylim',[-1.5 1.5],'Color','none','Xtick',[],'Ytick',[]);
box off;
axis off;
SaveAnyFigure(fig,'Figure2_part1',pwd,'png','y',[]);
close all
%% Figura 2 - parte 2
close all
% crear una onda sinusoidal
tasaMuestreo=1000;
vectorTiempo=0:1/tasaMuestreo:1;
frecuencia=3;
ondaSin=sin(2*pi*frecuencia.*vectorTiempo);
ruidoBase=(ondaSin(1:end-[100 + round(rand*100)]))/25;
phaseModel=[ruidoBase ondaSin];
fig=figure;
hn=plot(phaseModel,'LineWidth',10,'Color','k','MarkerFaceColor','none');
set(gca,'ylim',[-1.5 1.5],'Color','none','Xtick',[],'Ytick',[]);
box off;
axis off;
SaveAnyFigure(fig,'Figure2_part2',pwd,'png','y',[]);
close all
%% Figura 2 - parte 3
close all
% crear una onda sinusoidal
tasaMuestreo=1000;
vectorTiempo=0:1/tasaMuestreo:1;
frecuencia1=30;
frecuencia2=10;
frecuencia3=3;
ondaSin1=sin(2*pi*frecuencia1.*vectorTiempo);
ondaSin2=sin(2*pi*frecuencia2.*vectorTiempo);
ondaSin3=sin(2*pi*frecuencia3.*vectorTiempo);
phaseModel=[ondaSin1+rand(1,1001)/2 + ondaSin2 .* ondaSin3];
phaseModelNN=[ondaSin1 + ondaSin2 .* ondaSin3];
fig=figure;
hn=plot(vectorTiempo,phaseModel,'LineWidth',3,'Color','k',...
    'MarkerFaceColor','none');
hold on
winSize=round(size(phaseModel,2)/round(size(phaseModel,2)/frecuencia1));
st=1;
newTime=[];
for p=1:round(size(phaseModel,2)/frecuencia1)
    nanMod=nan(1,size(phaseModel,2));
    nanMod(st:st+winSize)=phaseModelNN(1,st:st+winSize);
    [ax(p),a(p)]=max(nanMod);
    [bx(p),b(p)]=min(nanMod);
    st=round(st+winSize);
end
% hn=plot(vectorTiempo(a),phaseModel(a),'.','MarkerSize',100,'Color',[0.3 0.3 0.3]);
% hn=plot(vectorTiempo(b),phaseModel(b),'.','MarkerSize',100,'Color',[0.75 0.75 0.75]);
hn=plot(vectorTiempo(a),phaseModel(a),'.','MarkerSize',100,'Color',[0 0.5 0.8]);
hn=plot(vectorTiempo(b),phaseModel(b),'.','MarkerSize',100,'Color',[0.8 0 0.1]);

box off;
axis off;
SaveAnyFigure(fig,'Figure2_part3_color',pwd,'png','y',[-1634 359 1308 668]);
% close all
%%
% Calcular el ERP
close all;
fig=figure;
fS=15;
postn=[440 378 560 450];
subplot(2,1,1)
for cnd=1:2    
    hold on;
    nameLoad=sprintf('trialData%d.mat',cnd);
    load(nameLoad);
    fontSize=15;
    sensor=169;
    nboot=100;
    alphaVal=0.05;
    nullVal=0;
    trm=0;    
%     tasaMuestreo=ALLEEG(1).srate;
%     vectorTiempo=ALLEEG(1).times;
    % Aplicar un filtro de pasa baja (low-pass filter),
    % requiere tener el "signal processing toolbox" instalado en el computador,
    % un toolbox de MATLAB disponible en https://www.mathworks.com/products/signal.html
    % Detalles del procedimiento que se llevar? a cabo puede encontrarse en
    % https://es.wikipedia.org/wiki/Filtro_paso_bajo
    % Adem?s se recomienda estudiar: Widmann, A., Schr?ger, E., & Maess, B. (2015).
    % Digital filter design for electrophysiological data?a practical approach.
    % Journal of neuroscience methods, 250, 34-46.
    nyquist=tasaMuestreo/2; %https://es.wikipedia.org/wiki/Teorema_de_muestreo_de_Nyquist-Shannon
    transicion=0.15; % porcentaje
    pasoBajo=40; % Hz
    frecuencias=[0 pasoBajo pasoBajo*(1+transicion) nyquist]/nyquist;
    respuestaIdeal=[1 1 0 0];
    pesosFiltro=firls(100,frecuencias,respuestaIdeal);
    x1=trialData(sensor,:,:);
    for i=1:size(x1)
        x1(1,:,i)=filtfilt(pesosFiltro,1,double(x1(1,:,i)));
    end
    bsln=[-200 0]; %en milisegundos
    bslnIx(1)=dsearchn(vectorTiempo',bsln(1)); %convertir de ms a indices
    bslnIx(2)=dsearchn(vectorTiempo',bsln(2)); %convertir de ms a indices
    bsrm=mean(x1(1,bslnIx(1):bslnIx(2),:)); %obtener valor de linea base
    x1=bsxfun(@minus,x1,bsrm); %restar la linea base
    [erp,CI,p]=limo_pbci(x1,nboot,alphaVal,nullVal,'tm',trm);
    if cnd==1        
        hf=plot(-20,-20,'linewidth',4,'color',lineColorMap(1,:));
%         hf.Color=[.5 .5 .5];
        hf=plot(-20,-20,'linewidth',4,'color',lineColorMap(2,:));        
%         hf.Color=[0 0 0];
        leg=legend('Condición 1','Condición 2','Location','best');
    end    
    if cnd==1
        plot(vectorTiempo,erp,'linewidth',3,'color',lineColorMap(cnd,:));        
%         hf.Color=1;
    else
        plot(vectorTiempo,erp,'linewidth',3,'color',lineColorMap(cnd,:));
%         hf.Color=1;
    end
%     hold on
    % plot confidence intervals
    x=vectorTiempo;
    y=squeeze(CI(:,1,1));z=squeeze(CI(:,1,2));
    if cnd==1
        c=[.9 .9 .9];        
        t=.5;
    else
        c=[.1 .1 .1];        
        t=.1;
    end    
    x=x(:)';y=y(:)';z=z(:)';
    X=[x,fliplr(x)];%create continuous x value array for plotting
    Y=[y,fliplr(z)];%create y values for out and then back
    hf=fill(X,Y,c);%plot filled area
    set(hf,'FaceAlpha',t,'EdgeColor',[.3 .3 .3]);
    set(gca,'FontSize',fS,'YColor','k','XColor','k')
    xlim([512 1200])
    
    set(gca,'FontSize',fontSize,'xTick',[512 646 806 956 1106 1182],...
        'xTickLabel',{'','0','170','300','450','',''})
%     hf=title(sprintf('Est?ndar para visualizar y reportar ERP'));
    xlabel('Tiempo (ms)','FontSize',fontSize);
    ylabel('Potencial (µV)','FontSize',fontSize);
%     hf.FontSize=fontSize;
    vline(646,'k');
    xlim([512 1200]); %446 = -200 | 646 = 0
    if cnd==1
        C1=x1;
    else
        C2=x1;
    end
end
subplot(2,1,2)
[~,erp,~,CI,~,~,~]=limo_yuen_ttest(C1,C2,trm,alphaVal);
plot(-20,-20,'linewidth',4,'color',lineColorMap(5,:));
legend('Diferencia entre Condiciones','Location','best')
plot(vectorTiempo,erp,'linewidth',3,'color',lineColorMap(5,:));
hold on
% plot confidence intervals
x=vectorTiempo;
y=squeeze(CI(:,:,1));
z=squeeze(CI(:,:,2));
c=[.7 .7 .7];t=.1;
x=x(:)';y=y(:)';z=z(:)';
X=[x,fliplr(x)];%create continuous x value array for plotting
Y=[y,fliplr(z)];%create y values for out and then back
hf=fill(X,Y,c);%plot filled area
set(hf,'FaceAlpha',t,'EdgeColor',[.3 .3 .3]);
set(gca,'FontSize',fS,'YColor','k','XColor','k')

set(gca,'FontSize',fontSize,'xTick',[512 646 806 956 1106 1182],...
    'xTickLabel',{'','0','170','300','450','',''})
% hf=title(sprintf('Est?ndar para visualizar y reportar ERP'));
xlabel('Tiempo (ms)','FontSize',fontSize);
ylabel('Potencial (µV)','FontSize',fontSize);
% hf.FontSize=fontSize;
vline(646,'k');
hline(0,'k');
xlim([512 1200]); %446 = -200 | 646 = 0
ylim([-0.8 1.2])
suptitle('Estándar para visualizar y reportar ERP',15)
SaveAnyFigure(gcf,'Figure3_color',pwd,'png','y',[717 121 613 658]);
% close all
%% Identificar la l?nea base del ERP y substraer
bsln=[-200 0]; %en milisegundos
bslnIx(1)=dsearchn(vectorTiempo',bsln(1)); %convertir de ms a indices
bslnIx(2)=dsearchn(vectorTiempo',bsln(2)); %convertir de ms a indices
bsrm=mean(erp(bslnIx(1):bslnIx(2))); %obtener valor de linea base
erp=bsxfun(@minus,erp,bsrm); %restar la linea base
% Aplicar un filtro de pasa baja (low-pass filter),
% requiere tener el "signal processing toolbox" instalado en el computador,
% un toolbox de MATLAB disponible en https://www.mathworks.com/products/signal.html
% Detalles del procedimiento que se llevar? a cabo puede encontrarse en
% https://es.wikipedia.org/wiki/Filtro_paso_bajo
% Adem?s se recomienda estudiar: Widmann, A., Schr?ger, E., & Maess, B. (2015).
% Digital filter design for electrophysiological data?a practical approach.
% Journal of neuroscience methods, 250, 34-46.
nyquist=tasaMuestreo/2; %https://es.wikipedia.org/wiki/Teorema_de_muestreo_de_Nyquist-Shannon
transicion=0.15; % porcentaje
pasoBajo=30; % Hz
frecuencias=[0 pasoBajo pasoBajo*(1+transicion) nyquist]/nyquist;
respuestaIdeal=[1 1 0 0];
pesosFiltro=firls(100,frecuencias,respuestaIdeal);
erp=filtfilt(pesosFiltro,1,double(erp));
figure;
for nt=1:150:600
    plot(vectorTiempo,erp);
    xlim([-100 600])
end
%%
