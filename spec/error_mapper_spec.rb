require 'spec_helper'

RSpec.describe JsonapiErrorsHandler::ErrorMapper do
  describe '.map_errors!' do
    let(:errors_hash) { {'Error' => 'Invalid'} }

    it 'merges errors_hash into the current errors' do
      result = described_class.map_errors!(errors_hash)
      expect(result['Error']).to eq 'Invalid'
    end
  end

  describe '.mapped_errors?' do
    it 'return false if the errors does not include a specific error' do
      expect(described_class.mapped_error?('AnError')).to be false
    end

    it 'return true if the errors include a specific error' do
      described_class.map_errors!({ 'Invalid' => 'Errors::Invalid'})
      expect(described_class.mapped_error?('Errors::Invalid')).to be true
    end
  end
end
