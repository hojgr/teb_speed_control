function KmhToMps(kmh)
    return kmh * (1/3.6)
end

function MpsToKmh(mps)
    return mps * 3.6
end

function MpsToMph(mps)
    return MpsToKmh(mps) * (1/1.609)
end