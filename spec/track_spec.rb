require 'spec_helper'

describe 'Track' do
  context 'title_from_filename' do
    it 'strips all the folder information' do
      result = Track.title_from_filename("path/to/file/My hit song")
      expect(result).to_not match("path")
      expect(result).to_not match("file")
      expect(result).to match("My hit song")
    end

    it 'removes extension information' do
      result = Track.title_from_filename("The End.mp3")
      expect(result).to_not match("mp3")
    end
  end
end
