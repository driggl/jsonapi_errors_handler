require 'spec_helper'

RSpec.describe JsonapiErrorsHandler::ErrorSerializer do
  let(:error) { JsonapiErrorsHandler::Errors::StandardError.new }
  let(:subject) { JsonapiErrorsHandler::ErrorSerializer.new(error) }

  describe '#to_h' do
    it 'returns error in hash format' do
      result = subject.to_h
      expect(result[:errors]).to eq [{status: 500,
                                      title: 'Something went wrong',
                                      detail: 'We encountered unexpected error, but our developers had been already notified about it',
                                      source: {}}]
    end
  end

  describe '#to_json' do
    it 'converts hash into json' do
      expect(subject.to_json).to eq "{\"errors\":[{\"status\":500,\"title\":\"Something went wrong\",\"detail\":\"We encountered unexpected error, but our developers had been already notified about it\",\"source\":{}}]}"
    end
  end
end
