defmodule Padawan.Assertions.BeSpec do
  use Padawan

  describe "Padawan.Assertions.Be" do
    context "Success" do
      it "checks success with `to`" do
        expect(2) |> to(be(:>, 1))
      end
    end
  end
end
