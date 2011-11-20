module ObscurifyAttribute
  module Validations
    def self.included(base)
      base.__send__(:extend, ::ObscurifyAttribute::Validations::ClassMethods)
      base.__send__(:include, ::ObscurifyAttribute::Validations::InstanceMethods)
      base.alias_method_chain(:errors, :obscured)
    end

    module ClassMethods
      attr_reader :sensitive_attrs

      def obscurify(*args)
        options = args.extract_options!
        args.reject!(&:blank?)
        options.symbolize_keys!
        options.assert_valid_keys(:message)
        to_name = args.pop
        raise(ArgumentError, "Should specify a second (target) attribute name") if args.empty?
        args.inject(sensitive_attrs) do |h, attr|
          h[attr] = {:to => to_name}.merge(options)
          h
        end
      end

      def sensitive_attrs
        @sensitive_attrs ||= {}
      end
    end

    module InstanceMethods
      def errors_with_obscured
        errors_without_obscured.tap do |result|
          if !self.class.sensitive_attrs.empty? && !(result.keys & self.class.sensitive_attrs.keys).empty?
            self.class.sensitive_attrs.each do |old_name, options|
              new_name = options[:to]
              messages = options.has_key?(:message) ? Array.wrap(options[:message]) : result[old_name]
              messages.each { |error| result.add(new_name, error) }
              result[old_name].clear
              result[new_name].uniq!
            end
          end
        end
      end
    end
  end
end
