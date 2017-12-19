module IqSMS
  class Response
    class SendSms < Response
      attr_reader :statuses

      def initialize(original_response)
        super

        @statuses = Array(@hash[:messages]).map do |hash_message|
          MessageStatus.new(
            status: hash_message[:status],
            client_id: hash_message[:clientId],
            smsc_id: hash_message[:smscId]
          )
        end
      end
    end
  end
end
