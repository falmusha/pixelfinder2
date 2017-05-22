module Pxfinder
  module Models
    class Manufacturer < Sequel::Model
      one_to_many :lenses, class: Lens
      one_to_many :cameras

      APPLE          = "Apple".freeze
      CANON          = "Canon".freeze
      CARL_ZEISS     = "Carl Zeiss".freeze
      FUJIFILM       = "Fujifilm".freeze
      HASSELBLAD     = "Hasselblad".freeze
      KONICA_MINOLTA = "Konica Minolta".freeze
      LEICA          = "Leica".freeze
      LENSBABY       = "Lensbaby".freeze
      NIKON          = "Nikon".freeze
      OLYMPUS        = "Olympus".freeze
      PANASONIC      = "Panasonic".freeze
      PENTAX         = "Pentax".freeze
      RICOH          = "Ricoh".freeze
      SAMSUNG        = "Samsung".freeze
      SAMYANG        = "Samyang".freeze
      SIGMA          = "Sigma".freeze
      SONY           = "Sony".freeze
      TAMRON         = "Tamron".freeze
      TOKINA         = "Tokina".freeze
      VOIGTLANDER    = "Voigtlander".freeze

      APPLE_REGEXP          = /\b(apple|iphone)\b/i
      CANON_REGEXP          = /\b(canon|eos|usm|ts-e|ef|ef-s|ef-m)\b/i
      CARL_ZEISS_REGEXP     = /\bzeiss\b/i
      FUJIFILM_REGEXP       = /\b(fujifilm|xc|xf|x-\w+|gfx?|fujinon)\b/i
      HASSELBLAD_REGEXP     = /\bhasselblad\b/i
      KONICA_MINOLTA_REGEXP = /\bkonica\s+minolta\b/i
      LEICA_REGEXP          =
        /\b(leica|asph|noct(ilux|icron)|summ(ilux|icron|arit|aron)|elma(rit|r))\b/i
      LENSBABY_REGEXP       =
        /\b(lensbaby|velvet|sweet|trio|circula|twist)\b/i
      NIKON_REGEXP          = /\b(nikon|nikkor|vr)\b/i
      OLYMPUS_REGEXP        = /\b(olympus|zuiko|m\.zuiko)\b/i
      PANASONIC_REGEXP      = /\b(lumix|dmc-\w+|panasonic|vario-elma(r|rit)[^-])\b/i
      PENTAX_REGEXP         = /\b(pentax|smc|plm|fa|faj|da)\b/i
      RICOH_REGEXP          = /\bricoh\b/i
      SAMSUNG_REGEXP        = /\b(samsung|nx-m|nx(\d+m?)?|sm-\w+|d-xenon)\b/i
      SAMYANG_REGEXP        = /\b(samyang|umc|ncs)\b/i
      SIGMA_REGEXP          = /\b(sigma|os|hsm|ex)\b/i
      SONY_REGEXP           =
        /\b(sony|fe|cybershot|cyber-shot|dt|oss|ssm|sam|((ilce|ilca|dslr|dsc|slt|nex)-\w+))\b/i
      TAMRON_REGEXP         = /\b(tamron|di|vc|usd)\b/i
      TOKINA_REGEXP         = /\b(tokina|at-x)\b/i
      VOIGTLANDER_REGEXP    = /\b(voigtlander|nokton|heliar|skopar|apo-lanthar|ultron)\b/i

      def self.find_or_create_by(model_name:, make: nil)
        $log.info("Manufacturer: find_or_create_by make: #{make}, model: #{model_name}")

        extracted = extract_make_name(make) || extract_make_name(model_name) 
        $log.info("Manufacturer: extracted #{extracted || 'nil'}")

        return find_or_create(name: extracted) if extracted

        if make.nil?
          return nil
        else
          return find_or_create(name: make)
        end
      end

      def self.extract_make_name(model_name)
        return nil if model_name.nil?

        makes = extract_make_names_by(model_name)

        if makes.length == 1
          return makes[0]
        elsif makes.length == 2 && makes.sort.eql?([PENTAX, RICOH])
          return PENTAX
        else
          nil
        end
      end

      def self.known?(manufacturer)
        all = [APPLE, CANON, CARL_ZEISS, FUJIFILM, HASSELBLAD, KONICA_MINOLTA,
               LEICA, LENSBABY, NIKON, OLYMPUS, PANASONIC, PENTAX, RICOH,
               SAMSUNG, SAMYANG, SIGMA, SONY, TAMRON, TOKINA, VOIGTLANDER]

        all.include?(manufacturer.capitalize)
      end

      private

      def self.extract_make_names_by(model_name)
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


      def self.third_party_lens?(m_name, for_)
        case for_
        when CANON
          return sigma?(m_name) || tamron?(m_name) || tokina?(m_name) ||
            lensbaby?(m_name) || samyang?(m_name) || voigtlander?(m_name)
        when NIKON 
          return sigma?(m_name) || tamron?(m_name) || tokina?(m_name) ||
            lensbaby?(m_name) || samyang?(m_name) || voigtlander?(m_name)
        when SONY 
          return sigma?(m_name) || tamron?(m_name) || tokina?(m_name) ||
            lensbaby?(m_name) || samyang?(m_name) || voigtlander?(m_name) ||
            carl_zeiss?(m_name) || konica_minolta?(m_name)
        when LEICA
          return panasonic?(m_name) || voigtlander?(m_name) || carl_zeiss?(m_name)
        when FUJIFILM
          return lensbaby?(m_name) || samyang?(m_name) || carl_zeiss?(m_name)
        when OLYMPUS
          return panasonic?(m_name) || sigma?(m_name) || lensbaby?(m_name) ||
            samyang?(m_name) || voigtlander?(m_name)
        when PENTAX 
          return sigma?(m_name) || tamron?(m_name) || lensbaby?(m_name) ||
            samyang?(m_name) || voigtlander?(m_name)
        when SAMSUNG 
          return samyang?(m_name) || lensbaby?(m_name)
        else
          false
        end
      end

      def self.apple?(model_name)
        APPLE_REGEXP.match?(model_name)
      end

      def self.canon?(model_name)
        CANON_REGEXP.match?(model_name) && !third_party_lens?(model_name, CANON) 
      end

      def self.carl_zeiss?(model_name)
        CARL_ZEISS_REGEXP.match?(model_name)
      end

      def self.fujifilm?(model_name)
        FUJIFILM_REGEXP.match?(model_name) && !third_party_lens?(model_name, FUJIFILM) 
      end

      def self.hasselblad?(model_name)
        HASSELBLAD_REGEXP.match?(model_name)
      end

      def self.konica_minolta?(model_name)
        KONICA_MINOLTA_REGEXP.match?(model_name)
      end

      def self.leica?(model_name)
        LEICA_REGEXP.match?(model_name) && !third_party_lens?(model_name, LEICA) 
      end

      def self.lensbaby?(model_name)
        LENSBABY_REGEXP.match?(model_name)
      end

      def self.nikon?(model_name)
        NIKON_REGEXP.match?(model_name) && !third_party_lens?(model_name, NIKON) 
      end

      def self.olympus?(model_name)
        OLYMPUS_REGEXP.match?(model_name) && !third_party_lens?(model_name, OLYMPUS) 
      end

      def self.panasonic?(model_name)
        PANASONIC_REGEXP.match?(model_name)
      end

      def self.pentax?(model_name)
        PENTAX_REGEXP.match?(model_name) && !third_party_lens?(model_name, PENTAX) 
      end

      def self.ricoh?(model_name)
        RICOH_REGEXP.match?(model_name)
      end

      def self.samsung?(model_name)
        SAMSUNG_REGEXP.match?(model_name) && !third_party_lens?(model_name, SAMSUNG) 
      end

      def self.samyang?(model_name)
        SAMYANG_REGEXP.match?(model_name)
      end

      def self.sigma?(model_name)
        SIGMA_REGEXP.match?(model_name) || model_name.downcase.include?("apo dg") ||
          model_name.downcase.include?("dc asp")
      end

      def self.sony?(model_name)
        SONY_REGEXP.match?(model_name) && !third_party_lens?(model_name, SONY) 
      end

      def self.tamron?(model_name)
        TAMRON_REGEXP.match?(model_name)
      end

      def self.tokina?(model_name)
        TOKINA_REGEXP.match?(model_name)
      end

      def self.voigtlander?(model_name)
        VOIGTLANDER_REGEXP.match?(model_name)
      end
    end
  end
end
