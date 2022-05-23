module Ilovepdf
  module Refinements
    module Crush
      refine Object do
        def crush
          self
        end
      end
      refine Array do
        def crush
          r = map(&:crush).compact

          r.empty? ? nil : r
        end
      end

      refine Hash do
        def crush
          r = each_with_object({ }) do |(k, v), h|
            if (_v = v.crush)
              h[k] = _v
            end
          end

          r.empty? ? nil : r
        end
      end
    end
  end
end
