clearvars; 
%% Simulation parameters
numFFT = 3300;           
GuardBandLength = 150;    %    150 Guard Band Length *60kHz SCS = 9 MHz Guard Band  
                          %    Much larger than 4.93 MHz GB Required for
                          %    200 MHz BW /  60 kHz SCS.

K = 3;                    %    Overlap Factor
bitsPerSubCarrier = 6;    %    Modulation Order = 2^bitsPerSubCarrier
numSymbols = 14;          %    (14 = Standard Number of OFDM Symbols per Slot)    
SNRdB     =   20; 
SymbolLength = numFFT-2*GuardBandLength;  
TransmissionLength = K*numFFT;
UpsampledSymbolLength = K*SymbolLength;
scFactor = TransmissionLength/sqrt(UpsampledSymbolLength);
CenterFrequency = 28e9;
BW = 198e6;
txLength = TransmissionLength*numSymbols;
%% Atmospheric Channel Construction
Temp = 25; 
Press = 101; 
RH = 80;
W0 = 0.01;
R =50;
ID = 2;
h = 0;
Distance =150;
BasebandChannel = BasebandEquivalentAtmosphericChannel(Temp,Press,RH,W0,R,ID,h,Distance,CenterFrequency,K*BW,txLength);
%% FBMC Filter
% Prototype Filter
switch K
    case 2
        HkOneSided = sqrt(2)/2;
    case 3
        HkOneSided = [0.911438 0.411438];
    case 4
        HkOneSided = [0.971960 sqrt(2)/2 0.235147];
    otherwise
        return
end
Hk = [fliplr(HkOneSided) 1 HkOneSided];

%% FBMC Transmitter
dataSubCar = zeros(SymbolLength, 1);
dataSubCarUp = zeros(UpsampledSymbolLength, 1);
inpData = zeros( bitsPerSubCarrier*SymbolLength/2, numSymbols);
txSigAll = complex(zeros(TransmissionLength, numSymbols));
txSymbolMap = complex(zeros(SymbolLength/2, numSymbols));

for symbolNr = 1:numSymbols   
    % Half the needed symbols to account for oversampling by 2
    inpData(:, symbolNr) = randi([0 1], bitsPerSubCarrier*SymbolLength/2, 1);
    modData = qammod(inpData(:, symbolNr),2^bitsPerSubCarrier,'InputType','bit');
    txSymbolMap(:, symbolNr) = modData;
      
    % OQAM Modulator: alternate real and imaginary
    if rem(symbolNr,2)==1
        dataSubCar(1:2:SymbolLength) = real(modData);
        dataSubCar(2:2:SymbolLength) = 1i*imag(modData);
    else
        dataSubCar(1:2:SymbolLength) = 1i*imag(modData);
        dataSubCar(2:2:SymbolLength) = real(modData);
    end
    
    % Upsample by K, pad with GB, and filter with the prototype filter
    dataSubCarUp(1:K:end) = dataSubCar;
    dataBitsUpPad = [zeros(GuardBandLength*K,1); dataSubCarUp; zeros(GuardBandLength*K,1)];
    X1 = filter(Hk, 1, dataBitsUpPad);
    
    % Remove 1/2 filter length delay
    X = [X1(K:end); zeros(K-1,1)];
    
    % Compute IFFT of length KF => Transmitted signal
    scFactor = TransmissionLength/sqrt(UpsampledSymbolLength);
    txSig = scFactor.*fftshift(ifft(X));
    txSigAll(:,symbolNr) = txSig;
end
txWaveform = txSigAll(:);
txBits = inpData(:);
txSymbolMap =txSymbolMap(:);
%% Signal after Channel and Noise

rxCleanWaveform = ifft(BasebandChannel'.*fft(txWaveform)); %Channel Applied
rxWaveform = awgn(rxCleanWaveform,SNRdB - 10*log10(2*K),'measured');  % Noise Applied
%% FBMC Receiver
rxBits = zeros( bitsPerSubCarrier*SymbolLength/2, numSymbols);
rxSymbolMap = complex(zeros(SymbolLength/2, numSymbols));
totalLen=length(rxWaveform);
txSigAll=reshape(rxWaveform, totalLen/numSymbols, numSymbols);
for symbolNr = 1:numSymbols
    rxSig = txSigAll(:, symbolNr);
    
    % Perform FFT
    RxFFT = fft(fftshift(rxSig/scFactor));
    
    % Filter with matched
    FilterRx = filter(Hk, 1, RxFFT);
    % Remove filtering Delay
    FilterRx = [FilterRx(K:end); zeros(K-1,1)];
    % Remove guards
    GuardlessRx = FilterRx(GuardBandLength*K+1:end-GuardBandLength*K);
    
    % Downsample by 2K and extract real and imaginary part
    if rem(symbolNr, 2)
        % Imaginary part is K samples after real one
        r1 = real(GuardlessRx(1:2*K:end));
        r2 = imag(GuardlessRx(K+1:2*K:end));
        ComplexRx = complex(r1, r2)/K;
    else
        % Real part is K samples after imaginary one
        r1 = imag(GuardlessRx(1:2*K:end));
        r2 = real(GuardlessRx(K+1:2*K:end));
        ComplexRx = complex(r2, r1)/K;
    end
    rxSymbolMap(:, symbolNr) = ComplexRx;  
    % Perform hard decisions
    rxBits(:, symbolNr) = qamdemod(ComplexRx,2^bitsPerSubCarrier,'OutputType','bit');
end
rxBits=rxBits(:);
rxSymbolMap=rxSymbolMap(:);

%% Calculating BER and Displaying the Received Constellation
BER = comm.ErrorRate;
ber = BER(txBits, rxBits);

disp(['FBMC Reception, BER = ' num2str(ber(1)) ' at SNR = ' ...
    num2str(SNRdB) ' dB']);

scatterplot(rxSymbolMap);