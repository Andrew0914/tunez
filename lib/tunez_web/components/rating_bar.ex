defmodule TunezWeb.Components.RatingBar do
  use TunezWeb, :component

  attr :resource_id, :string, required: true
  attr :resource_name, :string, default: ""
  attr :rating, :integer, default: 0
  attr :average, :float, default: 0.0
  attr :rating_count, :integer, default: 0

  def rating_bar(assigns) do
    ~H"""
    <div class="mt-3 flex items-center justify-between" data-role="rating-bar">
      <div class="flex flex-row-reverse">
        <button
          :for={n <- 5..1//-1}
          type="button"
          phx-click={"rate_#{@resource_name}"}
          phx-value-resource-id={@resource_id}
          phx-value-rating={n}
          aria-label={"Rate #{n} out of 5"}
          class="peer peer-hover:text-red-400 hover:text-red-400 text-gray-300 transition-colors cursor-pointer"
        >
          <.icon name={if n <= @rating, do: "hero-heart-solid", else: "hero-heart"} class="w-7 h-7" />
        </button>
      </div>
      <span
        :if={@rating_count > 0}
        data-role="rating-average"
        class="text-zinc-500 text-sm whitespace-nowrap"
      >
        <.icon name="hero-heart-solid" class="size-4 -mt-0.5 text-red-400" />
        {:erlang.float_to_binary(@average, decimals: 1)}
        <span class="text-zinc-400">({@rating_count})</span>
      </span>
    </div>
    """
  end
end
