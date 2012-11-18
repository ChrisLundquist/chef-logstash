
require 'rubygems'

class Erubis::RubyEvaluator::LogstashConf

  private

  def self.key_to_str(k)
    case k.class.to_s
    when "String"
      return k
    when "Fixnum", "Float"
      return k.to_s
    when "Regex"
      return k.inspect
    end
    return k
  end

  def self.key_value_to_str(k, v)
    case v.class.to_s
    when "String", "Fixnum", "Float"
      return key_to_str(k) + " => '" + v + "'"
    when "Array", "Regex"
      return key_to_str(k) + " => " + v.inspect
    when "Hash", "Mash"
      return key_to_str(k) + " => " + v.to_a.flatten.inspect
    when "TrueClass", "FalseClass", "Fixnum"
      return key_to_str(k) + " => " + v.to_s
    end
    return key_to_str(k)
  end

  public
  
  def self.section_to_str(section, version=nil, patterns_dir=nil)
    result = []
    patterns_dir_plugins = [ 'grok' ]
    unless version.nil?
      patterns_dir_plugins << 'multiline' if Gem::Version.new(version) >= Gem::Version.new('1.1.2')
    end
    section.each do |output|
      output.sort.each do |name, hash|
        result << ''
        result << '  ' + name.to_s + ' {'
        if patterns_dir_plugins.include?(name.to_s) and not patterns_dir.nil? and not hash.has_key?('patterns_dir')
          result << '    ' + key_value_to_str('patterns_dir', patterns_dir)
        end
        hash.sort.each do |k,v|
          result << '    ' + key_value_to_str(k, v)
        end
        result << '  }'
      end
    end
    return result.join("\n")
  end
  
end
  