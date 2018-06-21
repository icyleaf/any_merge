# any_merge

Crystal `Hash/Array` merge syntactic sugar.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  any_merge:
    github: icyleaf/any_merge
    branch: master
```

## Usage

```crystal
require "any_merge"
require "json"

json = JSON.parse(%Q{{"string":"foo","int":123,"float":1.23,"bool":true}}).as_h

new_json = json.any_merge({"string" => "bar", "nil" => nil })
puts new_json
# => {"string" => "bar", "int" => 123_i64, "float" => 1.23, "bool" => true, "nil" => nil}

json.any_merge!({"string" => "json"})
puts json
# => {"string" => "json", "int" => 123_i64, "float" => 1.23, "bool" => true}

```

Check [spec code](spec/any_merge_spec.cr).

## TODO

- [x] Hash
  - [x] JSON::Any
  - [x] YAML::Any
  - [x] Hash(String | Symbol | Int32 | Int64, String | Int32 | Int64 | Float64 | Bool | Nil)
- [ ] Array

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/icyleaf/any_merge/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) - creator, maintainer
