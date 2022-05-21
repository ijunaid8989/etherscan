defmodule Etherscan.API.HTTP do
  @spec post(
          binary | URI.t(),
          list(),
          nil
          | binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
          | {:stream, any},
          keyword
        ) ::
          {:error, %{:__exception__ => true, :__struct__ => atom, optional(atom) => any}}
          | {:ok, Finch.Response.t()}
  def post(url, headers \\ [], body \\ nil, opts \\ []) do
    request(:post, url, headers, body, opts)
  end

  defp request(method, url, headers, body, opts) do
    transformed_headers = tranform_headers(headers)

    Finch.build(method, url, transformed_headers, body)
    |> Finch.request(__MODULE__, opts)
    |> case do
      {:ok, %Finch.Response{} = response} ->
        {:ok, response}

      {:error, error} ->
        {:error, error}
    end
  end

  defp tranform_headers([]), do: []

  defp tranform_headers(headers) do
    headers
    |> Enum.map(fn {k, v} ->
      {Atom.to_string(k), v}
    end)
  end
end
