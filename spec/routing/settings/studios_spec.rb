require 'spec_helper'

describe Settings::StudiosController do
  describe 'routable' do
    it 'routes to #edit through settings' do
      expect(get('/settings/studio/edit')).to route_to('settings/studios#edit')
    end
    it 'routes to #update through settings' do
      expect(put('/settings/studio')).to route_to('settings/studios#update')
    end
  end

  describe 'not routable' do
    it 'should not route to #show through settings' do
      expect(get('/settings/studio')).to_not be_routable
    end
    it 'should not route to #index through settings' do
      expect(get('/settings/studios')).to_not be_routable
    end
    it 'should not route to #new through settings' do
      expect(get('/settings/studios/new')).to_not be_routable
    end
    it 'should not route to #create through settings' do
      expect(post('/settings/studios')).to_not be_routable
    end
    it 'should not route to #destroy through settings' do
      expect(delete('/settings/studio/1')).to_not be_routable
    end
    it 'should not route to #index' do
      expect(get('/studios')).to_not be_routable
    end
    it 'should not route to #show' do
      expect(get('/studios/1')).to_not be_routable
    end
    it 'should not route to #new' do
      expect(get('/studios/new')).to_not be_routable
    end
    it 'should not route to #create' do
      expect(post('/studios')).to_not be_routable
    end
    it 'should not route to #edit' do
      expect(get('/studio/edit')).to_not be_routable
    end
    it 'should not route to #update' do
      expect(put('/studio')).to_not be_routable
    end
    it 'should not route to #destroy' do
      expect(delete('/studio/1')).to_not be_routable
    end
  end
end
