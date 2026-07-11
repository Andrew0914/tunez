defmodule TunezWeb.Components.RatingBar do
  use TunezWeb, :component

  attr :resource_id, :string, required: true
  attr :resource_name, :string, default: ""
  attr :rating, :integer, default: 0
  attr :average, :any, default: nil

  def rating_bar(assigns) do
    assigns = assign(assigns, :average_display, format_average(assigns.average))

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
        :if={@average_display}
        data-role="rating-average"
        class="text-zinc-500 text-sm whitespace-nowrap"
      >
        <.icon name="hero-heart-solid" class="size-4 -mt-0.5 text-red-400" />
        {@average_display}
      </span>
    </div>
    """
  end

  # avg aggregates come back as Decimal (or nil when there are no ratings).
  defp format_average(nil), do: nil
  defp format_average(%Decimal{} = avg), do: Decimal.round(avg, 1) |> Decimal.to_string()
  defp format_average(avg) when is_float(avg), do: :erlang.float_to_binary(avg, decimals: 1)
  defp format_average(avg), do: to_string(avg)
end
