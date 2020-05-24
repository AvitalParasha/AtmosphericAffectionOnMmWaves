
clearvars 
%% Simulation parameters
numSymbols = 14;          %    (14 = Standard Number of OFDM Symbols per Slot)    
cpLength = 64;
numFFT = 3300;           
GuardBandLength = 150;    %    150 Guard Band Length *60kHz SCS = 9 MHz Guard Band  
                          %    Much larger than 4.93 MHz GB Required for
                          %    200 MHz BW /  60 kHz SCS.

bitsPerSubCarrier = 6;    %    Modulation Order = 2^bitsPerSubCarrier
SNRdB     =   20;
SymbolLength = numFFT-2*GuardBandLength;
CenterFrequency = 28e9;
BW = 198e6;
txLength = numSymbols*(numFFT+cpLength);
%% Atmospheric Channel Construction
Temp = 25; 
Press = 101; 
RH = 80;
W0 = 0.01;
R =50;
ID = 2;
h = 0;
Distance =150;
BasebandChannel = BasebandEquivalentAtmosphericChannel(Temp,Press,RH,W0,R,ID,h,Distance,CenterFrequency,BW,txLength);
%% OFDM Transmitter
txBits = randi([0 1],(numFFT-2*GuardBandLength)*bitsPerSubCarrier,numSymbols);
txSymbols = qammod(txBits,2^bitsPerSubCarrier,'InputType','bit');
txWaveform = ofdmmod([complex(zeros(GuardBandLength,14));txSymbols;complex(zeros(GuardBandLength,14))],numFFT,cpLength);
%% Signal after Channel and Noise

rxCleanWaveform = ifft(BasebandChannel'.*fft(txWaveform)); %Channel Applied
rxWaveform = awgn(rxCleanWaveform,SNRdB,'measured');  % Noise Applied
%% OFDM Receiver 
rxSymbols = ofdmdemod(rxWaveform,numFFT,cpLength);
rxSymbols = rxSymbols((GuardBandLength+1):(numFFT-GuardBandLength),:);
rxBits = qamdemod(rxSymbols,2^bitsPerSubCarrier,'OutputType','bit');

%% Calculating BER and Displaying the Received Constellation
BER = comm.ErrorRate;
ber = BER(txBits(:), rxBits(:));

disp(['OFDM Reception, BER = ' num2str(ber(1)) ' at SNR = ' ...
    num2str(SNRdB) ' dB']);
scatterplot(rxSymbols(:));