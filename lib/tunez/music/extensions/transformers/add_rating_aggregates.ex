defmodule Tunez.Music.Extensions.Transformers.AddRatingAggregates do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def transform(dsl_state) do
    table = Transformer.get_option(dsl_state, [:ratings], :table)

    {:ok, ratings} =
      Ash.Resource.Builder.build_relationship(:has_many, :ratings, Tunez.Music.Rating,
        destination_attribute: :resource_id
      )

    # build_relationship doesn't apply the `as: :context` alias, so set it directly.
    ratings = %{ratings | context: %{data_layer: %{table: table}}}

    {:ok, average} =
      Ash.Resource.Builder.build_aggregate(:average_rating, :avg, :ratings,
        field: :rating,
        public?: true
      )

    {:ok, count} =
      Ash.Resource.Builder.build_aggregate(:rating_count, :count, :ratings, public?: true)

    {:ok,
     dsl_state
     |> Transformer.add_entity([:relationships], ratings)
     |> Transformer.add_entity([:aggregates], average)
     |> Transformer.add_entity([:aggregates], count)}
  end

  def before?(_), do: true
end
