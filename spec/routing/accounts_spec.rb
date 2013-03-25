require 'spec_helper'

describe AccountsController do
  describe 'not routable' do
    it 'should not route to #show through members' do
      expect(get('/members/1/account')).to_not be_routable
    end
    it 'should not route to #destroy through members' do
      expect(delete('/members/1/account')).to_not be_routable
    end
  end
end
