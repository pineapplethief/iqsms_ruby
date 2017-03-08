module IqSMS
  class Response
    class SendSms < Response
      attr_reader :messages

      def initialize(original_response, messages)
        super(original_response)

        @messages = messages
        hash_messages = Array(@hash[:messages])
        @messages.each do |message|
          message_status_hash = hash_messages.find do |hash_message|
            hash_message[:clientId] == message.client_id
          end

          if message_status_hash.present?
            message.update!(message_status_hash)
          end
        end
      end
    end
  end
end
