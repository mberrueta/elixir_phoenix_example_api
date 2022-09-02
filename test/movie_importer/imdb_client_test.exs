defmodule Imdb.CoreTest do
  use Imdb.DataCase

  alias Imdb.Core.Director

  import Mock
  import Imdb.CoreFixtures

  describe "import happy path" do
    @describetag :importer

    test "movies" do
      with_mock
      MovieImporter.ImdbClient.import("inception")
    end
  end
end
