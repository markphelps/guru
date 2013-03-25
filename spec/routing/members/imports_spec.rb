require 'spec_helper'

describe Members::ImportsController do
  describe 'not routable' do
    it 'should route to #new through members' do
      expect(get('/members/import/new')).to route_to('members/imports#new')
    end
    it 'should route to #create through members' do
      expect(post('/members/import')).to route_to('members/imports#create')
    end
  end
end
