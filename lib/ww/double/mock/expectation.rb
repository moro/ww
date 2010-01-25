module Ww
  module Double
    module Mock
      class Expectation
        def executed?; !!@executed; end
        attr_reader :identifier

        def initialize(verb, path, verifier = nil, &verify_block)
          if verifier && block_given?
            raise ArgumentError, "only on of either argument or block can specified."
          end

          @identifier = "_mock_ #{verb.to_s.upcase} #{path}"
          @verifier = block_given? ? verify_block : verifier
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
          when Hash
            params = @verifier.dup
            header = params.delete(:header) || {}

            verify_by_hash(params, request.params) &&
            verify_by_hash(header, request.env, true)
          end
        end

        def verify_by_hash(expectations, actuals, upcase_key = false)
          expectations.all? do |key, value|
            key = key.to_s
            key = key.upcase if upcase_key
            hash_expectation_match?(value, actuals[key])
          end
        end

        def hash_expectation_match?(expect, actual)
          case expect
          when String  then expect == actual
          when Regexp  then expect.match(actual)
          when Integer then expect == actual.to_i
          when Class   then klass_match?(expect, actual)
          else false
          end
        end

        def klass_match?(e, actual)
          if e == Integer
            Integer(actual) rescue false
          elsif e == Float
            Float(actual) rescue false
          end
        end
      end
    end
  end
end

