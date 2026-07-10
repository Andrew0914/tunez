defmodule Tunez.Music.Extensions.Rateable do
  @ratings %Spark.Dsl.Section{
    name: :ratings,
    describe: "Makes a resource rateable via the shared Rating resource.",
    schema: [
      table: [
        type: :string,
        required: true,
        doc: "The physical table holding this resource's ratings."
      ]
    ]
  }

  use Spark.Dsl.Extension,
    sections: [@ratings],
    transformers: [Tunez.Music.Extensions.Transformers.AddRatingAggregates]
end
