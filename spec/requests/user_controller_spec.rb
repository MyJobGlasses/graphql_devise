require 'rails_helper'

RSpec.describe 'Integrations with the user controller' do
  include_context 'with graphql query request'

  let(:user) { create(:user, :confirmed) }
  let(:query) do
    <<-GRAPHQL
      query {
        user(
          id: #{user.id}
        ) {
          id
          email
        }
      }
    GRAPHQL
  end

  context 'when using a regular schema' do
    before { post_request('/api/v1/graphql') }

    context 'when user is authenticated' do
      let(:headers) { user.create_new_auth_token }

      it 'allow to perform the query' do
        expect(json_response[:data][:user]).to match(
          email: user.email,
          id:    user.id
        )
      end
    end

    context 'when user is not authenticated' do
      it 'returns a must sign in error' do
        expect(json_response[:errors]).to contain_exactly(
          hash_including(message: 'user field requires authentication', extensions: { code: 'USER_ERROR' })
        )
      end
    end
  end

  context 'when using an interpreter schema' do
    before { post_request('/api/v1/interpreter') }

    context 'when user is authenticated' do
      let(:headers) { user.create_new_auth_token }

      it 'allow to perform the query' do
        expect(json_response[:data][:user]).to match(
          email: user.email,
          id:    user.id
        )
      end
    end

    context 'when user is not authenticated' do
      it 'returns a must sign in error' do
        expect(json_response[:errors]).to contain_exactly(
          hash_including(message: 'user field requires authentication', extensions: { code: 'USER_ERROR' })
        )
      end
    end
  end
end
