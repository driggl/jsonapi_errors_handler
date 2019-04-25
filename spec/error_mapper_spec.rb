# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonapiErrorsHandler::ErrorMapper do
  let(:mapped_errors) { described_class.mapped_errors }

  describe '.mapped_errors' do
    it 'returns a Hash' do
      expect(mapped_errors).to be_instance_of(Hash)
    end

    it 'returns current value of class variable @mapped_errors' do
      expect(mapped_errors).to eq described_class.class_variable_get(:@@mapped_errors)
    end
  end

  describe '.map_errors!' do
    let(:errors_hash) { { 'Error' => 'Invalid' } }

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
      described_class.map_errors!('Invalid' => 'Errors::Invalid')
      expect(described_class.mapped_error?('Errors::Invalid')).to be true
    end
  end
end
