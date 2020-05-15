# frozen_string_literal: true

require 'spec_helper'

RSpec.describe JsonapiErrorsHandler::ErrorSerializer do
  let(:error) { JsonapiErrorsHandler::Errors::StandardError.new }
  let(:subject) { JsonapiErrorsHandler::ErrorSerializer.new(error) }

  describe '#to_h' do
    it 'returns error in hash format' do
      result = subject.to_h
      expect(result[:errors]).to eq [
        {
          status: 500,
          title: 'Something went wrong',
          detail: 'We encountered unexpected error, but our developers had been already notified about it',
          source: {}
        }
      ]
    end

    context 'when invalid error with a hash is given' do
      let(:error) do
        JsonapiErrorsHandler::Errors::Invalid.new(
          errors: {name: "can't be blank", password: "can't be blank"}
        )
      end

      it 'works when called with array' do
        result = subject.to_h
        expect(result[:errors]).to eq [
          {
            status: 422,
            title: 'Invalid request',
            detail: "can't be blank",
            source: { pointer: '/data/attributes/name' }
          },
          {
            status: 422,
            title: 'Invalid request',
            detail: "can't be blank",
            source: { pointer: '/data/attributes/password' }
          }
        ]
      end
    end
  end

  describe '#to_json' do
    it 'converts hash into json' do
      expect(subject.to_json).to eq(
        '{"errors":[{"status":500,"title":"Something went wrong","detail":"We encountered unexpected error, but our developers had been already notified about it","source":{}}]}'
      )
    end
  end
end
