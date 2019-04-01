require 'spec_helper'

RSpec.describe JsonapiErrorsHandler::ErrorMapper do
  let(:subject) { described_class }

  before(:each) {
    subject.class_variable_set(:@@mapped_errors, {}) 
  }

  describe '.mapped_errors' do
    it 'returns all the current mapped errors' do
      expect(subject.mapped_errors).to eq({})
    end
  end

  describe '.map_errors!' do
    let(:errors_hash) { {'Error' => 'Invalid'} }
    
    it 'merges errors_hash into the current errors' do
      result = subject.map_errors!(errors_hash)
      expect(result['Error']).to eq 'Invalid'
    end
  end

  describe '.mapped_errors?' do
    it 'return false if the errors does not include a specific error' do
      expect(subject.mapped_error?('AnError')).to be false
    end

    it 'return true if the errors include a specific error' do
      subject.map_errors!({ 'Invalid' => 'Errors::Invalid'})
      expect(subject.mapped_error?('Errors::Invalid')).to be true
    end
  end
end
