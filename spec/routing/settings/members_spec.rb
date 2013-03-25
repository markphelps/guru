require 'spec_helper'

describe Settings::MembersController do
  describe 'routable' do
    it 'routes to #edit through settings' do
      expect(get('/settings/members/edit')).to route_to('settings/members#edit')
    end
    it 'routes to #update through settings' do
      expect(put('/settings/members')).to route_to('settings/members#update')
    end
  end

  describe 'not routable' do
    it 'should not route to #show through settings' do
      expect(get('/settings/members')).to_not be_routable
    end
    it 'should not route to #index through settings' do
      expect(get('/settings/members')).to_not be_routable
    end
    it 'should not route to #new through settings' do
      expect(get('/settings/members/new')).to_not be_routable
    end
    it 'should not route to #create through settings' do
      expect(post('/settings/members')).to_not be_routable
    end
    it 'should not route to #destroy through settings' do
      expect(delete('/settings/members/1')).to_not be_routable
    end
  end
end
