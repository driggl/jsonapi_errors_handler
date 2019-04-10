require 'spec_helper'

class TestJsonapiErrorsHandler
  include JsonapiErrorsHandler
  
  def render(json: {}, status:)
    json.to_h.merge(status: status)
  end
end

RSpec.describe JsonapiErrorsHandler do 
  let(:dummy) { TestJsonapiErrorsHandler.new }
  
  it 'expects ErrorMapper to have already mapped some errors' do
    dummy
    expect(JsonapiErrorsHandler::ErrorMapper.mapped_errors).not_to be_empty
  end

  describe '.handle_error' do
    let(:subject) { dummy.handle_error(mapped_error) }

    context 'when error is mapped' do
      let(:mapped_error) { JsonapiErrorsHandler::Errors::Forbidden.new }
      let(:expected_result) do
        { errors: [{detail: 'You have no rights to access this resource',
                    source: {'pointer'=>'/request/headers/authorization'},
                    status: 403,
                    title: 'Forbidden request'}],
                  status: 403 }
      end

      it 'renders mapped error' do
        expect(subject).to include(expected_result)
      end
    end

    context 'when error is not mapped' do
      let(:mapped_error) { 'Error' }
      let(:expected_result) do
        { errors: [{detail: 'We encountered unexpected error, but our developers had been already notified about it',
                    source: {},
                    status: 500,
                    title: 'Something went wrong'}],
                  status: 500 }
      end

      it 'renders 500 error' do
        expect(subject).to include(expected_result)
      end
    end
  end

  describe '.map_error' do
    let(:subject) { dummy.map_error(mapped_error) }
    
    context 'error is not in defined error list' do
      let(:mapped_error) { 'Error' }

      it 'returns error' do
        expect(subject).to be_nil
      end
    end

    context 'error is in defined error list' do
      let(:mapped_error) { JsonapiErrorsHandler::Errors::Forbidden.new }

      it 'initializes an instance of error class' do
        expect(subject).to eq JsonapiErrorsHandler::Errors::Forbidden.new
      end
    end
  end

  describe '.render_error' do
    let(:subject) { dummy.render_error(error) }
    
    context 'renders the error' do
      let(:error) { JsonapiErrorsHandler::Errors::Forbidden.new }
      let(:expected_result) do
        { errors: [{detail: 'You have no rights to access this resource',
                    source: {'pointer'=>'/request/headers/authorization'},
                    status: 403,
                    title: 'Forbidden request'}],
                  status: 403 }
      end

      it 'returns error' do
        expect(subject).to include(expected_result)
      end
    end
  end
end
