module Types
  class MutationType < Types::BaseObject
    field :dummy_mutation, String, null: false, authenticate: true

    def dummy_mutation
      'Necessary so GraphQL gem does not complain about empty mutation type'
    end
  end
end
