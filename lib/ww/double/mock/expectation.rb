module Ww
  module Double
    module Mock
      class Expectation
        def executed!; @e = true; end
        def executed?; !!@e; end
        attr_reader :identifier

        def initialize(verb, path, verifier = nil)
          @identifier = "_mock_ #{verb.to_s.upcase} #{path}"
          @verifier = verifier
        end

        def verify(request, testing_thread = nil)
          return true unless @verifier && testing_thread # no need to verify
          return true if @verifier.call(r = request.dup, r.params)

          testing_thread.raise MockError
        end
      end
    end
  end
end

