require 'pry'
require 'semantic'

class SemVerEditor < Thor

  package_name "SemVerEditor"

  desc "bump_major", "increments the major version numbers for SERVICE"
  # method_option :keys, :type => :array, :default => [], :desc => "Optionally specify keys containing values to be bumped"
  method_option :level, :type => :string, :default => "patch", :required => true, :desc => "specifiy major, minor or patch"
  def bump
    case options[:level]
    when "major"
      find_semvers yaml, "major"
    when "minor"
      find_semvers yaml, "minor"
    when "patch"
      find_semvers yaml, "patch"
    else
      p "invalid level specified"
    end
  end

  desc "bump_minor", "increments the minor version numbers for SERVICE"
  def bump_minor
    find_semvers yaml, "minor"
  end

  desc "bump_patch", "increments the path version numbers for SERVICE"
  def bump_patch
    find_semvers yaml, "patch"
  end

  private

  def yaml
    @yaml ||= YAML.load_file("artifacts/example.yaml")
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

end
