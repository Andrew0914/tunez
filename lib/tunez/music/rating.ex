defmodule Tunez.Music.Rating do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    polymorphic? true
    repo Tunez.Repo
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
end
