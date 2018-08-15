require "pry"
require "version-editor"
require "thor/base"

describe VersionEditor do

  before(:each) do
    File.delete('outfile.yaml') if File.exists?('outfile.yaml')
  end

  it 'bumps all the semver values in the file by a major version' do
    test_bump level: 'major',
      advisorUi: 'v3.0.0',
      permissionsService: 'v2.0.0',
      adminApi: 'v2.0.0'
  end

  it 'bumps all the semver values in the file by a minor version' do
    test_bump level: 'minor',
      advisorUi: 'v2.14.0',
      permissionsService: 'v1.27.0',
      adminApi: 'v1.32.0'
  end

  it 'bumps all the semver values in the file by a patch version' do
    test_bump level: 'patch',
      advisorUi: 'v2.13.2',
      permissionsService: 'v1.26.4',
      adminApi: 'v1.31.1'
  end

  private

  def test_bump level: level, advisorUi: advisorUi, permissionsService: permissionsService, adminApi: adminApi
    args = ["bump", "-f", "./artifacts/example.yaml", "-l", level]
    VersionEditor.start(args)
    yaml = YAML.load_file "outfile.yaml"
    expect(yaml['advisorUi']['image']['dockerTag']).to eq(advisorUi)
    expect(yaml['permissionsService']['image']['dockerTag']).to eq(permissionsService)
    expect(yaml['adminApi']['image']['dockerTag']).to eq(adminApi)
  end
end

