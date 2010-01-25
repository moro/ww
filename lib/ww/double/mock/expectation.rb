module Ww
  module Double
    module Mock
      class Expectation
        def executed?; !!@executed; end
        attr_reader :identifier

        def initialize(verb, path, verifier = nil)
          @identifier = "_mock_ #{verb.to_s.upcase} #{path}"
          @verifier = verifier
        end

        def verify(request, testing_thread = nil)
          @executed = true
          return @executed unless @verifier && testing_thread # no need to verify
          return @executed if @verifier.call(r = request.dup, r.params)

          testing_thread.raise MockError
        end
      end
    end
  end
end

