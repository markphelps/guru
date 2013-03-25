require 'spec_helper'

describe Members::NotesController do
  describe 'not routable' do
    it 'should not route to #show through members' do
      expect(get('/members/1/notes/1')).to_not be_routable
    end
    it 'should not route to #index through members' do
      expect(get('/members/1/notes')).to_not be_routable
    end
  end
end
