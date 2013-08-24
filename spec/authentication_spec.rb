require 'spec_helper'

describe 'Authentication' do
  context 'load_from_file' do
    it 'returns nil when the auth file does not exist' do
      with_temp_home('unauthenticated-home') do
        result = Authentication.load_from_file
        expect(result).to eq(nil)
      end
    end

    it 'returns credentials when the file does exist' do
      with_temp_home('authenticated-home') do 
        result = Authentication.load_from_file
        expect(result).to eq(authenticated_token)
      end
    end
  end

  context 'token' do
    it 'returns the token if the user has already authed' do
      with_temp_home('authenticated-home') do
        client = Authentication.token
        expect(client).to eq(authenticated_token)
      end
    end

    it 'asks the user to authenticate if the user is unauthenticated' do
    end
  end

  def with_temp_home(relative_path)
    begin
      original_home = ENV['HOME']
      ENV['HOME'] = fixture_path(relative_path)
      yield
    ensure
      ENV['HOME'] = original_home
    end
  end

  def authenticated_token
    File.read(fixture_path('authenticated-home/.sc-cli'))
  end
end
