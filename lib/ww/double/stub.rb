module Ww
  module Double
    module Stub
      def stub(verb, path, &block)
        v = verb.to_s.upcase

        synchronize do
          send(verb, path, &block)
          routes[v].unshift(routes[v].pop)
        end
      end
    end
  end
end
