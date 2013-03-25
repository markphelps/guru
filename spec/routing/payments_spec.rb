require 'spec_helper'

describe PaymentsController do
  describe 'routable' do
    it 'routes to #index through members' do
      expect(get('/members/1/payments')).to route_to('payments#index', member_id: '1')
    end
    it 'routes to #new through members' do
      expect(get('/members/1/payments/new')).to route_to('payments#new', member_id: '1')
    end
    it 'routes to #create through members' do
      expect(post('/members/1/payments')).to route_to('payments#create', member_id: '1')
    end
    it 'routes to #destroy through members' do
      expect(delete('/members/1/payments/1')).to route_to('payments#destroy', member_id: '1', id: '1')
    end
  end

  describe 'not routable' do
    it 'should not route to #show through members' do
      expect(get('/members/1/payments/1')).to_not be_routable
    end
    it 'should not route to #edit through members' do
      expect(get('/members/1/payments/1/edit')).to_not be_routable
    end
    it 'should not route to #update through members' do
      expect(put('/members/1/payments/1')).to_not be_routable
    end
  end
end
