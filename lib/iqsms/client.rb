module IqSMS
  class Client
    attr_reader :connection
    attr_writer :status_queue_name

    def initialize(login:, password:, **options)
      with_value_must_be_present!(login) { @login = login }
      with_value_must_be_present!(password) { @password = password }

      @options = options.reverse_merge(default_options)

      check_status_queue_name!
    end

    def send_sms(messages)
      messages = Array(messages)
      check_messages_size!(messages)

      options = {
        statusQueueName: status_queue_name,
        messages: messages.map { |message| Message.message_to_hash(message) }
      }

      request(:post, 'send'.freeze, options) do |response|
        Response::SendSms.new(response, messages)
      end
    end

    def status(messages)
      messages = Array(messages)
      check_messages_size!(messages)

      options = {
        statusQueueName: status_queue_name,
        messages: messages.map { |message| Message.message_to_hash_for_status(message) }
      }

      request(:post, 'status'.freeze, options) do |response|
        Response::Status.new(response, messages)
      end
    end

    def balance
      request(:post, 'messages/v2/balance'.freeze) do |response|
        Response::Balance.new(response)
      end
    end

    def senders
      request(:post, 'senders'.freeze) do |response|
        Response::Senders.new(response)
      end
    end

    def ping?
      request(:post, 'messages/v2/balance'.freeze) do |response|
        response.status.success?
      end
    end

    def status_queue_name
      @status_queue_name ||= @options[:status_queue_name]
    end

    private

    def request(method, path, **params)
      params = params.nil? ? {} : params.dup

      params = params.reverse_merge!(authentication_params)

      @connection ||= HTTP.persistent(base_url)
                          .headers(accept: 'application/json'.freeze)

      begin
        retries ||= 0
        response = @connection.send(method, full_url(path), json: params)
      rescue HTTP::StateError
        retries += 1
        retry if retries < 3
      end

      block_given? ? yield(response) : response
    ensure
      response.flush if response.present?
      @connection.close if @connection.present?
    end

    def with_value_must_be_present!(value)
      raise ArgumentError, "can't be blank".freeze if value.blank?
      yield
    end

    def check_status_queue_name!
      queue_name = @options[:status_queue_name]
      return unless queue_name.present?

      unless queue_name.is_a?(String)
        raise ArgumentError, 'status_queue_name must be a string'.freeze
      end
      if queue_name.size < 3 || queue_name.size > 16
        raise ArgumentError, 'status_queue_name length must be in between 3 and 16 chars'.freeze
      end
      unless queue_name =~ /[a-zA-Z0-9]+/
        raise ArgumentError, 'status_queue_name must be alphanumeric only'.freeze
      end
    end

    def check_messages_size!(messages)
      return if messages.size <= 200

      raise MaximumMessagesLimitExceededError, 'API has cap of 200 messages per one request'
    end

    def default_options
      {
        base_url: 'http://json.gate.iqsms.ru'.freeze
      }
    end

    def authentication_params
      {
        login: @login,
        password: @password
      }
    end

    def base_url
      @options[:base_url]
    end

    def base_uri
      @base_uri ||= Addressable::URI.parse(base_url)
      @base_uri
    end

    def full_url(path)
      uri = base_uri
      uri.path = path
      uri.to_s
    end
  end
end
