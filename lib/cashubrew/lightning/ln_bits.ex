defmodule Cashubrew.LNBits.Api do
  Dotenv.load()

  @api_endpoint System.get_env("LN_BITS_API_ENDPOINT")
  @api_key System.get_env("LN_BITS_API_KEY")

  def fetch_data(path, attributes) do
    api_base_url=System.get_env("LN_BITS_API_ENDPOINT")
    api_key=System.get_env("LN_BITS_API_KEY")
    headers = [{"X-Api-Key", "#{api_key}"}]
    full_url = "#{api_base_url}#{path}"

    case HTTPoison.get(full_url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Received #{status_code} status code"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  # Function to send a POST request with a JSON body
  def post_data(path, attributes) do
    api_base_url=System.get_env("LN_BITS_API_ENDPOINT")
    api_key=System.get_env("LN_BITS_API_KEY")
    headers = [
      {"X-Api-Key", "#{api_key}"},
      {"Content-Type", "application/json"}
    ]

    IO.puts("path: #{inspect(path)}")


    body = Jason.encode!(attributes)  # Convert Elixir map to JSON string
    full_url = "#{api_base_url}#{path}"
    IO.puts("full_url: #{inspect(full_url)}")
    IO.puts("body: #{inspect(body)}")
    IO.puts("api_base_url: #{inspect(api_base_url)}")

    case HTTPoison.post(full_url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        {:ok, response_body}

      {:ok, %HTTPoison.Response{status_code: status_code, body: error_body}} ->
        {:error, "Received #{status_code}: #{error_body}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
