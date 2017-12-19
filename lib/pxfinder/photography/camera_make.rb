module Pxfinder
  module Photography
    class CameraMake
      APPLE_REGEXP          = /\b(apple|iphone)\b/i
      CANON_REGEXP          = /\b(canon|eos|power-?shot)\b/i
      FUJIFILM_REGEXP       = /\b(fujifilm|finepix|gfx|x-\w+|x\d+)\b/i
      HASSELBLAD_REGEXP     = /\b(hasselblad)\b/i
      KONICA_MINOLTA_REGEXP = /\b(konica\s+minolta)\b/i
      LEICA_REGEXP          = /\b(leica)\b/i
      NIKON_REGEXP          = /\b(nikon)\b/i
      OLYMPUS_REGEXP        = /\b(olympus|om-d|pen|e-\w+)\b/i
      PANASONIC_REGEXP      = /\b(panasonic|lumix|dmc-\w+)\b/i
      PENTAX_REGEXP         = /\b(pentax|k-\w+|k\d+d|\d+z|optio)\b/i
      RICOH_REGEXP          = /\b(ricoh)\b/i
      SAMSUNG_REGEXP        = /\b(samsung|nx-m|nx(\d+m?)?|sm-\w+|d-xenon)\b/i
      SONY_REGEXP           = /\b(sony|cyber-?shot|(ilce|ilca|dslr|dsc|slt|nex)-\w+)\b/i

      class << self
        def name(model_name)
          names = extract_names(model_name)
          puts names
          names.length > 1 ? nil : names.first
        end

        def apple?(model_name)
          APPLE_REGEXP.match?(model_name)
        end

        def canon?(model_name)
          CANON_REGEXP.match?(model_name)
        end

        def fujifilm?(model_name)
          FUJIFILM_REGEXP.match?(model_name)
        end

        def hasselblad?(model_name)
          HASSELBLAD_REGEXP.match?(model_name)
        end

        def konica_minolta?(model_name)
          KONICA_MINOLTA_REGEXP.match?(model_name)
        end

        def leica?(model_name)
          LEICA_REGEXP.match?(model_name)
        end

        def nikon?(model_name)
          NIKON_REGEXP.match?(model_name)
        end

        def olympus?(model_name)
          OLYMPUS_REGEXP.match?(model_name)
        end

        def panasonic?(model_name)
          PANASONIC_REGEXP.match?(model_name)
        end

        def pentax?(model_name)
          PENTAX_REGEXP.match?(model_name)
        end

        def ricoh?(model_name)
          RICOH_REGEXP.match?(model_name)
        end

        def samsung?(model_name)
          SAMSUNG_REGEXP.match?(model_name)
        end

        def sony?(model_name)
          SONY_REGEXP.match?(model_name)
        end

        def extract_names(model_name)
          makes = []
          makes << APPLE if apple?(model_name)
          makes << CANON if canon?(model_name)
          makes << FUJIFILM if fujifilm?(model_name)
          makes << HASSELBLAD if hasselblad?(model_name)
          makes << KONICA_MINOLTA if konica_minolta?(model_name)
          makes << LEICA if leica?(model_name)
          makes << NIKON if nikon?(model_name)
          makes << OLYMPUS if olympus?(model_name)
          makes << PANASONIC if panasonic?(model_name)
          makes << PENTAX if pentax?(model_name)
          makes << RICOH if ricoh?(model_name)
          makes << SAMSUNG if samsung?(model_name)
          makes << SONY if sony?(model_name)
          makes
        end
      end
    end
  end
end
