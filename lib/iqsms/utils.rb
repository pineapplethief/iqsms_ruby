module IqSMS
  module Utils
    extend self

    def deeply_with_indifferent_access(hash)
      hash = ActiveSupport::HashWithIndifferentAccess.new(hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          hash[key] = deeply_with_indifferent_access(value)
        elsif value.is_a?(Array)
          hash[key] = value.map do |element|
            if element.is_a?(Hash)
              deeply_with_indifferent_access(element)
            else
              element
            end
          end
        end
      end

      hash
    end
  end
end
