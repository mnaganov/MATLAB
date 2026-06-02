function loudnessmatch(splRef, refFile, srcFile, outFile, irFile)
    [ref, fs]  = audioread(refFile);
    [src, fs2] = audioread(srcFile);
    if fs ~= fs2
        error('Sample rates must match: %d vs %d', fs, fs2);
    end

    if size(ref, 2) == 1, ref = [ref, ref]; end
    if size(src, 2) == 1, src = [src, src]; end

    pRefPa    = 20e-6;
    targetRms = pRefPa * 10^(splRef/20);
    refPa     = ref * (targetRms / sqrt(mean(ref(:).^2)));
    srcPa     = src * (targetRms / sqrt(mean(src(:).^2)));

    [loudRef, specRefRaw] = acousticLoudness(refPa, fs, 1, ...
        'Method', 'ISO 532-2', 'SoundField', 'free');
    specRef = squeeze(specRefRaw); specRef = specRef(:);
    fprintf('Reference loudness: %.3f sones\n', loudRef);

    fcAll = [25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 ...
             630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 ...
             8000 10000 12500 16000];
    fc     = fcAll(fcAll < fs/2 * 0.9);
    nBands = numel(fc);
    Q      = 4.318 * ones(nBands, 1);

    msreTarget = 0.0049;
    gMin       = -18;
    gMax       =  18;
    maxOuter   = 15;

    nERB    = numel(specRef);
    refRef  = max(specRef, max(specRef)*1e-3);
    weight  = 1 ./ refRef;
    validIdx = specRef > max(specRef)*1e-4;

    gains      = zeros(nBands, 1);
    bestGains  = gains;
    bestMSRE   = inf;

    for outer = 1:maxOuter
        eqBase = applyEQ(srcPa, fs, fc, gains, Q);
        [Lcur, specBaseRaw] = acousticLoudness(eqBase, fs, 1, ...
            'Method', 'ISO 532-2', 'SoundField', 'free');
        specBase = squeeze(specBaseRaw); specBase = specBase(:);

        rel  = (specRef(validIdx) - specBase(validIdx)) ./ specRef(validIdx);
        msre = mean(rel.^2);
        fprintf('Outer %d: MSRE = %.6f, L_eq = %.3f sones\n', ...
            outer, msre, Lcur);

        if msre < bestMSRE
            bestMSRE  = msre;
            bestGains = gains;
        end
        if msre <= msreTarget
            break;
        end

        delta = 2.0;
        M = zeros(nERB, nBands);
        for j = 1:nBands
            gtest        = gains;
            gtest(j)     = gtest(j) + delta;
            eqTest       = applyEQ(srcPa, fs, fc, gtest, Q);
            [~, sRaw]    = acousticLoudness(eqTest, fs, 1, ...
                'Method', 'ISO 532-2', 'SoundField', 'free');
            sTest        = squeeze(sRaw); sTest = sTest(:);
            M(:, j)      = (sTest - specBase) / delta;
        end

        Wm = M .* weight;
        Wb = (specRef - specBase) .* weight;

        lambda = 1e-3 * trace(Wm' * Wm) / nBands;
        dg     = (Wm' * Wm + lambda * eye(nBands)) \ (Wm' * Wb);

        maxStep = 4.0;
        if max(abs(dg)) > maxStep
            dg = dg * (maxStep / max(abs(dg)));
        end

        newGains = gains + dg;
        newGains = max(gMin, min(gMax, newGains));

        candidate = applyEQ(srcPa, fs, fc, newGains, Q);
        [~, sCRaw] = acousticLoudness(candidate, fs, 1, ...
            'Method', 'ISO 532-2', 'SoundField', 'free');
        sC = squeeze(sCRaw); sC = sC(:);
        relC = (specRef(validIdx) - sC(validIdx)) ./ specRef(validIdx);
        msreC = mean(relC.^2);

        scale = 1.0;
        while msreC > msre && scale > 0.1
            scale = scale * 0.5;
            tryGains = gains + dg * scale;
            tryGains = max(gMin, min(gMax, tryGains));
            candidate = applyEQ(srcPa, fs, fc, tryGains, Q);
            [~, sCRaw] = acousticLoudness(candidate, fs, 1, ...
                'Method', 'ISO 532-2', 'SoundField', 'free');
            sC = squeeze(sCRaw); sC = sC(:);
            relC = (specRef(validIdx) - sC(validIdx)) ./ specRef(validIdx);
            msreC = mean(relC.^2);
            newGains = tryGains;
        end

        gains = newGains;
    end

    if bestMSRE < msreTarget
        gains = bestGains;
    else
        eqFinal = applyEQ(srcPa, fs, fc, gains, Q);
        [~, sFRaw] = acousticLoudness(eqFinal, fs, 1, ...
            'Method', 'ISO 532-2', 'SoundField', 'free');
        sF = squeeze(sFRaw); sF = sF(:);
        relF = (specRef(validIdx) - sF(validIdx)) ./ specRef(validIdx);
        finalMSRE = mean(relF.^2);
        if finalMSRE > bestMSRE
            gains = bestGains;
            finalMSRE = bestMSRE;
        else
            bestMSRE = finalMSRE;
        end
    end
    fprintf('Final MSRE: %.6f\n', bestMSRE);

    fid = fopen(outFile, 'w');
    if fid < 0
        error('Cannot open %s for writing', outFile);
    end
    fprintf(fid, '# Frequency(Hz)\tGain(dB)\tQ\n');
    for i = 1:nBands
        fprintf(fid, '%.2f\t%.4f\t%.4f\n', fc(i), gains(i), Q(i));
    end
    fclose(fid);
    fprintf('EQ written to %s (%d bands)\n', outFile, nBands);

    N        = 65536;
    impulse  = zeros(N, 1);
    impulse(1) = 1;
    ir       = applyEQ(impulse, fs, fc, gains, Q);
    audiowrite(irFile, single(ir), fs, 'BitsPerSample', 32);
    fprintf('Minimum-phase IR written to %s (%d samples @ %d Hz)\n', ...
        irFile, N, fs);
end

function y = applyEQ(x, fs, fc, gains, Q)
    y = x;
    for i = 1:numel(fc)
        if abs(gains(i)) > 1e-6
            [b, a] = rbjPeakingEQ(fc(i), gains(i), Q(i), fs);
            y = filter(b, a, y);
        end
    end
end

function [b, a] = rbjPeakingEQ(f0, gainDb, Q, fs)
    A     = 10^(gainDb/40);
    w0    = 2*pi*f0/fs;
    alpha = sin(w0)/(2*Q);

    b0 =  1 + alpha*A;
    b1 = -2*cos(w0);
    b2 =  1 - alpha*A;
    a0 =  1 + alpha/A;
    a1 = -2*cos(w0);
    a2 =  1 - alpha/A;

    b = [b0, b1, b2] / a0;
    a = [1,  a1/a0, a2/a0];
end
