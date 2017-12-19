module Pxfinder
  module Photography
    class LensMake
      APPLE_REGEXP          = /\b(apple|iphone)\b/i
      CANON_REGEXP          = /^canon|\b(eos|usm|ts-e|ef|ef-s|ef-m)\b/i
      CARL_ZEISS_REGEXP     = /zeiss/i
      FUJIFILM_REGEXP       = /^fujifilm|\b(gfx?|x(f|c)|fujinon)\b/i
      HASSELBLAD_REGEXP     = /hasselblad/i
      KONICA_MINOLTA_REGEXP = /konica.minolta/i
      LEICA_REGEXP          = /^leica|\b((asph|noct(ilux|icron)|summ(ilux|icron|arit|aron)|elma(rit|r)))\b/i
      LENSBABY_REGEXP       = /^lensbaby|\b(velvet|sweet|trio|circula|twist|edge)\b/i
      NIKON_REGEXP          = /^nikon|\b(nikkor|vr)\b/i
      OLYMPUS_REGEXP        = /^olympus|\b(zuiko|m\.zuiko|ez)\b/i
      PANASONIC_REGEXP      = /^panasonic|\b(lumix|o\.i\.s\.|dmc-\w+|vario-elma(r|rit)[^-]|dg\ssummilux)\b/i
      PENTAX_REGEXP         = /^pentax|\b(smc|plm|fa|faj|da)\b/i
      RICOH_REGEXP          = /ricoh/i
      SAMSUNG_REGEXP        = /^samsung|\b(nx|d-xenon)\b/i
      SAMYANG_REGEXP        = /^samyang|\b(umc|ncs)\b/i
      SIGMA_REGEXP          = /^sigma|\b(os|hsm|ex|apo\sdg|dc\sasp|dn)\b/i
      SONY_REGEXP           = /^sony|\b(fe|dt|oss|ssm|sam|((ilce|ilca|dslr|dsc|slt|nex)-\w+))\b/i
      TAMRON_REGEXP         = /^tamron|\b(di|vc|usd)\b/i
      TOKINA_REGEXP         = /^tokina|\b(at-x|firin)\b/i
      VOIGTLANDER_REGEXP    = /^voigtlander|\b(nokton|heliar|skopar|apo-lanthar|ultron)\b/i

      class << self
        def name(model_name)
          return nil if model_name.nil?
          names = extract_names(model_name.strip)
          names.length == 1 ? names.first : nil
        end

        def extract_names(model_name)
          makes = []
          makes << APPLE if apple?(model_name)
          makes << CANON if canon?(model_name)
          makes << CARL_ZEISS if carl_zeiss?(model_name)
          makes << FUJIFILM if fujifilm?(model_name)
          makes << HASSELBLAD if hasselblad?(model_name)
          makes << KONICA_MINOLTA if konica_minolta?(model_name)
          makes << LEICA if leica?(model_name)
          makes << LENSBABY if lensbaby?(model_name)
          makes << NIKON if nikon?(model_name)
          makes << OLYMPUS if olympus?(model_name)
          makes << PANASONIC if panasonic?(model_name)
          makes << PENTAX if pentax?(model_name)
          makes << RICOH if ricoh?(model_name)
          makes << SAMSUNG if samsung?(model_name)
          makes << SAMYANG if samyang?(model_name)
          makes << SIGMA if sigma?(model_name)
          makes << SONY if sony?(model_name)
          makes << TAMRON if tamron?(model_name)
          makes << TOKINA if tokina?(model_name)
          makes << VOIGTLANDER if voigtlander?(model_name)
          makes
        end

        def third_party_lens?(lens, for_)
          case for_
          when CANON
            sigma?(lens) || tamron?(lens) || tokina?(lens) || lensbaby?(lens) ||
              samyang?(lens) || voigtlander?(lens)
          when NIKON
            sigma?(lens) || tamron?(lens) || tokina?(lens) || lensbaby?(lens) ||
              samyang?(lens) || voigtlander?(lens)
          when SONY
            sigma?(lens) || tamron?(lens) || tokina?(lens) || lensbaby?(lens) ||
              samyang?(lens) || voigtlander?(lens) || carl_zeiss?(lens) ||
              konica_minolta?(lens)
          when LEICA
            panasonic?(lens) || voigtlander?(lens) || carl_zeiss?(lens)
          when FUJIFILM
            lensbaby?(lens) || samyang?(lens) || carl_zeiss?(lens)
          when OLYMPUS
            panasonic?(lens) || sigma?(lens) || lensbaby?(lens) ||
              samyang?(lens) || voigtlander?(lens)
          when PENTAX
            sigma?(lens) || tamron?(lens) || lensbaby?(lens) ||
              samyang?(lens) || voigtlander?(lens)
          when SAMSUNG
            samyang?(lens) || lensbaby?(lens)
          else
            false
          end
        end

        def apple?(model_name)
          APPLE_REGEXP.match?(model_name)
        end

        def canon?(model_name)
          CANON_REGEXP.match?(model_name) &&
            !third_party_lens?(model_name, CANON)
        end

        def carl_zeiss?(model_name)
          CARL_ZEISS_REGEXP.match?(model_name)
        end

        def fujifilm?(model_name)
          FUJIFILM_REGEXP.match?(model_name) &&
            !third_party_lens?(model_name, FUJIFILM)
        end

        def hasselblad?(model_name)
          HASSELBLAD_REGEXP.match?(model_name)
        end

        def konica_minolta?(model_name)
          KONICA_MINOLTA_REGEXP.match?(model_name)
        end

        def leica?(model_name)
          LEICA_REGEXP.match?(model_name) &&
            !third_party_lens?(model_name, LEICA)
        end

        def lensbaby?(model_name)
          LENSBABY_REGEXP.match?(model_name)
        end

        def nikon?(model_name)
          NIKON_REGEXP.match?(model_name) &&
            !third_party_lens?(model_name, NIKON)
        end

        def olympus?(model_name)
          OLYMPUS_REGEXP.match?(model_name) &&
            !third_party_lens?(model_name, OLYMPUS)
        end

        def panasonic?(model_name)
          PANASONIC_REGEXP.match?(model_name)
        end

        def pentax?(model_name)
          PENTAX_REGEXP.match?(model_name) &&
            !third_party_lens?(model_name, PENTAX)
        end

        def ricoh?(model_name)
          RICOH_REGEXP.match?(model_name)
        end

        def samsung?(model_name)
          SAMSUNG_REGEXP.match?(model_name) &&
            !third_party_lens?(model_name, SAMSUNG)
        end

        def samyang?(model_name)
          SAMYANG_REGEXP.match?(model_name)
        end

        def sigma?(model_name)
          SIGMA_REGEXP.match?(model_name)
        end

        def sony?(model_name)
          SONY_REGEXP.match?(model_name) && !third_party_lens?(model_name, SONY)
        end

        def tamron?(model_name)
          TAMRON_REGEXP.match?(model_name)
        end

        def tokina?(model_name)
          TOKINA_REGEXP.match?(model_name)
        end

        def voigtlander?(model_name)
          VOIGTLANDER_REGEXP.match?(model_name)
        end
      end
    end
  end
end
