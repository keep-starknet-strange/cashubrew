defmodule Cashubrew.Test.Mint do
  use ExUnit.Case, async: true
  alias Cashubrew.Schema
  alias Cashubrew.Web.MintController
  alias Cashubrew.Mint
  alias Cashubrew.Query.MeltTokens

  describe "Mint" do
    @tag :mint_quote

    test "Mint quote" do
      description_input="lfg"
      unit_input="sat"
      amount_input=1
      {:ok, mint}= Mint.create_mint_quote(amount_input, description_input)
      attributes = %{
        out: "false",
        amount: amount_input,
        unit_input: unit_input,
      }
      request = Map.get(mint, :payment_request)
      assert String.starts_with?(request, "ln")

      amount = Map.get(mint, :amount)
      assert amount == amount_input

      description = Map.get(mint, :description)

    end

    test "Melt quote" do
      invoice="lnbc10n1pn0dr0gdr8vs6xyd3c8qekxdfsvcunywtpxdjk2vmpx4snwdejv3nrye34xycrqvehvdnrqdtzxyukzdfsvycr2e3hvcunzvmzvgukzvrpv9nrzvqnp4qvhnmyfaj2k6gckmxsdcx0wrxdghx9eks0ck536sghwfjd6nv2pawpp5f3jjx7ag5fwk5jwa5g7gycl99e6y2ja93r5hu5m4gtllvlkausqqsp57545s7xnlmj7xkt08a9ze7cmmtvmsjjgqvqjcum2h2ge4fg4yp3s9qyysgqcqpcxqyz5vqgersy5pln9yxz6cksh8nmu4rs8mml6f0wzddaw0pr2l2t9rxkhrqfu89xnjcdukvn3v22t6w4lvp8g3ynymzn02952njk0ennzrunusqgd3w9d"
      unit_input="sat"
      amount_input_invoice=1000 # msat
      {:ok, melt_quote}= Mint.create_melt_quote(invoice, unit_input)
      request = Map.get(melt_quote, :request)
      assert String.length(request) == 64

      amount = Map.get(melt_quote, :amount)
      assert amount == amount_input_invoice

      unit = Map.get(melt_quote, :unit)
      assert unit == "sat"

      # TODO verify DB and Check if it's saved
      melt = MeltTokens.get_melt_by_quote_id!(request)

      if melt != nil do
        request_id_db = Map.get(melt, :request)
        assert request == request_id_db
      end

    end


  end


  defp normalize_binary(value) when is_binary(value), do: Base.encode16(value, case: :lower)
  defp normalize_binary(value), do: value
end
