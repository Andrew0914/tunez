defmodule Tunez.Music.Rating do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    polymorphic? true
    repo Tunez.Repo

    references do
      reference :user, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy]

    create :rate do
      accept [:resource_id, :rating]
      upsert? true
      upsert_identity :unique_rating
      upsert_fields [:rating]
      change relate_actor(:user)
    end
  end

  attributes do
    attribute :rating, :integer, default: 0
    attribute :resource_id, :uuid, public?: true
  end

  relationships do
    belongs_to :user, Tunez.Accounts.User do
      primary_key? true
      allow_nil? false
    end
  end

  identities do
    identity :unique_rating, [:resource_id, :user_id]
  end
end
