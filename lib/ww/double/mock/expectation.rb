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
          return true unless need_to_verify?(testing_thread)

          passed, message = _verify(request.dup)
          return true if passed

          testing_thread.raise MockError, message
        end

        private
        def need_to_verify?(testing_thread)
          @verifier && testing_thread
        end

        def _verify(request)
          case @verifier
          when Proc then @verifier.call(request.dup, request.params)
          when Hash then verify_by_hash(@verifier, request.params)
          end
        end

        def verify_by_hash(expectations, actuals)
          expectations.all? do |key, value|
            hash_expectation_match?(value, actuals[key.to_s])
          end
        end

        def hash_expectation_match?(expect, actual)
          case expect
          when String then expect == actual
          when Regexp then expect.match(actual)
          end
        end
      end
    end
  end
end

