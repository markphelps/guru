require 'spec_helper'

describe ClassesController do
  describe 'not routable' do
    it 'should not route to #show' do
      expect(get('/classes/1')).to_not be_routable
    end
  end
end
