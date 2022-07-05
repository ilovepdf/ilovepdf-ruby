module Ilovepdf
  module Signature
    module FileElement
      def self.included(base)
        base.send(:include,InstanceMethods)
      end

      module InstanceMethods
        attr_reader :file,:position,:pages,:size,:info,:type,:content
        def initialize(file)
          raise ::Ilovepdf::Errors::ArgumentError.new("Only Ilovepdf::File type of object is allowed") unless file.class.name == "Ilovepdf::File"
          @file = file
          @position = "0 0"
          @pages = "1"
          @size = 40
        end

        def set_position(x: 0,y: 0)
          raise ::Ilovepdf::Errors::ArgumentError.new("x must be an integer or float") unless x.is_a?(Integer) || x.is_a?(Float)
          raise ::Ilovepdf::Errors::ArgumentError.new("y must be an integer or float") unless y.is_a?(Integer) || y.is_a?(Float)
          @position = "#{x.abs} #{-y.abs}"
          position
        end

        def pages=(value)
          raise ::Ilovepdf::Errors::ArgumentError.new("value must be string type") unless value.is_a?(String)
          @pages = value
        end

        def size=(value)
          raise ::Ilovepdf::Errors::ArgumentError.new("value must be Integer type") unless value.is_a?(Integer)
          @size = value
        end

        def to_h
          {
            position: position,
            pages: pages,
            size: size,
            info: info,
            type: type,
            content: content
          }
        end

        def info
          @info && @info.to_json
        end

        protected

        def set_info_parameter(parameter_name,value)
          @info ||= {}
          @info[parameter_name] = value
          @info
        end
      end
    end
  end
end
