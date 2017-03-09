# Iqsms

This is Ruby gem to consume https://iqsms.ru JSON API for sending sms messages.

Some features:

* Clean, simple code.
* Uses fast and cool [http.rb](https://github.com/httprb/http) gem under the hood to do requests.
* Leverages persistent HTTP connections and connection_pool for maximum performance.
* Wraps results in PORO's instead of just spitting out hashes and arrays.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'iqsms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install iqsms

## Usage

First you need to instantiate instance of API client:

```ruby
client = IqSMS::Client.new(login: your_login, password: your_password)
```

You then call API endpoints by invoking client instance methods `send_sms`, `balance`, `status`, `status_queue`, `senders`. Raw HTTP response is then wrapped into endpoint-specific respones object with convenient getters and predicates.

### Response class

All API response objects have some common methods:

* `original_response` - returns http.rb response object. See [http.rb](https://github.com/httprb/http) for more info.
* `hash` - response body parsed into JSON for you.
* `status` - instance of `IqSMS::RequestStatus` class.

### RequestStatus class

You have one in each response. Instances have some useful predicate methods to query if request was successful or not.

* `status` - status string as returned from service, see [API reference](https://iqsms.ru/api/api_json/) for more info.
* `description` - extra info about error
* `auth_failed?` - wrong login/password
* `accepted?` - all ok
* `rejected?` - some error happened

### Message class

Represents SMS message either to be sent to service or returned from it(as result of original `send_sms` action or querying for message status later).

List of methods is pretty self-explanatory, see API reference:

```ruby
  :client_id,
  :smsc_id,
  :phone,
  :text,
  :wap_url,
  :sender,
  :flash,
  :status
```

You may want to store messages you send in relational database or almost-persistent storage like Redis if you want to check for message statuses, since knowledge of client_id (your database PK or UUID or whatever) or smsc_id(assigned to each message by service) is required.


### MessageStatus class

Represents status for an sms message. `delivered?` is pretty self-explanatory, `status_text` returns useful message about state of sms delivery in russian.

## Examples

### Send SMS

This endpoint uses duck-typing for messages, object(s) passed in just have to respond to specific methods, so you can use your ActiveRecord models directly.
`phone`, `text`, `client_id` and `sender` are mandatory, others are optional.
Phones are sent as-is, so any phone number normalization must be done in your app before-hand (see f.e. [phony-rails gem](https://github.com/joost/phony_rails))

```ruby
message = YourSMSModel.create(phone: '+11234567899', text: 'hey there', sender: 'one of your senders', client_id: '1')
send_sms_response = client.send_sms(message)
if send_sms_response.status.accepted?
  # do your logic to update message smsc_id and status, which are in send_sms_response.statuses
end
```

### Check SMS status

```ruby
messages = YourSMSModel.where(phone: 'bla')
status_response = client.status(messages)
if status_response.status.accepted?
  status_response.statuses # Same as send_sms endpoint
end
```

### Check SMS status via named queue

Either instantiate client with status_queue_name option,

```ruby
  client = IqSMS::Client.new(login: your_login, password: your_password, status_queue_name: 'myQueue')
```

Or just set one on instance you already have by using writer:

```ruby
  client.status_queue_name = 'myQueue'
```

Then call endpoint as usual:

```ruby
  status_queue_limit = 10 # default is 5
  status_queue_response = client.status_queue(status_queue_limit)
  if status_queue_response.status.accepted?
    status_queue_response.statuses # same as send_sms and status end-points
  end
```

### Get your senders

```ruby
senders_response = client.senders

senders_response.senders # returns array of strings - names of the senders
```

### Check Balance

```ruby
balance_response = client.balance

balance_response.balance # => 2.5
balance_response.currency # => 'RUB'
balance_response.credit # have no idea what the heck is that
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/iqsms_ruby.

