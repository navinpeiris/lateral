# Lateral

Ruby wrapper for [lateral.io](https://lateral.io) content recommendation service. For more information on
methods allowed, returned codes etc, see the [api docs](https://lateral.io/docs).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lateral'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lateral

## Usage

### Get an API Key

You can get an API key from [https://lateral.io/](https://lateral.io/).

### Use the service

```ruby
text_matcher = Lateral::TextMatcher.new API_KEY
```

#### Available methods

NOTE: The hash-bang methods throws an error if the request failed while the non hash-bang methods return null

```ruby
# Adding documents
text_matcher.add  document_id: 'document-id', text: 'document text'
text_matcher.add! document_id: 'document-id', text: 'document text'

# Deleting a document
text_matcher.delete  document_id: 'document-id'
text_matcher.delete! document_id: 'document-id'

# Delete all documents
text_matcher.delete_all
text_matcher.delete_all!

# Fetch a document
text_matcher.fetch  document_id: 'document-id'
text_matcher.fetch! document_id: 'document-id'

# List document ids
text_matcher.list
text_matcher.list!

# Recommend by id
text_matcher.recommend_by_id  document_id: 'document-id', records: 20
text_matcher.recommend_by_id! document_id: 'document-id', records: 20

# Recommend by text
text_matcher.recommend_by_text  text: 'some text', records: 20
text_matcher.recommend_by_text! text: 'some text', records: 20

# Update meta tags
text_matcher.update_meta  document_id: 'document-id', meta: 'meta-tags'
text_matcher.update_meta! document_id: 'document-id', meta: 'meta-tags'

# Update text
text_matcher.update_text  document_id: 'document-id', text: 'new document text'
text_matcher.update_text! document_id: 'document-id', text: 'new document text'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/navinpeiris/lateral/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
