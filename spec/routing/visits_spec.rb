require 'spec_helper'

describe VisitsController do
  describe 'routable' do
    it 'routes to #index through members' do
      expect(get('/members/1/visits')).to route_to('visits#index', member_id: '1')
    end
    it 'routes to #new through members' do
      expect(get('/members/1/visits/new')).to route_to('visits#new', member_id: '1')
    end
    it 'routes to #edit through members' do
      expect(get('/members/1/visits/1/edit')).to route_to('visits#edit', member_id: '1', id: '1')
    end
    it 'routes to #create through members' do
      expect(post('/members/1/visits')).to route_to('visits#create', member_id: '1')
    end
    it 'routes to #update through members' do
      expect(put('/members/1/visits/1')).to route_to('visits#update', member_id: '1', id: '1')
    end
    it 'routes to #destroy through members' do
      expect(delete('/members/1/visits/1')).to route_to('visits#destroy', member_id: '1', id: '1')
    end
  end

  describe 'not routable' do
    it 'should not route to #show through members' do
      expect(get('/members/1/visits/1')).to_not be_routable
    end
  end
end
