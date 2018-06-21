require "./any_merge/*"
require "yaml/any"
require "json/any"

require "json"

class Hash(K, V)
  def any_merge(other : Hash)
    hash = Hash(K, V).new
    hash.any_merge! self
    hash.any_merge! other
    hash
  end

  def any_merge!(other : Hash)
    other.each do |k, v|
      # Convert k
      {% if K.id == "YAML::Any".id %}
        k = case k
            when YAML::Any
              k
            when Int32
              YAML::Any.new(k.to_i64)
            when Symbol
              YAML::Any.new(k.to_s)
            else
              YAML::Any.new(k)
            end
      {% else %}
        k = k.to_s
      {% end %}

      # Convert v
      {% if V.id == "JSON::Any" %}
        case v
        when JSON::Any
          # do nothing
        when Int32
          v = JSON::Any.new(v.to_i64)
        when YAML::Any
          v = if v.as_i? || v.as_i64?
                  v.as_i.to_i64
              elsif v.as_f?
                v.as_f
              else
                v.as_s
              end
          v = JSON::Any.new(v)
        else
          v = JSON::Any.new(v)
        end
      {% elsif V.id == "YAML::Any" %}
        case v
        when YAML::Any
          # do nothing
        when Int32
          v = YAML::Any.new(v.to_i64)
        when JSON::Any
          v = if v.as_i? || v.as_i64?
                  v.as_i.to_i64
              elsif v.as_f?
                v.as_f
              else
                v.as_s
              end
          v = YAML::Any.new(v)
        else
          v = YAML::Any.new(v)
        end
      {% else %}
        v = v.as({{ V.id }})
      {% end %}

      self[k] = v
    end

    self
  end
end
