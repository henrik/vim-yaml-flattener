# YAMLator by Henrik Nyh <http://henrik.nyh.se> 2010-02-03 under the MIT license.
# Helps you update Rails i18n YAML files programmatically, to be used e.g. for
# editor extraction tools.

$KCODE = 'u'

require "yaml"
require "rubygems"
require "ya2yaml"  # Dumps with unescaped UTF-8.

class YAMLator

  def initialize(data=nil, preamble=nil)
    if data
      @data = data
      @hash = YAML.load(@data)
    else
      @data = preamble.to_s
      @hash = {}
    end
  end

  def to_yaml
    [ preamble, @hash.ya2yaml ].join
  end

  def to_flat_yaml
    tree = flatten_tree(@hash)
    flat = tree.inject({}) { |hash, (chain, leaf)| hash.merge(chain.join(".") => leaf) }
    [ preamble, flat.ya2yaml ].join
  end

  def to_nested_yaml
    yamlator = self.class.new(nil, preamble)
    @hash.each do |key, value|
      yamlator[key] = value
    end
    yamlator.to_yaml
  end

  def []=(key, value)
    chain = key.split('.')
    this_hash = @hash
    chain.each_with_index do |part, index|
      is_last = index==chain.length-1
      key_this_far = chain[0..index].join('.')

      case this_hash[part]
      when Hash
        raise("trying to add a string to a hash key in use: #{key_this_far.inspect}") if is_last
      when String
        raise("trying to add to a string key in use: #{key_this_far.inspect}")
      else
        this_hash[part] = is_last ? value : {}
      end
      this_hash = this_hash[part]
    end
    value
  end

private

  # Comments and blank lines in the beginning of the file.
  def preamble
    @data[/\A(\s*(#.*?)?\n)+/]
  end

  def flatten_tree(tree, chain=[])
    if tree.is_a?(Hash)
      tree.inject([]) { |m, (k,v)| m += flatten_tree(v, chain+[k]) }
    else
      [[chain, tree]]
    end
  end

end

if __FILE__ == $0

  def banner(text, first=false)
    unless first
      puts
      puts
    end
    puts "### #{text}: ###"
    puts
  end

  data = DATA.read

  banner "Building from nothing", :first

  y = YAMLator.new
  y['sv.foo.bar'] = 123
  puts y.to_yaml

  banner "Modifying"

  y = YAMLator.new(data)
  y['sv.some.foo.bar.baz'] = "boink"
  puts y.to_yaml

  banner "Flattening"

  puts y.to_flat_yaml

  banner "Unflattening"

  y = YAMLator.new("one.two.three: hej\none.two.four: ho\none.five: wat")
  puts y.to_nested_yaml

end


__END__

# Comment
# block!

sv:
  some:
    translations: 'föö'
    here: 'bär'
