function [ERP]=CalculaERP(datosCrudos,vectorTiempo,hacerGraficos)
% Nombre del programa: CalculaERP.m
% Uso: [ERP]=CalculaERP(datosCrudos,vectorTiempo,hacerGraficos)
%
% Variables de entrada:
% datosCrudos. Es una variable (vector o matriz) que
% contiene al menos 1 sensor de datos de EEG y sus respectivos ensayos.
% El orden de este vector o matriz sigue la nomenclatura del formato EEGLAB
% (Delorme, A., & Makeig, S. (2004). EEGLAB: an open source toolbox for
% analysis of single-trial EEG dynamics including independent component
% analysis. Journal of neuroscience methods, 134(1), 9-21.) donde los datos
% se guardan en un vector/matriz de 3 dimensiones donde la primera dimensi?n
% corresponde a sensores, la segunda es puntos de datos (tiempo) y la
% tercera corresponde a ensayos experimental.
%
% vectorTiempo. Vector que contiene el curso temporal del segmento de datos
% que se est? calculando. Esta variable es opcional.
%
% hacerGraficos. Es un l?gico (0|1) para indicar si el usuario desea
% graficar el ERP calculado. Al ingresar 0, no se realizar?n gr?ficos, al
% ingresar 1, un gr?fico parecido al panel superior de la Figura 3 (l?nea
% 293) aparecer?. Si los datos ingresados contienen m?s de 1 sensor, la
% figura ser? un "butterfly plot" (todos los sensores sobrepuestos en una
% misma figura.
%
% Variable de salida:
% ERP. Es una variable (vector o matriz) que contiene
% el mismo n?mero de sensores que la variable datosCrudos. Su orden sigue
% la nomenclatura EEGLAB. En esta oportunidad el vector/matriz tendr? una
% dimensi?n menos que la variable datosCrudos, ya que la dimensi?n de
% ensayos experimentales habr? sido promediada para computar el ERP. Esta
% variable puede ser graficada o testeada estad?sticamente utilizando
% MATLAB o alg?n otro software estad?stico.
%
% Al ingresar el vector/matriz con datos, la funci?n proceder? a computar
% el ERP al implementar la Ecuaci?n 1 del art?culo (l?nea 160).
%
% Nota importante: Para ejecutar esta funci?n computacional se requiere
% que el ordenador tenga instalado el ambiente MATLAB
% (The MathWorks, Inc., Natick, MA).

% Funci?n escrita en Abril de 2019 por Francisco J. Parada, Ph.D.
% (francisco.parada@udp.cl) de la Facultad de Psicolog?a de la Universidad
% Diego Portales para su difusi?n como documento suplementario del art?culo
% "Computaci?n, an?lisis e interpretaci?n de se?ales el?ctricas del cerebro
% humano en el dominio del tiempo: 90 a?os de Electrofisiolog?a Cognitiva".
% Junto con la presente funci?n computacional, se provee el archivo
% datosCrudos.mat que contiene 11 sensores occipitales junto con 748 puntos
% de datos de EEG en 101 ensayos experimentales. Estos datos fueron
% recolectados en el sistema Electrical Geodesics Inc. (EGI) que se
% encuentra ubicado en el Laboratorio de Neurociencia Cognitiva y Social de
% la Facultad de Psicolog?a de la Universidad Diego Portales, en Vergara
% 275, Santiago de Chile.
%% Calcula ERP
close all; %cierra todas las figuras anteriores
if isempty(datosCrudos) %comprueba si datosCrudos contiene datos
    error('datosCrudos parece no contener datos. Revisar y volver a intentar.')
    return
end
if size(datosCrudos,3)>1 %comprueba la existencia de dimensiones
    ERP=mean(datosCrudos,3); %Promediar la tercera dimensi?n de ensayos experimentales
elseif size(datosCrudos,2)>1 %comprueba las dimensiones
    ERP=mean(datosCrudos,2); %Promediar la tercera dimensi?n de ensayos experimentales
end
if ~exist('vectorTiempo','var') %comprueba si el par?metro opcional fue ingresado
    vectorTiempo=1:length(ERP);
end
if hacerGraficos %comprueba si se graficar? el resultado
    fig=figure; %abre una nueva figura
    fontSize=15; %establece tama?o de fuente
    plot(vectorTiempo,ERP','linewidth',3);
    xlabel('Tiempo (en milisegundos)','FontSize',fontSize);
    ylabel('Potencial (en microvolts)','FontSize',fontSize);
    title('Potencial relacionado a eventos (ERP)')
end
end