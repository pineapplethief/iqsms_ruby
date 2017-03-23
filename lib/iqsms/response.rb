module IqSMS
  class Response
    attr_reader :original_response, :hash, :status

    def initialize(original_response)
      @original_response = original_response
      @hash = if @original_response.body.present?
        puts "@original_response.body = #{@original_response.body.inspect}"
        puts "@original_response.body = #{@original_response.body.to_s}"
        JSON.parse(@original_response.body.to_s)
      else
        {}
      end
      @hash = IqSMS::Utils.deeply_with_indifferent_access(@hash)

      @status = RequestStatus.new(@hash[:status], @hash[:description])
    end
  end
end
