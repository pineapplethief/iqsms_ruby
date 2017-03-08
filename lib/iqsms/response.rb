module IqSMS
  class Response
    attr_reader :original_response, :hash, :status

    def initialize(original_response)
      @original_response = original_response
      @hash = if @original_response.body.present?
        JSON.parse(@original_response.body)
      else
        {}
      end
      @hash = IqSMS::Utils.deeply_with_indifferent_access(@hash)

      if @hash[:status].blank?
        raise IqSMS::NoResponseStatusError, 'В сообщении нет статуса'.freeze
      end
      @status = RequestStatus.new(@hash[:status], @hash[:description])
    end
  end
end
