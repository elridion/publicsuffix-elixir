defmodule PublicSuffix.RemoteFileFetcher do
  @moduledoc false

  @headers [
    {~c'accept', "*/*"},
    {~c'content-type', "text/plain; charset=utf-8"}
  ]

  def fetch_remote_file(url) when is_binary(url) do
    # These are not listed in `applications` in `mix.exs` because
    # this is only used at compile time or in one-off mix tasks --
    # so at deployed runtime, this is not used and these applications
    # are not needed.
    :inets.start()
    :ssl.start()

    case :httpc.request(:get, {url, @headers}, [], body_format: :binary) do
      {:ok, {{_, 200, _}, _headers, body}} -> {:ok, body}
      otherwise -> {:error, otherwise}
    end
  end
end
