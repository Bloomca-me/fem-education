ExUnit.start

Mix.Task.run "ecto.create", ~w(-r FemiEducation.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r FemiEducation.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(FemiEducation.Repo)

