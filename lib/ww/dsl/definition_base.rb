module Ww
  module Dsl
    class DefinitionBase
      attr_reader :servlet
      def initialize(servlet)
        @servlet = servlet
      end

      %w[get post put delete].each do |verb|
        class_eval <<-RUBY, __FILE__, __LINE__
          def #{verb}(path, options = {}, &action)
            define_action(:#{verb}, path, options, &action)
          end
        RUBY
      end

      private
      def define_action(verb, path, options = {}, &action)
        raise NotImplementedError, "override me"
      end

      def unbound_action(klass, mname, block)
        klass.module_eval do
          begin
            define_method(mname, &block)
            instance_method(mname)
          ensure
            remove_method(mname) if instance_methods.include?(mname)
          end
        end
      end
    end
  end
end
