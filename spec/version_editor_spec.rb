require "pry"
require "version-editor"
require "thor/base"

describe VersionEditor do

  before(:each) do
    File.delete('outfile.yaml') if File.exists?('outfile.yaml')
  end

  context 'when editing the entire file' do

    it 'bumps all the semver values by a major version' do
      test_bump level: 'major',
        advisorUi: 'v3.0.0',
        permissionsService: 'v2.0.0',
        adminApi: 'v2.0.0'
    end

    it 'bumps all the semver values by a minor version' do
      test_bump level: 'minor',
        advisorUi: 'v2.14.0',
        permissionsService: 'v1.27.0',
        adminApi: 'v1.32.0'
    end

    it 'bumps all the semver values by a patch version' do
      test_bump level: 'patch',
        advisorUi: 'v2.13.2',
        permissionsService: 'v1.26.4',
        adminApi: 'v1.31.1'
    end

  end

  context 'when varying the output file location' do

    it 'writes to the default location' do
      args = ["bump", "-f", "./artifacts/example.yaml", "-l", 'major']
      VersionEditor.start(args)
      expect(File.exists?('alternate.yaml')).to be_falsey
      expect(File.exists?('outfile.yaml')).to be_truthy
    end

    it 'writes to an alternate location' do
      args = ["bump", "-f", "./artifacts/example.yaml", "-l", 'major', '-o', 'alternate.yaml']
      VersionEditor.start(args)
      expect(File.exists?('alternate.yaml')).to be_truthy
      expect(File.exists?('outfile.yaml')).to be_falsey
    end
  end

  private

  def test_bump level:, advisorUi:, permissionsService:, adminApi:
    args = ["bump", "-f", "./artifacts/example.yaml", "-l", level]
    VersionEditor.start(args)
    yaml = YAML.load_file "outfile.yaml"
    expect(yaml['advisorUi']['image']['dockerTag']).to eq(advisorUi)
    expect(yaml['permissionsService']['image']['dockerTag']).to eq(permissionsService)
    expect(yaml['adminApi']['image']['dockerTag']).to eq(adminApi)
  end
end

