require 'semantic'

class SemVerEditor < Thor

  package_name "SemVerEditor"

  desc "bump", "increments the version numbers in a YAML file"

  method_option :level,
    :aliases => "-l",
    :type => :string,
    :default => "patch",
    :required => true,
    :enum => ['major', 'minor', 'patch'],
    :desc => "specifiy version level"

  method_option :file_path,
    :aliases => "-f",
    :type => :string,
    :required => true,
    :desc => "path to file"

  method_option :keys,
    :aliases => "-k",
    :type => :array,
    :default => [],
    :desc => "Optionally target specific keys"

  method_option :trees,
    :aliases => "-t",
    :type => :array,
    :default => [],
    :desc => "Optionally target all the values nested under these keys"

  method_option :outfile,
    :aliases => "-o",
    :type => :string,
    :default => "outfile.yaml",
    :desc => "output file name, default is ./outfile.yaml"

  def bump
    find_semvers hash: yaml, level: options[:level], keys: options[:keys], trees: options[:trees]
    save_yaml
  end

  private

  def file
    @file ||= File.open options[:file_path]
  rescue Errno::ENOENT
    puts "Your file could not be found. Please double-check your path."
    exit(1)
  end

  def yaml
    @yaml ||= YAML.load_file(file)
  end

  def find_semvers hash:, level:, keys: [], trees: [], inside_tree: false
    hash.map do |key, value|
      hash_copy = {}
      if value.is_a?(Hash)
        if trees.any? then next unless trees.include?(key.to_s) || inside_tree end
        hash_copy[key] = {}
        find_semvers(hash: value, level: level, keys: keys, trees: trees, inside_tree: trees.include?(key.to_s))
      end
      if value.is_a?(String) && is_semver?(value) then
        if keys.any? then next unless keys.include?(key) end
        hash_copy[key] = {}
        hash.update(hash_copy)[key] = increment(value, level)
      end
    end
  end

  def is_semver? version
    version.match(/^v\d+\.\d+\.\d+$/)
  end

  def increment version, level
    version = version.delete("v")
    old_version = Semantic::Version.new version
    old_version.increment!(level.to_sym).to_s.prepend("v")
  end

  def save_yaml
    file = options[:outfile]
    output = File.open( file,"w" )
    output << yaml.to_yaml
    output.close
    puts "Your file was written to #{file}."
  end
end
