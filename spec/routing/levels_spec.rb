require 'spec_helper'

describe LevelsController do
  describe 'not routable' do
    it 'should not route to #show' do
      expect(get('/levels/1')).to_not be_routable
    end
  end
end
