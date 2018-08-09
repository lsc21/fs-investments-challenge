require 'pry'
require 'semantic'

class SemVerEditor < Thor

  package_name "SemVerEditor"

  desc "bump", "increments the rsion numbers in a YAML file"
  # method_option :keys, :type => :array, :default => [], :desc => "Optionally specify keys containing values to be bumped"
  method_option :level,
    :aliases => "-l",
    :type => :string,
    :default => "patch",
    :required => true,
    :enum => ['major', 'minor', 'patch'],
    :desc => "specifiy major, minor or patch"

  method_option :file_path,
    :aliases => "-f",
    :type => :string,
    :required => true,
    :desc => "path to file"

  method_option :outfile,
    :aliases => "-o",
    :type => :string,
    :default => "outfile.yaml",
    :desc => "output file name, default is ./outfile.yaml"

  def bump
    case options[:level]
    when "major"
      find_semvers yaml, "major"
    when "minor"
      find_semvers yaml, "minor"
    when "patch"
      find_semvers yaml, "patch"
    end
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

  def find_semvers hash, level
    hash.map do |key, value|
    hash_copy = {}
      if value.is_a?(Hash)
        hash_copy[key] = {}
        find_semvers(value, level)
      end
      if value.is_a?(String) && is_semver?(value) then
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
