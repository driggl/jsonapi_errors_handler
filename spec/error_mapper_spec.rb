# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonapiErrorsHandler::ErrorMapper do
  let(:mapped_errors) { described_class.mapped_errors }

  describe '.mapped_errors' do
    it 'returns a Hash' do
      expect(mapped_errors).to be_instance_of(Hash)
    end

    it 'returns current value of class variable @mapped_errors' do
      expect(mapped_errors).to eq described_class.instance_variable_get(:@mapped_errors)
    end
  end

  describe '.map_errors!' do
    let(:errors_hash) { { 'Error' => 'Invalid' } }

    it 'merges errors_hash into the current errors' do
      result = described_class.map_errors!(errors_hash)
      expect(result['Error']).to eq 'Invalid'
    end
  end

  describe '.mapped_error' do
    let(:subject) { described_class.mapped_error(mapped_error) }

    context 'when error is an instance and is defined on the error list' do
      let(:mapped_error) { JsonapiErrorsHandler::Errors::Forbidden.new(message: 'test') }

      context 'error is not in defined error list' do
        let(:mapped_error) { 'Error' }

        it 'returns error' do
          expect(subject).to be_nil
        end
      end

      it 'returns the original error if the instance had been risen' do
        JsonapiErrorsHandler::ErrorMapper.map_errors!(
          'JsonapiErrorsHandler::Errors::Forbidden' => 'JsonapiErrorsHandler::Errors::Forbidden'
        )
        expect(subject).to eq mapped_error
        expect(subject.detail).to eq('test')
      end
    end

    context 'when error is a class and is defined on the error list' do
      let(:mapped_error) { JsonapiErrorsHandler::Errors::Forbidden }

      it 'returns an instance of the risen error klass' do
        JsonapiErrorsHandler::ErrorMapper.map_errors!(
          'JsonapiErrorsHandler::Errors::Forbidden' => 'JsonapiErrorsHandler::Errors::Forbidden'
        )
        expect(subject).to eq mapped_error.new
      end
    end
  end

  describe '.mapped_errors?' do
    it 'return false if the errors does not include a specific error' do
      expect(described_class.mapped_error?('AnError')).to be false
    end

    it 'return true if the errors include a specific error' do
      described_class.map_errors!('Invalid' => 'Errors::Invalid')
      expect(described_class.mapped_error?('Invalid')).to be true
    end
  end
end
