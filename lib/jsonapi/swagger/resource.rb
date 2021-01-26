require 'forwardable'
module Jsonapi
  module Swagger
    class Resource
      def self.with(model_class_name)
        if Object.const_defined?("#{model_class_name}Resource")
          @resource_class = "#{model_class_name}Resource".safe_constantize
          unless @resource_class < JSONAPI::Resource
            raise Jsonapi::Swagger::Error, "#{@resource_class.class} is not Subclass of JSONAPI::Resource!"
          end
          require 'jsonapi/swagger/resources/jsonapi_resource'
          return Jsonapi::Swagger::JsonapiResource.new(@resource_class)
        elsif Object.const_defined?("Serializable#{model_class_name}")
          @resource_class = "Serializable#{model_class_name}".safe_constantize
          unless @resource_class < JSONAPI::Serializable::Resource
            raise Jsonapi::Swagger::Error, "#{@resource_class.class} is not Subclass of JSONAPI::Serializable::Resource!"
          end
          require 'jsonapi/swagger/resources/serializable_resource'
          return Jsonapi::Swagger::SerializableResource.new(@resource_class)
        elsif Object.const_defined?("#{model_class_name}Serializer")
          @resource_class = "#{model_class_name}Serializer".safe_constantize
          case @resource_class
          when JSONAPI::Serializer
            require 'jsonapi/swagger/resources/jsonapi_serializer_resource'
            return Jsonapi::Swagger::JsonapiSerializerResource.new(@resource_class)
          when FastJsonapi::ObjectSerializer
            require 'jsonapi/swagger/resources/fast_jsonapi_resource'
            return Jsonapi::Swagger::FastJsonapiResource.new(@resource_class)
          end
          raise Jsonapi::Swagger::Error, "#{@resource_class.class} is not Subclass of FastJsonapi::ObjectSerializer! or JSONAPI::Serializer"
        else
          raise Jsonapi::Swagger::Error, "#{model_class_name} not support!"
        end
      end
    end
  end
end
