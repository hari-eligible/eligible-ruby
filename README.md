# Eligible

[![Circle CI](https://circleci.com/gh/eligible/eligible-ruby.svg?style=svg)](https://circleci.com/gh/eligible/eligible-ruby)

Ruby bindings for the [Eligible API](https://eligible.com/rest)

## Installation

Add this line to your application's Gemfile:

    gem 'eligible'

And then execute:

    $ bundle

Or install it yourself with:

    $ gem install eligible

## Usage

### Setup
```ruby
require 'eligible'
Eligible.api_key = 'YOUR_KEY'
```

### Test
```ruby
Eligible.test = true
```

### Parameters overwrite

On each api call, you can overwrite the api key or the test parameter:

```ruby
Eligible::Demographic.get({:api_key => 'NEW_KEY', :test => false})
```

### Response Format

By default, all responses are in JSON, but you can request raw
access to X12 by adding is as a parameter on the api call:

```ruby
Eligible::Demographic.get({:format => "x12"})
```

# Important notes

## Payer List for Eligibility

the parameter `payer_id`, required for most of the api calls, is
provided by Eligible from its website, in xml and json format, which
you can embed into your applications.

[https://eligible.com/resources/information-sources.xml](https://eligible.com/resources/information-sources.xml)  
[https://eligible.com/resources/information-sources.json](https://eligible.com/resources/information-sources.json)

## Payer List for Claims

the parameter `payer_id`, required for claims, is provided by Eligible
from its website, in xml and json format, which you can embed into
your applications.

[https://eligible.com/resources/claims-payer.xml](https://eligible.com/resources/claims-payer.xml)  
[https://eligible.com/resources/claims-payer.json](https://eligible.com/resources/claims-payer.json)

## Service Type Codes

the parameter `service_type`, required on the api calls, is provided
by Eligible from its website, in xml and json format, which you can
embed into your applications.

[https://eligible.com/resources/service-codes.xml](https://eligible.com/resources/service-codes.xml)  
[https://eligible.com/resources/service-codes.json](ttps://eligible.com/resources/service-codes.json)

## Place of Service

[https://eligible.com/resources/place_of_service.json](https://eligible.com/resources/place_of_service.json)

## Health Care Provider Taxonomy

[https://eligible.com/resources/health-care-provider-taxonomy-code-set.json](https://eligible.com/resources/health-care-provider-taxonomy-code-set.json)

### Api Call Results

On all results you can check for errors in `result.error`. The raw
json format is available by using `result.to_hash`.

```ruby
demographic = Eligible::Demographic.get(params)
demographic.error
demographic.to_hash
```

## Coverage

### Reference

[https://eligible.com/rest-api-v1-1/coverage-all#apiCoverageInfo](https://eligible.com/rest-api-v1-1/coverage-all#apiCoverageInfo)

### Retrieve eligibility and benefit information

```ruby
params = {
  :service_type => "33",
  :network => "OUT",
  :payer_id   => "000001",
  :provider_last_name => "Last",
  :provider_first_name => "First",
  :provider_npi => "12345678",
  :member_id => "12345678",
  :member_last_name => "Austen",
  :member_first_name => "Jane",
  :member_dob => "1955-12-14"
}

coverage = Eligible::Coverage.get(params)
coverage.to_hash # returns all coverage info for the request
coverage.error   # return error, if any
```

## Demographic

### Reference

[https://eligible.com/rest-api-v1-1/demographic-all#apiDemographics](https://eligible.com/rest-api-v1-1/demographic-all#apiDemographics)

### Fetch demographics for a patient

```ruby
params = {
  :payer_name => "Aetna",
  :payer_id   => "000001",
  :provider_last_name => "Last",
  :provider_first_name => "First",
  :provider_npi => "12345678",
  :member_id => "12345678",
  :member_last_name => "Austen",
  :member_first_name => "Jane",
  :member_dob => "1955-12-14"
}

demographic = Eligible::Demographic.get(params)
demographic.to_hash # returns all coverage info for the request
demographic.error   # return error, if any
```

## Medicare

### Reference

[https://github.com/Eligible/tools/wiki/Medicare](https://github.com/eligible/tools/wiki/Medicare)

### Retrieve eligibility and benefit information from CMS Medicare for a patient.

```ruby
params = {
  :payer_id   => "000001",
  :provider_last_name => "Last",
  :provider_first_name => "First",
  :provider_npi => "12345678",
  :member_id => "12345678",
  :member_last_name => "Austen",
  :member_first_name => "Jane",
  :member_dob => "1955-12-14"
}
medicare = Eligible::Medicare.get(params)
medicare.to_hash # returns all coverage info for the request
medicare.error   # return error, if any
```

## Batch API

### Reference

[https://github.com/Eligible/tools/wiki/Batch-Api](https://github.com/ligible/tools/wiki/Batch-Api)

All the batch api calls will notify the results via webhook. You can
setup a webhook in your
[Dashboard](https://ligible.com/dashboard/webhooks). All batch api
calls return a *reference_id* value and the *number_of_items*
submitted.

### Coverage Batch API

```ruby
params = {
    "api_key"=>"81ef98e5-4584-19fb-0d8c-6e987b95d695",
    "parameters"=>[
        {
            "id"=>1,
            "payer_name"=>"UnitedHealthCare",
            "payer_id"=>"00112",
            "service_provider_npi"=>"12341234",
            "subscriber_id"=>"98769876",
            "subscriber_first_name"=>"Jane",
            "subscriber_last_name"=>"Austen",
            "service_provider_last_name"=>"Gaurav",
            "service_provider_first_name"=>"Gupta",
            "subscriber_dob"=>"1947-10-07"
        },
        {
            "id"=>2,
            "payer_name"=>"UnitedHealthCare",
            "payer_id"=>"00112",
            "service_provider_npi"=>"67676767",
            "subscriber_id"=>"98989898",
            "subscriber_first_name"=>"Gaurav",
            "subscriber_last_name"=>"Gupta",
            "service_provider_last_name"=>"Jane",
            "service_provider_first_name"=>"Austen",
            "subscriber_dob"=>"1947-08-15"
        }
    ]
}

result = Eligible::Coverage.batch_post(params)
result.to_hash # returns the api call results
result.error   # return error, if any
```

### Demographic Batch API

```ruby
params = {
    "parameters"=>[
        {
            "id"=>1,
            "payer_name"=>"UnitedHealthCare",
            "payer_id"=>"00112",
            "service_provider_npi"=>"12341234",
            "subscriber_id"=>"98769876",
            "subscriber_first_name"=>"Jane",
            "subscriber_last_name"=>"Austen",
            "service_provider_last_name"=>"Gaurav",
            "service_provider_first_name"=>"Gupta",
            "subscriber_dob"=>"1947-10-07"
        },
        {
            "id"=>2,
            "payer_name"=>"UnitedHealthCare",
            "payer_id"=>"00112",
            "service_provider_npi"=>"67676767",
            "subscriber_id"=>"98989898",
            "subscriber_first_name"=>"Gaurav",
            "subscriber_last_name"=>"Gupta",
            "service_provider_last_name"=>"Jane",
            "service_provider_first_name"=>"Austen",
            "subscriber_dob"=>"1947-08-15"
        }
    ]
}
result = Eligible::Demographic.batch_post(params)
result.to_hash # returns the api call results
result.error   # return error, if any
```

### Medicare Batch API

```ruby
params = {
    "parameters"=>[
        {
            "id"=>1,
            "service_provider_npi"=>"12341234",
            "subscriber_id"=>"98769876",
            "subscriber_first_name"=>"Jane",
            "subscriber_last_name"=>"Austen",
            "service_provider_last_name"=>"Gaurav",
            "service_provider_first_name"=>"Gupta",
            "subscriber_dob"=>"1947-10-07"
        },
        {
            "id"=>2,
            "service_provider_npi"=>"67676767",
            "subscriber_id"=>"98989898",
            "subscriber_first_name"=>"Gaurav",
            "subscriber_last_name"=>"Gupta",
            "service_provider_last_name"=>"Jane",
            "service_provider_first_name"=>"Austen",
            "subscriber_dob"=>"1947-08-15"
        }
    ]
}

Eligible::Coverage.batch_medicare_post params
result.to_hash # returns the api call results
result.error   # return error, if any
```

## Enrollment

### Reference

[https://github.com/eligible/tools/wiki/Enrollments](https://github.com/eligible/tools/wiki/Enrollments)

Enrollment requests can have multiple enrollment NPIs. You can repeat
the enrollment for a NPI multiple times across different enrollment
requests.

### Create an Enrollment Request

```ruby
params = {
  "service_provider_list" => [
      {
        "facility_name" => "Quality",
        "provider_name" => "Jane Austen",
               "tax_id" => "12345678",
              "address" => "125 Snow Shoe Road",
                 "city" => "Sacramento",
                "state" => "CA",
                  "zip" => "94107",
                 "ptan" => "54321",
                  "npi" => "987654321"
      },
      {
        "facility_name" => "Aetna",
        "provider_name" => "Jack Austen",
               "tax_id" => "12345678",
              "address" => "985 Snow Shoe Road",
                 "city" => "Menlo Park",
                "state" => "CA",
                  "zip" => "94107",
                 "ptan" => "54321",
                  "npi" => "987654321"
      }
    ],
    "payer_ids" => [
      "00431",
      "00282"
    ]
}
result = Eligible::Enrollment.post(params)
result.to_hash # returns the api call results
result.error   # return error, if any
```

### Retrieve an Enrollment Request

```ruby
params = { :enrollment_request_id => 123 }
enrollment = Eligible::Enrollment.get(params)
enrollment.to_hash # return the api call results
enrollment.error  # return error, if any
enrollment.enrollment_npis # quick access to the enrollment npis within the enrollment request object

params = { :npis => %w(123 456 789).join(',') }
enrollment = Eligible::Enrollment.get(params)
```

## Claims

### Reference

[https://github.com/eligible/tools/wiki/Claims](https://github.com/eligible/tools/wiki/Claims)

### Create Claim object

```ruby
params = {
    "receiver" => {
        "name" => "AETNA",
        "id" => "60054"
    },
    "billing_provider" => {
        "taxonomy_code" => "332B00000X",
        "practice_name" => "Jane Austen Practice",
        "npi" => "1922222222",
        "address" => {
            "street_line_1" => "419 Fulton",
            "street_line_2" => "",
            "city" => "San Francisco",
            "state" => "CA",
            "zip" => "94102"
        },
        "tin" => "43291023"
    },
    "subscriber" => {
        "last_name" => "Franklin",
        "first_name" => "Benjamin",
        "member_id" => "12312312",
        "group_id" => "455716",
        "group_name" => "",
        "dob" => "1734-05-04",
        "gender" => "M",
        "address" => {
            "street_line_1" => "435 Sugar Lane",
            "street_line_2" => "",
            "city" => "Sweet",
            "state" => "OH",
            "zip" => "436233127"
        }
    },
    "payer" => {
        "name" => "AETNA",
        "id" => "60054",
        "address" => {
            "street_line_1" => "Po Box 981106",
            "street_line_2" => "",
            "city" => "El Paso",
            "state" => "TX",
            "zip" => "799981222"
        }
    },
    "claim" => {
        "total_charge_amount" => "275",
        "claim_frequency" => "1",
        "patient_signature_on_file" => "Y",
        "provider_plan_participation" => "A",
        "direct_payment_authorized" => "Y",
        "release_of_information" => "I",
        "service_lines" => [
            {
                "line_number" => "1",
                "service_start" => "2013-03-07",
                "service_end" => "2013-03-07",
                "place_of_service" => "11",
                "charge_amount" => "275",
                "product_service" => "99213",
                "qualifier" => "HC",
                "diagnosis_1" => "32723"
            }
        ]
    }
}

result = Eligible::Claim.post(params)
enrollment.to_hash # return the api call results
enrollment.error  # return error, if any
```

### Retrieve all Claim objects/acknowledgments

```ruby
claims = Eligible::Claim.all # returns acknowledgment information for all claims that have been submitted with the API key
```

### Retrieve individual Claim object/acknowledgment

```ruby
params = {
  :reference_id => "12345"
}

claim = Eligible::Claim.get(params) # returns acknowledgment information on an individual claim identified by its reference_id
```

## Payment Status

### Reference

[https://eligible.com/rest-api-v1-1/beta/payment-status#apiPaymentStatus](https://eligible.com/rest-api-v1-1/beta/payment-status#apiPaymentStatus)

### Retrieve  Payment status

```ruby
params = { :payer_id => '00001',
           :provider_tax_id => '4373208923',
           :provider_npi => '1234567890',
           :provider_first_name => 'Thomas',
           :provider_first_name => 'Thomas',
           :member_id => '123',
           :member_first_name => 'Benjamin',
           :member_last_name => 'Franklin',
           :member_dob => '01-01-1980',
           :charge_amount => '100.00',
           :start_date => '2013-03-25',
           :end_date => '2013-03-25' }

result = Eligible::Payment.get(params)
result.to_hash   # return the api call results
result.error     # return error, if any
```

## X12

### Reference

[https://github.com/EligibleAPI/tools/wiki/X12](https://github.com/EligibleAPI/tools/wiki/X12)

### X12 post

```ruby
params = { :x12 => "ISA*00*          *00*          *ZZ*SENDERID       *ZZ*ELIGIB         *130610*0409*^*00501*100000001*0*T*:~GS*HS*SENDERID*ELIGIB*20130610*0409*1*X*005010X279A1~ST*270*0001*005010X279A1~BHT*0022*13*137083739083716126837*20130610*0409~HL*1**20*1~NM1*PR*2*UnitedHealthCare*****PI*112~HL*2*1*21*1~NM1*1P*1*AUSTEN*JANE****XX*1222494919~HL*3*2*22*0~TRN*1*1*1453915417~NM1*IL*1*FRANKLIN*BENJAMIN****MI*23412342~DMG*D8*17371207~DTP*291*D8*20130610~EQ*30~SE*13*0001~GE*1*1~IEA*1*100000001~" }

result = Eligible::X12.post(params)
```

## Tickets

### Reference

[https://github.com/EligibleAPI/tools/wiki/Tickets](https://github.com/EligibleAPI/tools/wiki/Tickets)

### Create a ticket

```ruby
params = {:priority => 'normal',
          :title => 'TITLE',
          :notification_email => 'admin@eligible.com',
          :body => 'Your comment'}
result = Eligible::Ticket.create params
result.to_hash # return the api call results
enrollment.error  # return error, if any
```

### Get a ticket

```ruby
ticket = Eligible::Ticket.get(:id => 1)
ticket.to_hash # return the api call result
ticket.error   # return error, if any
```

### Update a ticket

```ruby
params = { :id => 1,
           :priority => 'normal',
           :title => 'TITLE',
           :notification_email => 'your_email@test.com',
           :body => 'Your comment'}
result = Eligible::Ticket.update(params)
result.to_hash # return the api call results
enrollment.error  # return error, if any
```

### Get comments for a ticket

```ruby
comments = Eligible::Ticket.get(:id => 1)
comments.to_hash # return the api call result
comments.error   # return error, if any

```

### Delete a ticket
```ruby
result = Eligible::Ticket.delete(:id => 1)
comments.to_hash # return the api call result
comments.error   # return error, if any
```

### Get all tickets

```ruby
Eligible::Ticket.all
```

## Contributing

Running `rake` will run the test suite along with rubocop as a basic
style assessment. If you are going to submit a pull request, please
verify that all tests pass and there are no rubocop errors. Please add
additional tests for any features or fixes provided.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run tests (see above)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
