# frozen_string_literal: true

require 'spec_helper'

class TestJsonapiErrorsHandler
  include JsonapiErrorsHandler

  def config
    JsonapiErrorsHandler::Configuration.instance
  end

  def render(json: {}, status:)
    json.to_h.merge(status: status)
  end
end

class DummyErrorLogger
  include JsonapiErrorsHandler

  def render(json: {}, status:)
    json.to_h.merge(status: status)
  end

  def log_error(_error); end
end

RSpec.describe JsonapiErrorsHandler do
  let(:dummy) { TestJsonapiErrorsHandler.new }

  it 'expects ErrorMapper to have already mapped some errors' do
    dummy
    expect(JsonapiErrorsHandler::ErrorMapper.mapped_errors).not_to be_empty
  end

  describe '.handle_error' do
    let(:mapped_error) { JsonapiErrorsHandler::Errors::Forbidden.new }
    let(:subject) { dummy.handle_error(mapped_error) }

    context 'when error is mapped' do
      let(:expected_result) do
        {
          errors: [
            {
              detail: 'You have no rights to access this resource',
              source: { 'pointer' => '/request/headers/authorization' },
              status: '403',
              title: 'Forbidden request'
            }
          ],
          status: 403
        }
      end

      it 'renders mapped error' do
        expect(subject).to include(expected_result)
      end

      context 'when responds to log_error method' do
        let(:dummy) { DummyErrorLogger.new }
        let(:subject) { dummy.handle_error(mapped_error) }
        it 'does not call error that is mapped' do
          expect(dummy).not_to receive(:log_error)
          subject
        end
      end
    end

    context 'when error is not mapped' do
      let(:unmapped_error) { 'Error' }
      let(:subject) { dummy.handle_error(unmapped_error) }
      let(:expected_result) do
        {
          errors: [
            {
              detail: "We've encountered unexpected error, but our developers had been already notified about it",
              source: {},
              status: '500',
              title: 'Something went wrong'
            }
          ],
          status: 500
        }
      end

      it 'raises the original error by default' do
        expect { subject }.to raise_error(unmapped_error)
      end

      it 'renders 500 error' do
        JsonapiErrorsHandler.configure do |config|
          config.handle_unexpected = true
        end

        expect(subject).to include(expected_result)
      end

      context 'when responds to log_error method' do
        let(:dummy) { DummyErrorLogger.new }
        let(:subject) { dummy.handle_error(unmapped_error) }
        it 'logs unmapped error' do
          expect(dummy).to receive(:log_error).with(unmapped_error)
          subject
        end
      end
    end
  end

  describe '.render_error' do
    let(:subject) { dummy.render_error(error) }

    context 'renders the error' do
      let(:error) { JsonapiErrorsHandler::Errors::Forbidden.new }
      let(:expected_result) do
        {
          errors: [
            {
              detail: 'You have no rights to access this resource',
              source: { 'pointer' => '/request/headers/authorization' },
              status: '403',
              title: 'Forbidden request'
            }
          ],
          status: 403
        }
      end

      it 'returns error' do
        expect(subject).to include(expected_result)
      end
    end
  end
end
