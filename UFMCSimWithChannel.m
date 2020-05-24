%% UFMC Signal Generator
%% Parameters:
clearvars;
numFFT = 3300;        % number of FFT points
subbandSize = 12;    % 
numSubbands = 250;    %
subbandOffset =  numFFT/2-subbandSize*numSubbands/2; % for band center
numSymbols = 14;

% Dolph-Chebyshev window design parameters
filterLen = 64;      % similar to cyclic prefix length
slobeAtten = 40;     % sidelobe attenuation, dB


bitsPerSubCarrier = 6;   % 2: 4QAM, 4: 16QAM, 6: 64QAM, 8: 256QAM
SNRdB = 1000;              % SNR in dB

CenterFrequency = 28e9;
BW = 198e6;
symLength = (numFFT + filterLen - 1);
txLength = numSymbols*symLength;
%% Atmospheric Channel Construction
Temp = 25; 
Press = 101; 
RH = 80;
W0 = 0.01;
R = 50;
ID = 2;
h = 0;
Distance =150;
BasebandChannel = BasebandEquivalentAtmosphericChannel(Temp,Press,RH,W0,R,ID,h,Distance,CenterFrequency,BW,txLength);
%% UFMC Signal Construction
% Design window with specified attenuation
prototypeFilter = chebwin(filterLen, slobeAtten);
txWaveform = complex(zeros(txLength,1));
% Transmit-end processing
%  Initialize arrays
inpData = zeros(bitsPerSubCarrier*subbandSize, numSubbands,numSymbols);
for SymIdx = 1:numSymbols
    txInfo = complex(zeros(symLength,1));

% Loop over each subband
    for bandIdx = 1:numSubbands

        bitsIn = randi([0 1], bitsPerSubCarrier*subbandSize,1);
        symbolsIn = qammod(bitsIn,2^bitsPerSubCarrier,'InputType','bit');
        inpData(:,bandIdx,SymIdx) = bitsIn; % log bits for comparison
    
        % Pack subband data into an UFMC symbol
        offset = subbandOffset+(bandIdx-1)*subbandSize; 
        symbolsInOFDM = [zeros(offset,1); symbolsIn; ...
                         zeros(numFFT-offset-subbandSize, 1)];
        ifftOut = ifft(ifftshift(symbolsInOFDM));
    
        % Filter for each subband is shifted in frequency
        bandFilter = prototypeFilter.*exp( 1i*2*pi*(0:filterLen-1)'/numFFT* ...
                     ((bandIdx-1/2)*subbandSize+0.5+subbandOffset+numFFT/2) );    
        filterOut = conv(bandFilter,ifftOut);
        % Sum the filtered subband responses to form the aggregate transmit
        % signal
        txInfo = txInfo + filterOut; 
    end
    txWaveform(symLength*(SymIdx - 1) + 1:symLength*SymIdx) = txInfo;
end
%% 

rxCleanWaveform = ifft(BasebandChannel'.*fft(txWaveform)); %Channel Applied
rxWaveform = awgn(rxCleanWaveform,SNRdB,'measured');  % Noise Applied

%% DeModulation
% Pad receive vector to twice the FFT Length (note use of txSig as input)
%   No windowing or additional filtering adopted
rxBits = zeros(bitsPerSubCarrier*subbandSize*numSubbands,numSymbols);
EqualizedRxSymbols = complex(zeros(subbandSize*numSubbands,numSymbols));
for SymIdx = 1:numSymbols
    rxInfo = rxWaveform(symLength*(SymIdx - 1) + 1:symLength*SymIdx);
    yRxPadded = [rxInfo; zeros(2*numFFT-numel(txInfo),1)];

    % Perform FFT and downsample by 2
    RxSymbols2x = fftshift(fft(yRxPadded));
    RxSymbols = RxSymbols2x(1:2:end);

    % Select data subcarriers
    dataRxSymbols = RxSymbols(subbandOffset+(1:numSubbands*subbandSize));
    % %
    % % Plot received symbols constellation
    % constDiagRx = comm.ConstellationDiagram('ShowReferenceConstellation', ...
    %     false, 'Position', figposition([20 15 25 30]), ...
    %     'Title', 'UFMC Pre-Equalization Symbols', ...
    %     'Name', 'UFMC Reception', ...
    %     'XLimits', [-150 150], 'YLimits', [-150 150]);
    % constDiagRx(dataRxSymbols);
    % %}
    % Use zero-forcing equalizer after UFMC demodulation
    rxf = [prototypeFilter.*exp(1i*2*pi*0.5*(0:filterLen-1)'/numFFT); ...
           zeros(numFFT-filterLen,1)];
    prototypeFilterFreq = fftshift(fft(rxf));
    prototypeFilterInv = 1./prototypeFilterFreq(numFFT/2-subbandSize/2+(1:subbandSize));

    % Equalize per subband - undo the filter distortion
    dataRxSymbolsMat = reshape(dataRxSymbols,subbandSize,numSubbands);
    EqualizedRxSymbolsMat = bsxfun(@times,dataRxSymbolsMat,prototypeFilterInv);
    EqualizedRxSymbols(:,SymIdx) = EqualizedRxSymbolsMat(:);

    %
    %}
    % Demapping and BER computation



    % Perform hard decision and measure errors
    rxBits(:,SymIdx) = qamdemod(EqualizedRxSymbolsMat(:),2^bitsPerSubCarrier,'OutputType','bit');
end
scatterplot(EqualizedRxSymbols(:));

BER = comm.ErrorRate;
ber = BER(inpData(:), rxBits(:));

disp(['UFMC Reception, BER = ' num2str(ber(1)) ' at SNR = ' ...
    num2str(SNRdB) ' dB']);