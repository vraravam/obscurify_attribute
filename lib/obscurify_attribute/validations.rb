require 'active_model'
require 'active_model/validations'

# TODO: I dont like this reopening the module - see if we can inject a new module into the original one
module ActiveModel
  module Validations
    def self.included(base)
      base.__send__(:extend, ObscurifyClassMethods)
    end

    module ObscurifyClassMethods
      attr_accessor :sensitive_attrs

      def obscurify(*args)
        options = args.extract_options!
        args.reject!(&:blank?)
        options.symbolize_keys!
        options.assert_valid_keys(:message)
        to_name = args.pop
        raise(ArgumentError, "Should specify a second (target) attribute name") if args.empty?
        @sensitive_attrs ||= {}
        args.inject(@sensitive_attrs) do |h, attr|
          h[attr] = {:to => to_name}.merge(options)
          h
        end
      end
    end

    def errors_with_obscured
      errors_without_obscured.tap do |result|
        if !(result.keys & self.class.sensitive_attrs.keys).empty?
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

    alias_method_chain :errors, :obscured
  end
end
