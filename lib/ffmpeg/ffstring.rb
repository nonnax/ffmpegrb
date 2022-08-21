#!/usr/bin/env ruby
# Id$ nonnax 2022-08-21 19:02:49
module HString
  refine Hash do
    def to_str
      inject([]){|acc, (k,v)|
        acc <<
          if v.respond_to?(:assoc)
            repeat k, v
          else
            format " -%s %s ", k, v
          end
      }
      .join(' ')
      .tr('true', '')
      .split.join(' ')
    end
    alias to_s to_str

    def repeat(k, v)
      v.inject(''){|str, e|
        str<<format( " -%s %s ", k, e )
      }
    end

    def method_missing(k, args)
    	self[k]=args
    end
  end
end

