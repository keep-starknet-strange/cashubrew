defmodule Cashubrew.LNBitsApi do
  @moduledoc """
  LN BITS Api Network Services.
  """
  Dotenv.load()

  # Function to send a GET request
  def make_get(endpoint) do
    api_base_url = System.get_env("LN_BITS_API_ENDPOINT")
    api_key = System.get_env("LN_BITS_API_KEY")
    headers = [{"X-Api-Key", "#{api_key}"}]
    full_url = "#{api_base_url}#{endpoint}"

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
  def make_post(endpoint, body) do
    api_base_url = System.get_env("LN_BITS_API_ENDPOINT")
    api_key = System.get_env("LN_BITS_API_KEY")

    headers = [
      {"X-Api-Key", "#{api_key}"},
      {"Content-Type", "application/json"}
    ]

    # Convert Elixir map to JSON string
    json_body = Jason.encode!(body)
    full_url = "#{api_base_url}#{endpoint}"

    case HTTPoison.post(full_url, json_body, headers) do
      {:ok, %HTTPoison.Response{status_code: 201, body: response_body}} ->
        {:ok, response_body}

      {:ok, %HTTPoison.Response{status_code: status_code, body: error_body}} ->
        {:error, "Received #{status_code}: #{error_body}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
